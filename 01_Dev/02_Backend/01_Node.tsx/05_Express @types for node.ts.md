---
title: 05_Express for node.ts
tags:
  - Backend
  - Typescript
created: 2025-11-02
updated: 2025-11-02
---

# 🚀 05_Express for node.ts

> **Framework / Library:** Express.js  
> **Language:** {{Language}}  
> **Category:** {{Category}}  
> **Level:** Beginner / Intermediate / Advanced

---

# node-ts , express , ts , .env,@types/module

Absolutely! Let’s break this **TypeScript + Express + EJS + dotenv** setup into **full understanding** and step-by-step installation so nothing is confusing. I’ll explain every line, why we do it, and how to install the modules correctly.

---

## 1️⃣ Folder structure

Assume your project looks like this:

```
Backend_Node.js/
│
├─ src/
│   ├─ server.ts
│
├─ views/
│   └─ index.ejs
│
├─ .env
├─ package.json
├─ tsconfig.json

```

---

## 2️⃣ Install Node.js modules

**Essential modules for this project:**

```bash
npm init -y                 # initialize package.json
npm install express ejs dotenv
npm install --save-dev typescript @types/node @types/express ts-node nodemon
npx tsc --init
```

**Explanation:**

| Package | Purpose |
| --- | --- |
| `express` | Web framework for server & routing |
| `ejs` | Template engine to render HTML |
| `dotenv` | Load `.env` variables into `process.env` |
| `typescript` | TypeScript compiler |
| `@types/node` | Type definitions for Node.js |
| `@types/express` | Type definitions for Express |
| `ts-node` | Run TypeScript files directly |
| `nodemon` | Auto-reload server during development |

---

## 3️⃣ tsconfig.json (TypeScript config)

Create `tsconfig.json`:

```json
{
  "compilerOptions": {
    "target": "ES2020",                // Modern JS version
    "module": "ESNext",                // For ESM modules
    "moduleResolution": "node",        // Resolve node_modules correctly
    "esModuleInterop": true,           // Allows `import express from "express"`
    "forceConsistentCasingInFileNames": true,
    "strict": true,                     // Type-checking enabled
    "skipLibCheck": true                // Skip checking node_modules types
  },
  "include": ["src/**/*"]
}

```

---

## 4️⃣ .env file

Create a file called `.env` in the root:

```
PORT=3000

```

**Explanation:**

- This file stores **environment variables** like PORT, DB connection strings, API keys, etc.
- Never commit `.env` to Git if it has sensitive info.

---

## 5️⃣ server.ts file explained

```tsx
import express from "express";                 // Web framework
import path from "path";                       // Node module for file paths
import { fileURLToPath } from "url";          // Convert URL to file path (ESM)
import dotenv from "dotenv";                   // Load .env

dotenv.config();                               // Reads .env and sets process.env

// Fix __dirname for ESM
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();                          // Create express app

// Set EJS as template engine
app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "../views")); // Path to views folder

// Define route
app.get("/", (req, res) => {
  res.render("index");                          // Render index.ejs
});

// Get PORT from environment variable
const PORT = process.env.PORT || 3000;

// Start server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});

```

**Key points:**

1. `dotenv.config()` → Loads `.env` variables like `PORT`
2. `fileURLToPath(import.meta.url)` → Needed in ES modules because `__dirname` doesn’t exist by default
3. `app.set("view engine", "ejs")` → Tells Express to render `.ejs` templates
4. `process.env.PORT || 3000` → Fallback if PORT not defined in `.env`

---

## 6️⃣ Running the project

1. Add scripts in `package.json`:

```json
"scripts": {
  "start": "ts-node src/server.ts",
  "dev": "nodemon --watch 'src/**/*.ts' --exec 'ts-node' src/server.ts"
}

```

1. Run in development:

```bash
npm run dev

```

This will auto-reload your server whenever you edit `server.ts`.

---

## 7️⃣ Install everything for TypeScript

Full command list:

```bash
npm install express ejs dotenv
npm install --save-dev typescript @types/node @types/express ts-node nodemon

```

Optional: If you use **ESLint**, you can add:

```bash
npm install --save-dev eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin

```

---

✅ With this setup, you have:

- TypeScript server (`.ts`)
- `.env` support
- EJS templates
- Nodemon auto-reload
- Full type checking

---

If you want, I can **write the final fully working `server.ts` + `tsconfig.json` + `.env` + package.json scripts** so you can copy-paste and it just works.

Do you want me to do that?