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

---

## **1. CI Pipeline (Code Validation)**

**Purpose:** Make sure code is correct before it merges to main branch.

**Example in real life:**

- A React + Node.js app in a company repo
    
- Pipeline steps:
    
    1. Checkout code
        
    2. Install dependencies (`npm ci`)
        
    3. Run tests (`npm test`)
        
    4. Run linter (`eslint`) and format checks (`prettier`)
        
    5. Upload test coverage reports
        

**Trigger:** Pull request (PR) opened  
**Benefit:** PR cannot be merged if tests fail → prevents breaking main branch

---

## **2. CD Pipeline (Automatic Deployment)**

**Purpose:** Automatically release your code to users.

**Example in real life:**

- A web app deployed to **Netlify or Vercel**
    
- Pipeline steps:
    
    1. Checkout code
        
    2. Install dependencies
        
    3. Build project (`npm run build`)
        
    4. Deploy build folder to hosting
        
- Optional: Add cache for `node_modules` to speed up builds
    

**Trigger:** Push to `main`  
**Benefit:** Developers don’t have to manually upload files → fast and consistent releases

---

## **3. Scheduled Pipeline**

**Purpose:** Run tasks automatically on a schedule.

**Example in real life:**

- A data analytics pipeline:
    
    1. Every night at 2 AM, pull latest sales data from database
        
    2. Run data cleaning scripts
        
    3. Generate CSV reports
        
    4. Commit reports to a GitHub repo or send via email
        

**Trigger:** Cron schedule (`cron: "0 2 * * *"`)  
**Benefit:** Reports are generated automatically every day

---

## **4. Manual / Workflow Dispatch Pipeline**

**Purpose:** Trigger workflows **on demand**, not automatically.

**Example in real life:**

- A marketing team wants to update README or badges before a product launch
    
- Steps:
    
    1. Append current timestamp / update version badge
        
    2. Push changes to `main`
        
- Triggered via **“Run workflow”** in GitHub Actions
    

**Benefit:** Flexible and safe, doesn’t run automatically unless requested

---

## **5. Release / Versioning Pipeline**

**Purpose:** Automate releases and version management.

**Example in real life:**

- An NPM package project:
    
    1. Run tests
        
    2. Bump version (patch, minor, major)
        
    3. Generate changelog
        
    4. Publish to NPM
        
    5. Create GitHub release with changelog attached
        

**Trigger:** Push to main or manual dispatch  
**Benefit:** Reduces human error and keeps versions consistent

---

## **6. Security / Code Quality Pipeline**

**Purpose:** Make sure code is secure and high-quality.

**Example in real life:**

- A SaaS company:
    
    1. Run static code analysis (SAST)
        
    2. Scan for secrets in commits
        
    3. Run dependency vulnerability check (`npm audit`)
        
    4. Block merge if critical issues found
        

**Trigger:** Pull request or push  
**Benefit:** Prevents insecure code from being merged

---

## **7. Infrastructure / DevOps Pipeline**

**Purpose:** Manage infrastructure deployment automatically.

**Example in real life:**

- Kubernetes deployment pipeline:
    
    1. Build Docker image
        
    2. Push image to Docker Hub
        
    3. Update Kubernetes manifests
        
    4. Apply manifests to cluster using `kubectl`
        
- Trigger: Push to `main` or manual
    

**Benefit:** Infrastructure changes are versioned, repeatable, and automated

---

### **Summary Table**

|Pipeline Type|Trigger|Example Steps|Real-life Benefit|
|---|---|---|---|
|CI|PR / push|Tests, lint, build|Prevent broken code in main|
|CD|Push to main|Build, deploy to hosting|Quick, automated releases|
|Scheduled|Cron|Data reports, cleanup|Automates repetitive tasks|
|Manual|workflow_dispatch|Update README, trigger builds|Controlled, on-demand actions|
|Release|Push / manual|Version bump, changelog, publish|Consistent software releases|
|Security / Quality|PR / push|SAST, secrets, dependency scan|Prevent vulnerabilities|
|DevOps / Infra|Push / manual|Docker build, deploy to Kubernetes|Automated infrastructure management|

---
Nice — below are **concise, copy-pasteable GitHub Actions YAML examples** covering the major pipeline _types_ you’ll encounter in real life. Each example has a short explanation and a ready-to-use workflow file.  
**Important:** Many orgs require actions pinned to a full commit SHA for security. If your repo enforces that, **replace `@v3` / `@main` style tags with the action’s full-length commit SHA** before using (I’ll mention where secrets are required).

---

# CI — Node / React test + lint (runs on PRs)

Runs tests, lint, and uploads coverage. Trigger: `pull_request`.

```yaml
name: CI — test & lint

on:
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repo
        uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: 20
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Run linter
        run: npm run lint

      - name: Run tests
        run: npm test

      - name: Upload coverage (optional)
        if: success()
        uses: actions/upload-artifact@v4
        with:
          name: coverage-report
          path: coverage/
```

**Use when:** You want PRs blocked until tests/lint pass.

---

# CD — Build & Deploy to GitHub Pages (manual dispatch or push to main)

Builds Vite app and deploys to `gh-pages` using `peaceiris/actions-gh-pages`.

