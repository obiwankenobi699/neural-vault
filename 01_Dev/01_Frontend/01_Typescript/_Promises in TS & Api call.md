---
tags:
  - Typescript
  - Basics_of_Ts
created: 2025-11-03
---





Sure — here’s a **TypeScript example** showing how to use **Promises** and **Axios** to fetch and print 5 random jokes from a Dad Jokes API.
It demonstrates how asynchronous operations (like API calls) work with Promises.

---

### 📘 Example: Using Promises with Axios (TypeScript)

```ts
import axios from "axios";

// Function to fetch a single joke using Promise
function getDadJoke(): Promise<string> {
  return axios
    .get("https://icanhazdadjoke.com/", {
      headers: { Accept: "application/json" },
    })
    .then((response) => response.data.joke)
    .catch((error) => {
      console.error("Error fetching joke:", error.message);
      return "No joke found 😅";
    });
}

// Function to fetch 5 jokes
function getFiveJokes(): Promise<void> {
  const jokePromises: Promise<string>[] = [];

  for (let i = 0; i < 5; i++) {
    jokePromises.push(getDadJoke());
  }

  // Wait for all 5 jokes to resolve
  return Promise.all(jokePromises).then((jokes) => {
    console.log("\nHere are 5 Dad Jokes 🤣:\n");
    jokes.forEach((joke, index) => {
      console.log(`${index + 1}. ${joke}\n`);
    });
  });
}

// Run it
getFiveJokes();
```

---

### 🧠 Explanation

1. **Promise Basics:**

   * A `Promise` in TypeScript represents a value that will be available **in the future** — either **resolved** (success) or **rejected** (error).
   * You can chain `.then()` for success and `.catch()` for error handling.

2. **`axios.get()`** returns a Promise.

   * When the API call succeeds → `.then()` runs with the response.
   * When it fails → `.catch()` runs with the error.

3. **`Promise.all()`** waits for all Promises in an array to finish — useful when calling an API multiple times.

4. **TypeScript Typing:**
[[10_Promise in Node.js and dns module]]
   * `Promise<string>` means the function returns a Promise that will eventually contain a string (the joke).
   * You could also use `async/await` syntax instead of `.then()` if you prefer.

---


