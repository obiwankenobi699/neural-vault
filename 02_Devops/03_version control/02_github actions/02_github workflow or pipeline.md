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

## 1. Events

Events are **triggers** that start a GitHub Action workflow.  
These triggers are fired by actions inside the repository or by external GitHub events.

### Key Examples

- **push** — starts workflow whenever new commits are pushed
    
- **pull_request** — starts workflow when a PR is opened, updated, or closed
    
- **workflow_dispatch** — manually start from GitHub UI
    
- **schedule** — cron-based automation
    
- **release** — when a release is created or updated
    

### Summary

Events = “What causes your workflow to start?”

---

## 2. Workflows

A Workflow is the _whole YAML file_ inside `.github/workflows/...`.

It contains **jobs**, which contain **steps**.  
A repository can have multiple workflows.

### Structure

```
.github/
 └── workflows/
      ├── ci.yml
      └── deploy.yml
```

Workflows = your **full automation pipeline definition**.

---

## 3. Pipelines

GitHub does not use the term “pipeline” officially, but a workflow itself _acts as a pipeline_.  
People use "pipeline" to refer to:

- the full automation flow
    
- from event → workflow → jobs → steps → runner → output
    

So you can think of **Pipeline = Workflow + Jobs + Steps**.

---

## 4. Jobs

Jobs are **sections inside a workflow** that run tasks.  
Each job runs in a **separate runner** unless you chain them with `needs`.

### Example

```
jobs:
  build:
    runs-on: ubuntu-latest
  test:
    runs-on: ubuntu-latest
    needs: build
```

### Summary

Jobs = “A group of steps that run in one runner.”

---

## 5. Steps

Steps are the **actual commands in a job**, executed one-by-one.

Steps can be:

- shell commands
    
- actions from the marketplace
    

### Example

```
steps:
  - name: Checkout
    uses: actions/checkout@v4

  - name: Install dependencies
    run: npm install

  - name: Run tests
    run: npm test
```

Steps = “Exact tasks inside a job.”

---

## 6. Runner

A runner is a **machine** that executes a job.

### Types

- **GitHub-hosted runner** — Ubuntu, Windows, macOS virtual machines
    
- **Self-hosted runner** — Your own laptop, server, cloud VM, Docker runner, etc.
    

Each job is assigned to **one runner**, and steps run sequentially on that runner.

---

# ASCII Diagram: Complete Workflow Structure

```
               +----------------------+
               |      GitHub Event    |
               |  (push / PR / cron)  |
               +----------+-----------+
                          |
                          v
                +--------------------+
                |     WORKFLOW       |
                |  (.github/workflows) 
                +----------+---------+
                           |
     --------------------------------------------------
     |                                                |
     v                                                v
+------------+                               +----------------+
|   JOB 1    |  -- runs-on --> Runner A      |     JOB 2      |
| (build)    |------------------------------>|    (test)      |
+-----+------+                               +--------+-------+
      |                                               |
      v                                               v
+------------+                                 +-------------+
|  Steps     |                                 |   Steps     |
|  checkout  |                                 |   checkout  |
|  install   |                                 |   test      |
|  build     |                                 |             |
+------------+                                 +-------------+
```

---

# Full Example Workflow (Pipeline)

```
name: CI Pipeline

on:
  push:
    branches: [ "main" ]

jobs:

  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repo
        uses: actions/checkout@v4

      - name: Install Dependencies
        run: npm install

      - name: Build Project
        run: npm run build

  test:
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Checkout Repo
        uses: actions/checkout@v4

      - name: Install Dependencies
        run: npm install

      - name: Run Tests
        run: npm test
```

---

# Final Summary

### Event

Triggers your workflow.

### Workflow

YAML automation file inside `.github/workflows`.

### Pipeline

Informal term representing the entire workflow execution.

### Jobs

Groups of steps executed on runners.

### Steps

Commands or GitHub Actions executed inside a job.

### Runner

Machine that executes the job.
Here is a clean, Obsidian-ready explanation of **DAG (Directed Acyclic Graph) Jobs** in GitHub Actions, with diagrams and a full YAML example.

---

# DAG Jobs in GitHub Actions

A Directed Acyclic Graph (DAG) describes the **order** and **dependencies** between jobs in a workflow.  
In GitHub Actions, this is done using the **needs** keyword.

---

# 1. What is a DAG in GitHub Actions?

GitHub Actions workflows form a **DAG**:

- **Nodes** = jobs
    
- **Edges** = dependencies using `needs`
    
- No cycles allowed (a job cannot depend on itself)
    

This allows complex pipelines like:

- parallel jobs
    
- sequential jobs
    
- fan-out → fan-in
    
- multi-stage pipelines
    

---

# 2. ASCII Diagrams of DAG Structures

---

## A. Linear DAG

```
Job A → Job B → Job C
```

### YAML

```
jobs:
  A:
    runs-on: ubuntu-latest

  B:
    runs-on: ubuntu-latest
    needs: A

  C:
    runs-on: ubuntu-latest
    needs: B
```

---

## B. Fan-Out DAG

```
        Job A
       /  |  \
   Job B Job C Job D
```

### YAML

```
jobs:
  A:
    runs-on: ubuntu-latest

  B:
    runs-on: ubuntu-latest
    needs: A

  C:
    runs-on: ubuntu-latest
    needs: A

  D:
    runs-on: ubuntu-latest
    needs: A
```

---

## C. Fan-In DAG

```
Job B
   \ 
    \
     → Job D
    /
Job C
```

### YAML

```
jobs:
  B:
    runs-on: ubuntu-latest

  C:
    runs-on: ubuntu-latest

  D:
    runs-on: ubuntu-latest
    needs: [B, C]
```

---

## D. Complex DAG (Fan-Out + Fan-In)

```
            Job A
      /       |        \
   Job B    Job C    Job D
       \      |       /
        \     |      /
          \   |     /
             Job E
```

---

### YAML (Complex DAG)

```
jobs:
  A:
    runs-on: ubuntu-latest

  B:
    runs-on: ubuntu-latest
    needs: A

  C:
    runs-on: ubuntu-latest
    needs: A

  D:
    runs-on: ubuntu-latest
    needs: A

  E:
    runs-on: ubuntu-latest
    needs: [B, C, D]
```

---

# 3. Full Real-World DAG Workflow Example

This mimics a CI/CD pipeline:

```
name: Full DAG Pipeline

on:
  push:
    branches: ["main"]

jobs:

  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm run lint

  build:
    runs-on: ubuntu-latest
    needs: lint
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm run build

  test:
    runs-on: ubuntu-latest
    needs: build
    steps:
      - uses: actions/checkout@v4
      - run: npm test

  package:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v4
      - run: npm pack

  deploy:
    runs-on: ubuntu-latest
    needs: package
    steps:
      - uses: actions/checkout@v4
      - run: echo "Deploying to production..."
```

---

# 4. ASCII Diagram of This Pipeline

```
                +---------+
                |  lint   |
                +---------+
                     |
                     v
                +---------+
                | build   |
                +---------+
                     |
                     v
                +---------+
                |  test   |
                +---------+
                     |
                     v
                +-----------+
                |  package  |
                +-----------+
                     |
                     v
                +-----------+
                |  deploy   |
                +-----------+
```

This is a linear DAG — but you can modify it to any shape (fan out, fan in, etc.).

---

# 5. Key Takeaways

- GitHub Actions uses **DAG execution** for jobs.
    
- `needs:` controls dependencies.
    
- Jobs without dependencies run **in parallel**.
    
- Jobs depending on multiple jobs wait for **all** of them to finish.
    
- No cycles allowed.
    

---