---
title: 02_Package Manager
tags:
  - Typescript
  - Backend
created: 2025-11-02
updated: 2025-11-02
---


> **Subject:**   
> **Topic Type:** Concept / Process / Architecture / Example  
> **Related Topics:** 

---

###  **Content-Addressable Store (CAS)**

Think of it like Git for packages.

Each package version is stored **once**, with a unique hash based on its **content**.

```
~/.pnpm-store/v3/
└── 2a/
    └── 7d2f63b23f14f...  (react@18.2.0)

```

If another project installs the same version, it **just links** to this cache — no duplication.

---

### 🔗 **Symlink Mechanism**

When you install:

```
pnpm install react

```

pnpm doesn’t copy React files.

It creates a symbolic link (shortcut) in your project’s `node_modules` pointing to the global store path.

```
project/node_modules/react  -->  ~/.pnpm-store/react@18.2.0/

```

✅ Saves disk

✅ Faster installs

✅ Consistent dependency tree

---

##  5. **npx**

> npx = “npm executor”
> 

It allows you to run CLI tools **without installing them globally**.

Example:

```bash
npx create-react-app myApp

```

👉 Downloads the package temporarily, runs it, and deletes it automatically.

###  Benefits

- No global clutter
- Always runs latest version
- Great for scaffolding tools

---

## 🧩 6. **Common Problems With npm / Yarn**

| Problem | npm / Yarn | Solved by |
| --- | --- | --- |
| Duplicate packages | ✅ Yes | **pnpm** |
| Slow install speed | ❌ Sometimes | **pnpm** |
| Disk waste | ❌ Yes | **pnpm** |
| Strict dependency isolation | ❌ Weak | **pnpm** |
| Compatibility with legacy tools | ✅ Yes | **npm**, **Yarn 1** |

---

##  7. **Real-World Usage (Companies & Trends)**

| Company / Ecosystem | Common Choice | Why |
| --- | --- | --- |
| **Meta, Expo, React Native** | Yarn | Workspaces + speed |
| **Vercel, Next.js, modern projects** | pnpm | Space & performance |
| **Older projects / tutorials** | npm | Default + stable |
| **CI/CD / Docker builds** | pnpm | Cache efficiency |

📊 **2025 Trend:**

> 🔥 pnpm is becoming the most used in production due to speed + space + monorepo efficiency.
> 

---

## 8. **Quick Comparison Summary**

| Feature | npm | Yarn | pnpm |
| --- | --- | --- | --- |
| Speed | 🟡 Medium | 🟢 Fast | 🟢🚀 Fastest |
| Disk usage | 🔴 High | 🟠 Medium | 🟢 Very Low |
| Deterministic install | 🟢 Yes | 🟢 Yes | 🟢 Yes |
| Workspaces | 🟢 Yes | 🟢 Yes | 🟢 Yes |
| Content store | ❌ No | ❌ No | 🟢 Yes |
| Symlink node_modules | ❌ No | ❌ No | 🟢 Yes |
| Compatibility | 🟢 Best | 🟠 Medium | 🟢 Good |
| Modern preference | 🟢 Ok | 🟡 Ok | 🟢🔥 Recommended |

---

## 9. **Conclusion**

| If you want... | Use |
| --- | --- |
| Simplicity and default support | **npm** |
| Monorepos + workspaces | **Yarn** |
| Performance, space efficiency, modern setup | 🥇 **pnpm** |
| Temporary CLI runner | **npx** |

---

Would you like me to generate a **markdown note version with ASCII architecture diagram** (like your networking notes)?

I can show visually how **symlinks and the content-addressable store** work in pnpm — it’s perfect for revision.

Perfect question 👏 — this is **super important** for modern Node.js developers.
Let’s break down everything cleanly, including **npm, yarn, pnpm, npx, symlinks, content-addressable store**, and why teams choose one over another.

---

# ⚙️ JavaScript Package Managers — Complete Developer Notes

---

## 🧩 1. **What Are They?**

All of these — `npm`, `yarn`, and `pnpm` — are **package managers** for Node.js.

They handle:

- 📦 Installing project dependencies
- 🧱 Resolving versions
- 🔗 Linking modules
- ⚙️ Managing `package.json` and `node_modules`

---

## 🧠 2. **npm (Node Package Manager)**

> 🏗️ Comes preinstalled with Node.js — the default and oldest ecosystem tool.
> 

### ✅ Features

- Installs packages from the npm registry.
- Creates a `node_modules` folder.
- Supports **scripts**, **version locking** (`package-lock.json`).
- Works with `npx` (we’ll cover that below).

### ⚠️ Problems (Old npm versions)