```yaml
name: Deploy to GitHub Pages

on:
  workflow_dispatch:
  push:
    branches:
      - main

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Setup Node
        uses: actions/setup-node@v3
        with:
          node-version: 20
          cache: 'npm'

      - name: Install
        run: npm ci

      - name: Build
        run: npm run build

      - name: Deploy to gh-pages
        uses: peaceiris/actions-gh-pages@v7
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./dist
```

**Secrets:** None additional (uses `GITHUB_TOKEN`) — but branch protection must allow this or use PAT.

---

# Docker — Build image and push to registry (GHCR/Docker Hub)

CI that builds a Docker image and pushes it to a registry on push to `main`.

```yaml
name: Docker Build & Push

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build-push:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Set up QEMU (for multi-arch)
        uses: docker/setup-qemu-action@v2

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2

      - name: Login to registry
        uses: docker/login-action@v2
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GHCR_TOKEN }} # create PAT or use GITHUB_TOKEN depending on permissions

      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ghcr.io/${{ github.repository_owner }}/my-app:latest
          file: ./Dockerfile
```

**Secrets:** `GHCR_TOKEN` (or use `GITHUB_TOKEN` with proper permissions). Replace action tags with SHAs if required.

---

# Scheduled — Nightly report (cron)

Run nightly job to generate or update reports.

```yaml
name: Nightly Report

on:
  schedule:
    - cron: '0 2 * * *'  # every day at 02:00 UTC
  workflow_dispatch:

jobs:
  nightly:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Run report script
        run: |
          npm ci
          npm run generate-report
      - name: Upload report
        uses: actions/upload-artifact@v4
        with:
          name: nightly-report
          path: reports/
```

**Use when:** You need automated tasks on a schedule (backups, reports, dependency updates).

---

# Manual / Dispatch — single-branch README updater (no branch clutter)

Manual dispatch that edits README and pushes directly to `main`. **Requires branch protection to allow Actions or a PAT**.

```yaml
name: Manual README Update

on:
  workflow_dispatch:
    inputs:
      message:
        description: 'Message to echo'
        required: false
        default: 'Manual run'

jobs:
  update-readme:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
        with:
          persist-credentials: true

      - name: Append timestamp
        run: |
          echo "Manual message: ${{ github.event.inputs.message }}" >> README.md
          echo "Last manual run: $(date)" >> README.md
          git config --local user.email "github-actions[bot]@users.noreply.github.com"
          git config --local user.name "github-actions[bot]"
          git add README.md
          git commit -m "Update README [skip ci]" || echo "No changes"
          git push origin main
```

**Note:** If push fails because of protection, either allow Actions to push or use a PAT.

---

# Release pipeline — bump version, build, publish NPM, create GitHub Release

Automates version bump, npm publish and GitHub Release when a tag is pushed or on dispatch.

```yaml
name: Release — publish to npm

on:
  workflow_dispatch:
    inputs:
      release_type:
        description: 'patch|minor|major'
        required: true
        default: 'patch'
  push:
    tags:
      - 'v*.*.*'

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Setup Node
        uses: actions/setup-node@v3
        with:
          node-version: 20
          cache: 'npm'

      - name: Install and build
        run: |
          npm ci
          npm run build

      - name: Bump version & create tag (manual dispatch flow)
        if: ${{ github.event_name == 'workflow_dispatch' }}
        run: |
          npm version ${{ github.event.inputs.release_type }} -m "chore(release): %s"
          git push --follow-tags

      - name: Publish to npm (on tag push)
        if: startsWith(github.ref, 'refs/tags/')
        env:
          NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}
        run: npm publish
```

**Secrets:** `NPM_TOKEN` for publishing. You can expand to create a GitHub Release via `actions/create-release`.

---

# Security scan — dependency & static analysis (example)

Run `npm audit` and CodeQL analysis on PRs.

```yaml
name: Security & Static Analysis

on:
  pull_request:
  push:
    branches: [ main ]

jobs:
  npm-audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node
        uses: actions/setup-node@v3
        with: { node-version: 20 }
      - name: Install
        run: npm ci
      - name: npm audit
        run: npm audit --json > audit.json || true
      - name: Upload audit
        uses: actions/upload-artifact@v4
        with:
          name: npm-audit
          path: audit.json

  codeql:
    name: CodeQL analysis
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Initialize CodeQL
        uses: github/codeql-action/init@v2
        with:
          languages: javascript
      - name: Autobuild
        uses: github/codeql-action/autobuild@v2
      - name: Perform CodeQL analysis
        uses: github/codeql-action/analyze@v2
```

**Tip:** Add severity gating or fail-on-findings if you want PRs blocked.

---

## Quick notes & best practices

- **Pin actions to SHAs** if your org requires it (replace `@v3` with full commit SHA).
    
- **Use secrets** for credentials (Docker Hub, GHCR, NPM). Add them in repo Settings → Secrets → Actions.
    
- **Cache dependencies** (`actions/cache` or `setup-node cache`) to speed builds.
    
- **Use `persist-credentials: true`** with `actions/checkout` when pushing back with `GITHUB_TOKEN`.
    
- **Use `[skip ci]` in commit messages** to prevent loops.
    
- **Protect `main`** via branch protection rules and design pipelines to comply (PR flow or allow Actions/PAT).
    
- **Separate jobs** for lint/test/build to get parallelism and faster feedback.
    

---
