---
title:
  "{ Title }":
tags:
  - theory
  - "{ Subject }":
  - semester_notes
created:
  "{ date }":
updated:
  "{ date }":
---
# TypeScript Objects Complete Guide

**From Basics to Advanced Object Typing**

---

## Table of Contents

1. [What is an Object](#what-is-an-object)
2. [Object Type Declaration](#object-type-declaration)
3. [Property Inference](#property-inference)
4. [Duck Typing (Structural Typing)](#duck-typing-structural-typing)
5. [Optional & Readonly Properties](#optional--readonly-properties)
6. [Utility Types](#utility-types)
7. [Array of Objects](#array-of-objects)
8. [Why Everything is an Object](#why-everything-is-an-object)
9. [Cheat Sheet](#cheat-sheet)

---

## What is an Object

### Object Basics

```
┌─────────────────────────────────────────────────┐
│           OBJECT STRUCTURE                      │
├─────────────────────────────────────────────────┤
│                                                 │
│  Object = Collection of key-value pairs         │
│                                                 │
│  {                                              │
│    key1: value1,    ← Property                  │
│    key2: value2,    ← Property                  │
│    key3: value3     ← Property                  │
│  }                                              │
│                                                 │
│  Key (Property name) : Value (Any type)         │
│                                                 │
└─────────────────────────────────────────────────┘
```

### Simple Object

```typescript
// JavaScript object
const person = {
    name: "mukul",
    age: 21,
    isStudent: true
};

// Access properties
console.log(person.name);      // mukul
console.log(person["age"]);    // 21
```

### Memory Representation

```
Stack (Reference)          Heap (Actual Data)
─────────────────          ──────────────────
person: 0x1234    ───────> {
                             name: "mukul",
                             age: 21,
                             isStudent: true
                           }

Objects stored in heap memory
Variables hold reference (address)
```

---

## Object Type Declaration

### Inline Type Annotation

```typescript
// Your tea example
let tea: {
    name: string;
    ishot: true;        // Literal type
    price: number;
};

tea = {
    name: 'mukul',
    ishot: true,
    price: 25
};

console.log(tea);
```

**Structure:**

```
let variableName: {
    property1: type1;
    property2: type2;
} = { ... };
        ↑
        └── Object type definition
```

### Type Alias (Reusable)

```typescript
// Define once, use many times
type Tea = {
    name: string;
    ishot: boolean;
    price: number;
};

let masalaTea: Tea = {
    name: 'masala',
    ishot: true,
    price: 30
};

let icedTea: Tea = {
    name: 'iced',
    ishot: false,
    price: 25
};
```

### Interface (Alternative)

```typescript
// Similar to type
interface User {
    name: string;
    age: number;
    email: string;
}

const user: User = {
    name: 'mukul',
    age: 21,
    email: 'mukul@example.com'
};
```

### Type vs Interface for Objects

```
┌─────────────────────────────────────────────────┐
│       TYPE vs INTERFACE                         │
├─────────────────────────────────────────────────┤
│                                                 │
│  TYPE                  INTERFACE                │
│  ────────────────      ─────────────────        │
│  type User = {}        interface User {}        │
│  Use = sign            No = sign                │
│  Can be union          Cannot be union          │
│  Cannot extend         Can extend               │
│                                                 │
│  For objects: Both work the same                │
│  Recommendation: Use TYPE by default            │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

## Property Inference

### Automatic Type Inference

```typescript
// TypeScript infers type from value
const user = {
    name: 'mukul',    // Inferred: string
    age: 21,          // Inferred: number
    active: true      // Inferred: boolean
};

// Hover over 'user' in IDE:
// const user: {
//     name: string;
//     age: number;
//     active: boolean;
// }
```

### Inference Flow

```
Declaration                    Inference
───────────                    ─────────
const obj = {
    x: 5           ──────────> x: number
    y: 'hello'     ──────────> y: string
    z: true        ──────────> z: boolean
}

TypeScript analyzes values and assigns types
```

### When Inference Works

```typescript
// Good inference
const point = { x: 10, y: 20 };
// Type: { x: number; y: number }

// Good inference
const config = {
    debug: true,
    port: 3000,
    host: 'localhost'
};
// Type: { debug: boolean; port: number; host: string }

// No inference (needs annotation)
let data;  // Type: any
data = { name: 'mukul' };
```

### Explicit vs Inferred

```typescript
// Inferred (simple)
const product = {
    name: 'Laptop',
    price: 50000
};

// Explicit (complex or reusable)
type Product = {
    name: string;
    price: number;
    category?: string;
};

const product2: Product = {
    name: 'Laptop',
    price: 50000
};
```

---

## Duck Typing (Structural Typing)

### Concept

```
┌─────────────────────────────────────────────────┐
│         DUCK TYPING                             │
├─────────────────────────────────────────────────┤
│                                                 │
│  "If it walks like a duck and quacks like      │
│   a duck, it's a duck"                          │
│                                                 │
│  TypeScript cares about STRUCTURE, not NAME     │
│                                                 │
│  Type checking:                                 │
│  Does object have required properties?          │
│  ✓ Yes → Compatible                             │
│  ✗ No  → Error                                  │
│                                                 │
└─────────────────────────────────────────────────┘
```

### Your Cup Example Explained

```typescript
type Cup = {
    size: string;
};

let smallcup: Cup = {
    size: '5ml'
};

// Has MORE properties than Cup
let largecup = {
    size: '10ml',
    ishot: true
};

// This works! (Duck typing)
smallcup = largecup;
console.log(smallcup);  // { size: '10ml', ishot: true }
```

**Why it works:**

```
Required by Cup:       Has in largecup:
────────────────       ────────────────
size: string      ✓    size: string  ✓
                       ishot: boolean (extra, OK)

largecup HAS AT LEAST what Cup needs
Therefore: Compatible
```

### Structural Compatibility

```typescript
type Person = {
    name: string;
};

type Employee = {
    name: string;
    id: number;
};

let person: Person = { name: 'mukul' };
let employee: Employee = { name: 'mukul', id: 123 };

// This works (employee has 'name')
person = employee;  // ✓

// This fails (person doesn't have 'id')
// employee = person;  // ✗ Error
```

**Rule:**

```
Source (right side) must have AT LEAST
all properties of Target (left side)

Target = Source  ✓  if Source >= Target
Target = Source  ✗  if Source < Target
```

### Look-Alike Code Pattern

```typescript
// Define minimal interface
type Printable = {
    toString(): string;
};

// Different objects with same structure
const book = {
    title: 'TS Guide',
    toString() { return this.title; }
};

const product = {
    name: 'Laptop',
    price: 50000,
    toString() { return this.name; }
};

// Both work as Printable
function print(item: Printable) {
    console.log(item.toString());
}

print(book);     // TS Guide
print(product);  // Laptop
```

---

## Optional & Readonly Properties

### Optional Properties (?)

```typescript
type Chai = {
    name: string;
    ishot?: boolean;    // Optional
    price: number;
};

// Valid: ishot not provided
const chai1: Chai = {
    name: 'masala',
    price: 30
};

// Also valid: ishot provided
const chai2: Chai = {
    name: 'ginger',
    ishot: true,
    price: 25
};
```

**Syntax:**

```
property?: type

Means: property can be present OR undefined
```

### Readonly Properties

```typescript
type Chai = {
    name: string;
    readonly price: "23";  // Literal + readonly
};

const masala: Chai = {
    name: 'masala',
    price: "23"
};

// Error: Cannot modify readonly
// masala.price = "30";

// Can modify non-readonly
masala.name = 'sweet';  // ✓
```

**Readonly behavior:**

```
┌─────────────────────────────────────────────────┐
│         READONLY PROPERTY                       │
├─────────────────────────────────────────────────┤
│                                                 │
│  Declaration:  Can set value                    │
│  const obj = { readonly x: 10 };  ✓             │
│                                                 │
│  After creation:  Cannot modify                 │
│  obj.x = 20;  ✗  Error                          │
│                                                 │
│  TypeScript enforces at compile time only       │
│  JavaScript has no readonly at runtime          │
│                                                 │
└─────────────────────────────────────────────────┘
```

### Combining Optional & Readonly

```typescript
type Config = {
    readonly apiKey: string;     // Required + immutable
    port?: number;               // Optional + mutable
    readonly debug?: boolean;    // Optional + immutable
};

const config: Config = {
    apiKey: 'abc123',
    debug: true
};

// config.apiKey = 'xyz';  // Error: readonly
config.port = 3000;        // OK: optional but mutable
// config.debug = false;   // Error: readonly
```

---

## Utility Types

### Partial (All Optional)

```typescript
type Chai = {
    name: string;
    ishot: boolean;
    price: number;
};

// Partial makes ALL properties optional
type PartialChai = Partial<Chai>;
// Equivalent to:
// type PartialChai = {
//     name?: string;
//     ishot?: boolean;
//     price?: number;
// }

// Your function example
const updateChai = (value: Partial<Chai>) => {
    console.log(value);
    return value.name;
};

// Can pass any combination
updateChai({ name: "masala" });              // ✓
updateChai({ ishot: true });                 // ✓
updateChai({ name: "ginger", price: 25 });   // ✓
updateChai({});                              // ✓
```

**Use case:**

```
Update functions where you don't need all properties
Partial updates to existing objects
Configuration overrides
```

### Required (All Required)

```typescript
type Chai = {
    name: string;
    ishot?: boolean;      // Optional
    price?: number;       // Optional
};

// Required removes all optional modifiers
type RequiredChai = Required<Chai>;
// Equivalent to:
// type RequiredChai = {
//     name: string;
//     ishot: boolean;
//     price: number;
// }

const fullChai: RequiredChai = {
    name: 'masala',
    ishot: true,
    price: 30
    // All properties must be present
};
```

### Pick (Select Properties)

```typescript
type Chai = {
    name: string;
    ishot: boolean;
    price: number;
    rating: number;
};

// Pick only specific properties
type ChaiSummary = Pick<Chai, 'name' | 'price'>;
// Equivalent to:
// type ChaiSummary = {
//     name: string;
//     price: number;
// }

const summary: ChaiSummary = {
    name: 'masala',
    price: 30
    // Only these two needed
};
```

### Omit (Exclude Properties)

```typescript
type Chai = {
    name: string;
    ishot: boolean;
    price: number;
    internalId: number;
};

// Omit specific properties
type PublicChai = Omit<Chai, 'internalId'>;
// Equivalent to:
// type PublicChai = {
//     name: string;
//     ishot: boolean;
//     price: number;
// }

const publicData: PublicChai = {
    name: 'masala',
    ishot: true,
    price: 30
    // internalId not included
};
```

### Utility Types Comparison

```
┌─────────────────────────────────────────────────┐
│       UTILITY TYPE QUICK REFERENCE              │
├─────────────────────────────────────────────────┤
│                                                 │
│  Partial<T>                                     │
│  └─ All properties optional                     │
│  Use: Update functions                          │
│                                                 │
│  Required<T>                                    │
│  └─ All properties required                     │
│  Use: Strict validation                         │
│                                                 │
│  Pick<T, Keys>                                  │
│  └─ Select specific properties                  │
│  Use: Create subset type                        │
│                                                 │
│  Omit<T, Keys>                                  │
│  └─ Exclude specific properties                 │
│  Use: Remove sensitive data                     │
│                                                 │
│  Readonly<T>                                    │
│  └─ All properties readonly                     │
│  Use: Immutable objects                         │
│                                                 │
│  Record<K, V>                                   │
│  └─ Object with specific key-value types        │
│  Use: Dictionaries, maps                        │
│                                                 │
└─────────────────────────────────────────────────┘
```

### Practical Examples

```typescript
type User = {
    id: number;
    name: string;
    email: string;
    password: string;
    createdAt: Date;
};

// Update user (not all fields)
function updateUser(id: number, updates: Partial<User>) {
    // Can update any subset of properties
}
updateUser(1, { name: 'New Name' });

// Public user (no password)
type PublicUser = Omit<User, 'password'>;
function getPublicProfile(id: number): PublicUser {
    // Return user without password
}

// User summary (only name and email)
type UserSummary = Pick<User, 'name' | 'email'>;
function listUsers(): UserSummary[] {
    // Return minimal user data
}

// Readonly user (cannot modify)
type ImmutableUser = Readonly<User>;
function freezeUser(user: User): ImmutableUser {
    return user;
}
```

---

## Array of Objects

### Basic Array of Objects

```typescript
// Type for single object
type Tea = {
    name: string;
    price: number;
};

// Array of objects (Method 1)
const teas: Tea[] = [
    { name: 'masala', price: 30 },
    { name: 'ginger', price: 25 },
    { name: 'green', price: 20 }
];

// Array of objects (Method 2)
const teas2: Array<Tea> = [
    { name: 'masala', price: 30 }
];
```

### Inline Type in Array

```typescript
// Define type inline
const users: { name: string; age: number }[] = [
    { name: 'mukul', age: 21 },
    { name: 'ravi', age: 25 }
];
```

### Operations on Object Arrays

```typescript
type Product = {
    id: number;
    name: string;
    price: number;
};

const products: Product[] = [
    { id: 1, name: 'Laptop', price: 50000 },
    { id: 2, name: 'Phone', price: 30000 },
    { id: 3, name: 'Tablet', price: 20000 }
];

// Map
const names = products.map(p => p.name);
// string[]

// Filter
const expensive = products.filter(p => p.price > 25000);
// Product[]

// Find
const laptop = products.find(p => p.id === 1);
// Product | undefined

// Reduce
const total = products.reduce((sum, p) => sum + p.price, 0);
// number
```

### Nested Objects in Array

```typescript
type Order = {
    id: number;
    user: {
        name: string;
        email: string;
    };
    items: {
        name: string;
        quantity: number;
    }[];
};

const orders: Order[] = [
    {
        id: 1,
        user: {
            name: 'mukul',
            email: 'mukul@example.com'
        },
        items: [
            { name: 'Laptop', quantity: 1 },
            { name: 'Mouse', quantity: 2 }
        ]
    }
];

// Access nested properties
console.log(orders[0].user.name);
console.log(orders[0].items[0].quantity);
```

---

## Why Everything is an Object

### Object Hierarchy

```
┌─────────────────────────────────────────────────┐
│       OBJECT-ORIENTED HIERARCHY                 │
├─────────────────────────────────────────────────┤
│                                                 │
│                  Object                         │
│                    │                            │
│        ┌───────────┼───────────┐                │
│        │           │           │                │
│     Function    Array       Date               │
│        │           │           │                │
│    User-defined  [1,2,3]    new Date()         │
│    functions                                    │
│                                                 │
│  Everything inherits from Object.prototype      │
│                                                 │
└─────────────────────────────────────────────────┘
```

### What Makes Everything an Object

**In JavaScript (and by extension TypeScript):**

```typescript
// Numbers have methods (boxed to object)
const num = 42;
num.toString();        // "42"
num.toFixed(2);        // "42.00"

// Strings have methods (boxed to object)
const str = "hello";
str.toUpperCase();     // "HELLO"
str.length;            // 5

// Arrays are objects
const arr = [1, 2, 3];
arr.push(4);
arr.length;

// Functions are objects
function greet() {}
greet.name;            // "greet"
greet.prototype;       // {}

// Even primitive wrappers
typeof new Number(5);  // "object"
typeof new String("x"); // "object"
```

### Internal Object Structure

```
JavaScript Engine Memory Layout
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Object in memory:
┌──────────────────────────┐
│ Object Header            │
│ ├─ Type info            │
│ ├─ Memory layout        │
│ └─ GC metadata          │
├──────────────────────────┤
│ Properties (Hash Map)    │
│ ├─ name → "mukul"       │
│ ├─ age → 21             │
│ └─ active → true        │
├──────────────────────────┤
│ [[Prototype]] pointer    │
│ └─> Object.prototype    │
└──────────────────────────┘

Each property access = hash table lookup
Fast O(1) access time
```

### Object Without Class

```typescript
// TypeScript: Define structure without class
type User = {
    name: string;
    age: number;
    greet(): string;
};

// Create object matching type
const user: User = {
    name: 'mukul',
    age: 21,
    greet() {
        return `Hello, ${this.name}`;
    }
};

// No class needed!
console.log(user.greet());
```

**Why this works:**

```
┌─────────────────────────────────────────────────┐
│    CLASS vs TYPE for Objects                    │
├─────────────────────────────────────────────────┤
│                                                 │
│  CLASS (Runtime)                                │
│  ────────────────                               │
│  - Creates blueprint                            │
│  - Can instantiate with 'new'                   │
│  - Has constructor                              │
│  - Runtime overhead                             │
│                                                 │
│  TYPE (Compile-time only)                       │
│  ──────────────────────                         │
│  - Describes shape                              │
│  - No 'new' keyword                             │
│  - No constructor                               │
│  - Zero runtime overhead                        │
│  - Erased after compilation                     │
│                                                 │
│  TypeScript favors TYPES for objects            │
│  More flexible, no runtime cost                 │
│                                                 │
└─────────────────────────────────────────────────┘
```

### Class vs Type Example

```typescript
// With class (runtime construct)
class UserClass {
    constructor(public name: string, public age: number) {}
    
    greet() {
        return `Hello, ${this.name}`;
    }
}

const user1 = new UserClass('mukul', 21);

// With type (compile-time only)
type UserType = {
    name: string;
    age: number;
    greet(): string;
};

const user2: UserType = {
    name: 'mukul',
    age: 21,
    greet() {
        return `Hello, ${this.name}`;
    }
};

// Both work the same functionally
// But UserType has no runtime overhead
```

**Compilation result:**

```javascript
// UserClass compiles to:
class UserClass {
    constructor(name, age) {
        this.name = name;
        this.age = age;
    }
    greet() {
        return `Hello, ${this.name}`;
    }
}

// UserType compiles to:
// NOTHING (types erased)
// Only the object literal remains:
const user2 = {
    name: 'mukul',
    age: 21,
    greet() {
        return `Hello, ${this.name}`;
    }
};
```

---

## Cheat Sheet

### Object Type Syntax

```typescript
// Inline type
let obj: { name: string; age: number } = { name: 'x', age: 1 };

// Type alias
type User = { name: string; age: number };
let user: User = { name: 'x', age: 1 };

// Interface
interface User { name: string; age: number }
let user: User = { name: 'x', age: 1 };

// Optional property
type User = { name: string; age?: number };

// Readonly property
type User = { readonly id: number; name: string };

// Method in object
type User = { name: string; greet(): string };
type User = { name: string; greet: () => string };
```

### Array of Objects

```typescript
// Method 1
type Item = { id: number; name: string };
const items: Item[] = [{ id: 1, name: 'x' }];

// Method 2
const items: Array<Item> = [{ id: 1, name: 'x' }];

// Inline
const items: { id: number; name: string }[] = [];
```

### Utility Types Quick Reference

```typescript
type User = { name: string; age: number; email: string };

// All optional
Partial<User>
// { name?: string; age?: number; email?: string }

// All required
Required<Partial<User>>
// { name: string; age: number; email: string }

// Pick specific
Pick<User, 'name' | 'email'>
// { name: string; email: string }

// Omit specific
Omit<User, 'email'>
// { name: string; age: number }

// All readonly
Readonly<User>
// { readonly name: string; readonly age: number; readonly email: string }
```

### Common Patterns

```typescript
// Object as dictionary
type Dictionary = { [key: string]: number };
const scores: Dictionary = { math: 90, english: 85 };

// Record utility
type Scores = Record<string, number>;
const scores: Scores = { math: 90, english: 85 };

// Index signature with specific keys
type Config = {
    apiKey: string;
    [key: string]: string | number;
};

// Nested objects
type User = {
    profile: {
        name: string;
        avatar: string;
    };
    settings: {
        theme: 'light' | 'dark';
        notifications: boolean;
    };
};
```

---

## Summary

**Key Concepts:**

1. **Objects are key-value collections**
   - Properties can be any type
   - Access with dot or bracket notation

2. **Type declarations**
   - Inline: `let x: { prop: type }`
   - Type alias: `type Name = { prop: type }`
   - Interface: `interface Name { prop: type }`

3. **Duck typing (Structural typing)**
   - Structure matters, not name
   - Extra properties allowed
   - Must have required properties

4. **Optional (`?`) and Readonly**
   - Optional: Can be missing
   - Readonly: Cannot be modified after creation

5. **Utility types**
   - Partial: All optional
   - Required: All required
   - Pick: Select properties
   - Omit: Exclude properties

6. **Arrays of objects**
   - `Type[]` or `Array<Type>`
   - Full type safety on operations

7. **Why objects**
   - Everything inherits from Object
   - Primitive boxing (methods on primitives)
   - Hash map internally

8. **Type vs Class**
   - Type: Compile-time, zero cost
   - Class: Runtime, has overhead
   - Types preferred for shapes