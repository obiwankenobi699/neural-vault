---
title:
  "{ Title }":
tags:
  - DevOps
  - Git
created:
  "{ date }":
updated:
  "{ date }":
---
Below is a concise, practical guide covering **GitHub tokens (GITHUB_TOKEN)**, **what permissions it has**, **how the runner provides it**, **how to use it (curl / gh / actions)**, differences with **PATs / GitHub Apps / OIDC**, security notes, and several ready-to-paste YAML / shell examples. Key internet references are cited.

---

## What is `GITHUB_TOKEN` and how the runner provides it

- `GITHUB_TOKEN` is a **repository-scoped, short-lived token** automatically created by GitHub for each workflow run. It is an **installation access token** issued to the GitHub App that backs Actions for that repository, and it is automatically injected into the workflow as a secret named `GITHUB_TOKEN`. Use it via `${{ secrets.GITHUB_TOKEN }}` or as the environment variable `GITHUB_TOKEN`. ([GitHub Docs](https://docs.github.com/en/actions/concepts/security/github_token?utm_source=chatgpt.com "GITHUB_TOKEN"))
    
- The runner does not “create” the token locally — GitHub issues it when the workflow starts, injects it into the runner environment, and revokes it when the run finishes. You cannot reuse it outside that run.
    

---

## What permissions does `GITHUB_TOKEN` have (and how to control them)

- The exact **default** permissions can be configured at repository/organization level (there is a workflow-permissions setting in repo/org settings). Defaults vary: personal repos may default to more restricted (contents: read) while org settings can give broader rights. Because defaults can change, **always explicitly set the permissions you need in your workflow** rather than relying on defaults. ([GitHub Docs](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/enabling-features-for-your-repository/managing-github-actions-settings-for-a-repository?utm_source=chatgpt.com "Managing GitHub Actions settings for a repository"))
    
- To change token scopes for a workflow, add a `permissions:` block at the workflow top-level (applies to all jobs) or per job (applies to that job). Use fine-grained least-privilege: request only what you need (for example `contents: read` or `pull-requests: write`). See example below. ([GitHub Docs](https://docs.github.com/actions/using-workflows/workflow-syntax-for-github-actions?utm_source=chatgpt.com "Workflow syntax for GitHub Actions"))
    

### Example — set permissions at the workflow level

```yaml
name: CI

on: [push]

permissions:
  contents: read        # repo contents (checkout) read-only
  pull-requests: write  # allow creating/merging PRs if needed
  id-token: write       # allow OIDC token exchange (if using OIDC)

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
```

### Example — set permissions per job

```yaml
jobs:
  release:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      issues: write
    steps:
      - uses: actions/checkout@v4
```

---

## How to access/use the token inside a step (curl, gh, git)

- The token is available in the workflow as `${{ secrets.GITHUB_TOKEN }}`. You can inject it into an environment variable or use it directly when calling the REST API.
    

**Using curl**

```yaml
- name: Call GitHub API
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  run: |
    curl -H "Authorization: Bearer $GITHUB_TOKEN" \
         -H "Accept: application/vnd.github+json" \
         https://api.github.com/repos/${{ github.repository }}/issues
```

GitHub’s REST docs show `Authorization: Bearer <token>` usage. ([GitHub Docs](https://docs.github.com/en/rest/authentication/authenticating-to-the-rest-api?utm_source=chatgpt.com "Authenticating to the REST API"))

**Using `gh` CLI**

```yaml
- uses: actions/setup-node@v4
- run: |
    echo "${{ secrets.GITHUB_TOKEN }}" | gh auth login --with-token
    gh api repos/${{ github.repository }}/actions/runs
```

**For git pushes from a workflow** (commit + push), use the `GITHUB_TOKEN` with `git`:

```yaml
- name: Push changes
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  run: |
    git config user.name "github-actions[bot]"
    git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
    git remote set-url origin https://x-access-token:$GITHUB_TOKEN@github.com/${{ github.repository }}.git
    git add .
    git commit -m "Auto changes"
    git push origin HEAD:main
```

Note: the token must have `contents: write` to push. ([GitHub Docs](https://docs.github.com/en/rest/authentication/authenticating-to-the-rest-api?utm_source=chatgpt.com "Authenticating to the REST API"))

---

## Token behavior for different triggers (security implication)

- Workflows triggered by **pull requests from forks** run with **restricted** token permissions (to prevent secret exfiltration). If you need repository secrets for a PR from a fork you must use `pull_request_target` (dangerous) or a protected workflow pattern with manual approvals/environments. Do not run untrusted code with write-level tokens. ([GitHub Docs](https://docs.github.com/actions/using-workflows/workflow-syntax-for-github-actions?utm_source=chatgpt.com "Workflow syntax for GitHub Actions"))
    

---

## Self-hosted runners and `GITHUB_TOKEN`

- Self-hosted runners receive the same `GITHUB_TOKEN` for the run, but they are **more sensitive** because the host machine could be compromised; anyone with access to that machine could potentially read secrets available to the runner. Limit which repositories can use self-hosted runners and apply least-privilege. Treat self-hosted runners as sensitive infrastructure. ([GitHub Docs](https://docs.github.com/en/actions/concepts/security/github_token?utm_source=chatgpt.com "GITHUB_TOKEN"))
    

---

## OIDC and exchanging token for cloud credentials

- For cloud deployments, prefer **OIDC** (OpenID Connect) to mint short-lived cloud credentials directly from the runner (`id-token: write` permission). This avoids storing long-lived cloud secrets in GitHub. To enable OIDC you must grant `id-token: write` in `permissions:` and use `actions/iam` or the cloud provider’s OIDC settings. ([GitHub Docs](https://docs.github.com/actions/using-workflows/workflow-syntax-for-github-actions?utm_source=chatgpt.com "Workflow syntax for GitHub Actions"))
    

---

## When to use `GITHUB_TOKEN` vs a Personal Access Token (PAT) or GitHub App

- **GITHUB_TOKEN**: short-lived, repo-scoped, safe for most in-workflow operations. It is automatically rotated and revoked after the job.
    
- **PAT**: long-lived (user-scoped), used when you need cross-repo access, external services, or permissions not available through `GITHUB_TOKEN`. Store PATs in repo/org secrets and rotate regularly.
    
- **GitHub App**: for fine-grained, installable app behavior (useful for integrations). `GITHUB_TOKEN` is actually an installation token for GitHub App used by Actions. ([GitHub Docs](https://docs.github.com/en/actions/concepts/security/github_token?utm_source=chatgpt.com "GITHUB_TOKEN"))
    

---

## Best practices (short)

- Always **explicitly set** `permissions:` in workflows to least-privilege. ([GitHub Docs](https://docs.github.com/actions/using-workflows/workflow-syntax-for-github-actions?utm_source=chatgpt.com "Workflow syntax for GitHub Actions"))
    
- Do not use `secrets.GITHUB_TOKEN` to authenticate to external services — use dedicated secrets or OIDC.
    
- Be careful with `pull_request_target` — never run untrusted code with write-level permissions. ([GitHub Docs](https://docs.github.com/actions/using-workflows/workflow-syntax-for-github-actions?utm_source=chatgpt.com "Workflow syntax for GitHub Actions"))
    
- For self-hosted runners, restrict which workflows can run and who can administer the host. ([openssf.org](https://openssf.org/blog/2024/08/12/mitigating-attack-vectors-in-github-workflows/?utm_source=chatgpt.com "Mitigating Attack Vectors in GitHub Workflows"))
    

---

## Ready-to-use YAML snippets

**Minimal least-privilege workflow (read-only contents):**

```yaml
name: Safe CI

on: [push]

permissions:
  contents: read
  actions: read

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "GITHUB_TOKEN is available as secrets.GITHUB_TOKEN"
```

**Workflow that needs to create a release (grant only what’s needed):**

```yaml
name: Release

on:
  workflow_dispatch:

permissions:
  contents: write
  packages: write
  issues: write

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Create release via API
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          curl -X POST -H "Authorization: Bearer $GITHUB_TOKEN" \
               -H "Accept: application/vnd.github+json" \
               https://api.github.com/repos/${{ github.repository }}/releases \
               -d '{"tag_name":"v1.0.0","name":"Release v1.0.0","draft":false}'
```

---

## References

- GitHub docs: GITHUB_TOKEN and authentication in a workflow. ([GitHub Docs](https://docs.github.com/en/actions/concepts/security/github_token?utm_source=chatgpt.com "GITHUB_TOKEN"))
    
- GitHub docs: workflow permissions and how defaults are managed in repo/org settings. ([GitHub Docs](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/enabling-features-for-your-repository/managing-github-actions-settings-for-a-repository?utm_source=chatgpt.com "Managing GitHub Actions settings for a repository"))
    
- GitHub REST auth examples (curl / gh). ([GitHub Docs](https://docs.github.com/en/rest/authentication/authenticating-to-the-rest-api?utm_source=chatgpt.com "Authenticating to the REST API"))
    
- Security guidance on workflow permissions and attack vectors. ([openssf.org](https://openssf.org/blog/2024/08/12/mitigating-attack-vectors-in-github-workflows/?utm_source=chatgpt.com "Mitigating Attack Vectors in GitHub Workflows"))
    

---

Reference image (your uploaded file): `/mnt/data/2025-11-24_21-28-25_grim.png`

If you want, I can:

- generate a one-page Obsidian note with the YAML examples above,
    
- create a visual ASCII flow of how the runner requests and receives `GITHUB_TOKEN`,
    
- or produce a secure workflow template that uses least-privilege for releases or deploys. Which would you like?