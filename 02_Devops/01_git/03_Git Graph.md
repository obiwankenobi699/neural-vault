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
## Branch concept (short theory)

A **branch** is a movable pointer (a ref) to a commit. Branches let you develop features, fixes, or experiments in isolation. The default primary branch is typically `main` or `master`. Branches are light-weight: they are simply refs stored under `.git/refs/heads/`.

`HEAD` is a special ref that points to the currently checked-out commit or branch. When `HEAD` points to a branch ref (e.g., `refs/heads/bug-fix`), you are on that branch. When `HEAD` points directly to a commit hash you are in a detached HEAD state.

---

## Create a branch

Create a new branch named `bug-fix`:

```bash
git branch bug-fix
```

This creates the ref `refs/heads/bug-fix` pointing to the current commit but does not switch to it.

Create and switch in one command:

```bash
git switch -c bug-fix
# or equivalently (older form)
git checkout -b bug-fix
```

---

## Switch branches

Switch to an existing branch:

```bash
git switch bug-fix
# or
git checkout bug-fix
```

If you have uncommitted changes and switching would overwrite working files, Git will refuse unless you stash or commit changes first.

---

## Common workflow example

1. Update local main:
    

```bash
git checkout main
git pull origin main
```

2. Create and switch to bug-fix:
    

```bash
git switch -c bug-fix
```

3. Work, add, commit:
    

```bash
git add .
git commit -m "fix: bug in X"
```

4. Push new branch to remote:
    

```bash
git push -u origin bug-fix
```

`-u` sets the upstream so later `git push` / `git pull` know the remote branch.

---

## Switch back to main (example)

```bash
git switch main
# or
git checkout main
```

---

## Delete a branch

### Delete local branch

Safe delete (refuses if branch is unmerged):

```bash
git branch -d bug-fix
```

Force delete (remove regardless of merge status):

```bash
git branch -D bug-fix
```

### Delete remote branch

```bash
git push origin --delete bug-fix
# or
git push origin :bug-fix
```

---

## HEAD explained (detailed)

- `HEAD` is the currently checked-out reference. Typical values:
    
    - `HEAD -> refs/heads/main` (normal)
        
    - `HEAD -> <commit-hash>` (detached HEAD)
        
- When you commit, Git updates the branch `HEAD` points to (moves it forward to the new commit).
    
- You can view HEAD and branch pointers:
    

```bash
git symbolic-ref HEAD      # shows branch ref if not detached
git rev-parse --abbrev-ref HEAD  # prints current branch or "HEAD"
```

---

## Branch graph (ASCII)

Simple branch split and merge:

```
A---B---C---D   (main)
     \
      E---F     (bug-fix)
```

If you merge `bug-fix` into `main` and `main` did not move past C, you may get a fast-forward merge or a merge commit depending on strategy (see below).

---

## Fast-forward merge vs. Non-fast-forward (merge commit)

### Fast-forward merge (no new commit)

If the target branch has no new commits since you branched, Git can move the branch pointer forward — no merge commit is created.

Example pre-merge:

```
A---B---C   (main)
       \
        D---E  (feature)
```

Merging `feature` into `main` with a fast-forward moves `main` to E:

```
A---B---C---D---E  (main, feature)
```

Command that produces fast-forward:

```bash
git checkout main
git merge feature
```

If fast-forwarding is possible and not prohibited, Git will perform it.

### Non-fast-forward merge (explicit merge commit)

If you want an explicit merge commit (to preserve history graph or for clearer feature boundaries) use `--no-ff`:

```bash
git checkout main
git merge --no-ff feature -m "Merge feature into main"
```

This creates a new commit with two parents:

```
A---B---C----------M   (main)
       \          /
        D---E----/      (feature)
```

`M` is the merge commit. Use `--no-ff` when you want to keep a record that a branch was merged, even if fast-forward would be possible.

---

## Merge behavior and options

