---
title: Compile Time Vs Run Time
tags:
  - java
created: 2025-11-19
updated: 2025-11-19
---

# 💻 Compile Time Vs Run Time

> **Language:** {{Language}}  
> **Category:** {{Category}}  
> **Difficulty:** Easy / Medium / Hard  
> **Related Topics:** 

---

## 🧠 1. Problem Statement / Concept
Briefly explain what the problem or topic is.

**Example:**
> The “Two Sum” problem asks to find indices of two numbers in an array that add up to a given target.

---



---

## 🧠 1️⃣ Overview: Compile-Time vs Run-Time in Java

|Stage|Happens When|Key Responsibility|
|---|---|---|
|**Compile-time**|When you run `javac`|Syntax check, type check, and bytecode generation|
|**Run-time**|When you run `java`|JVM loads, allocates memory, and executes code|

---

## ⚙️ 2️⃣ Example Program

```java
public class Main {
    public static void main(String[] args) {
        int[] arr = new int[5];
        arr[0] = 10;
        arr[1] = 20;
        System.out.println(arr[1]);
    }
}

```

---

## 🧩 3️⃣ What Happens at **Compile Time**

When you run:

```bash
javac Main.java

```

🔹 The Java Compiler (`javac`) does **not** execute code.

It only:

- Checks **syntax** (semicolons, parentheses, etc.)
- Checks **types** (e.g., you can’t assign `String` to `int`)
- Ensures the array type is valid (`int[]`)
- Generates **bytecode** → `Main.class`

Nothing in memory (stack/heap) is created yet.

The array `arr` **does not exist yet**.

🧮 Compiler only _knows_:

> There will be an int[] variable named arr.

---

## 🚀 4️⃣ What Happens at **Run Time**

When you run:

```bash
java Main

```

Now the **JVM** starts executing `Main.main()` step-by-step 👇

---

### Step 1️⃣ – JVM Loads Class

- Class loader loads `Main.class` bytecode.
- JVM verifies it.
- JVM creates a **stack frame** for `main()`.

```
[Stack Memory]
┌────────────┐
│ main()     │
└────────────┘

```

---

### Step 2️⃣ – Declare Array Reference

```java
int[] arr;

```

At this point:

- JVM reserves space on **stack** for a reference variable `arr`.
- But it points to **nothing yet** (`null`).

```
Stack:
┌──────────────┐
│ arr : null   │
└──────────────┘

```

---

### Step 3️⃣ – Create Array Object in Heap

```java
arr = new int[5];

```

Now:

- JVM allocates space in **heap** for 5 integers.
- All values are initialized to 0 (default for int).
- The reference of that heap object is stored in `arr`.

```
Stack:                        Heap:
┌──────────────┐              ┌────────────────────────┐
│ arr ─────────┼────────────► │ [0] 0  [1] 0  [2] 0   │
└──────────────┘              │ [3] 0  [4] 0 (int[5]) │
                              └────────────────────────┘

```

---

### Step 4️⃣ – Assign Values

```java
arr[0] = 10;
arr[1] = 20;

```

Now heap content updates:

```
Heap:
[0] 10   [1] 20   [2] 0   [3] 0   [4] 0

```

---

### Step 5️⃣ – Print Value

```java
System.out.println(arr[1]);

```

- JVM looks up `arr` on stack → finds the heap reference.
- Reads the value `20` from index `[1]`.
- Passes it to the print stream.

Output:

```
20

```

---

### Step 6️⃣ – Program Ends

- Stack frame for `main()` is popped.
- Reference `arr` is lost.
- JVM’s **Garbage Collector (GC)** sees the heap array is unreachable → cleans it later.

---

## ⚖️ Summary Table

|Phase|Event|Memory Action|
|---|---|---|
|Compile-time|`javac` runs|Checks code, makes `.class` file|
|Run-time|JVM loads `Main.class`|Creates stack + heap|
|Run-time|`new int[5]`|Allocates heap memory for array|
|Run-time|Assign `arr[0]=10`|Writes value in heap|
|Run-time|Print|Reads from heap|
|End|GC cleans heap|Memory released|

---

## 🧭 ASCII Diagram — Full Memory Visualization

```
───────────── JVM MEMORY ─────────────
[Stack]                     [Heap]
┌────────────┐              ┌────────────────────────┐
│ main()     │              │ int[5] array object    │
│ ┌────────┐ │              │ ┌────────────────────┐ │
│ │ arr ───┼───────────────►│ [0]=10 [1]=20 [2]=0 │ │
│ └────────┘ │              │ [3]=0  [4]=0         │ │
└────────────┘              └──────────────────────┘ │
                                   ▲
                             Created by `new int[5]`
────────────────────────────────────────────────────

```

---