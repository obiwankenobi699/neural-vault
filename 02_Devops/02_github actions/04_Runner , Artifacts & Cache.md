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

## What is a Runner in GitHub Actions?

A **runner** is a machine (virtual or physical) that **executes the steps** defined in your GitHub Actions workflow `.yml` files.  
Whenever a workflow triggers (push, PR, schedule, manual dispatch), GitHub allocates a runner, downloads your repository, and runs the `jobs` and `steps` on that machine.

In simple terms:

**A runner = a worker machine that executes your CI/CD tasks.**

---

## Types of Runners

There are **two main categories**:

---

## 1. GitHub-Hosted Runners

These runners are automatically provided and maintained by GitHub.

### Characteristics

- Fully managed by GitHub
    
- Automatically created when a workflow triggers
    
- Fresh VM each time (clean environment)
    
- Pre-installed tooling
    
- Automatically scaled
    
- You pay via Actions minutes (free for public repos)
    

### Operating Systems Available

- Ubuntu (most common)
    
- Windows
    
- macOS
    
- ARM variants (Ubuntu/Windows ARM runners)
    

### Preinstalled Software Examples

- Git
    
- Docker
    
- Node.js, Python, Java, Go
    
- Android SDK
    
- Browsers (Chrome, Firefox)
    
- .NET, Ruby, PHP
    
- Build tools like gcc, make, ninja, CMake
    

### When to Use

- Most CI tasks
    
- Testing, linting, building
    
- Docker builds
    
- Multi-platform pipelines
    

---

## 2. Self-Hosted Runners

A **self-hosted runner** is a machine you configure yourself.

This can be:

- Your laptop
    
- On-prem server
    
- Cloud VM (AWS EC2 / GCP compute / Azure VM)
    
- Kubernetes pod
    
- Raspberry Pi
    
- Bare metal workstation
    

### Characteristics

- You manage installation, updates, security
    
- Persistent environment (state is NOT reset between runs)
    
- You choose the OS and hardware
    
- Useful for special hardware or large pipelines
    
- Can be **way cheaper** than using GitHub-hosted runners
    

### Benefits

- Unlimited minutes (free)
    
- Full control over software + hardware
    
- Faster builds possible (GPU, high RAM, multi-core servers)
    
- Can host runners behind firewalls
    

### When to Use

- Machine learning pipelines
    
- Heavy Docker builds
    
- GPU training
    
- Secure internal deployments
    
- Large monorepos
    
- Custom tools not available on GitHub-hosted runners
    

---

## What Does a Runner Actually Do?

When a workflow starts:

1. GitHub assigns a runner
    
2. Checks out your repo (via `actions/checkout`)
    
3. Executes each step in the job in order
    
4. Provides environment variables and GitHub context
    
5. Manages job logs
    
6. Handles caching and artifacts
    
7. Cleans up environment after execution
    

For GitHub-hosted runners:

- The VM is **destroyed** after the job.
    

For self-hosted runners:

- Nothing is destroyed automatically
    
- You must manage workspace cleanup manually or via `actions/runner`.
    

---

## Runner Labels

Every runner has a **label**, used in the workflow under `runs-on`.

### GitHub-hosted examples:

```yaml
runs-on: ubuntu-latest
runs-on: macos-14
runs-on: windows-latest
```

### Self-hosted examples:

GitHub auto-creates labels:

- `self-hosted`
    
- `linux` / `windows` / `macos`
    
- `x64` / `arm64`
    

You can add custom labels:

- `gpu`
    
- `ml`
    
- `docker-builder`
    

Workflow example using custom label:

```yaml
runs-on: [self-hosted, linux, gpu]
```

---

## What Happens Internally in a Runner?

### High-level process:

1. Workflow triggered
    
2. GitHub queues a job
    
3. A runner picks the job
    
4. Runner downloads workflow details
    
5. Runner executes each step
    
6. Runner sends logs back to GitHub
    

### ASCII Flow

```
Trigger (push/pr) 
        |
        v
+---------------------+
|   GitHub Actions    |
|   Workflow Engine   |
+---------------------+
        |
        v
   Assign Runner
        |
        v
+---------------------+
|     Runner VM       |
|  Executes Jobs/Steps|
+---------------------+
        |
        v
   Upload Logs/Artifacts
```

---

## YAML Example Using Both Runner Types

### GitHub-hosted runner

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm test
```

### Self-hosted runner

```yaml
jobs:
  build-heavy:
    runs-on: [self-hosted, linux, gpu]
    steps:
      - uses: actions/checkout@v4
      - run: python train.py
