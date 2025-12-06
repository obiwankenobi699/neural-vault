---
title: Handle API
tags:
  - Backend
  - Typescript
created: 2025-11-02
updated: 2025-11-02
---
> **Subject:** {{Subject}}  
> **Topic Type:** Concept / Process / Architecture / Example  
> **Related Topics:** 

---

## 🧩 Folder Structure Overview

```
project/
│
├── app.ts                     # Main entry point (Express app setup)
├── routes/
│   └── user.routes.ts         # Route definitions for user-related APIs
├── controllers/
│   └── user.controller.ts     # Logic (controller) for each route
└── utils/
    └── asyncHandler.ts        # Utility for handling async errors safely

```

---

## 1️⃣ app.ts — Main Express Setup

```tsx
import express from "express";
export const app = express();
app.use(express.json());

// Import routes
import userRouter from "./routes/user.routes.ts";
app.use('/api', userRouter);

```

### ✅ What’s happening:

- `express()` → creates the Express app instance.
- `app.use(express.json())` → allows parsing of JSON request bodies (required for POST requests).
- `userRouter` → imported from `routes/user.routes.ts`.
- `app.use('/api', userRouter)` → mounts all routes from `userRouter` under the `/api` prefix.

### 💡 Why we used `app.use('/api', userRouter)`

This makes your route modular and organized.

Without prefix:

→ You would have to define every route (like `/api/v1/user/joke`) directly in `app.ts`.

With prefix `/api`:

→ You can just define subpaths (`/joke`, `/user`, etc.) inside `user.routes.ts`, and all of them will be automatically accessible under `/api/...`.

Example:

If inside `user.routes.ts` you define `/joke`,

then full URL becomes → **`http://localhost:3000/api/joke`**

This keeps your `app.ts` clean and scalable.

---

## 2️⃣ asyncHandler.ts — Error Handling Utility

```tsx
import type { Request, Response, NextFunction } from "express";

export const asyncHandler = (
  fn: (req: Request, res: Response, next: NextFunction) => Promise<any>
) => {
  return (req: Request, res: Response, next: NextFunction) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
};

```

### ✅ What’s happening:

This function wraps your async route handlers so that you **don’t need try–catch blocks** everywhere.

Normally you’d write:

```tsx
router.get('/', async (req, res, next) => {
  try {
    const data = await something();
    res.json(data);
  } catch (err) {
    next(err);
  }
});

```

With `asyncHandler`, you just do:

```tsx
router.get('/', asyncHandler(async (req, res) => {
  const data = await something();
  res.json(data);
}));

```

### 💡 Why we did it:

- Prevents code repetition of `try–catch`.
- Automatically forwards errors to Express’s error handler.
- Keeps controllers clean and readable.

---

## 3️⃣ user.routes.ts — Router Layer

```tsx
import { Router } from "express";
import joke from "../controllers/user.controller.ts";

const router = Router();
router.route('/joke').post(joke);

export default router;

```

### ✅ What’s happening:

- `Router()` → creates a mini Express app for user-specific routes.
- `router.route('/joke').post(joke)` → defines a POST route `/api/joke`.
- The handler function `joke` is imported from the controller.

### 💡 Why we did it:

- **Keeps routes modular** — each feature (user, auth, products, etc.) can have its own route file.
- Easier to maintain large codebases.
- Avoids putting all route logic in `app.ts`.

---

## 4️⃣ user.controller.ts — Controller Layer

```tsx
import { asyncHandler } from "../utils/asyncHandler.ts";

const Jokes = [{ Name: "Mukul" }, { Name: "Kuki" }];

const joke = asyncHandler(async (req, res) => {
  res.status(200).json(Jokes);
});

export default joke;

```

### ✅ What’s happening:

- `asyncHandler` wraps the function to handle errors.
- Returns a list of jokes as a JSON response.

### 💡 Why we did it:

- **Controller handles logic** — fetching, computing, or responding.
- Keeps the route file (`user.routes.ts`) short and focused on defining endpoints only.

---

## 🧠 Full Flow Summary

| Layer | File | Responsibility | Example |
| --- | --- | --- | --- |
| **App (Entry)** | `app.ts` | Starts the server, mounts routes | `/api` prefix added |
| **Router (Paths)** | `routes/user.routes.ts` | Defines endpoints (like `/joke`) | `/api/joke` |
| **Controller (Logic)** | `controllers/user.controller.ts` | Handles actual business logic | Send jokes array |
| **Utility (Helper)** | `utils/asyncHandler.ts` | Handles async errors cleanly | Avoid try-catch |

---

## 🧩 How to Add Multiple APIs in `user.routes.ts`

```tsx
import { Router } from "express";
import { getJokes, addJoke, deleteJoke } from "../controllers/user.controller.ts";

const router = Router();

router.get('/jokes', getJokes);      // GET /api/jokes
router.post('/joke', addJoke);       // POST /api/joke
router.delete('/joke/:id', deleteJoke); // DELETE /api/joke/:id

export default router;

```

This structure scales easily — you can later have `auth.routes.ts`, `product.routes.ts`, etc., and just import them into `app.ts` like: