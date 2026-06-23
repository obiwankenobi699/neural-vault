---
title: 03_Relation Between 2 Models _id
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

##  1️⃣ Why Relationships Matter

In MongoDB, **data is stored in collections**, not tables.
There’s **no JOIN** like in SQL, but we can create **references** between collections.

Example idea:

- Each **User** can post many **Jokes**
- Each **Joke** belongs to **one User**

That’s a **one-to-many relationship**.

---

## 🧩 2️⃣ Reference Fields in Mongoose

To “link” one document to another, we use the field:

```jsx
ref: 'ModelName'

```

and store the **ObjectId** of the related document.

Example:

```jsx
author: {
  type: mongoose.Schema.Types.ObjectId,
  ref: 'User'
}

```

✅ Here:

- `ObjectId` = unique ID of the related document
- `ref: 'User'` = name of the model it refers to (must match `mongoose.model('User')`)

---

##  3️⃣ Example: One-to-Many (User → Jokes)

### 🧩 User Schema

```jsx
const userSchema = new mongoose.Schema({
  name: String,
  email: String,
});

const User = mongoose.model('User', userSchema);

```

### 🧩 Joke Schema

```jsx
const jokeSchema = new mongoose.Schema({
  title: String,
  joke: String,
  author: {
    type: mongoose.Schema.Types.ObjectId, // store ID of User
    ref: 'User',                          // reference the User model
    required: true
  }
});

const Joke = mongoose.model('Joke', jokeSchema);

```

Now every `Joke` document stores a **reference** (the `ObjectId`) of the user who created it.

---

## 🧩 4️⃣ Inserting Referenced Documents

Example:

```jsx
const user = await User.create({ name: 'Mukul', email: 'mukul@example.com' });

const joke = await Joke.create({
  title: 'Broken Pencil',
  joke: 'It’s pointless.',
  author: user._id, // reference to Mukul
});

```

In MongoDB, your `jokes` collection will look like:

```json
{
  "_id": "66e...",
  "title": "Broken Pencil",
  "joke": "It’s pointless.",
  "author": "66d..."
}

```

Here `"66d..."` is the user’s `_id` (reference).

---

## 🧩 5️⃣ Populating (Getting Full Related Data)

By default, MongoDB only stores IDs — not the full related document.
To get the **actual user data**, use **`.populate()`** in Mongoose:

```jsx
const joke = await Joke.findOne().populate('author');
console.log(joke);

```

Output:

```json
{
  "_id": "66e...",
  "title": "Broken Pencil",
  "joke": "It’s pointless.",
  "author": {
    "_id": "66d...",
    "name": "Mukul",
    "email": "mukul@example.com"
  }
}

```

✅ `populate()` replaces the `author` ID with the full user document.

---

##  6️⃣ Types of Relationships in MongoDB / Mongoose

| Relationship | Description | Example |
| --- | --- | --- |
| **One-to-One (1:1)** | One user has one profile | `User → Profile` |
| **One-to-Many (1:N)** | One user can post many jokes | `User → Jokes` |
| **Many-to-Many (N:N)** | Many users can like many jokes | `User ↔ Joke` |

---

## 🧩 7️⃣ Example: Many-to-Many (Users ↔ Liked Jokes)

### User Schema

```jsx
const userSchema = new mongoose.Schema({
  name: String,
  likedJokes: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Joke' }]
});

```

### Joke Schema

```jsx
const jokeSchema = new mongoose.Schema({
  title: String,
  likedBy: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }]
});

```

Now both sides can reference each other.

Example usage:

```jsx
const user = await User.findById(userId).populate('likedJokes');

```

---

## 🧩 8️⃣ TL;DR Revision Notes

| Term | Meaning | Example |
| --- | --- | --- |
| **ObjectId** | Unique ID MongoDB gives each document | `mongoose.Schema.Types.ObjectId` |
| **ref** | References another model name | `{ ref: 'User' }` |
| **populate()** | Fetches full document instead of just ID | `.populate('author')` |
| **1:1** | One-to-one | User → Profile |
| **1:N** | One-to-many | User → Jokes |
| **N:N** | Many-to-many | Users ↔ Jokes |

---

## 🧩 9️⃣ Best Practices

✅ Always use `ref` with `ObjectId` for relationships
✅ Use `.populate()` only when needed (it can slow down queries)
✅ For heavy reads, consider **embedding** small sub-documents instead of referencing

---