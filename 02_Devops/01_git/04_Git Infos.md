---
title:
  "{ Title }":
tags:
  - theory
  - "{ Subject }":
  - semester_notes
created:
  "{ date }":
updated:
  "{ date }":
---

# 1. Git Status

`git status` shows the current state of your working directory and staging area.  
It tells you which files are:

- Modified but not staged
    
- Staged but not committed
    
- Untracked
    
- Ready to be committed
    

It helps you understand what Git will include in the next commit.

### Command

```
git status
```

This is one of the most frequently used commands when working with branches, staging, and debugging code changes.

---

# 2. Git Diff

`git diff` shows the exact line-by-line changes between:

- Working directory vs staging area
    
- Staging area vs last commit
    
- Two commits
    
- Two branches
    

It is used to review your changes before adding or committing.

### Working directory vs staging area

```
git diff
```

### Staged files vs last commit

```
git diff --cached
```

### Any two commits

```
git diff <commit1> <commit2>
```

### Compare branches

```
git diff main bug-fix
```

`git diff` is purely for inspection and does not change your repo.

---

# 3. Git Log

`git log` shows the commit history of your current branch.  
Each commit includes:

- Commit SHA
    
- Author
    
- Date
    
- Commit message
    
- Parent commit link
    

### Basic

```
git log
```

### Single line log

```
git log --oneline
```

### Log with graph (visualizing branches)

```
git log --oneline --graph --decorate --all
```

Useful when understanding merges, rebase histories, or debugging where a commit came from.

---

# 4. Git Stash

`git stash` temporarily saves uncommitted changes without committing them.  
You use it when switching branches but want to keep your current modifications safe.

Stash acts like a temporary shelf where code is stored as stack entries.

### Save changes

```
git stash
```

### Save with message

```
git stash save "work in progress"
```

### Show stash list

```
git stash list
```

### Apply most recent stash (does not delete)

```
git stash apply
```

### Apply a specific stash

```
git stash apply stash@{2}
```

### Pop (apply + remove from stash)

```
git stash pop
```

### Drop a stash

```
git stash drop stash@{1}
```

### Clear all stashes

```
git stash clear
```

Stash is extremely useful when you need a clean working directory quickly.

---

# 5. Git Tag

Tags are used to mark specific commits, often for releases like v1.0, v2.1 etc.

There are two types of tags:

1. Lightweight tags (just a pointer)
    
2. Annotated tags (stored as full Git objects with metadata)
    

---

## Lightweight Tag

```
git tag v1.0
```

## Annotated Tag

Annotated tags are recommended for real releases.

```
git tag -a v1.0 -m "Production release 1.0"
```

## List all tags

```
git tag
```

## View tag details

```
git show v1.0
```

## Push a single tag

```
git push origin v1.0
```

## Push all tags

```
git push --tags
```

## Delete a tag locally

```
git tag -d v1.0
```

## Delete a tag from GitHub

```
git push origin --delete v1.0
```

Tags are extremely important in versioning software and tracking stable snapshots.

---

# Combined Summary Table

|Concept|Purpose|Key Commands|
|---|---|---|
|git status|Shows working directory and staging area state|`git status`|
|git diff|Shows actual code changes line-by-line|`git diff`, `git diff --cached`|
|git log|Shows commit history|`git log`, `git log --oneline`|
|git stash|Saves changes temporarily|`git stash`, `git stash pop`|
|git tag|Marks important commits|`git tag v1.0`, `git push --tags`|

---

If you want, I can continue the Obsidian notes with:

- Git reset vs revert
    
- Git rebase (interactive)
    
- How HEAD works internally
    
- Branching workflows (GitHub Flow, Git Flow, trunk based)
    
- ASCII diagrams for stash, tags, diff, log
    