- `git merge <branch>`: attempt to merge `<branch>` into current branch.
    
- `git merge --no-ff <branch>`: force a merge commit even if fast-forward is possible.
    
- `git merge --ff-only <branch>`: only allow fast-forward; fail if a merge commit would be required.
    

---

## Resolve merge conflicts (step-by-step)

1. Merge and see conflict markers:
    

```bash
git checkout main
git merge bug-fix
# if conflicts exist, Git will stop and list conflicts
```

2. Identify conflicted files:
    

```bash
git status
# lists "both modified" files
```

3. Open each conflicted file and look for conflict markers:
    

```
<<<<<<< HEAD
your changes on current branch
=======
incoming changes from other branch
>>>>>>> bug-fix
```

Edit to produce the desired final content. Remove the markers.

4. Mark resolved by staging the file:
    

```bash
git add path/to/conflicted-file
```

5. Continue the merge (create the merge commit):
    

```bash
git commit
```

If Git paused during a merge, `git commit` finalizes the merge commit. (If using `git merge --no-commit`, you may need `git commit`.)

6. If you used a rebase that had conflicts:
    

```bash
# after resolving and staging
git rebase --continue
# to abort the rebase:
git rebase --abort
```

7. Useful conflict resolution tools:
    

- Use a mergetool (graphical or terminal):
    

```bash
git mergetool
```

- See diffs:
    

```bash
git diff                 # unstaged changes
git diff --staged        # staged changes
git diff --name-only --diff-filter=U   # list conflicted files
```

8. If the merge is wrong, abort it before committing:
    

```bash
git merge --abort
```

---

## Strategies to prevent conflicts

- Pull frequently from the remote base branch (e.g., `main`) into your feature branch:
    

```bash
git checkout bug-fix
git pull --rebase origin main
```

- Keep changes small and focused.
    
- Communicate with team members on large refactors.
    
- Rebase feature branches onto updated main (careful with published branches; avoid rebasing public/shared branches unless everyone coordinated).
    

---

## Merge vs Rebase (brief note)

- `git merge` creates a merge commit (history shows branches and merges).
    
- `git rebase` rewrites commits to appear as if work was based on a later commit (linear history).
    
- Use `rebase` for local cleanup; prefer `merge` for shared branches if preserving true branching history matters.
    

---

## Delete merged branches on GitHub (remote cleanup)

After a PR is merged on GitHub you can delete the remote branch from the web UI or via CLI:

```bash
# delete remote branch
git push origin --delete bug-fix

# delete local branch
git branch -d bug-fix
```

---

## Quick command summary

Create: `git branch bug-fix`  
Create + switch: `git switch -c bug-fix` or `git checkout -b bug-fix`  
Switch: `git switch <branch>` or `git checkout <branch>`  
Push new branch: `git push -u origin <branch>`  
Merge: `git checkout main` then `git merge bug-fix`  
Force merge commit: `git merge --no-ff bug-fix`  
Fast-forward only: `git merge --ff-only bug-fix`  
Abort merge: `git merge --abort`  
Delete local branch: `git branch -d bug-fix` (or `-D`)  
Delete remote branch: `git push origin --delete bug-fix`

---

## Troubleshooting common issues

- “error: Your local changes to the following files would be overwritten by checkout” → stash or commit changes before switching:
    
    ```bash
    git stash
    git switch other-branch
    # later
    git switch bug-fix
    git stash pop
    ```
    
- Merge produced conflicts and you want to back out:
    
    ```bash
    git merge --abort
    ```
    
- Rebase conflicts and you want to abort:
    
    ```bash
    git rebase --abort
    ```
    

---

This note is ready for Obsidian. If you want, I can:

- Split this into multiple Obsidian notes and create a folder structure,
    
- Add step-by-step examples with a sample repository (commands and expected outputs),
    
- Or generate a printable one-page cheat sheet for quick reference.