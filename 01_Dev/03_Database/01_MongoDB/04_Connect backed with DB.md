---
title: 04_Connect DB
tags:
  - database
  - mongo
created: 2025-11-04
updated: 2025-11-04
---

> **Subject:** Mongo
> **Topic Type:** Concept / Process / Architecture / Example  
> **Related Topics:** 

---

## 🧩 **Backend Database Connection (MongoDB + Express + dotenv)**

---

### **1. Importing Required Modules**

```jsx
import mongoose from "mongoose";
import { DB_NAME } from "../constants.ts";

```

- `mongoose`: ODM (Object Data Modeling) library for MongoDB — simplifies data interaction.
- `DB_NAME`: a constant variable imported from another file (e.g., `"myDatabase"`).

---

### **2. Async Function to Connect Database**

```jsx
const connectDB = async () => {
  try {
    const connectionInstance = await mongoose.connect(
      `${process.env.MONGODB_URI}/${DB_NAME}`
    );

```

- **`connectDB`**: an async function that connects your Node.js app to MongoDB.
- **`mongoose.connect()`**: establishes the connection using the URI (from `.env` file).
- **Template string** combines the base Mongo URI (`process.env.MONGODB_URI`) with the database name (`DB_NAME`).

Example:

```bash
MONGODB_URI=mongodb+srv://username:password@cluster0.mongodb.net
DB_NAME=myappdb

```

→ Final URI becomes:

```
mongodb+srv://username:password@cluster0.mongodb.net/myappdb

```

---

### **3. Success Log Message**

```jsx
console.log(`✅ MongoDB connected! Host: ${connectionInstance.connection.host}`);

```

- Prints a confirmation message once MongoDB connects successfully.
- `connectionInstance.connection.host` shows the connected cluster host (useful for debugging).

---

### **4. Error Handling**

```jsx
} catch (error) {
  console.error("❌ MongoDB connection ERROR:", error);
  process.exit(1);
}

```

- Catches any connection error.
- `process.exit(1)` stops the Node process if MongoDB fails to connect.

---

### **5. Exporting Function**

```jsx
export default connectDB;

```

- Makes the `connectDB` function reusable in other files (like `index.ts` or `server.ts`).

---

## 🚀 **Main Entry File: `index.ts`**

---

### **1. Import Dependencies**

```jsx
import connectDB from "./db/db.ts";
import dotenv from "dotenv";
import { app } from "./app.ts";

```

- `dotenv`: loads environment variables from `.env` file.
- `app`: Express app imported from another module.

---

### **2. Load Environment Variables**

```jsx
dotenv.config();

```

- Reads `.env` file and attaches variables to `process.env`.

---

### **3. Start Server After DB Connection**

```jsx
connectDB()
  .then(() => {
    app.listen(process.env.PORT, () => {
      console.log(`Server is running on <http://localhost$>{process.env.PORT}`);
    });
  })
  .catch((error) => {
    console.error('DB cant handshake with server');
  });

```

- **`.then()`**: runs only after MongoDB successfully connects.
    - Starts Express server on the given `PORT`.
- **`.catch()`**: if DB connection fails, prints an error message (doesn’t start server).

---

### ⚙️ **Flow Summary**

1. `dotenv` loads `.env` config.
2. `connectDB()` tries connecting to MongoDB.
3. If successful → server starts.
4. If fails → server doesn’t start, logs error.

---