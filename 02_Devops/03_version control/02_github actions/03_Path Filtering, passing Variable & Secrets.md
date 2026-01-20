---
title:
  "{ Title }":
tags:
  - DevOps
  - Git
created: 2025-11-25
updated:
  "{ date }":
---

# Path filtering for pull requests  

You can limit when a workflow runs on pull requests using `on: pull_request` combined with `paths` and `paths-ignore`. The `paths` array means “run this workflow only when changed files match these patterns”; `paths-ignore` means “don’t run when only these patterns changed.” Patterns accept globs (`src/**`, `*.md`, `docs/**`). Use `branches` (or `branches-ignore`) to restrict target branches (the branch the PR targets). Example: the workflow below runs for PRs targeting `main` only when files under `src/` or `package.json` change; it will not run if only docs changed.

```yaml
name: PR Path-filter example

on:
  pull_request:
    branches: [ "main" ]            # target branch of the PR
    paths:
      - 'src/**'
      - 'package.json'
    paths-ignore:
      - 'docs/**'
```

Note security behavior differences: `pull_request` runs the workflow in the context of the PR commit (from the fork) without access to repository secrets, while `pull_request_target` runs in the base repo context (has access to secrets) but executes with the base branch code — be careful with `pull_request_target` because it can be abused by untrusted PRs if your workflow uses secrets or performs checkout/execute of untrusted code.

---

Scope of environment variables and repository variables  
GitHub supports several places to declare variables; scope and precedence matter:

- `env` in workflow top-level: available to all jobs and steps in that workflow.
    
- `env` inside a `job`: available to that job and its steps; it overrides workflow-level values for that job.
    
- `env` inside a `step`: only for that step; overrides job and workflow env.
    
- `jobs.<job_id>.outputs`: used to expose values from a job to other jobs — not the same as `env`.
    
- Repository variables (`vars`) and repository secrets (`secrets`) are defined in repo settings and referenced as `vars.MY_VAR` or `secrets.MY_SECRET` inside the workflow. `vars` are accessible in workflows and can be masked if needed; `secrets` are encrypted and available via `secrets.NAME`.
    

Precedence (high → low): step `env` → job `env` → workflow `env`. Example:

```yaml
env:
  GLOBAL: "global-value"

jobs:
  example:
    runs-on: ubuntu-latest
    env:
      JOB_VAR: "job-value"
      GLOBAL: "job-override"   # overrides workflow env in this job
    steps:
      - name: show vars
        env:
          STEP_VAR: "step-value"
        run: |
          echo "GLOBAL=$GLOBAL"
          echo "JOB_VAR=$JOB_VAR"
          echo "STEP_VAR=$STEP_VAR"
```

---

# Passing variables between jobs  
Jobs are isolated and run on different runners, so you cannot rely on process environment to propagate values between jobs. Use **job outputs**, **artifacts**, or **repository/state storage**.

**Job outputs** are the usual lightweight way to pass small values. A producing job sets outputs and a consuming job reads them via `needs.<job>.outputs`.

Important: use the modern `GITHUB_OUTPUT` file to set outputs inside a step (the older `::set-output` command was deprecated). Example:

```yaml
jobs:
  produce:
    runs-on: ubuntu-latest
    outputs:
      version: ${{ steps.set-version.outputs.version }}
    steps:
      - name: Determine version
        id: set-version
        run: |
          VERSION="v1.2.3"
          echo "version=$VERSION" >> "$GITHUB_OUTPUT"

  consume:
    runs-on: ubuntu-latest
    needs: produce
    steps:
      - name: Use produced version
        run: |
          echo "Got version from produce job: ${{ needs.produce.outputs.version }}"
```

**Artifacts** are for larger files or binary data. `actions/upload-artifact` in producer and `actions/download-artifact` in consumer:

```yaml
- uses: actions/upload-artifact@v4
  with:
    name: build-output
    path: ./dist

# in later job
- uses: actions/download-artifact@v4
  with:
    name: build-output
```

**Caveats**: job outputs are strings and limited in size; artifacts are persisted files. Also remember that jobs that run in parallel cannot `needs` each other — you must express dependencies with `needs`.

---

# Secrets and built-in secret storage  
GitHub provides **Secrets** at multiple scopes: repository, organization, and environment (environment-level secrets tied to deployment environments). Secrets are stored encrypted and exposed to workflows via the `secrets` context: `secrets.MY_SECRET`.

Key points and best practices:

- Access: use `secrets.MY_SECRET` in `env` or `run` steps. Avoid echoing secrets to logs (they are masked, but avoid accidental leaks).
    
- Fork and PR behavior: workflows triggered by PRs from forked repos do **not** have access to repository secrets when using `pull_request`. `pull_request_target` _does_ have access to secrets (dangerous if you run untrusted code). For PRs from forks, use a strategy that does not expose secrets or use protected workflows with manual approvals via environments.
    
- Environments: you can configure environment protection rules (required reviewers, wait timers) and store environment-specific secrets there (useful for deployments).
    
- Rotating and auditing: rotate secrets regularly and use least privilege. For cloud credentials, scope them to minimal permissions.
    
- Secrets cannot be read by workflows as plaintext via the GitHub API once stored; they are injected at runtime only. Avoid committing secret values to repo or logs.
    

Example usage in workflow:

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Deploy
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        run: |
          aws s3 cp ./build s3://my-bucket --recursive
```

Security note: if you need to run workflows from external contributors that require secrets, use `environments` with approval gates or run those steps in a protected pipeline that requires human approval.

---

Short checklist (practical rules)

- Use `paths` and `paths-ignore` under `on: pull_request` to avoid unnecessary runs.
    
- Prefer `pull_request` for safe PR builds; use `pull_request_target` only if you need to run workflows with access to secrets, and handle security carefully.
    
- Use `env` at workflow/job/step levels for scoping; prefer explicit `env` on jobs/steps to avoid accidental leakage.
    
- Pass small values between jobs via **job outputs** (set via `$GITHUB_OUTPUT`), larger files via **artifacts**.
    
- Store credentials in **Secrets** (repo/org/environment). Do not echo secrets; secrets are masked but still sensitive.
    
- For deployments, use **environments** with required reviewers and environment secrets for safer production access.
    

---

Example combined snippet (pull_request path filter + secret usage + job outputs):

```yaml
name: PR CI with outputs and secrets

on:
  pull_request:
    branches: ["main"]
    paths:
      - 'src/**'
      - 'package.json'

env:
  NODE_ENV: test

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci && npm run lint

  build:
    runs-on: ubuntu-latest
    needs: lint
    outputs:
      build-id: ${{ steps.setid.outputs.build_id }}
    steps:
      - uses: actions/checkout@v4
      - id: setid
        run: |
          BUILD_ID="build-$(date +%s)"
          echo "build_id=$BUILD_ID" >> "$GITHUB_OUTPUT"
      - run: npm run build

  deploy:
    runs-on: ubuntu-latest
    needs: build
    if: github.event_name == 'pull_request' && github.event.pull_request.merged == true
    steps:
      - uses: actions/checkout@v4
      - name: Use build id and secrets
        env:
          BUILD_ID: ${{ needs.build.outputs.build-id }}
          SSH_KEY: ${{ secrets.DEPLOY_SSH_KEY }}
        run: |
          echo "Deploying $BUILD_ID"
          # use $SSH_KEY securely (avoid echoing it)
```

---

Uploaded file reference for your notes  
`/mnt/data/2025-11-24_21-28-25_grim.png`

---

