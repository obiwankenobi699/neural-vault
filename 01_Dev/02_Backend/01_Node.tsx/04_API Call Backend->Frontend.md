---
title: 04_API Call Backend->Frontend
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
# Dynamic limit , api call of backend in frontend

---

## 🧩 1. Without Dynamic Query (Static Limit)

Here you just tell the backend to give 2 jokes by default.

### 🔹 Frontend (React)

```tsx
useEffect(() => {
  async function getJokes() {
    const response = await axios.get('/api/jokes'); // no query
    setJokes(response.data);
  }
  getJokes();
}, []);

```

### 🔹 Backend (Express)

```jsx
app.get('/api/jokes', (req, res) => {
  const jokes = [
    { id: 1, title: "Broken Pencil", joke: "Why did the pencil go to the principal's office? It broke the rules." },
    { id: 2, title: "Math Book", joke: "Why was the math book sad? It had too many problems." },
    { id: 3, title: "Skeleton", joke: "Why don’t skeletons fight each other? They don’t have the guts." },
  ];

  res.json(jokes.slice(0, 2)); // ✅ only first 2 jokes
});

```

✅ Always returns 2 jokes.

---

## 🧩 2. With Dynamic Query (Dynamic Limit)

Here you can control how many jokes to fetch (e.g. `/api/jokes?limit=2`).

### 🔹 Frontend (React)

```tsx
useEffect(() => {
  async function getJokes() {
    const limit = 2; // you can make this dynamic later
    const response = await axios.get(`/api/jokes?limit=${limit}`);
    setJokes(response.data);
  }
  getJokes();
}, []);

```

### 🔹 Backend (Express)

```jsx
app.get('/api/jokes', (req, res) => {
  const jokes = [
    { id: 1, title: "Broken Pencil", joke: "Why did the pencil go to the principal's office? It broke the rules." },
    { id: 2, title: "Math Book", joke: "Why was the math book sad? It had too many problems." },
    { id: 3, title: "Skeleton", joke: "Why don’t skeletons fight each other? They don’t have the guts." },
    { id: 4, title: "Ocean", joke: "What did the ocean say to the beach? Nothing, it just waved." },
  ];

  const limit = parseInt(req.query.limit) || jokes.length; // ✅ default all if no limit
  res.json(jokes.slice(0, limit));
});

```

✅ You can now fetch `/api/jokes?limit=2`, `/api/jokes?limit=3`, etc.

---