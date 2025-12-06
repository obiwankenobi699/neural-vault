---
title: 05_Middleware ,inbuild, Custom Functions
tags:
  - database
  - mongo
created: 2025-11-05
updated: 2025-11-05
---


> **Subject:** {{Subject}}  
> **Topic Type:** Concept / Process / Architecture / Example  
> **Related Topics:** 
Excellent 🔥 — this is one of those topics that separates a **junior dev** from a **real backend engineer**.
Let’s break down **Mongoose hooks** and **middleware** clearly — what types exist, when they run, and how companies use them in production.

---

## 🧩 What Are “Hooks” or “Middleware” in Mongoose?

In **Mongoose**, “middleware” (also called **hooks**) are functions that run **before** or **after** certain actions (like saving, deleting, or finding documents).

They help you **automate logic**, like:

- hashing passwords before saving 🪪
- validating or transforming data
- logging actions
- updating timestamps
- cascading deletes

---

## ⚙️ Two Main Types of Middleware (Hooks)

| Type | Description | Example |
| --- | --- | --- |
| **Document Middleware** | Runs on *individual documents* — e.g. before/after saving, validating | `pre('save')`, `post('save')` |
| **Query Middleware** | Runs on *queries* — e.g. before/after `find`, `updateOne`, `deleteOne` | `pre('find')`, `post('find')` |

---

## 🧱 1. **Document Middleware (Hooks)**

These work when you call `.save()`, `.validate()`, etc.
They have access to `this` — the **actual document** being modified.

### Common document hooks:

| Hook | Runs Before/After | Used For |
| --- | --- | --- |
| `pre('validate')` | Validation | Custom field checks |
| `pre('save')` | Saving doc | Hash passwords, modify fields |
| `post('save')` | Saving doc | Logging, send welcome email |
| `pre('remove')` | Deleting doc | Cascade delete related data |
| `post('remove')` | Deleting doc | Cleanup after delete |
| `pre('init')` | Document init | Transform data when loading from DB |

### Example:

```jsx
userSchema.pre('save', function(next) {
  if (!this.isModified('password')) return next();
  console.log('About to save user:', this.email);
  next();
});

```

---

## 🔍 2. **Query Middleware**

These run on **query methods**, like:

- `find()`
- `findOne()`
- `updateOne()`
- `deleteOne()`
- `findOneAndUpdate()`

They **do not** have direct access to the document — instead, `this` refers to the **query object**.

### Common query hooks:

| Hook | Runs Before/After | Used For |
| --- | --- | --- |
| `pre('find')` | Before find query | Filter out soft-deleted docs |
| `pre('findOne')` | Before findOne query | Add default filters |
| `pre('updateOne')` | Before update | Modify update payload |
| `post('find')` | After find query | Log query results |
| `pre('findOneAndUpdate')` | Before update | Validate updates |

### Example:

```jsx
userSchema.pre('find', function(next) {
  this.where({ isDeleted: false }); // filter out soft-deleted users
  next();
});

```

---

## 🧩 3. **Aggregate Middleware**

Used with **aggregation pipelines** (`Model.aggregate()`).

They let you modify or inspect the aggregation before it runs.

### Example:

```jsx
userSchema.pre('aggregate', function(next) {
  // Automatically filter out inactive users
  this.pipeline().unshift({ $match: { isActive: true } });
  next();
});

```

✅ Used by companies for:

- Global filters
- Soft delete logic
- Tenant-based filtering (multi-tenant apps)

---

## 🧩 4. **Model Middleware**

These hooks are attached to **static model methods** (like `insertMany`).

Example:

```jsx
userSchema.pre('insertMany', function(next, docs) {
  console.log('Inserting multiple users:', docs.length);
  next();
});

```

---

## 🧠 Summary Table

| Middleware Type | Triggered On | Access to Document? | Common Use Case |
| --- | --- | --- | --- |
| **Document** | `save`, `validate`, `remove` | ✅ Yes (`this`) | Hashing password, modify fields |
| **Query** | `find`, `update`, `delete` | ❌ No | Filtering, security rules |
| **Aggregate** | `aggregate()` | ❌ No | Modify pipeline |
| **Model** | `insertMany()` | ❌ No | Bulk operations |

---

## 🚀 Real-World Use Cases (Used in Companies)