```

---

## When to Choose What?

|Use Case|GitHub Runner|Self-Hosted Runner|
|---|---|---|
|Normal CI|✔️||
|ML/GPU workloads||✔️|
|Private network deployment||✔️|
|Light pipelines|✔️||
|Cost-sensitive builds||✔️|
|ARM hardware needed|depends|✔️|
|Need clean environment|✔️||

---
Here is a clean, Obsidian-ready explanation of **Persisting Data and Artifacts in GitHub Actions**.  
This covers: what artifacts are, why they exist, where they are stored, how to upload/download, retention, caching vs artifacts, and advanced patterns.

---

# Persisting Data in GitHub Actions (Artifacts)

## What Are Artifacts?

Artifacts are **files or folders saved from a job** so that:

- They can be **downloaded later** from the workflow run page
    
- They can be **reused by later jobs** in the same workflow
    
- They can be **archived** for debugging, logs, binaries, coverage reports, datasets, builds
    
- They persist even after the runner VM is destroyed
    

GitHub-hosted runners are **ephemeral**, meaning the filesystem is wiped after each job.  
Artifacts solve this by letting you store output outside the runner.

---

# Why Use Artifacts?

- Pass files between jobs in a workflow
    
- Save build output (binaries, zip files, docker layers, ML models)
    
- Debug logs
    
- Test reports
    
- Save datasets
    
- Save screenshots from UI tests
    
- Save release artifacts (zip, exe, dmg, deb, rpm)
    

---

# Uploading an Artifact

You upload artifacts using:

```
- uses: actions/upload-artifact@v4
```

Example:

```
steps:
  - name: Build
    run: make build

  - name: Upload build output
    uses: actions/upload-artifact@v4
    with:
      name: my-build
      path: dist/
```

This uploads the folder `dist/` as an artifact named **my-build**.

---

# Downloading an Artifact in Another Job

```
- uses: actions/download-artifact@v4
  with:
    name: my-build
    path: ./build-output
```

---

# DAG Example: Passing Artifacts Between Jobs

```
jobs:

  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm run build
      - uses: actions/upload-artifact@v4
        with:
          name: webapp
          path: build/

  test:
    runs-on: ubuntu-latest
    needs: build
    steps:
      - uses: actions/download-artifact@v4
        with:
          name: webapp
          path: app/
      - run: npm test
```

ASCII:

```
build (uploads artifact)
   |
   v
test (downloads artifact)
```

---

# Artifact Retention and Storage

Default retention: **90 days**  
You can override:

```
retention-days: 5
```

Storage limit:

- Free: 500MB
    
- Team/Enterprise: More
    

---
Here is a clean, complete, Obsidian-ready explanation on **Persisting Data & Artifacts in GitHub Actions** (expanded since you replied “yes”).  
No icons, no emojis.

---

# Persisting Data and Artifacts in GitHub Actions

## 1. What Are Artifacts?

Artifacts are files or directories that your workflow uploads during one job so they can be **stored**, **downloaded**, or **used by other jobs**. They are GitHub’s official mechanism for persisting data between steps or jobs.

Examples of artifacts:

- Build output (compiled binaries, bundles)
    
- Test reports or coverage reports
    
- Log files
    
- Exported datasets
    
- Model weights or temporary assets
    

Artifacts are stored by GitHub only for the duration you configure (default 90 days).

---

## 2. Why Persist Artifacts?

GitHub Actions runs each job on a clean virtual environment unless you use self-hosted runners. That means:

- Jobs do not share files automatically
    
- Containers/jobs start fresh without previous state
    

Artifacts solve this by providing a controlled way to pass files across jobs or allow users to download them after a workflow finishes.

---

## 3. How to Upload Artifacts

Use the `actions/upload-artifact` action.

### Example: Uploading build output

```yaml
- name: Upload build output
  uses: actions/upload-artifact@v4
  with:
    name: build-output
    path: ./dist
```

This stores the `dist` directory as an artifact named `build-output`.

---

## 4. How to Download Artifacts

In later jobs, use `actions/download-artifact`.

```yaml
- name: Download build output
  uses: actions/download-artifact@v4
  with:
    name: build-output
    path: ./dist
```

Now the next job can reuse the output.

---

## 5. Example Workflow Passing Artifacts Between Jobs

```yaml
name: Build and Test

on: push

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Build project
        run: npm run build

      - name: Upload build output
        uses: actions/upload-artifact@v4
        with:
          name: build
          path: dist/

  test:
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Download build output
        uses: actions/download-artifact@v4
        with:
          name: build
          path: dist/

      - name: Run tests on built output
        run: npm test
