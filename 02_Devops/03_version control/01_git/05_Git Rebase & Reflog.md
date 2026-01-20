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

# **1. Git Rebase (Rewrite History)**

Rebase = **moving commits** to a new base (another branch’s tip) and **rewriting commit history**.

Think of it as:

```
take my commits
remove them temporarily
replay them one by one on top of another branch
create new commits with new SHAs
```

---

## **Why do we use Git Rebase?**

- To keep history **clean & linear**
    
- To avoid unnecessary merge commits
    
- To make a branch up-to-date with `main` without clutter
    

---

## **Rebase Diagram**

### Before rebase:

```
main:   A──B──C
                \
feature:         D──E
```

### After `git rebase main` on feature:

```
main:    A──B──C
feature:         D'──E'
```

D' and E' are **new commits** (different SHAs).

---

# **Basic Commands**

### Rebase your branch with latest main

```
git checkout feature
git rebase main
```

### Rebase main onto feature (not common)

```
git rebase feature main
```

---

# **Interactive Rebase (edit, squash, reorder commits)**

```
git rebase -i HEAD~5
```

You can then:

- `pick` – keep commit
    
- `squash` – combine commits
    
- `reword` – change commit message
    
- `edit` – modify code in between
    
- `drop` – delete commit
    

---

# **When to Use Rebase**

Use when you want:

- clean linear history
    
- to update your feature branch
    
- to squash messy commits
    

---

# **When NOT to Rebase**

**Never rebase a branch that others already pulled.**

Rebase rewrites history → will cause conflicts on team repos.

---

---

# **2. Git Reflog (Time Machine of Git)**

Reflog = Git’s **internal diary**.  
It records **everything HEAD ever pointed to**, including:

- commits
    
- branch switches
    
- merges
    
- rebases
    
- resets
    
- stashes
    

This is **not shared with GitHub** → local only.

Reflog helps you recover code even if:

- you deleted a branch
    
- reset destroyed commits
    
- rebase changed commit IDs
    
- stash was lost
    

---

## **Command**

```
git reflog
```

You will see:

```
a3f4a2 HEAD@{0}: rebase finished
91d9f7 HEAD@{1}: commit: new login UI
3ae98c HEAD@{2}: checkout: moving from main to feature
...
```

---

# **ASCII Diagram: How Reflog Remembers Everything**

```
HEAD moves over time:

HEAD -> A
HEAD -> B (commit)
HEAD -> C (rebase)
HEAD -> D (reset)
HEAD -> E (merge)

Reflog stores ALL this:
A
B
C
D
E
```

Even if commit C disappears from your branch, it still exists in Reflog.

---

# **Recover Lost Commits Using Reflog**

If you did a bad reset:

```
git reset --hard HEAD~3
```

Your work is gone… or is it?

Run:

```
git reflog
```

Find old commit:

```
git reset --hard <old-commit-sha>
```

**Your lost code is back.**

---

# **Rebase vs Reflog (Differences)**

|Feature|Git Rebase|Git Reflog|
|---|---|---|
|Purpose|Rewrite history|Track every history change|
|Risk|High if misused|No risk|
|Local/Remote|Changes commit IDs (affects sharing)|Local only|
|Can recover deleted commits?|No|Yes|
|Can fix rebase mistakes?|No|Yes|

---

# **How They Work Together**

Rebase changes commit SHAs → rewriting history.

Reflog stores:

```
HEAD before rebase
HEAD after rebase
each replayed commit
```

So if rebase breaks everything:

```
git reflog
git reset --hard HEAD@{3}
```

Back to safety.

---

# **In One Sentence**

### **Rebase** = rewrite commit history to make it clean

### **Reflog** = a time machine that remembers every step you took

---

If you want, I can add this to your Obsidian Git Notes with:

- ASCII diagrams
    
- examples
    
- commands
    
- workflows (merge vs rebase)
    
- danger zones (what not to do)
    

Want me to combine everything into a single Obsidian-ready note?