---
title: 03_Functions and Safety
tags:
  - Typescript
  - Basics_of_Ts
created: 2025-11-02
updated: 2025-11-02
---
---

# 🧠 Functions and Safety in TypeScript

> **Subject:** TypeScript
> **Topic Type:** Concept / Process / Example
> **Related Topics:** 

---

## 🧩 1. Overview

In **TypeScript**, functions are defined with **explicit parameter types** and **return types**.
This improves **type safety**, reduces runtime errors, and makes the code more predictable.

> A function defines what inputs it accepts and what output it returns — enforced at **compile time**.

---

## ⚙️ 2. Core Concepts

| Concept                  | Description                                   | Example                              |
| ------------------------ | --------------------------------------------- | ------------------------------------ |
| **Function Declaration** | Defines reusable code blocks                  | `function add(a, b)`                 |
| **Parameter Types**      | Define expected data types                    | `function add(a: number, b: number)` |
| **Return Type**          | Declares what type a function outputs         | `(): number`                         |
| **Callback Function**    | Function passed as argument                   | `(msg: string) => void`              |
| **Anonymous Function**   | Function without a name                       | `(a, b) => a + b`                    |
| **Async Callback**       | Function called later (e.g., in `setTimeout`) | `setTimeout(() => {}, 1000)`         |

---

## 🧩 3. Typed Function Declaration

TypeScript enforces **parameter** and **return** type annotations.

```tsx
function add(a: number, b: number): number {
  return a + b;
}

console.log(add(5, 10)); // 15
```

✅ **Explanation:**

* `a: number, b: number` → Input types
* `: number` after parentheses → Return type
* TypeScript ensures you cannot call `add("x", "y")`.

---

## 🧩 4. Callback Functions

A **callback** is a function that is passed as an argument to another function,
then invoked **inside** that function to complete a process.

---

### 🔹 Example 1 — Basic Callback

```tsx
function greet(name: string, callback: (msg: string) => void): void {
  let message = `Hello, ${name}!`;
  callback(message);
}

greet("Mukul", (msg) => console.log(msg)); // Hello, Mukul!
```

🧠 **Explanation:**

* `callback: (msg: string) => void` → defines a function type
* The callback **receives a string**, but returns **nothing** (`void`).

  > Call back Function does not have a refrence of .this keywords so cant use it in object related things. ^3da6b4

---

### 🔹 Example 2 — Callback with Return Type

```tsx
function processNumbers(
  a: number,
  b: number,
  callback: (x: number, y: number) => number
): number {
  return callback(a, b);
}

let sum = processNumbers(5, 10, (x, y) => x + y);
let product = processNumbers(5, 10, (x, y) => x * y);

console.log(sum);      // 15
console.log(product);  // 50
```

✅ **Key Idea:**
You can customize function behavior by passing logic (callback) as a parameter.

---

### 🔹 Example 3 — Async Callback (`setTimeout`)

```tsx
function delayedMessage(msg: string, callback: () => void): void {
  setTimeout(() => {
    console.log(msg);
    callback();
  }, 2000);
}

delayedMessage("Hello after 2 seconds!", () => {
  console.log("Callback executed!");
});
```

🕓 **Use Case:**
Perfect for async actions like timers, HTTP requests, file I/O, or event handling.

---

## 🧩 5. Why Type Safety Matters

| Risk                 | Without TS               | With TS                   |
| -------------------- | ------------------------ | ------------------------- |
| Wrong parameter type | `add("5", "10") → "510"` | Compile error ⚠️          |
| Missing callback arg | Runtime error            | Compile-time check        |
| Wrong return type    | Unexpected results       | Enforced type correctness |

✅ **Benefits:**

* Detects type mismatches before execution
* Prevents logic bugs caused by invalid arguments
* Increases reliability in large codebases

---

## 🔍 6. Architecture / Flow (Callback Lifecycle)

```
Caller Function → Defines main process
        ↓
Callback Function → Passed as argument
        ↓
Caller executes callback → once event/task completes
```

🧭 Example:

* `setTimeout()` → schedules a callback
* `fetch()` → executes callback after response
* `map()` or `filter()` → applies callback to each item

---

## ⚡ 7. Summary

| Feature               | Purpose                       | Example                   |
| --------------------- | ----------------------------- | ------------------------- |
| **Typed Parameters**  | Define expected inputs        | `(a: number, b: number)`  |
| **Return Type**       | Specify output                | `(): string`              |
| **Callback Function** | Reusable, dynamic behavior    | `(msg: string) => void`   |
| **Async Callback**    | Run later (e.g., after delay) | `setTimeout(() => {})`    |
| **Type Safety**       | Prevent invalid calls         | Compile-time protection ✅ |

---