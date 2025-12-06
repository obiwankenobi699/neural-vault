---
title: 07_Middleware
tags:
  - Backend
  - Typescript
created: 2025-11-02
updated: 2025-11-02
---
> **Subject:** Node.js
> **Topic Type:** Concept / Process / Architecture / Example  
> **Related Topics:** 

---
# Middleware

👉 **Express Middleware**, including `cors`, `express.json()`, `urlencoded()`, `body-parser`, `cookies`, and `express.static()` 

---

## ⚙️ What is Middleware?

> Middleware are functions that sit between the client request 🧍‍♂️ and the server response 🖥️ in an Express app.
> 

They can:

- Inspect, modify, or reject the request.
- Add or remove data.
- Handle authentication, parsing, logging, etc.

---

### 🧩 **ASCII Flow Diagram**

```
   ┌────────────────────────────────────────────────────┐
   │                    CLIENT (Browser)                │
   │              Sends HTTP Request (GET/POST)         │
   └────────────────────────────────────────────────────┘
                         │
                         ▼
   ┌────────────────────────────────────────────────────┐
   │                Express Middleware Stack            │
   │----------------------------------------------------│
   │ 1️⃣  cors()              → Allow cross-origin requests│
   │ 2️⃣  express.json()      → Parse incoming JSON data   │
   │ 3️⃣  express.urlencoded()→ Parse form data            │
   │ 4️⃣  cookie-parser()     → Parse cookies              │
   │ 5️⃣  body-parser         → Older body parsing logic   │
   │ 6️⃣  express.static()    → Serve static files (img,js)│
   └────────────────────────────────────────────────────┘
                         │
                         ▼
   ┌────────────────────────────────────────────────────┐
   │                    Route Handlers                  │
   │----------------------------------------------------│
   │ app.get("/", ...)  → Handle GET requests            │
   │ app.post("/", ...) → Handle POST requests           │
   └────────────────────────────────────────────────────┘
                         │
                         ▼
   ┌────────────────────────────────────────────────────┐
   │                   RESPONSE SENT                    │
   └────────────────────────────────────────────────────┘

```

---

## 🧱 **Middleware in Express**

Express uses middleware functions in a **stack-like flow**:

```jsx
app.use(middleware1);
app.use(middleware2);
app.get('/', handler);

```

Each middleware can:

- Process `req` (request) and `res` (response)
- Call `next()` → to move to the next middleware
- Or send a response directly (ending the cycle)

---

### 🧭 Middleware Flow Example

```jsx
app.use((req, res, next) => {
  console.log("1️⃣ Logging middleware");
  next(); // moves to next middleware
});

app.use((req, res, next) => {
  console.log("2️⃣ Authentication middleware");
  next();
});

app.get("/", (req, res) => {
  res.send("🏠 Home Page");
});

```

**Flow Visualization:**

```
Request → Logging → Auth → Route("/") → Response

```

---

## 🌐 **CORS (Cross-Origin Resource Sharing)**

### 🧩 What it does:

CORS allows or restricts requests from **other domains** (e.g., your frontend and backend are separate).

### ⚙️ Install:

```bash
npm install cors

```

### 🧠 Use:

```jsx
import cors from "cors";
app.use(cors({
  origin: "http://localhost:5173", // allowed frontend
  credentials: true,               // allows cookies/auth headers
}));

```

### 📘 Features:

| Option | Description |
| --- | --- |
| `origin` | Allow specific domain(s) |
| `methods` | Allowed HTTP methods (`GET,POST,PUT,DELETE`) |
| `credentials` | Allow cookies or auth headers |
| `allowedHeaders` | Specify allowed request headers |

---

## 📦 **express.json()**

### 🧩 What it does:

Parses **incoming JSON** requests into `req.body`.

```jsx
app.use(express.json({ limit: "10kb" }));

```

### ⚙️ Options:

| Option | Description |
| --- | --- |
| `limit` | Restrict JSON payload size (e.g., `"10kb"`) to prevent large uploads |

### 💡 Example:

```jsx
// POST /user with body: { "name": "Mukul" }
app.post("/user", (req, res) => {
  console.log(req.body.name); // Mukul
  res.send("User received");
});

```

---

## 📑 **express.urlencoded()**

### 🧩 What it does:

Parses **form data** (from HTML forms) — e.g., `application/x-www-form-urlencoded`.

```jsx
app.use(express.urlencoded({ extended: true }));

```

### ⚙️ Options:

| Option | Description |
| --- | --- |
| `extended: true` | Uses the `qs` library → allows nested objects `{ user: { name: "Mukul" }}` |
| `extended: false` | Uses `querystring` library → simple key-value parsing |

---

## 🧍‍♂️ **body-parser (Old Version)**

> ✅ Note: body-parser is now built into Express (express.json() and express.urlencoded()).
> 

### Still works if you prefer explicit use:

```jsx
import bodyParser from "body-parser";
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

```

---

## 🍪 **cookie-parser**

### 🧩 What it does:

Parses cookies from client requests → adds them to `req.cookies`.

```bash
npm install cookie-parser

```

```jsx
import cookieParser from "cookie-parser";
app.use(cookieParser());

```

### 💡 Example:

```jsx
app.get("/read-cookie", (req, res) => {
  console.log(req.cookies); // { token: 'abc123' }
  res.send("Cookie read");
});

```

---

## 🖼️ **express.static()**

### 🧩 What it does:

Serves **static files** (images, CSS, JS) from a folder.

```jsx
app.use(express.static("public"));

```

Now files in `/public` are accessible:

```
/public/logo.png → http://localhost:3000/logo.png

```

---

## 🧭 **Overall Request-Response Flow**

```
      ┌────────────┐
      │  Client 🧑  │
      └──────┬─────┘
             │  HTTP Request
             ▼
┌──────────────────────────────────────────────┐
│              Express Middleware Stack        │
│----------------------------------------------│
│ cors() → express.json() → express.urlencoded()│
│ cookie-parser() → static() → route handler    │
└──────────────────────────────────────────────┘
             │
             ▼
     ┌────────────┐
     │  Route     │
     │  app.get() │
     │  app.post()│
     └──────┬─────┘
             │
             ▼
     ┌────────────┐
     │  Response  │
     │  (res.send)│
     └────────────┘

```

---

## 🧠 Summary Table

| Middleware | Purpose | Common Options |
| --- | --- | --- |
| `cors()` | Enables cross-origin requests | `origin`, `methods`, `credentials` |
| `express.json()` | Parse JSON body | `limit` |
| `express.urlencoded()` | Parse form data | `extended` |
| `cookie-parser()` | Parse cookies | — |
| `body-parser` | Old JSON/form parser | `extended`, `limit` |
| `express.static()` | Serve static files | directory path |

---

## 🧩 Example Setup

```jsx
import express from "express";
import cors from "cors";
import cookieParser from "cookie-parser";

const app = express();

app.use(cors({ origin: "http://localhost:5173", credentials: true }));
app.use(express.json({ limit: "10kb" }));
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(express.static("public"));

// ROUTES
app.get("/", (req, res) => res.send("GET route hit ✅"));
app.post("/data", (req, res) => res.json(req.body));

export { app };

```

---

Would you like me to **add a second ASCII diagram** showing middleware as **layers in Express pipeline (like an onion)** — so you can visualize how each wraps around the request-response cycle?