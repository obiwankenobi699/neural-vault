---
title: 01_Basic
tags:
  - Typescript
  - Backend
  - Basics_of_Ts
created: 2025-11-02
updated: 2025-11-02
---
---


> **Subject:** TypeScript Backend Setup
> **Topic Type:** Concept / Configuration / Practical
> **Related Topics:** 

---

## 🧩 1. Overview

> **Node.ts** means using **TypeScript** with **Node.js**.
> It allows backend JavaScript development with **type safety**, **ESNext features**, and better **scalability**.

**Node.js** runs JavaScript on the server.
**TypeScript** adds a compiler layer that:

* Checks types before running.
* Converts `.ts` → `.js` using `tsconfig.json`.

---

## ⚙️ 2. Installation Steps

### 🧱 1️⃣ Install Node.js

Make sure Node is installed:

```bash
node -v
npm -v
```

---

### 🧱 2️⃣ Install TypeScript

```bash
npm install -g typescript
```

Or as a dev dependency in your project:

```bash
npm install --save-dev typescript
```

---

### 🧱 3️⃣ Initialize TypeScript in Your Project

Inside your project root:

```bash
npx tsc --init
```

✅ This automatically creates a `tsconfig.json` file.
This file controls how your `.ts` files are compiled into `.js`.

---

## 🔍 3. tsconfig.json (Full Setup)

A typical **ES2020 Node TypeScript configuration** looks like this:

```json
{
  "compilerOptions": {
    "target": "ES2020",                  
    "module": "ESNext",                 
    "moduleResolution": "node",         
    "rootDir": "src",                   
    "outDir": "dist",                   
    "strict": true,                     
    "esModuleInterop": true,            
    "forceConsistentCasingInFileNames": true,
    "skipLibCheck": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules"]
}
```

---

## 🧠 4. Explanation of Each Property

| Property                           | Meaning                                     | Example / Notes                                      |
| ---------------------------------- | ------------------------------------------- | ---------------------------------------------------- |
| `target`                           | Specifies the JS version to compile to      | `ES2020` gives modern JS features like `async/await` |
| `module`                           | Defines how modules are handled             | `ESNext` = modern import/export syntax               |
| `moduleResolution`                 | Tells TS how to locate modules              | `node` = follow Node.js module system                |
| `rootDir`                          | Folder where TypeScript source code lives   | Usually `"src"`                                      |
| `outDir`                           | Folder where compiled JS files go           | Usually `"dist"`                                     |
| `strict`                           | Enables all type-checking rules             | Helps catch more errors early                        |
| `esModuleInterop`                  | Allows default import of CommonJS modules   | Enables syntax like `import express from "express"`  |
| `forceConsistentCasingInFileNames` | Prevents case-sensitive filename mismatches | Helpful across OS (Windows/Linux)                    |
| `skipLibCheck`                     | Skips checking `.d.ts` files for speed      | Recommended for faster builds                        |

---

## 🧩 5. Folder Structure Example

```
my-ts-app/
│
├─ src/
│   ├─ index.ts
│
├─ dist/
│   └─ index.js
│
├─ tsconfig.json
├─ package.json
```

---

## ⚙️ 6. Compile & Run Commands

###  Compile to JS

```bash
npx tsc
```

→ Compiles `src/index.ts` → `dist/index.js`

---

###  Watch Mode (auto compile on save)

```bash
npx tsc --watch
```

---

###  Run Directly (without compiling)

Install `ts-node`:

```bash
npm install --save-dev ts-node
```

Then:

```bash
npx ts-node src/index.ts
```

---

##  7. Example `index.ts`

```ts
const greet = (name: string): void => {
  console.log(`Hello, ${name}!`);
};

greet("Mukul");
```

---

## 🧩 8. Example Output

After `npx tsc`, you’ll get:

**dist/index.js**

```js
"use strict";
const greet = (name) => {
    console.log(`Hello, ${name}!`);
};
greet("Mukul");
```

---

##  9. ES2020 Features Used in TypeScript

| Feature            | Description                      | Example               |
| ------------------ | -------------------------------- | --------------------- |
| `async/await`      | Handle async code easily         | `await fetch()`       |
| Optional chaining  | Safely access nested objects     | `user?.profile?.name` |
| Nullish coalescing | Default value for null/undefined | `let x = val ?? 10;`  |
| BigInt             | Handles large integers           | `123n`                |
| Dynamic import     | Import modules on demand         | `import('./file.js')` |

---

## 10. Common Errors & Fixes

| Error                              | Reason                       | Fix                                             |
| ---------------------------------- | ---------------------------- | ----------------------------------------------- |
| `Cannot find module 'express'`     | Missing types                | `npm install @types/express --save-dev`         |
| `__dirname not defined`            | Using ESM modules            | Use `fileURLToPath(import.meta.url)` workaround |
| `Cannot use import outside module` | Missing `"module": "ESNext"` | Update tsconfig.json                            |

---

## 11. Summary

✅ `Node.ts` = Node.js with TypeScript
✅ `tsconfig.json` = Blueprint for compiling TypeScript
✅ `ES2020` = Enables modern JS features
✅ `npx tsc --init` = Creates tsconfig easily
✅ `ts-node` = Runs TypeScript without compiling
✅ `strict` mode = Best practice for reliable code

---