---
title: 01_Basics
tags:
  - Typescript
  - Basics_of_Ts
created: 2025-11-02
updated: 2025-11-02
---
>**Subject:** Typescript  
> **Topic Type:** 
> **Related Topics:** 

---

## 🧩 1. Overview

TypeScript is a **superset of JavaScript** that adds **static typing** and compile-time error checking.
It helps developers catch errors early, build scalable applications, and improve IDE support with auto-completion and type inference.

> In short, **TypeScript = JavaScript + Types + Better Tooling**

---

## ⚙️ 2. Core Concepts

| Concept          | Description                                                            | Example                              |         |
| ---------------- | ---------------------------------------------------------------------- | ------------------------------------ | ------- |
| **Typing**       | TypeScript adds static types, ensuring data consistency before runtime | `let age: number = 25;`              |         |
| **Compilation**  | TS compiles into plain JS before execution                             | `tsc index.ts → index.js`            |         |
| **Strict Mode**  | Ensures better type-safety via `"strict": true`                        | Detects undefined variables          |         |
| **Interfaces**   | Define shape of objects                                                | `interface User { name: string }`    |         |
| **Type Aliases** | Create reusable type definitions                                       | `type ID = string                    | number` |
| **Enums**        | Group related constants                                                | `enum Role { Admin, User }`          |         |
| **Union Types**  | Allow multiple possible types                                          | `let id: string                      | number` |
| **Generics**     | Build flexible, reusable functions/classes                             | `function id<T>(x:T):T { return x }` |         |

---

## 🔍 3. Architecture / Structure

**TypeScript Workflow:**

```mermaid
graph LR
A[Write TS Code (.ts)] --> B[Compile with tsc]
B --> C[Generate JS (.js)]
C --> D[Run with Node.js / Browser]
```

**Folder Structure Example:**

```
src/
 └── index.ts
dist/
 └── index.js
tsconfig.json
```

---

## 🧱 4. Key Features Comparison

| Feature             | JavaScript    | TypeScript                         |
| ------------------- | ------------- | ---------------------------------- |
| **Typing**          | Dynamic       | Static / Explicit                  |
| **Error Detection** | Runtime       | Compile-time                       |
| **Tooling Support** | Limited       | Excellent (IntelliSense, refactor) |
| **Learning Curve**  | Easy          | Moderate                           |
| **File Extension**  | `.js`         | `.ts` or `.tsx`                    |
| **Execution**       | Runs directly | Needs compilation to JS            |

---

## 🧩 5. Setup & Workflow

1. **Initialize Project:**

   ```bash
   npm init -y
   tsc --init
   ```
2. **Compile File:**

   ```bash
   tsc index.ts
   node index.js
   ```
3. **Watch Changes:**

   ```bash
   tsc --watch
   ```
4. **Run Directly (without compiling):**

   ```bash
   ts-node index.ts
   ```
5. **Basic `tsconfig.json`:**

   ```json
   {
     "compilerOptions": {
       "target": "ES2020",
       "module": "commonjs",
       "outDir": "./dist",
       "rootDir": "./src",
       "strict": true,
       "esModuleInterop": true
     },
     "include": ["src/**/*"]
   }
   ```

---

## 🔢 6. Data Types Summary

| Type      | Example                                          |
| --------- | ------------------------------------------------ |
| `number`  | `let age: number = 25;`                          |
| `string`  | `let name: string = "Mukul";`                    |
| `boolean` | `let isActive: boolean = true;`                  |
| `any`     | `let data: any = 5; data = "hello";`             |
| `unknown` | `let value: unknown;`                            |
| `void`    | `function log(): void {}`                        |
| `never`   | `function error(): never { throw new Error(); }` |
| `tuple`   | `let user: [string, number] = ["Alice", 25];`    |
| `enum`    | `enum Color { Red, Green }`                      |

---

## 🧮 7. Special Notes — NaN (Not a Number)

| Property       | Description                     | Example                                 |
| -------------- | ------------------------------- | --------------------------------------- |
| **Type**       | `NaN` is still of type `number` | `typeof NaN → "number"`                 |
| **Comparison** | `NaN !== NaN`                   | use `Number.isNaN(NaN)`                 |
| **Causes**     | Invalid math ops                | `0/0`, `Number("abc")`, `Math.sqrt(-1)` |

---



---

## 🧰 8. Summary

TypeScript enhances JavaScript by:

* Adding **compile-time safety**
* Making code **more predictable**
* Improving **developer tooling**
* Keeping **full JS compatibility**

> Learn TS once → write safer JS forever 🚀

---