```

---

## 6. Workflow DAG (Job Dependency Structure)

A Directed Acyclic Graph (DAG) shows job relationships.

```
   +--------+
   | build  |
   +--------+
        |
        v
   +--------+
   |  test  |
   +--------+
```

Jobs run in order based on `needs:`.

---

## 7. Artifacts vs Caching

It's important to distinguish:

### Artifacts

- Persist data between **jobs**
    
- Files accessible after workflow ends
    
- Intended for output, test results, bundles, logs
    

### Cache

- Speeds up workflows by caching dependencies
    
- Designed for node_modules, pip cache, build cache
    
- Not available for user download
    
- Not preserved between jobs automatically unless restored
    

---

## 8. Best Practices for Artifacts

1. Only upload necessary files (avoid large node_modules).
    
2. Compress large artifacts before upload.
    
3. Use meaningful artifact names.
    
4. Use artifacts for:
    
    - Passing compiled code to deployment
        
    - Persisting logs for debugging
        
    - Passing generated assets to later jobs
        
5. Use caching instead for speeding up dependency installs.
    

---

# Case Study: How GitHub Actions Cache Works

### Should You Cache `node_modules`? How Do Companies Do It?

---

# 1. Scenario Background

You are a full-stack + ML engineer building a CI pipeline for a Node.js project.  
Goal: **Speed up CI**, reduce npm install time, keep builds stable.

Two options exist:

1. Cache **node_modules**
    
2. Cache **npm cache** (the recommended real-world approach)
    

This case study compares both with diagrams, why companies choose one over the other, and complete YAML examples.

---

# 2. Key Question

**Does GitHub Actions Cache store `node_modules`?**  
**Yes — but only if you explicitly include it in `path:`.**

Example:

```yaml
path: node_modules
```

But storing node_modules directly has problems.

---

# 3. Why Companies Avoid Caching `node_modules`

Caching `node_modules` leads to issues:

- Node version changes → cache breaks
    
- Ubuntu runner updates weekly → cache invalid
    
- Permissions mismatched between hosts
    
- Cache size can be huge (200MB–1GB)
    

This causes inconsistent builds.

---

# 4. What the Industry Actually Does

Most professional CI pipelines cache **npm’s artifact cache** instead of `node_modules`.

They cache this directory:

```
~/.npm
```

This stores downloaded package tarballs, not the fully built modules.

Then they still run:

```
npm ci
```

This ensures a clean, reproducible `node_modules`.

---

# 5. ASCII Diagram: What Actually Gets Cached

### A. Caching `node_modules`

```
+--------------------+
| GitHub Cache       |
+--------------------+
          ^
          | restore
          |
+----------------------+
| node_modules         |
| (large, OS-bound)    |
+----------------------+
```

Fast but fragile.

---

### B. Caching `~/.npm`

```
+------------------------+
| GitHub Cache           |
+------------------------+
          ^
          | restore
          |
+------------------------+
| ~/.npm                 |
| (downloaded packages)  |
| small + stable         |
+------------------------+

npm ci  ---> builds fresh node_modules
```

Slightly slower than caching node_modules,  
but **100× more stable and recommended by GitHub + npm docs**.

---

# 6. Real-World Example: Recommended Pipeline

### Cache npm cache + clean install

```yaml
name: CI

on:
  push:
    branches: [ main ]
  pull_request:

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Use Node 20
        uses: actions/setup-node@v4
        with:
          node-version: 20

      - name: Cache npm downloads
        uses: actions/cache@v4
        with:
          path: ~/.npm
          key: npm-${{ runner.os }}-${{ hashFiles('package-lock.json') }}
          restore-keys: |
            npm-${{ runner.os }}-

      - name: Install deps
        run: npm ci

      - name: Run build
        run: npm run build
```

---

# 7. Example: Caching `node_modules` (Not Recommended But Allowed)

```yaml
- name: Cache node_modules
  uses: actions/cache@v4
  with:
    path: node_modules
    key: node-${{ runner.os }}-${{ hashFiles('package-lock.json') }}
    restore-keys: |
      node-${{ runner.os }}-
