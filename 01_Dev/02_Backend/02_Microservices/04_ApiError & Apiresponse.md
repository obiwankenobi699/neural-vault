---
title:
  "{ Title }":
tags:
  - theory
  - "{ Subject }":
  - semester_notes
created:
  "{ date }":
updated:
  "{ date }":
---


> **Subject:** Backend (Node.js)  
> **Topic Type:** Concept / Process / Architecture / Example  
> **Related Topics:** 

---
## 🧩 Step 1 — Create `ApiError` Utility

📁 `src/utils/ApiError.js`

```jsx
class ApiError extends Error {
  constructor(statusCode, message, errors = [], stack = "",data) {
    super(message); // call parent Error constructor
    this.statusCode = statusCode; // e.g. 404, 500, etc.
    this.errors = errors; // optional: extra validation errors
    this.success = false;
    this.data = null // consistent response structure

    if (stack) {
      this.stack = stack;
    } else {
      Error.captureStackTrace(this, this.constructor);
    }
  }
}

export default ApiError;

```

---

## 🧩 Step 2 — Update `asyncHandler` to Work With It

📁 `src/utils/asyncHandler.js`

```jsx
const asyncHandler = (fn) => async (req, res, next) => {
  try {
    await fn(req, res, next);
  } catch (err) {
    next(err); // pass to global error middleware
  }
};

export default asyncHandler;

```

---

## 🧩 Step 3 — Add Global Error Middleware

📁 `src/middleware/errorHandler.js`

```jsx
import ApiError from "../utils/ApiError.js";

const errorHandler = (err, req, res, next) => {
  // If it's not an ApiError, wrap it as one
  if (!(err instanceof ApiError)) {
    err = new ApiError(500, err.message || "Internal Server Error");
  }

  const { statusCode, message, errors, stack } = err;

  res.status(statusCode).json({
    success: false,
    message,
    errors,
    ...(process.env.NODE_ENV === "development" && { stack }),
  });
};

export default errorHandler;

```

Then mount it at the end of your app:

```jsx
import errorHandler from "./middleware/errorHandler.js";

app.use(errorHandler);

```

---

## 🧩 Step 4 — Use in Controllers

```jsx
import asyncHandler from "../utils/asyncHandler.js";
import ApiError from "../utils/ApiError.js";

export const getUser = asyncHandler(async (req, res, next) => {
  const user = await User.findById(req.params.id);

  if (!user) {
    throw new ApiError(404, "User not found");
  }

  res.status(200).json({
    success: true,
    data: user,
  });
});

```

---

## ⚙️ Final Flow Diagram

```
        ┌─────────────┐
        │   Request   │
        └──────┬──────┘
               │
               ▼
       ┌───────────────┐
       │ asyncHandler() │
       └──────┬────────┘
              │ try { await controller() }
              │ catch(err) { next(err) }
              ▼
       ┌─────────────────┐
       │   controller()   │
       └────────┬─────────┘
                │
         throw new ApiError(404,"Not found")
                ▼
       ┌───────────────────┐
       │ errorHandler()    │
       │ sends JSON error  │
       └───────────────────┘

```

---

## ✅ Advantages

- Clean controller code (no try/catch)
- Standardized JSON error format
- Reusable error class for any module
- Works with async/await + Express flow

---

Would you like me to also add a **success utility** (`ApiResponse`) so both success and error responses follow one consistent JSON structure (like REST standards)?