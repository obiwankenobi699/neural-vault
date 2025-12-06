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

# **Git Internals — Complete Note (Obsidian Ready)**

Git is a **content-addressable version control system**.  
Every file, folder, and commit gets stored as an **object** inside the private `.git/` directory and is identified using a **SHA-1 hash**.

Git does **not** store diffs.  
Git stores **snapshots** of your project.

---

# **1. Git as a Content-Addressable Database**

Git stores objects in:

```
.git/objects/
```

Each object is saved as:

```
SHA1 hash → file name
object bytes → file content
```

A SHA acts as:

- The **name** of the object
    
- The **location** of the object
    
- The **unique identity** of the object
    

Git calculates hashes using:

```
SHA1( "type size\0" + object_content )
```

This makes objects **immutable** and **tamper-proof**.

---

# **2. The Three Musketeers of Git**

Git stores 3 primary object types:

---

## **2.1 Blob Object (file contents)**

A **blob** stores ONLY the file’s data — no filename or path.

Example:

```
Hello world
console.log("JS file");
```

Git creates:

```
blob <size>\0<content>
SHA1 = <blob-hash>
```

Command:

```
git show <blob-sha>
```

---

## **2.2 Tree Object (directory / folder)**

A **tree** stores:

- filenames
    
- permissions / modes
    
- blob hashes (files)
    
- tree hashes (subfolders)
    

Tree = folder snapshot.

Command:

```
git ls-tree <tree-sha>
```

ASCII:

```
Tree
├── fileA.txt → blob-hash-A
├── fileB.js  → blob-hash-B
└── src/      → tree-hash-C
```

---

## **2.3 Commit Object (snapshot metadata)**

A **commit** stores:

- Tree pointer (root of project)
    
- Parent commit pointer
    
- Author + timestamp
    
- Commit message
    

Example structure:

```
Commit
├── tree: <tree-hash>
├── parent: <previous-commit-hash>
├── author: Mukul
└── message: "Initial commit"
```

Command:

```
git show <commit-sha>
```

---

# **3. Full ASCII Diagram of Git Internals**

```
                 Commit (SHA-aaaa)
                 ├─────────────┐
                 │             │
                 │   parent: <SHA-prev>
                 │   tree:   <tree-root>
                 └─────────────┘
                          |
                          v
                  Tree (SHA-bbbb)
                  ├───────────────┐
                  │ fileA.txt -> blobA
                  │ fileB.js  -> blobB
                  │ src/      -> treeC
                  └───────────────┘
                         |
                         v
                 TreeC (SHA-cccc)
                  ├── main.js  -> blobD
                  └── utils.js -> blobE

Blobs store RAW data
Trees store STRUCTURE
Commit stores HISTORY + METADATA
```

---

# **4. Full Workflow: Working Directory → Git Database**

```
Working Directory (your files)
          |
          | git add
          v
Staging Area / Index
(files mapped to blob hashes)
          |
          | git commit
          v
Git Object Database (.git/objects)
------------------------------------
|   Blob Objects  (file content)   |
|   Tree Objects  (folder layout)  |
|   Commit Objects(history + meta) |
------------------------------------
```

---

# **5. What Happens Internally for Each Command**

---

## **5.1 `git add`**

Git:

1. Reads file content
    
2. Creates a **blob object**
    
3. Stores blob under `.git/objects`
    
4. Writes entry to **index** (filename → blob-hash)
    

ASCII:

```
file → blob → index
```

---

## **5.2 `git commit`**

Git:

1. Reads index (staging area)
    
2. Builds **tree objects** for directories
    
3. Builds **commit object** linking to tree
    
4. Stores commit in `.git/objects`
    
5. Moves branch pointer to new commit
    

ASCII:

```
index → tree → commit → branch pointer updates
```

---

# **6. SHA = The Identity of Every Object**

SHA identifies:

- a blob
    
- a tree
    
