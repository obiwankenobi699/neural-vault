---
title: 02_Object & Classes
tags:
  - Typescript
  - Basics_of_Ts
created: 2025-11-02
updated: 2025-11-02
---
---


> **Subject:** TypeScript
> **Topic Type:** Object/Classes
> **Related Topics:** 

---

## 🧩 1. Overview

In **TypeScript**, **objects** and **classes** are core parts of Object-Oriented Programming (OOP).
They allow you to structure your code into **reusable blueprints** (classes) and **real entities** (objects).
TypeScript enhances this with **static typing**, **interfaces**, and **access modifiers** for better reliability.

> A **class** defines the structure (properties + methods).
> An **object** is a real instance created from that class.

---

## ⚙️ 2. Core Concepts

| Concept              | Description                                                 | Example                            |
| -------------------- | ----------------------------------------------------------- | ---------------------------------- |
| **Interface**        | Defines the *structure* (shape) of an object                | `interface User { name: string }`  |
| **Type Alias**       | Creates reusable type definitions                           | `type ID = string \| number`       |
| **Class**            | Blueprint for creating objects                              | `class Person { name: string }`    |
| **Object**           | Instance of a class                                         | `const p = new Person()`           |
| **Constructor**      | Initializes properties automatically                        | `constructor(name: string) {...}`  |
| **Access Modifiers** | Controls property access (`public`, `private`, `protected`) | `private age: number`              |
| **Inheritance**      | One class extending another                                 | `class Dog extends Animal {}`      |
| **super()**          | Calls parent constructor or methods                         | `super(name)`                      |
| **Getter/Setter**    | Encapsulates property access with logic                     | `get name() {}` / `set name(v) {}` |
| **Abstract Class**   | Base class with unimplemented methods                       | `abstract class Shape {}`          |

---

## 🧩 3. Interfaces in TypeScript

### 🔹 Purpose

Defines the **shape of an object** — what properties or methods it must contain.
It doesn’t hold data or logic itself.

### 🔹 Key Examples

```tsx
interface Person {
  name: string;
  age: number;
}

const user: Person = { name: "Mukul", age: 22 };
```

* **Optional property:** `model?: string`
* **Readonly property:** `readonly id: number`
* **Methods:** `speak(): void`
* **Extend interface:** `interface Employee extends Person { salary: number }`
* **Function type:**

  ```tsx
  interface Add {
    (a: number, b: number): number;
  }
  ```

✅ Use **interface** when defining *object contracts* or *API shapes*.

---

## 🧩 4. Type Aliases

`type` creates a custom **name** for any complex type — primitive, union, function, or object.

```tsx
type ID = string | number;
type User = { name: string; age: number };
type Add = (a: number, b: number) => number;
```

### 🔹 Intersection Type (`&`)

Combine multiple types:

```tsx
type Name = { name: string };
type Age = { age: number };
type Person = Name & Age;
```

✅ Use **type** when combining, aliasing, or building **complex** structures.

---

## 🧩 5. Classes in TypeScript

A **class** encapsulates data (properties) and behavior (methods).

### Example

```tsx
class Person {
  constructor(public name: string, public age: number) {}

  greet() {
    console.log(`Hello, I'm ${this.name} (${this.age})`);
  }
}
```

* `new Person("Mukul", 22)` → creates an object.
* Can have constructors, access modifiers, methods, and inheritance.

---

## 🧩 6. Access Modifiers

| Modifier      | Scope                     | Example                   |
| ------------- | ------------------------- | ------------------------- |
| **public**    | Accessible everywhere     | `public name: string`     |
| **private**   | Only inside the class     | `private age: number`     |
| **protected** | Inside class + subclasses | `protected grade: string` |

Example:

```tsx
class Student {
  constructor(public name: string, private age: number) {}
}
```

✅ Use `private` to encapsulate data and protect it from direct modification.

---

## 🧩 7. Inheritance & `super()`

Inheritance allows one class to **reuse** another class’s properties and methods.

```tsx
class Device {
  constructor(public name: string) {}
  greet() { console.log(`Device: ${this.name}`); }
}

class Smartphone extends Device {
  constructor(name: string, public brand: string) {
    super(name); // calls parent constructor
  }

  greet() {
    super.greet();
    console.log(`Brand: ${this.brand}`);
  }
}
```

✅ Use `super()` to:

* Call the **parent constructor**
* Access or reuse **parent methods**

---

## 🧩 8. Getters and Setters

Encapsulate access with validation or side effects.

```tsx
class Employee {
  private _salary: number;

  constructor(salary: number) {
    this._salary = salary;
  }

  get salary() {
    return this._salary;
  }

  set salary(value: number) {
    if (value < 0) console.log("❌ Invalid Salary");
    else this._salary = value;
  }
}
```

✅ Use for **controlled property access** — ensures data safety and validation.

---

## 🧩 9. Abstract Classes

An **abstract class** defines a *base template* with **incomplete methods**.
Subclasses must implement those abstract methods.

```tsx
abstract class Animal {
  constructor(public name: string) {}
  abstract makeSound(): void; // must be implemented
  move() { console.log(`${this.name} moves`); }
}

class Dog extends Animal {
  makeSound() { console.log("Woof!"); }
}
```

✅ Use abstract classes to:

* Enforce structure across subclasses
* Share common logic + force specific implementations

---

## 🔍 10. Architecture / Flow

**Object-Oriented Workflow:**

1. Define interface / type → structure of object
2. Create class → logic and methods
3. Instantiate object → use in program
4. Extend class → inheritance and reuse
5. Use getter/setter → control data flow
6. Use abstract class → define blueprint

🧭 *Diagram (conceptual)*

```
Interface / Type → Class → Object → Inheritance → super() → Getter/Setter → Abstract Base
```

---

## ⚡ 11. Summary

| Concept           | Purpose                     | Example                           |         |
| ----------------- | --------------------------- | --------------------------------- | ------- |
| **Interface**     | Define structure            | `interface User { name: string }` |         |
| **Type Alias**    | Create reusable types       | `type ID = number                 | string` |
| **Class**         | Blueprint for objects       | `class Car {}`                    |         |
| **Object**        | Instance of class           | `new Car()`                       |         |
| **super()**       | Call parent constructor     | `super(name)`                     |         |
| **Getter/Setter** | Encapsulation               | `get salary()`                    |         |
| **Abstract**      | Base with mandatory methods | `abstract class Shape`            |         |

---