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
## Git vs GitHub

Git is a distributed version-control system installed locally on your machine. It tracks changes in files, maintains version history, allows branching, and helps you manage your code’s evolution. Git does not require the internet and works entirely offline.

GitHub is a cloud-based hosting platform built on top of Git. It stores your repositories online, enables collaboration with other developers, provides pull requests, issue tracking, automated workflows, CI/CD pipelines, and acts as a remote server for your Git projects. In short, Git is the tool, and GitHub is the service that gives Git collaboration features.

---

# Git Configuration

Git configuration defines user identity and default Git behaviors. The command `git config --list` displays the complete list of active configurations from all levels: system, global, and local.

To set your identity globally for all repositories, use:

```
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

To verify settings:

```
git config --global --list
git config --list
```

Global configuration applies to all repos. Local configuration overrides global settings for a specific repository.

---

# Creating a Repository

A repository is a folder tracked by Git. To turn an existing folder into a repo, navigate to it and run:

```
git init
```

This creates a hidden `.git` directory which stores all Git history.

To check file states:

```
git status
```

It shows untracked files, staged files, and committed changes.

To clone an existing GitHub repository:

```
git clone https://github.com/username/repository.git
```

---

# Git Flow and Core Concepts

Git follows a simple workflow: you initialize a repository, stage changes, commit them, and then push them to a remote server like GitHub.

The flow begins with:

```
git init
```

This prepares your project for version tracking. When you modify files, Git sees them as untracked or modified, and they remain in the working directory. To move them into the staging area, use:

```
git add filename
git add .
```

Staging means the file is prepared to be committed. To inspect the staging area:

```
git status
```

Commit your staged changes to the repository history:

```
git commit -m "message"
```

To undo a commit before pushing, you can use:

```
git reset --soft HEAD~1
```

This moves the last commit back into the staging area.

To see commit history:

```
git log
```

When pushing to a remote repository, Git uses two identifiers: `origin` and `main`.  
`origin` is the default name of the remote repository URL.  
`main` is the default primary branch name (previously named master).  
Push changes using:

```
git push origin main
```

If the branch is new, use:

```
git push -u origin main
```

The `-u` flag sets upstream tracking so future pushes can simply be:

```
git push
```

---

# .gitignore and .gitkeep

A `.gitignore` file tells Git which files or folders to avoid tracking. This is useful for preventing temporary, sensitive, or machine-specific files from entering the repository. Typical examples include environment variables, dependencies, compiled output, caches, and virtual environments.

Example `.gitignore`:

```
node_modules/
.env
.venv/
__pycache__/
dist/
build/
```

`.gitkeep` is not a Git feature but a common convention. It is an empty file placed inside an otherwise empty folder to force Git to track that directory, because Git normally does not track empty folders. Developers add `.gitkeep` whenever they need to preserve a folder structure in a repository.

---

If you want, I can expand this into multiple Obsidian pages (each topic as a separate note in a folder), add diagrams (ASCII format), or add interview-style Q&A for Git.