- a commit
    

SHA is generated from **content**, so if content changes → SHA changes.

This ensures:

- Integrity
    
- Distribution safety
    
- No accidental corruption
    

SHA is also used to **deduplicate data**.

If two files have the same content → same blob.  
Git stores it only once.

---

# **7. Git Snapshots vs Diffs**

Git stores a **full snapshot** per commit:

```
Commit 1
 f1 → blobX
 f2 → blobY

Commit 2
 f1 → blobX (same)
 f2 → blobZ (changed)
```

Only blob **Z** is new.

Git is extremely space-efficient.

---

# **8. Indexing and Commit Relationship**

### Workflow:

```
Working Directory → Index → Commit → History Graph
```

### Index (Staging Area)

A map:

```
filename → blob hash
```

### Commit

Points to:

```
commit → tree → blobs + trees
commit → parent
```

---

# **9. `.gitignore` and `.gitkeep`**

### `.gitignore`

Tells Git what NOT to track:

Common ignores:

```
node_modules/
.env
.venv
dist/
.DS_Store
logs/
```

### `.gitkeep`

Git does not track empty folders.  
To force-add an empty directory:

```
touch folder/.gitkeep
```

---

# **10. Internal Object Storage Layout**

Git stores hashes as:

```
<first two chars>/<remaining 38 chars>
```

Example:

```
.git/objects/a1/b2c3d4e5f6...
```

This avoids too many files in one directory.

---

# **11. Commit Behind the Scenes**

Commit object contains:

```
type commit
size X
tree <tree-sha>
parent <parent-sha>
author <name>
committer <name>
message "msg"
```

SHA is computed from this WHOLE content.

Linking parent commits builds the entire project history graph.

---

# **12. Git Snapshot Graph (ASCII)**

```
C3 ──> C2 ──> C1 ──> C0
│
└── merge parents
```

Each commit stores:

- a pointer to its tree
    
- a pointer to its parent
    

---

# **13. Summary (Cheat Sheet)**

### Git Objects:

- **Blob** = file content
    
- **Tree** = folder structure
    
- **Commit** = snapshot metadata
    

### Git Storage:

- Everything stored in `.git/objects`
    
- SHA identifies every object
    
- Git stores **snapshots**, not diffs
    

### Workflow:

```
Working Directory → Index → Tree → Commit
```

---

# **Want the Bonus Sections?**

I can also generate:

- **Git Refs, HEAD, Branch pointers, Tags explained**
    
- **How `git checkout` actually works**
    
- **Git compression: packfiles, deltas, garbage collection**
    
- **Git branching & merging internals (ASCII diagrams)**
    
- **A complete Obsidian Vault structure with folders + links**


ok lets suppose we having 2 changes one i did hello and commit and another change added world in hello so it become hello world and again commit so it means hello become an history so it saved 2 files ? of 100kb or just object and how it memory efficient and speedy ?

**Thinking**

Yes, Git handles this scenario very efficiently by storing the full content of the file only once and managing subsequent changes as new, lightweight objects that reference existing data where possible. It is highly memory efficient.

- **First commit ("hello"):** Git calculates a unique hash (SHA-1) for the content "hello". It stores this content as a single, immutable **blob object** in its database.
- **Second commit ("hello world"):** Git calculates a new hash for "hello world". It stores this _entire_ new content as another, separate **blob object**.
- **Memory Efficiency:** The key is that each change is small. Git is incredibly efficient at compressing these objects. A tiny 5-byte change (" world") doesn't waste 100kb of space. Git stores the _exact_ bytes changed and uses highly sophisticated data compression (packfiles) in the background to find redundancies across all versions of all files and store them optimally.
- **Speed:** Because each commit is a complete snapshot, finding a past version is instantaneous. Git doesn't have to "rebuild" the file by applying a sequence of patches; it simply retrieves the specific, pre-calculated snapshot from its local database.