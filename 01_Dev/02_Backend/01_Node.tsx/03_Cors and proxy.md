---
title: 03_Cors and proxy
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
# CORS , Proxy,Whitelisting

Here’s a **concise revision note** for **CORS and proxy in MERN stack**:

---

## **1️⃣ CORS (Cross-Origin Resource Sharing)**

**Definition:**

Browser security mechanism that **blocks requests from a different origin** (`protocol + domain + port`) than the webpage’s origin.

**Problem Example:**

- React frontend: `http://localhost:5173`
- Express backend: `http://localhost:5000`
- Fetching `http://localhost:5000/api/data` → blocked by browser → **CORS error**.

**How it works:**

- Simple requests: Browser sends request → backend must respond with `Access-Control-Allow-Origin`.
- Preflight requests (`POST`, `PUT`, custom headers): Browser sends `OPTIONS` first to check permission.

**Express solution:**

```jsx
const cors = require("cors");
app.use(cors({
  origin: "http://localhost:5173",
  methods: ["GET","POST","PUT","DELETE"],
  credentials: true
}));

```

- `origin` → allowed frontend URL
- `credentials: true` → allow cookies/auth headers

---

## **2️⃣ Vite Proxy (Development Proxy)**

**Definition:**

Vite dev server can **forward requests** from frontend to backend to **avoid CORS issues**.

**Vite config example:**

```jsx
export default defineConfig({
  plugins: [react()],
  server: {
    proxy: {
      '/api': 'http://localhost:5000'
    }
  }
})

```

**Usage in React:**

```jsx
axios.get("/api/jokes")  // auto-forwarded to backend

```

**Advantages:**

- Avoids CORS errors in development
- No need to change backend
- Cleaner URLs in frontend code

---

## **3️⃣ Quick Revision Points**

- **CORS:** Browser prevents cross-origin requests. Fix via **backend headers** (`cors` middleware).
- **Proxy:** Dev server forwards requests to backend. Fix via **Vite proxy config**.
- **404 Error:** Often caused by **wrong URL or missing backend route**, not CORS itself.
- **Best Practice:**
    - Dev: Use **proxy** for convenience
    - Prod: Enable **CORS on backend** only for allowed frontend domains

---

I can also make a **1-page ultra-short “flashcard style” summary** for CORS + proxy that you can memorize in 5 mins.

Do you want me to do that?

Here’s a **clear explanation of whitelisting** in the context of CORS and web security:

---

## **Whitelisting**

**Definition:**

Whitelisting is the practice of **allowing only specific trusted origins, IPs, or domains** to access a resource, while **blocking all others**.

**In CORS context:**

- You don’t allow all websites to call your backend ().
- You only allow requests from **trusted frontend origins**.

**Example in Express:**

```jsx
const cors = require("cors");

const whitelist = ["http://localhost:5173", "https://myfrontend.com"];
const corsOptions = {
  origin: function(origin, callback){
    if(!origin || whitelist.indexOf(origin) !== -1){
      callback(null, true); // allow
    } else {
      callback(new Error("Not allowed by CORS")); // block
    }
  },
  credentials: true
};

app.use(cors(corsOptions));

```

✅ Explanation:

- Only requests from `localhost:5173` or `myfrontend.com` are allowed.
- Any other origin → blocked by CORS.

---

**Why Whitelisting is Important:**

1. **Security:** Prevents malicious websites from accessing your API.
2. **Control:** You control which clients can communicate with your server.
3. **Production readiness:** Never use `origin: '*'` in production if sensitive data is involved.

---

**Quick Revision Note:**

- **CORS** = browser security for cross-origin requests.
- **Proxy** = dev server forwards requests to avoid CORS.
- **Whitelisting** = allow only trusted origins to access your API.

---