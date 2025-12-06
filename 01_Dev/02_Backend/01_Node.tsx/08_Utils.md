---
title: 08_Utils
tags:
  - Backend
  - Typescript
created: 2025-11-02
updated: 2025-11-02
---
> **Subject:** 
> **Topic Type:** Concept / Process / Architecture / Example  
> **Related Topics:** 

---
# utils:-

This is a **very common professional pattern** to simplify error handling for async functions like `req, res, next` — without writing repetitive `try/catch` blocks in every route.

Let’s break it down clearly 👇

---

## 🧩 Problem: Repeating `try/catch` in async routes

### ❌ Old way (messy)

```jsx
app.get("/users", async (req, res, next) => {
  try {
    const users = await User.find();
    res.json(users);
  } catch (err) {
    next(err); // must manually pass errors
  }
});

```

You’ll end up writing this in *every* route.

---

## ✅ Solution: Make an `asyncHandler` wrapper

### 💡 The idea

Create a **reusable function** that:

- Takes an async route/controller function.
- Automatically catches errors.
- Passes them to `next()` (so your Express error middleware can handle them).

---

### 🧱 Code Example

```jsx
// utils/asyncHandler.js

import type { Request,Response,NextFunction } from "express"
const asyncHandler = (fn:(req:Request,res:Response,next:NextFunction)=> Promise<any>) =>{

return (req:Request,res:Response,next:NextFunction)=>{

Promise.resolve(fn(req,res,next)).catch(next);
	}

 }
export default asyncHandler;
```

---

### 🧩 Usage

```jsx
import express from "express";
import { asyncHandler } from "./utils/asyncHandler.js";
import User from "./models/User.js";

const router = express.Router();

router.get("/users", asyncHandler(async (req, res) => {
  const users = await User.find();
  res.json(users);
}));

router.post("/create", asyncHandler(async (req, res) => {
  const user = await User.create(req.body);
  res.status(201).json(user);
}));

export default router;

```

---

### 📘 Why it works

- The `asyncHandler` returns a **new function** that Express can call.
- If your async route throws an error or rejects a Promise, `.catch(next)` ensures the error goes to your error-handling middleware instead of crashing the app.

---

### 🧠 Flow Diagram

```
           ┌────────────────────┐
           │  Incoming Request  │
           └────────┬───────────┘
                    │
                    ▼
          ┌──────────────────────┐
          │  asyncHandler(fn)    │
          │----------------------│
          │ try { fn(...) }      │
          │ catch(err){next(err)}│
          └────────┬─────────────┘
                    │
                    ▼
          ┌──────────────────────┐
          │ Controller executes  │
          │ await User.find()    │
          └────────┬─────────────┘
                    │
                    ▼
          ┌──────────────────────┐
          │  Success  → res.send │
          │  Error    → next(err)│
          └──────────────────────┘

```

---

### 🧩 Example with Error Middleware

```jsx
// app.js
import express from "express";
import { asyncHandler } from "./utils/asyncHandler.js";

const app = express();

app.get("/", asyncHandler(async (req, res) => {
  throw new Error("🔥 Something broke");
}));

// Global Error Handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ message: err.message });
});

app.listen(3000, () => console.log("✅ Server running"));

```

---

### ✅ Benefits

| Advantage | Description |
| --- | --- |
| 🧹 Clean Code | No more try/catch in every route |
| 🪶 Lightweight | Only a few lines of code |
| 🧩 Reusable | Works with any async Express handler |
| 🧱 Scalable | Integrates with global error middleware easily |

---

Here’s the **correct and polished version** of your async handler wrapper:

---

```jsx
const asyncHandler = (fn) => async (req, res, next) => {
  try {
    await fn(req, res, next);
  } catch (err) {
    console.error("⚠️ Async Error:", err.message);

    res.status(500).json({
      success: false,
      message: err.message || "Internal Server Error",
    });
  }
};

```

---

### 🧠 Explanation

| Line | Meaning |
| --- | --- |
| `const asyncHandler = (fn) =>` | Takes a function (your route/controller). |
| `async (req, res, next)` | Returns an async middleware. |
| `await fn(req, res, next)` | Executes your route code. |
| `catch (err)` | Catches any thrown or rejected errors. |
| `res.status(500).json(...)` | Sends error as a JSON response (so app doesn’t crash). |

---

### 💡 Usage Example

```jsx
app.get(
  "/users",
  asyncHandler(async (req, res) => {
    const users = await User.find(); // if fails, auto-caught
    res.json(users);
  })
);

```

✅ **No manual try/catch** needed

✅ Works perfectly for **async controllers**

✅ Prevents app crashes due to unhandled Promise rejections

---

### ⚙️ Pro Tip — Combine With Global Error Handler

Instead of sending the error here, you can also **forward it to your error middleware**:

```jsx
const asyncHandler = (fn) => async (req, res, next) => {
  try {
    await fn(req, res, next);
  } catch (err) {
    next(err); // pass error to global handler
  }
};

```

Then define this once: