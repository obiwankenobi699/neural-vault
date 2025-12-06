---
title:
  "{ Title }":
tags:
  - Typescript
  - Backend
created: 2025-11-17
updated:
  "{ date }":
---


> **Subject:** {{Subject}}  
> **Topic Type:** Concept / Process / Architecture / Example  
> **Related Topics:** 

---

# Event Loop in JavaScript

The event loop is the mechanism that controls how JavaScript handles synchronous and asynchronous operations. JavaScript runs on a single thread, so it processes tasks in a specific order to remain non-blocking. Execution always begins with synchronous code, which is placed directly on the call stack and runs immediately, line by line. After synchronous work completes, the event loop checks the microtask queue. Microtasks include resolved Promises and mutation observer callbacks. These tasks are always given priority over macrotasks and must be fully cleared before any macrotask executes. Once the microtask queue is empty, the event loop processes the macrotask queue, which contains callbacks from setTimeout, setInterval, I/O events, and rendering events. This structure ensures JavaScript can schedule asynchronous operations without blocking the main thread.

In the following example, the console output demonstrates the event loop order. The synchronous log executes first. The Promise callback is a microtask, so it executes immediately after synchronous code, before any timer completes. The setTimeout callback runs after its delay as a macrotask. The setInterval callback also runs as a macrotask at regular intervals. The final output order reflects the priority of synchronous tasks, then microtasks, followed by macrotasks.

---

## Example Code

```javascript
console.log("1.Script Start");

setTimeout(() => {
    console.log("2.Settimeout macrotask");
}, 10000);

setInterval(() => {
    console.log("4.SetInterval");
}, 10000);

Promise.resolve().then(() => {
    console.log("3.Promise microtask");
});
```

---

# ASCII Diagram of the Event Loop

```
                ┌──────────────────────────┐
                │      Call Stack          │
                │  (runs synchronous code) │
                └───────────┬──────────────┘
                            │
                            ▼
                ┌──────────────────────────┐
                │    Microtask Queue       │
                │  Promise.then callbacks  │
                └───────────┬──────────────┘
                            │ (higher priority)
                            ▼
                ┌──────────────────────────┐
                │     Macrotask Queue      │
                │ setTimeout, setInterval  │
                └───────────┬──────────────┘
                            │
                            ▼
                ┌──────────────────────────┐
                │       Event Loop         │
                │  Decides which queue     │
                │  to process next         │
                └──────────────────────────┘
```

---

# Execution Timeline for the Code

```
Time = 0 ms
----------------------------------
Call Stack:
  console.log("1.Script Start")
Output:
  1.Script Start

Microtask Queue:
  Promise.then(...)
Output:
  3.Promise microtask


Time = 10 seconds
----------------------------------
Macrotask Queue:
  setInterval callback
  setTimeout callback

Execution Order:
  4.SetInterval
  2.Settimeout macrotask

Next intervals:
  4.SetInterval
  4.SetInterval
  ...
```

---

# Final Output Order

```
1.Script Start
3.Promise microtask
(after 10 seconds)
4.SetInterval
2.Settimeout macrotask
(every 10 seconds after)
4.SetInterval
4.SetInterval
...
```

---
Below is your **final combined Obsidian-ready note**, now including the **heavy CPU task inside your exact function**.  
The explanation includes: event loop, microtasks, macrotasks, async, blocking behavior, ASCII diagrams, and complete theory paragraphs.

---

# JavaScript Event Loop, Async Execution, Microtasks, Macrotasks, and CPU-Intensive Blocking

JavaScript runs on a single-threaded event loop, meaning only one operation can execute on the call stack at a time. Synchronous code always runs first. Once synchronous execution finishes, the event loop checks the microtask queue, which contains Promise callbacks and async/await continuations. Microtasks always run before macrotasks. After all microtasks finish, the event loop processes macrotasks such as setTimeout, setInterval, script tasks, and I/O callbacks. Because JavaScript only has one main thread, any CPU-intensive computation blocks the entire event loop, preventing microtasks and macrotasks from executing until the heavy operation completes.

