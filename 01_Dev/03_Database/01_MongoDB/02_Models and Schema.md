---
title: 02_Models and Schema
tags:
  - database
  - mongo
created: 2025-11-04
updated: 2025-11-04
---


> **Subject:** MongoDB
> **Topic Type:** Concept / Process / Architecture / Example  
> **Related Topics:** 
---

## 🧠 1️⃣ What is **Mongoose**?

**Mongoose** is an **ODM (Object Data Modeling)** library for **MongoDB** and **Node.js**.

It allows you to:

- Define the **structure** of your documents (like a schema)
- Add **validation**
- Use **models** to interact with collections easily

Think of it as a **bridge** between your **MongoDB database** and **Node.js code**.

---

## 🧩 2️⃣ Importing Mongoose

```jsx
import mongoose from 'mongoose';

```

This imports the **Mongoose** library so you can define schemas and connect to MongoDB.

---

## 🧩 3️⃣ What is `mongoose.Schema({})`?

`mongoose.Schema()` defines the **structure** (blueprint) of the documents inside a **collection**.

It’s like defining the **columns** of a table in SQL — but for MongoDB.

### Example:

```jsx
const jokeSchema = new mongoose.Schema({
  title: { type: String, required: true },
  joke: { type: String, required: true },
  author: { type: String, default: 'Anonymous' },
  createdAt: { type: Date, default: Date.now },
});

```

✅ **Explanation:**

| Field | Type | Meaning |
| --- | --- | --- |
| `title` | `String` | The title of the joke |
| `joke` | `String` | The actual joke text |
| `author` | `String` | Optional field with a default value |
| `createdAt` | `Date` | Automatically set to current date/time |

---

## 🧩 4️⃣ What is `mongoose.model(name, schema)`?

`mongoose.model()` compiles your **schema** into a **Model** —
which is a **class** that gives you methods to interact with the database.

### Example:

```jsx
const Joke = mongoose.model('Joke', jokeSchema);

```

✅ **Explanation:**

- `'Joke'` → The **singular name** of your MongoDB collection.
(Mongoose automatically pluralizes it → **"jokes"** collection)
- `jokeSchema` → The structure (rules) we defined above

Now you can use `Joke` to:

- **Create** a new joke
- **Find** jokes
- **Update** jokes
- **Delete** jokes

---

##  5️⃣ Example Full Flow

```jsx
import mongoose from 'mongoose';

// 1️⃣ Connect to MongoDB
mongoose.connect('mongodb://localhost:27017/jokesDB');

// 2️⃣ Define Schema
const jokeSchema = new mongoose.Schema({
  title: String,
  joke: String,
});

// 3️⃣ Create Model
const Joke = mongoose.model('Joke', jokeSchema);

// 4️⃣ Create and Save a Document
const newJoke = new Joke({
  title: 'Broken Pencil',
  joke: 'Why did the pencil go to the principal’s office? It broke the rules.'
});

newJoke.save().then(() => console.log('Joke saved!'));

```

✅ This will insert one document into your MongoDB `jokes` collection.

---

## 🧩 6️⃣ Summary Notes for Revision

| Concept | Description | Example |
| --- | --- | --- |
| **Schema** | Blueprint for collection’s structure | `mongoose.Schema({ title: String })` |
| **Model** | Compiled schema that interacts with DB | `mongoose.model('Joke', jokeSchema)` |
| **Instance** | Actual document created from a model | `new Joke({ title: '...' })` |
| **Save()** | Stores the instance in the DB | `newJoke.save()` |

---

## 🧩 Quick Analogy

| SQL Term | Mongoose Equivalent |
| --- | --- |
| Table | Collection |
| Row | Document |
| Column | Field |
| Table schema | `mongoose.Schema()` |
| ORM Model | `mongoose.model()` |

---

---

##  1️⃣ Basic Schema Field Definition

In Mongoose, each field can be defined either **simply**:

```jsx
title: String

```

or with a **detailed object** that includes extra properties:

```jsx
title: {
  type: String,
  required: true,
  unique: true,
  trim: true,
  minlength: 3,
  maxlength: 100
}

```

---

## 🧩 2️⃣ Example: Full Schema with Properties

```jsx
import mongoose from 'mongoose';

const jokeSchema = new mongoose.Schema({
  title: {
    type: String,         // field data type
    required: true,       // must be provided
    unique: true,         // no two jokes can have the same title
    trim: true,           // removes spaces from start & end
    minlength: 3,         // minimum characters allowed
    maxlength: 100        // maximum characters allowed
  },
  joke: {
    type: String,
    required: [true, 'Joke text is required'], // custom error message
  },
  author: {
    type: String,
    default: 'Anonymous', // default value if not provided
  },
  category: {
    type: String,
    enum: ['Dad', 'Dark', 'Programming', 'Puns'], // restrict values
  },
  likes: {
    type: Number,
    default: 0,
    min: 0, // cannot be negative
  },
  createdAt: {
    type: Date,
    default: Date.now,
    immutable: true, // cannot be changed later
  },
});

```

✅ Then compile it into a model:

```jsx
const Joke = mongoose.model('Joke', jokeSchema);
export default Joke;

```

---

## 3️⃣ Explanation of Common Field Properties

| Property | Meaning | Example |
| --- | --- | --- |
| **type** | Defines the data type | `{ type: String }` |
| **required** | Field must exist | `{ required: true }` or `[true, 'Message']` |
| **unique** | Prevent duplicate values | `{ unique: true }` |
| **default** | Assigns a value if not given | `{ default: 'Anonymous' }` |
| **trim** | Removes whitespace from both ends | `{ trim: true }` |
| **minlength / maxlength** | Restrict string length | `{ minlength: 3, maxlength: 50 }` |
| **min / max** | Restrict numeric range | `{ min: 0, max: 100 }` |
| **enum** | Restrict allowed values | `{ enum: ['Dad', 'Programming'] }` |
| **immutable** | Field cannot be updated | `{ immutable: true }` |
| **match** | Regex pattern validation | `{ match: /^[A-Za-z\s]+$/ }` |

---

## 🧩 4️⃣ Example of a Validation Error

If someone tries to insert:

```jsx
const badJoke = new Joke({
  title: 'Hi',
  joke: ''
});

await badJoke.save();

```

Mongoose will throw:

```
ValidationError: Joke validation failed:
title: Path `title` (`Hi`) is shorter than the minimum allowed length (3).
joke: Path `joke` is required.

```

---

## 🧩 5️⃣ TL;DR Revision Notes

| Field Option | Purpose | Example |
| --- | --- | --- |
| **type** | Sets the data type | `{ type: String }` |
| **required** | Makes field mandatory | `{ required: true }` |
| **unique** | Prevents duplicates | `{ unique: true }` |
| **default** | Assigns a fallback value | `{ default: 'Anon' }` |
| **trim** | Removes spaces | `{ trim: true }` |
| **enum** | Restricts to fixed values | `{ enum: ['A', 'B', 'C'] }` |
| **min/max** | For numbers | `{ min: 1, max: 10 }` |
| **minlength/maxlength** | For strings | `{ minlength: 5 }` |
| **immutable** | Prevents future changes | `{ immutable: true }` |

---


