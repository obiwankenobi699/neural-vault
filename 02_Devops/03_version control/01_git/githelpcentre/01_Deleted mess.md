It depends on **where the deletion happened** and **what “discard” you are using**. In Git there are three common cases.

---

## 1. File deleted but **not committed yet**

If you delete a tracked file and it only appears in **Git changes**, you can restore it.

**Command**

```bash
git restore filename
```

or

```bash
git checkout -- filename
```

**Result**

- File comes back from the **last commit**
    
- Works only if deletion is **not committed**
    

If you press **Discard Changes in IDE (VS Code / PyCharm)**, it does the same thing.

---

## 2. File deleted and **already committed**

If you committed the deletion, discard will **not bring it back automatically**. You must restore from a previous commit.

**Command**

```bash
git checkout HEAD~1 -- filename
```

or

```bash
git restore --source=HEAD~1 filename
```

```
git restore --source=commithash.gif
```
This restores the file from the **previous commit**.

---

## 3. File deleted and **staged but not committed**

If you ran `git add` after deleting:

```bash
git restore --staged filename
git restore filename
```

---

## Quick Summary

|Situation|Command|File Restored|
|---|---|---|
|Deleted but not committed|`git restore file`|Yes|
|Deleted + staged|`git restore --staged file` then `git restore file`|Yes|
|Deleted + committed|restore from previous commit|Yes|

---

If you want, I can also show **a safe workflow to recover _any deleted file in Git_** (even if you forgot the commit), which is useful during development.