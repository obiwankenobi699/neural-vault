---
title: JWT,Bcrypt
tags:
  - Backend
  - auth
  - Typescript
created: 2025-11-05
updated: 2025-11-05
---


> **Subject:** Auth
> **Topic Type:** Concept / Process / Architecture / Example  
> **Related Topics:** [[03_Functions and Safety in TS#^3da6b4]] , [[05_Middleware ,inbuild , Custom Functions#^d916d9]]

---

Excellent question 🔥 —
Let’s break down **how to use JWT (for authentication)** and **bcrypt (for password hashing)** in a **Node.js MVC architecture**.

---

## 🧩 1. MVC Structure Overview

Here’s the **basic structure** for an Express + MongoDB app using MVC:

```
project/
├── src/
│   ├── models/
│   │   └── user.model.ts
│   ├── controllers/
│   │   └── auth.controller.ts
│   ├── routes/
│   │   └── auth.routes.ts
│   ├── middleware/
│   │   └── auth.middleware.ts
│   ├── utils/
│   │   └── jwt.utils.ts
│   ├── server.ts
│   └── config/
│       └── db.ts
├── package.json
└── .env
```

---

## 🧠 2. Install Required Packages

```bash
npm install express mongoose bcrypt jsonwebtoken dotenv
npm install -D typescript @types/express @types/jsonwebtoken @types/bcrypt
```

---

## 🧱 3. User Model — `/models/user.model.ts`

```ts
import mongoose, { Document, Schema } from "mongoose";
import bcrypt from "bcrypt";

export interface IUser extends Document {
  name: string;
  email: string;
  password: string;
  comparePassword(candidate: string): Promise<boolean>;
}

const userSchema = new Schema<IUser>({
  name: { type: String, required: true },
  email: { type: String, unique: true, required: true },
  password: { type: String, required: true },
});

// 🔒 Hash password before saving
userSchema.pre("save", async function (next) {
  if (!this.isModified("password")) return next();
  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
  next();
});

// ✅ Compare passwords
[[05_Middleware and inbuild Functions |^Custom Methods in Mongoose]]
// Compare password string==hash
userSchema.methods.comparePassword = async function (candidate: string) {
  return await bcrypt.compare(candidate, this.password);
};

export default mongoose.model<IUser>("User", userSchema);
```

---

## 🔐 4. JWT Utility — `/utils/jwt.utils.ts`

```ts
import jwt from "jsonwebtoken";

const JWT_SECRET = process.env.JWT_SECRET || "secret123";

export const generateToken = (userId: string) => {
  return jwt.sign({ id: userId }, JWT_SECRET, { expiresIn: "1d" });
};

export const verifyToken = (token: string) => {
  return jwt.verify(token, JWT_SECRET);
};
```

---

## 🧩 5. Auth Controller — `/controllers/auth.controller.ts`

```ts
import { Request, Response } from "express";
import User from "../models/user.model";
import { generateToken } from "../utils/jwt.utils";

export const registerUser = async (req: Request, res: Response) => {
  try {
    const { name, email, password } = req.body;
    const existing = await User.findOne({ email });
    if (existing) return res.status(400).json({ message: "User already exists" });

    const user = new User({ name, email, password });
    await user.save();

    const token = generateToken(user._id.toString());
    res.status(201).json({ message: "Registered successfully", token });
  } catch (err) {
    res.status(500).json({ error: (err as Error).message });
  }
};

export const loginUser = async (req: Request, res: Response) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });
    if (!user || !(await user.comparePassword(password))) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    const token = generateToken(user._id.toString());
    res.status(200).json({ message: "Login successful", token });
  } catch (err) {
    res.status(500).json({ error: (err as Error).message });
  }
};
```

---

## 🛡️ 6. Middleware — `/middleware/auth.middleware.ts`

```ts
import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";

const JWT_SECRET = process.env.JWT_SECRET || "secret123";

export const authMiddleware = (req: Request, res: Response, next: NextFunction) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ message: "No token provided" });
  }

  const token = authHeader.split(" ")[1];

  try {
    const decoded = jwt.verify(token, JWT_SECRET) as { id: string };
    (req as any).userId = decoded.id;
    next();
  } catch {
    res.status(401).json({ message: "Invalid or expired token" });
  }
};
```

---

## 🚏 7. Routes — `/routes/auth.routes.ts`

```ts
import { Router } from "express";
import { registerUser, loginUser } from "../controllers/auth.controller";
import { authMiddleware } from "../middleware/auth.middleware";

const router = Router();

router.post("/register", registerUser);
router.post("/login", loginUser);

// Example protected route
router.get("/me", authMiddleware, (req, res) => {
  res.json({ message: "You are authenticated!", userId: (req as any).userId });
});

export default router;
```

---

## 🧩 8. Server — `/server.ts`

```ts
import express from "express";
import dotenv from "dotenv";
import mongoose from "mongoose";
import authRoutes from "./routes/auth.routes";

dotenv.config();
const app = express();

app.use(express.json());
app.use("/api/auth", authRoutes);

mongoose.connect(process.env.MONGO_URI || "")
  .then(() => console.log("MongoDB Connected"))
  .catch(err => console.error(err));

app.listen(5000, () => console.log("Server running on port 5000"));
```

---

## ⚙️ 9. `.env` file

```
MONGO_URI=mongodb://localhost:27017/mvc_demo
JWT_SECRET=supersecretkey
```

---

## 🧩 1. How Access Token Travels in Headers

When the user logs in successfully, the backend sends a JWT like this:

```json
{
  "message": "Login success",
  "token": "eyJhbGciOiJIUzI1NiIsInR5..."
}
```

Then the **frontend** (React / Postman / etc.) stores that token — usually in:

- `localStorage`, or
    
- `sessionStorage`, or
    
- memory (like React context or Redux)
    

and then **sends it back** on protected requests like this 👇

```http
GET /api/users/profile HTTP/1.1
Host: localhost:5000
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5...
```

That `Authorization` header is what your middleware checks.

---

## 🧠 2. How Middleware Reads It

You already have this middleware (perfectly correct):

```ts
const authMiddleware = (req: Request, res: Response, next: NextFunction) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ message: "No token provided" });
  }

  const token = authHeader.split(" ")[1]; // ✅ "Bearer <token>"
  
  try {
    const decoded = jwt.verify(token, JWT_SECRET) as { id: string };
    (req as any).userId = decoded.id; // attach userId
    next();
  } catch {
    return res.status(401).json({ message: "Invalid or expired token" });
  }
};
```

So — it looks inside `req.headers.authorization`, finds the token, verifies it, and if valid → lets the request continue.

---

## 🧪 3. How to Send Token (Examples)

### 🧠 From Postman

1. Open **Headers tab**
    
2. Add:
    
    ```
    Key: Authorization
    Value: Bearer <your-token-here>
    ```
    

or

### 🧠 From Frontend (React / fetch)

```ts
const token = localStorage.getItem("token");

fetch("http://localhost:5000/api/users/profile", {
  method: "GET",
  headers: {
    "Content-Type": "application/json",
    "Authorization": `Bearer ${token}`, // 👈 here
  },
})
  .then(res => res.json())
  .then(data => console.log(data));
```

or using **Axios**:

```ts
axios.get("http://localhost:5000/api/users/profile", {
  headers: {
    Authorization: `Bearer ${token}`,
  },
});
```

---

## ⚙️ 4. Full Request Flow

| Step | Component                        | What Happens                                    |
| ---- | -------------------------------- | ----------------------------------------------- |
| 1️⃣  | User logs in                     | Server returns a JWT                            |
| 2️⃣  | Frontend stores token            | localStorage / Redux                            |
| 3️⃣  | Frontend sends protected request | Adds `Authorization: Bearer <token>`            |
| 4️⃣  | Middleware runs                  | Extracts token from `req.headers.authorization` |
| 5️⃣  | JWT verified                     | Adds `req.userId`                               |
| 6️⃣  | Route handler runs               | Uses `req.userId` to fetch data                 |

---

## ✅ 5. Quick Debug Tip

Add a console log to confirm header works:

```ts
const authMiddleware = (req, res, next) => {
  console.log("Auth Header:", req.headers.authorization); // 👀 Check if token arrives
  ...
};
```

If it logs `undefined` → your frontend didn’t send the token.

---

### 🔐 Summary

| Concept         | Where it happens                          |
| --------------- | ----------------------------------------- |
| JWT created     | In `/login` route                         |
| Token sent back | In response body                          |
| Token stored    | In frontend (localStorage/sessionStorage) |
| Token attached  | In `Authorization` header (Bearer scheme) |
| Token verified  | In middleware before route                |

---