Async/await uses Promises internally. The part before await runs synchronously. The moment await is encountered, the rest of the async function is scheduled as a microtask. This gives async/await predictable ordering: synchronous execution first, then Promise microtasks, then timers, unless the event loop is blocked by a CPU-heavy task.

CPU-intensive tasks like large loops, mathematical computation, encryption, or image processing freeze the thread. When such a task executes, the event loop cannot process microtasks or macrotasks. Timers are delayed, intervals stop, and Promises pause until the heavy computation finishes. This is why Node.js provides worker threads and browsers provide Web Workers: these let expensive tasks run off the main thread, keeping the event loop responsive.

---

# Example with Heavy CPU Task Injection

```javascript
function heavyTask() {
    console.log("Blocking CPU-heavy task started");

    let s = 0;
    for (let i = 0; i < 1e10; i++) {   // intense CPU loop
        s += i;
    }

    console.log("Blocking CPU-heavy task finished");
    return s;
}

console.log("1.Script Start");

setTimeout(() => {
    console.log("2.Settimeout macrotask");
}, 10000);

setInterval(() => {
    console.log("4.SetInterval");
}, 10000);

Promise.resolve().then(() => {
    console.log("3.Promise microtask");
});

async function example() {
    console.log("5.Async start"); 
    await null;                     
    console.log("6.Async microtask");
}

example();

// CPU HEAVY TASK BLOCKS EVERYTHING BELOW
heavyTask();

console.log("7.Script End");
```

---

# Expected Output (Event Loop Model)

```
1.Script Start
5.Async start
3.Promise microtask
6.Async microtask
Blocking CPU-heavy task started
(huge delay...)
Blocking CPU-heavy task finished
7.Script End
2.Settimeout macrotask       // delayed heavily
4.SetInterval                // delayed heavily
```

---

# Why This Happens

When heavyTask() runs, it occupies the call stack with a long-running loop. Because JavaScript has only one main thread, the event loop cannot proceed to microtasks or macrotasks until heavyTask completes. Promises pause, async/await pauses, and timers do not fire until the CPU is free again.

---

# ASCII Diagram: Blocking Effect

```
Call Stack
-----------------------------------------------------------
| heavyTask() – long loop – CPU fully consumed            |
-----------------------------------------------------------
                  |
                  V
 Event Loop Frozen
 -------------------------------
 Microtasks: waiting
 Macrotasks: waiting
 Timers: delayed
 Async jobs: paused
 UI: frozen
 -------------------------------
```

---

# Event Loop Architecture (ASCII)

```
             ┌────────────────────┐
             │    Call Stack      │
             └────────────────────┘
                       │
                       ▼
             ┌────────────────────┐
             │  Microtask Queue   │
             │ Promise, await     │
             └────────────────────┘
                       │
                       ▼
             ┌────────────────────┐
             │  Macrotask Queue   │
             │ setTimeout, I/O    │
             └────────────────────┘
                       │
                       ▼
             ┌────────────────────┐
             │     Event Loop     │
             └────────────────────┘
```

With heavyTask:

```
Call Stack (Blocked)
-------------------------------
| heavyTask running forever   |
-------------------------------
event loop cannot proceed
```

---

# Explanation of Each Part in This Example

- `console.log("1.Script Start")`  
    Runs synchronously.
    
- `example()` async call  
    Runs `"5.Async start"` immediately.
    
- `await null`  
    Schedules `"6.Async microtask"` as a microtask.
    
- `Promise.resolve()`  
    Schedules `"3.Promise microtask"`.
    
- Microtasks run:  
    `"3.Promise microtask"` then `"6.Async microtask"`.
    
- `heavyTask()`  
    Blocks the CPU for a long time.
    
- Because of this block:
    
    - `"2.Settimeout macrotask"` is delayed.
        
    - `"4.SetInterval"` is delayed.
        
    - No timers or events can run.
        
- After heavyTask finishes:  
    Timers execute their callbacks.
    

---