| Issue | Description |
| --- | --- |
| 🔁 **Redundant copies** | Every project keeps full copies of packages. |
| 🐌 **Slow** | Deep folder structures and duplication. |
| ❌ **Disk waste** | Huge `node_modules` (can reach GBs). |

✅ **npm v7+** fixed many of these (improved caching and workspaces).

---

## ⚡ 3. **Yarn**

> Developed by Facebook to solve npm’s early performance issues.
> 

### Advantages

- 🧠 **Deterministic installs** via `yarn.lock`
- ⚡ **Faster installs** due to parallel operations
- 🧰 **Workspaces** (monorepo support)
- 🧩 **Offline cache**

### ⚠️ Problems

| Issue | Description |
| --- | --- |
| 📦 **Still duplicates dependencies** | Not space-optimized like pnpm |
| 🧮 **Yarn 2+ (Berry)** changed syntax | Not backward compatible, causes confusion |
| 🪞 **Plug’n’Play (PnP)** | Removes `node_modules`, breaks older tools |

---

##  4. **pnpm (Performant npm)**

> A modern reimagining of npm — fastest and most space efficient.
> 

### ✅ Advantages

1. 🧱 **Content-addressable store**
    - All packages are stored **once globally** on disk.
    - Each project creates **symlinks** (shortcuts) to them.
2. 🔗 **Symlinked node_modules**
    - Uses hard links/symlinks instead of copying files.
    - Saves **tons of space** (you can have 10 projects, but only 1 copy of React).
3. ⚡ **Super fast installs**
    - Reuses cached packages instantly.
4. 🔒 **Strict node_modules structure**
    - Avoids accidental dependency leaks.

---

###  **Content-Addressable Store (CAS)**

Think of it like Git for packages.

Each package version is stored **once**, with a unique hash based on its **content**.

```
~/.pnpm-store/v3/
└── 2a/
    └── 7d2f63b23f14f...  (react@18.2.0)

```

If another project installs the same version, it **just links** to this cache — no duplication.

---

### 🔗 **Symlink Mechanism**

When you install:

```
pnpm install react

```

pnpm doesn’t copy React files.
It creates a symbolic link (shortcut) in your project’s `node_modules` pointing to the global store path.

```
project/node_modules/react  -->  ~/.pnpm-store/react@18.2.0/

```

✅ Saves disk
✅ Faster installs
✅ Consistent dependency tree

---

## 💡 5. **npx**

> npx = “npm executor”
> 

It allows you to run CLI tools **without installing them globally**.

Example:

```bash
npx create-react-app myApp

```

👉 Downloads the package temporarily, runs it, and deletes it automatically.

### ✅ Benefits

- No global clutter
- Always runs latest version
- Great for scaffolding tools

---

## 🧩 6. **Common Problems With npm / Yarn**

| Problem | npm / Yarn | Solved by |
| --- | --- | --- |
| Duplicate packages | ✅ Yes | **pnpm** |
| Slow install speed | ❌ Sometimes | **pnpm** |
| Disk waste | ❌ Yes | **pnpm** |
| Strict dependency isolation | ❌ Weak | **pnpm** |
| Compatibility with legacy tools | ✅ Yes | **npm**, **Yarn 1** |

---

##  7. **Real-World Usage (Companies & Trends)**

| Company / Ecosystem | Common Choice | Why |
| --- | --- | --- |
| **Meta, Expo, React Native** | Yarn | Workspaces + speed |
| **Vercel, Next.js, modern projects** | pnpm | Space & performance |
| **Older projects / tutorials** | npm | Default + stable |
| **CI/CD / Docker builds** | pnpm | Cache efficiency |

📊 **2025 Trend:**

> 🔥 pnpm is becoming the most used in production due to speed + space + monorepo efficiency.
> 

---

## 8. **Quick Comparison Summary**

| Feature | npm | Yarn | pnpm |
| --- | --- | --- | --- |
| Speed | 🟡 Medium | 🟢 Fast | 🟢🚀 Fastest |
| Disk usage | 🔴 High | 🟠 Medium | 🟢 Very Low |
| Deterministic install | 🟢 Yes | 🟢 Yes | 🟢 Yes |
| Workspaces | 🟢 Yes | 🟢 Yes | 🟢 Yes |
| Content store | ❌ No | ❌ No | 🟢 Yes |
| Symlink node_modules | ❌ No | ❌ No | 🟢 Yes |
| Compatibility | 🟢 Best | 🟠 Medium | 🟢 Good |
| Modern preference | 🟢 Ok | 🟡 Ok | 🟢🔥 Recommended |

---

## 9. **Conclusion**

| If you want... | Use |
| --- | --- |
| Simplicity and default support | **npm** |
| Monorepos + workspaces | **Yarn** |
| Performance, space efficiency, modern setup | 🥇 **pnpm** |
| Temporary CLI runner | **npx** |

---