| Use Case | Type | Description |
| --- | --- | --- |
| 🔐 Password hashing | Document (`pre('save')`) | Automatically hash before save |
| 🧹 Cascade delete | Document (`pre('remove')`) | Delete related documents (e.g., user’s posts) |
| 🔍 Soft delete | Query (`pre('find')`) | Hide inactive or deleted records |
| 🧾 Audit logging | Post hooks | Record who changed what |
| 📊 Data consistency | Aggregate | Add global filters to pipelines |

---

## 💡 Bonus: Order of Execution

If you have multiple hooks of the same type:

- They run **in the order defined**.
- You can call `next()` to continue or throw an error to stop the chain.

---

## 🧠 Pro Tip:

You can register **global hooks** that apply to all models:

```jsx
mongoose.plugin(schema => {
  schema.pre('find', function(next) {
    this.where({ isDeleted: false });
    next();
  });
});

```

---

Absolutely! Let’s break it down carefully — in **Mongoose/MongoDB**, you have **two types of methods** on your models: **inbuilt (built-in) methods** and **custom methods** (that you define yourself).

---

## 1️⃣ **Inbuilt Methods in Mongoose/MongoDB**

These are **predefined methods** that come with Mongoose models and documents.

### a) **Document Methods**

Run on individual document instances:

| Method | Description |
| --- | --- |
| `save()` | Saves the current document to DB |
| `validate()` | Validates schema rules before saving |
| `remove()` | Removes the document from DB |
| `update()` | Updates the document (deprecated: use `updateOne`) |
| `toObject()` | Converts document to plain JS object |
| `toJSON()` | Converts document to JSON (useful for APIs) |

**Example:**

```jsx
const user = new User({ name: 'Mukul', email: 'mukul@example.com' });
await user.save();          // inbuilt
await user.validate();      // inbuilt

```

---

### b) **Model Methods**

Run on the **model itself**, not a single document:

| Method | Description |
| --- | --- |
| `find()` | Find multiple documents |
| `findOne()` | Find one document |
| `findById()` | Find by ID |
| `findOneAndUpdate()` | Find one and update |
| `updateOne()` / `updateMany()` | Update document(s) |
| `deleteOne()` / `deleteMany()` | Delete document(s) |
| `countDocuments()` | Count matching documents |
| `aggregate()` | Aggregation pipelines |

**Example:**

```jsx
const users = await User.find({ city: 'Delhi' });  // inbuilt
const count = await User.countDocuments();        // inbuilt

```

---

## 2️⃣**Custom Methods in Mongoose**

^d916d9

These are **methods you define yourself** on:

### a) **Document Methods**

Run on a single document (instance method).

```jsx
// Define method
userSchema.methods.sayHello = function() {
  return `Hello, my name is ${this.name}`;
};

// Use method
const user = await User.findOne({ email: 'mukul@example.com' });
console.log(user.sayHello());  // Hello, my name is Mukul

```

✅ Use Cases:

- Password verification
- Formatting or transforming data
- Sending notifications

---

### b) **Static / Model Methods**

Run on the **model itself**, like `User.find()`, but custom.

```jsx
// Define static method
userSchema.statics.findByEmail = function(email) {
  return this.findOne({ email });
};

// Use method
const user = await User.findByEmail('mukul@example.com');
console.log(user);

```

✅ Use Cases:

- Custom queries (`findByEmail`, `getActiveUsers`)
- Aggregations or reports
- Reusable query logic

---

### c) **Virtuals**

Not exactly methods, but computed fields:

```jsx
userSchema.virtual('fullName').get(function() {
  return `${this.firstName} ${this.lastName}`;
});

const user = await User.findOne();
console.log(user.fullName); // John Doe

```

---

## 3️⃣ **Summary Table**

| Method Type | Where | Built-in / Custom | Example |
| --- | --- | --- | --- |
| Document | Instance | Built-in | `doc.save()` |
| Document | Instance | Custom | `doc.sayHello()` |
| Model | Static | Built-in | `User.find()` |
| Model | Static | Custom | `User.findByEmail()` |
| Virtual | Instance | Custom (getter/setter) | `user.fullName` |

---

## 4️⃣ **Why Companies Use Custom Methods**

- Reusable business logic → reduces code duplication
- Cleaner controllers → move logic into models
- Adds abstraction → easy to maintain large apps
- Security → e.g., password comparison (`isPasswordCorrect`)

---

If you want, I can show a **full example combining:**

- **Inbuilt methods** (`save`, `find`)
- **Custom instance methods** (`isPasswordCorrect`)
- **Custom static methods** (`findByEmail`)

All in a single **User model setup with JWT + bcrypt**, like a real company backend.

Do you want me to do that?