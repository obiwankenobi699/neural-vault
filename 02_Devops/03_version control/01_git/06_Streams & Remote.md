---
title:
  "{ Title }":
tags:
  - DevOps
  - Git
created: 2025-11-24
updated:
  "{ date }":
---

# Git Remotes, Upstream/Downstream, Push, Fetch, and Branch Tracking

A **remote** in Git is a name that points to a repository URL.  
Examples:

- `origin` → the repo you cloned from
    
- `upstream` → usually the original repo when you fork
    

Use `git remote -v` to inspect all remotes.

---

# 1. git remote -v

Shows the configured remotes and their URLs.

```
git remote -v
```

Example:

```
origin   https://github.com/you/repo.git (fetch)
origin   https://github.com/you/repo.git (push)
upstream https://github.com/original/project.git (fetch)
upstream https://github.com/original/project.git (push)
```

---

# 2. git branch -M main

Renames the current branch to `main` and forces the rename.

```
git branch -M main
```

Useful for replacing `master` with `main`.

---

# 3. git remote add origin

Add a remote named `origin`.

```
git remote add origin https://github.com/username/repo.git
```

Change URL (if already added):

```
git remote set-url origin <url>
```

Remove and re-add:

```
git remote remove origin
git remote add origin <url>
```

---

# 4. Push to a Different Remote

Add another remote:

```
git remote add other https://github.com/someone/another-repo.git
```

Push local `main` to that repo:

```
git push other main
```

Push and rename the branch on the remote:

```
git push other feature:feature-copy
```

Force push:

```
git push --force other main
```

---

# 5. git fetch vs git pull

Fetch:

```
git fetch origin
git fetch upstream
```

Fetch downloads objects and updates remote tracking branches but does not merge.

Inspect fetched changes:

```
git log HEAD..origin/main --oneline --graph --decorate
```

Pull = fetch + merge:

```
git pull
git pull origin main
```

Or pull with rebase:

```
git pull --rebase
```

---

# 6. git push -u origin main

Push local `main` to `origin/main` and set upstream tracking.

```
git push -u origin main
```

After this:

```
git push
git pull
```

work without specifying branch or remote.

Check what upstream a branch is tracking:

```
git branch -vv
```

Unset or change upstream:

```
git branch --unset-upstream
git branch -u origin/other-branch
```

---

# 7. Typical Workflows

## Initial push of a new repo

```
git init
git add .
git commit -m "initial"
git branch -M main
git remote add origin <url>
git push -u origin main
```

## Fork workflow (origin + upstream)

Clone your fork:

```
git clone https://github.com/you/project.git
cd project
```

Add the original repo:

```
git remote add upstream https://github.com/original/project.git
```

Sync your fork:

```
git fetch upstream
git switch main
git merge upstream/main
git push origin main
```

---

# 8. Upstream vs Downstream Concepts

Upstream  
The branch or repo you pull from.  
Your local branch usually tracks `origin/main` as upstream.

Downstream  
Branches or repos that receive updates from you.

Simple:

- Upstream = the source of truth
    
- Downstream = receivers of your code
    

---

# 9. Upstream and Downstream (ASCII Explanation)

## Basic Architecture

```
        LOCAL REPO (your laptop)
                 |
       pull <----|---- push
                 |
           REMOTE REPO (origin)
```

- You pull code **down** from origin → downstream.
    
- You push code **up** to origin → upstream for others.
    

---

## Relationship Between Tracking Branches

```
[ local main ] ------------------> [ origin/main ]
          |                                 |
          |---------- tracking ------------|
```

Created by:

```
git push -u origin main
```

---

## Multi-remote Example (fork workflow)

```
             [ upstream/main ]
                     |
                     | pull
                     v
             [ origin/main ]
                     |
                     | push
                     v
               [ local main ]
```

Meaning:

- You fetch from **upstream**
    
- You push to **origin**
    
- Your local repo sits downstream from both
    

---

# 10. Pulling from a Different Branch

Pull another branch into your current one:

```
git pull origin dev
```

Pull updates into the branch itself:

```
git switch dev
git pull
```

If only on remote:

```
git switch -c dev origin/dev
```

---

# 11. Commands Cheatsheet

```
git remote -v
git remote add <name> <url>
git remote set-url <name> <url>
git remote remove <name>

git branch -M main
git branch -vv
git branch -u origin/main
git branch --unset-upstream

git fetch <remote>
git pull <remote> <branch>
git pull --rebase

git push <remote> <branch>
git push -u origin main
git push other main
git push other feature:feature-copy
git push --force <remote> <branch>
```

---


```
         YOUR LAPTOP                          GITHUB SERVER
        (Local Repo)                           (Remote Repo)
        ----------------                     -------------------
        |  main       |                     |  origin/main     |
        |  dev        |   pull (origin/dev) |  origin/dev      |
        |  feature-x  | <------------------ |  origin/feature  |
        |   .git      |                     |      .git        |
        ----------------                     -------------------
          Working Dir                           Remote Storage
```