```

After restore:

```
if node_modules exists → npm install --prefer-offline
else → npm ci
```

---

# 8. Real-World Benchmark Comparison

|Method|Speed|Stability|Cache Size|Industry Use|
|---|---|---|---|---|
|Cache node_modules|★★★★★|★★☆☆☆|very large|low|
|Cache ~/.npm|★★★★☆|★★★★★|small|very high (best practice)|
|No cache|★★☆☆☆|★★★★★|none|small projects|

**Conclusion: cache npm cache, not node_modules.**

---

# 9. Final Case Study Conclusion

**Summary:**

- GitHub Actions cache stores **whatever paths you list** in the YAML.
    
- You _can_ cache `node_modules`, but it’s fragile, OS-dependent, and large.
    
- Real-world teams (GitHub, Microsoft, Netflix, Meta) **cache ~/.npm** instead.
    
- This keeps builds deterministic but still fast.
    
- Always use a hash key based on `package-lock.json` for cache invalidation.
    

The winning pattern:

**cache → ~/.npm**  
**install → npm ci**  
**build → stable reproducible output**

This is the standard CI practice in the industry.

---
Below is a clean, Obsidian-ready explanation of **how GitHub Actions creates artifacts**, **what `actions/cache` actually does**, **what “npm cache” means**, and **what a cache `key` is** — with clear examples.

---

# 1. What is an Artifact?

An **artifact** is a file or folder that your workflow uploads and stores after a job finishes.

Artifacts are used to:

- store build outputs
    
- share files between jobs
    
- download results locally (logs, binaries, model weights, etc.)
    

Artifacts are persistent:  
**They live for the duration you configure (default 90 days).**

Artifacts use this official action:

```
actions/upload-artifact
```

Example:

```yaml
- name: Upload build output
  uses: actions/upload-artifact@v4
  with:
    name: web-build
    path: dist/
```

This stores your `dist/` folder as an artifact.

---

# 2. How Artifacts Work (ASCII)

```
Job Output (dist/)
       |
       v
+-----------------------+
| upload-artifact@v4    |
+-----------------------+
       |
       v
Artifact Stored in GitHub
```

Artifacts are meant for **files you want to download or use later**.

---

# 3. What is Github Cache (`actions/cache`)?

Caching is **completely different** from artifacts.

`actions/cache@v4` stores **dependencies** so builds run faster next time.

Example stored items:

- `~/.npm` (npm downloaded packages cache)
    
- Python pip cache (`~/.cache/pip`)
    
- Node modules (not recommended but possible)
    
- Build intermediate files
    

Cache = performance  
Artifact = storage / distribution

---

# 4. How Cache Works (ASCII)

```
Job Start
   |
   v
actions/cache (tries to restore)
   |
   +--> Cache HIT ----> skip download → fast install
   |
   +--> Cache MISS ---> full install → save new cache
```

---

# 5. What is “npm cache”?

When you install packages, npm downloads **tarballs** (compressed package files).  
These downloads are stored in a folder called the **npm cache**, usually here:

```
~/.npm
```

Inside it you’ll see:

```
~/.npm/_cacache/index-v5/*
```

This cache stores:

- tarballs
    
- metadata
    
- integrity data
    

It makes repeat installs **super fast**.

---

# 6. Why We Cache ~/.npm Instead of node_modules

Caching node_modules:

- huge (200MB–1GB)
    
- OS-dependent
    
- breaks with node version changes
    

Caching npm cache:

- small
    
- stable
    
- supported by official Node team
    
- improves install speed by 60–80%
    

This is why companies use:

```
path: ~/.npm
```

---

# 7. What is “key” in actions/cache?

The **key** uniquely identifies a cache entry.

Example:

```yaml
key: npm-${{ runner.os }}-${{ hashFiles('package-lock.json') }}
```

Breakdown:

- `npm-` → prefix
    
- `${{ runner.os }}` → ensures Linux cache ≠ Windows cache
    
- `hashFiles('package-lock.json')` → links cache to dependency versions
    

So if package-lock.json changes:

- you get **new cache**
    
- old cache is preserved
    
- builds stay reproducible
    

---

# 8. Full Example With Cache and Artifact (Real-World)

```yaml
name: CI

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20

      - name: Cache npm downloads
        uses: actions/cache@v4
        with:
          path: ~/.npm
          key: npm-${{ runner.os }}-${{ hashFiles('package-lock.json') }}
          restore-keys: |
            npm-${{ runner.os }}-

      - name: Install
        run: npm ci

      - name: Build
        run: npm run build

      - name: Upload artifact
        uses: actions/upload-artifact@v4
        with:
          name: build-output
          path: dist/
```

---

# 9. Final Conclusion (Short and Clear)

### Artifacts

- Used to store files (builds, logs, models).
    
- Use: `actions/upload-artifact`.
    

### Cache

- Used to speed up workflows by storing dependencies.
    
- Use: `actions/cache`.
    

### npm cache

- Directory where npm stores downloaded packages (`~/.npm`).
    
- Fast and stable → recommended to cache.
    

### key

- A unique identifier for cache entries.
    
- Changing the key makes a new cache.
    

---
