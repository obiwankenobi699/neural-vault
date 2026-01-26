---
title: 03_Functions and Safety
tags:
  - Typescript
  - Basics_of_Ts
created: 2025-11-02
updated: 2025-11-02
---
## Table of Contents

1. [Types vs Interfaces](https://claude.ai/chat/607261bc-c435-4531-ba14-e695a595220c#types-vs-interfaces)
2. [Type Annotation vs Inference](https://claude.ai/chat/607261bc-c435-4531-ba14-e695a595220c#type-annotation-vs-inference)
3. [Type Narrowing](https://claude.ai/chat/607261bc-c435-4531-ba14-e695a595220c#type-narrowing)
4. [Type Guards](https://claude.ai/chat/607261bc-c435-4531-ba14-e695a595220c#type-guards)
5. [Type Assertions](https://claude.ai/chat/607261bc-c435-4531-ba14-e695a595220c#type-assertions)
6. [Union Types](https://claude.ai/chat/607261bc-c435-4531-ba14-e695a595220c#union-types)
7. [any vs unknown](https://claude.ai/chat/607261bc-c435-4531-ba14-e695a595220c#any-vs-unknown)
8. [Discriminated Unions](https://claude.ai/chat/607261bc-c435-4531-ba14-e695a595220c#discriminated-unions)
9. [React Type Patterns](https://claude.ai/chat/607261bc-c435-4531-ba14-e695a595220c#react-type-patterns)
10. [Cheat Sheet](https://claude.ai/chat/607261bc-c435-4531-ba14-e695a595220c#cheat-sheet)

---

## Types vs Interfaces

### Quick Comparison

```
┌─────────────────────────────────────────────────────┐
│           TYPE vs INTERFACE                         │
├─────────────────────────────────────────────────────┤
│                                                     │
│  TYPE                   INTERFACE                   │
│  ────                   ─────────                   │
│  type Name = {}         interface Name {}           │
│  Can use unions         Cannot use unions           │
│  Can be primitives      Must be objects             │
│  Cannot be extended     Can be extended             │
│  Use = syntax           No = needed                 │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Type Examples

```typescript
// Primitive
type ID = string | number;

// Object
type User = {
    name: string;
    age: number;
};

// Union
type Status = 'active' | 'inactive' | 'pending';

// Intersection
type Admin = User & { role: 'admin' };

// Function
type Handler = (event: Event) => void;

// Tuple
type Point = [number, number];
```

### Interface Examples

```typescript
// Basic
interface User {
    name: string;
    age: number;
}

// Extending
interface Admin extends User {
    role: 'admin';
}

// Multiple inheritance
interface SuperAdmin extends User, Admin {
    permissions: string[];
}

// Function signature
interface Handler {
    (event: Event): void;
}

// Merging (declaration merging)
interface Window {
    customProp: string;
}
interface Window {
    anotherProp: number;
}
// Both merge into one Window interface
```

### When to Use

```
Use TYPE when:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- Need unions: string | number
- Need primitives: type ID = string
- Need tuple: type Point = [number, number]
- Need mapped types
- Need conditional types

Use INTERFACE when:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- Defining object shapes
- Need declaration merging
- Extending classes
- Public API (better error messages)

Recommendation: Use TYPE by default, INTERFACE for OOP
```

---

## Type Annotation vs Inference

### Visual Difference

```
┌─────────────────────────────────────────────────────┐
│      ANNOTATION vs INFERENCE                        │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Annotation (Explicit)                              │
│  ─────────────────────                              │
│  let naam: string = 'mukul';                        │
│           └──┬──┘                                   │
│              └── You tell TypeScript the type       │
│                                                     │
│  Inference (Automatic)                              │
│  ─────────────────────                              │
│  let naam = 'mukul';                                │
│             └──┬──┘                                 │
│                └── TypeScript figures out type      │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Examples from Your Code

```typescript
// Inference (TypeScript guesses)
let naam = 'mukul';       // Inferred as: string
let nam = 1234;           // Inferred as: number
let nm = 'mukul123';      // Inferred as: string

// Annotation (You specify)
let naaam: string = 'mukul';
let age: number = 21;
let active: boolean = true;

// Complex type annotation
type Name = {
    naam: string;
    nam: any;
    nm: string | number;
};

let person: Name = {
    naam: 'mukul',
    nam: 123,
    nm: 'mukul123'
};
```

### When to Annotate

```
ALWAYS ANNOTATE:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- Function parameters
- Function return types
- When inference is wrong
- When type is complex

LET INFERENCE WORK:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- Simple variable assignments
- Constants
- When type is obvious
```

```typescript
// Good: Annotation for functions
function greet(name: string): string {
    return `Hello ${name}`;
}

// Good: Inference for simple values
const count = 5;  // number
const message = 'hello';  // string

// Bad: Unnecessary annotation
const count: number = 5;  // Redundant

// Good: Annotation for unclear types
const data: User[] = [];  // Empty array needs type
```

---

## Type Narrowing

### What is Type Narrowing

```
┌─────────────────────────────────────────────────────┐
│           TYPE NARROWING                            │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Start: Wide type                                   │
│  string | number                                    │
│        │                                            │
│        ↓  Check with typeof/instanceof/etc          │
│        │                                            │
│  End: Narrow type                                   │
│  string  OR  number                                 │
│                                                     │
│  TypeScript knows which branch = which type         │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### typeof Narrowing

```typescript
function print(value: string | number) {
    if (typeof value === 'string') {
        // TypeScript knows: value is string here
        console.log(value.toUpperCase());
    } else {
        // TypeScript knows: value is number here
        console.log(value.toFixed(2));
    }
}
```

### Your Dispatch Example

```typescript
function dispatch(
    item: string,
    size: 'large' | 'medium' | 'small',
    msg?: string
) {
    // Narrowing: typeof + literal check
    if (typeof item === 'string' && size === 'large') {
        console.log(`${item}, ${size} is given`);
    }
    
    if (typeof item === 'string' && size === 'small') {
        console.log('small poor guy');
    } else {
        console.log(msg);
    }
}

dispatch('chai', 'medium', "Please accept im poor");
```

### Truthiness Narrowing

```typescript
function greet(name?: string) {
    if (name) {
        // name is string here (truthy check removes undefined)
        console.log(name.toUpperCase());
    } else {
        // name is undefined here
        console.log('No name');
    }
}
```

---

## Type Guards

### Built-in Type Guards

```
┌─────────────────────────────────────────────────────┐
│         BUILT-IN TYPE GUARDS                        │
├─────────────────────────────────────────────────────┤
│                                                     │
│  typeof     - Primitive types                       │
│  instanceof - Class instances                       │
│  in         - Property existence                    │
│  Array.isArray() - Array check                      │
│                                                     │
└─────────────────────────────────────────────────────┘
```

**typeof:**

```typescript
function process(value: string | number) {
    if (typeof value === 'string') {
        return value.trim();
    }
    return value * 2;
}
```

**instanceof:**

```typescript
function handle(error: Error | string) {
    if (error instanceof Error) {
        console.log(error.message);
    } else {
        console.log(error);
    }
}
```

**in operator:**

```typescript
type Fish = { swim: () => void };
type Bird = { fly: () => void };

function move(animal: Fish | Bird) {
    if ('swim' in animal) {
        animal.swim();
    } else {
        animal.fly();
    }
}
```

### Custom Type Guards

```typescript
// User-defined type guard
function isString(value: unknown): value is string {
    return typeof value === 'string';
}

function process(value: unknown) {
    if (isString(value)) {
        // TypeScript knows value is string
        console.log(value.toUpperCase());
    }
}
```

**Pattern:**

```
function isType(value: unknown): value is TargetType {
    return /* check logic */;
}
         ↑                       ↑
         └── Type predicate      └── Return boolean
```

### Advanced Type Guards

```typescript
// Array type guard
function isStringArray(value: unknown): value is string[] {
    return Array.isArray(value) && value.every(item => typeof item === 'string');
}

// Object type guard
type User = { name: string; age: number };

function isUser(value: unknown): value is User {
    return (
        typeof value === 'object' &&
        value !== null &&
        'name' in value &&
        'age' in value &&
        typeof (value as User).name === 'string' &&
        typeof (value as User).age === 'number'
    );
}

// Usage
const data: unknown = JSON.parse('{"name":"mukul","age":21}');

if (isUser(data)) {
    // data is User here
    console.log(data.name.toUpperCase());
}
```

---

## Type Assertions

### What are Assertions

```
┌─────────────────────────────────────────────────────┐
│         TYPE ASSERTION                              │
├─────────────────────────────────────────────────────┤
│                                                     │
│  "Trust me, I know the type better than you"        │
│                                                     │
│  TypeScript: value is unknown                       │
│  You:        value as string                        │
│  TypeScript: OK, I'll trust you                     │
│                                                     │
│  WARNING: No runtime checking!                      │
│  You can lie, and code will break                   │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Syntax

```typescript
// Method 1: as keyword (preferred)
let value: unknown = 'hello';
let length = (value as string).length;

// Method 2: angle brackets (avoid in React)
let length2 = (<string>value).length;
```

### Your Examples

```typescript
// String assertion
let value: string = '34';
let lengthofvalue: number = (value as string).length;
console.log(typeof lengthofvalue);  // number

// JSON parsing assertion
type Info = {
    type: string;
};

let str = '{"name":"im Mukul","age":"21"}';
let json = JSON.parse(str) as Info;
console.log(json);
```

### DOM Assertions

```typescript
// DOM element assertions
const button = document.querySelector('button') as HTMLButtonElement;
button.disabled = true;

const input = document.getElementById('name') as HTMLInputElement;
input.value = 'mukul';

const div = document.querySelector('.container') as HTMLDivElement;
div.style.backgroundColor = 'red';
```

### Function Assertions

```typescript
// Return type assertion
function getData(): unknown {
    return { name: 'mukul', age: 21 };
}

type User = { name: string; age: number };
const user = getData() as User;
console.log(user.name);

// Parameter assertion
function process(value: any) {
    const str = value as string;
    return str.toUpperCase();
}
```

### Non-null Assertion

```typescript
// Non-null assertion operator (!)
function greet(name: string | null) {
    // TypeScript thinks name might be null
    console.log(name!.toUpperCase());
    //              ↑ Tells TS: "name is NOT null, trust me"
}

// DOM example
const button = document.querySelector('button')!;
button.click();  // No null check needed
```

### When to Avoid Assertions

```
AVOID:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- When you're not sure of the type
- When data comes from external source
- When you can use type guards instead

USE INSTEAD:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- Type guards
- Runtime validation (Zod, Yup)
- Optional chaining (?.)
```

```typescript
// Bad: Assertion
const data = getData() as User;
data.name.toUpperCase();  // Crashes if getData returns null

// Good: Type guard
const data = getData();
if (isUser(data)) {
    data.name.toUpperCase();  // Safe
}

// Good: Optional chaining
const data = getData();
data?.name?.toUpperCase();  // Safe
```

---

## Union Types

### Basic Unions

```typescript
// Simple union
let id: string | number;
id = 'abc123';  // OK
id = 123;       // OK
// id = true;   // Error

// Literal union
type Size = 'small' | 'medium' | 'large';
let size: Size = 'medium';

// Union with null/undefined
type Name = string | null | undefined;
let name: Name;
name = 'mukul';
name = null;
name = undefined;
```

### Working with Unions

```typescript
function process(value: string | number) {
    // Error: Property 'toUpperCase' does not exist on type 'number'
    // console.log(value.toUpperCase());
    
    // Must narrow first
    if (typeof value === 'string') {
        console.log(value.toUpperCase());
    } else {
        console.log(value * 2);
    }
}
```

### Union Arrays

```typescript
// Array of mixed types
let mixed: (string | number)[] = [1, 'two', 3, 'four'];

// Array OR string
let value: string[] | string;
value = 'hello';
value = ['hello', 'world'];
```

---

## any vs unknown

### Comparison

```
┌─────────────────────────────────────────────────────┐
│           any vs unknown                            │
├─────────────────────────────────────────────────────┤
│                                                     │
│  any                    unknown                     │
│  ───                    ───────                     │
│  Opt-out of types       Type-safe any              │
│  No checking            Requires checking           │
│  Dangerous              Safe                        │
│  Quick & dirty          Best practice               │
│                                                     │
│  let x: any;            let x: unknown;             │
│  x.anything();          // x.anything();  ERROR     │
│  x.foo.bar;             if (typeof x === 'string')  │
│  x[100];                    x.toUpperCase();        │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### any - The Escape Hatch

```typescript
let value: any = 'hello';

// Can do ANYTHING (no type checking)
value.toUpperCase();
value.nonExistent();
value();
value[100];

// Can assign to anything
let str: string = value;
let num: number = value;

// TypeScript gives up
```

### unknown - Type-safe any

```typescript
let value: unknown = 'hello';

// Cannot use directly
// value.toUpperCase();  // Error

// Must narrow first
if (typeof value === 'string') {
    value.toUpperCase();  // OK
}

// Or assert
(value as string).toUpperCase();

// Cannot assign directly
// let str: string = value;  // Error

// Must narrow or assert
let str: string = value as string;
```

### Your Example

```typescript
let chai: unknown = 'chai';

// Must check before use
if (typeof chai === 'string') {
    console.log(chai.toUpperCase());  // CHAI
}

// Or assert (risky)
console.log((chai as string).toUpperCase());
```

### Decision Matrix

```
Use UNKNOWN when:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- External data (API, user input)
- JSON.parse() results
- Third-party library data
- Type is truly unknown

Use ANY when:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- Migrating JavaScript to TypeScript
- Prototyping (temporarily)
- Absolutely impossible to type
- Never use in production code
```

---

## Discriminated Unions

### Your Chai Example Explained

```typescript
type Masala = {
    type: 'masala';           // Discriminant (literal type)
    madeby: 'ravi' | 'vivaan';
};

type Sweet = {
    type: 'sweet';            // Discriminant (literal type)
    madeby: 'mukul' | 'kuki';
};

type Chai = Masala | Sweet;   // Union of types
```

**Structure:**

```
┌─────────────────────────────────────────────────────┐
│      DISCRIMINATED UNION PATTERN                    │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Common property (discriminant)                     │
│  with literal types                                 │
│         │                                           │
│         ↓                                           │
│  type: 'masala' | 'sweet'                           │
│         │                                           │
│         └── TypeScript uses this to narrow          │
│                                                     │
│  Benefits:                                          │
│  - Exhaustive checking                              │
│  - Type narrowing                                   │
│  - Safer than plain unions                          │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Working with Discriminated Unions

```typescript
function brew(order: Chai) {
    switch (order.type) {     // TypeScript narrows based on type
        case 'masala':
            // order is Masala here
            console.log(order.madeby);  // 'ravi' | 'vivaan'
            break;
        case 'sweet':
            // order is Sweet here
            console.log(order.madeby);  // 'mukul' | 'kuki'
            break;
        default:
            // Exhaustive check
            const _exhaustive: never = order;
            return _exhaustive;
    }
}
```

### Exhaustive Checking

```typescript
// If you add a new type but forget to handle it
type Masala = { type: 'masala'; madeby: string };
type Sweet = { type: 'sweet'; madeby: string };
type Kadak = { type: 'kadak'; madeby: string };  // New type

type Chai = Masala | Sweet | Kadak;

function brew(order: Chai) {
    switch (order.type) {
        case 'masala':
            console.log('masala');
            break;
        case 'sweet':
            console.log('sweet');
            break;
        // Forgot 'kadak' case
        default:
            const _exhaustive: never = order;  // ERROR: Type 'Kadak' not assignable to 'never'
            return _exhaustive;
    }
}
```

### Common Patterns

```typescript
// API Response
type Success = { status: 'success'; data: any };
type Error = { status: 'error'; message: string };
type Loading = { status: 'loading' };

type ApiState = Success | Error | Loading;

function handle(state: ApiState) {
    switch (state.status) {
        case 'success':
            console.log(state.data);
            break;
        case 'error':
            console.log(state.message);
            break;
        case 'loading':
            console.log('Loading...');
            break;
    }
}

// Redux Action
type AddTodo = { type: 'ADD_TODO'; payload: string };
type RemoveTodo = { type: 'REMOVE_TODO'; payload: number };
type ToggleTodo = { type: 'TOGGLE_TODO'; payload: number };

type Action = AddTodo | RemoveTodo | ToggleTodo;

function reducer(state: any, action: Action) {
    switch (action.type) {
        case 'ADD_TODO':
            return { ...state, todos: [...state.todos, action.payload] };
        case 'REMOVE_TODO':
            return { ...state, todos: state.todos.filter((_, i) => i !== action.payload) };
        case 'TOGGLE_TODO':
            return { ...state, todos: state.todos.map((t, i) => i === action.payload ? { ...t, done: !t.done } : t) };
    }
}
```

---

## React Type Patterns

### Component Props

```typescript
// Props type
type ButtonProps = {
    text: string;
    onClick: () => void;
    disabled?: boolean;
    variant?: 'primary' | 'secondary';
};

function Button({ text, onClick, disabled, variant = 'primary' }: ButtonProps) {
    return (
        <button onClick={onClick} disabled={disabled}>
            {text}
        </button>
    );
}
```

### React Hooks with Types

```typescript
import { useState } from 'react';

// State with type inference
const [count, setCount] = useState(0);  // number

// State with explicit type
type User = { name: string; age: number };
const [user, setUser] = useState<User | null>(null);

// Array state
const [items, setItems] = useState<string[]>([]);
```

### useReducer with Discriminated Unions

```typescript
import { useReducer } from 'react';

// State type
type State = {
    count: number;
    error: string | null;
};

// Actions (discriminated union)
type Action =
    | { type: 'INCREMENT' }
    | { type: 'DECREMENT' }
    | { type: 'RESET' }
    | { type: 'SET_ERROR'; payload: string };

// Reducer with type narrowing
function reducer(state: State, action: Action): State {
    switch (action.type) {
        case 'INCREMENT':
            return { ...state, count: state.count + 1 };
        case 'DECREMENT':
            return { ...state, count: state.count - 1 };
        case 'RESET':
            return { ...state, count: 0 };
        case 'SET_ERROR':
            return { ...state, error: action.payload };  // payload available
        default:
            const _exhaustive: never = action;
            return state;
    }
}

// Usage
function Counter() {
    const [state, dispatch] = useReducer(reducer, { count: 0, error: null });

    return (
        <div>
            <p>{state.count}</p>
            <button onClick={() => dispatch({ type: 'INCREMENT' })}>+</button>
            <button onClick={() => dispatch({ type: 'DECREMENT' })}>-</button>
            <button onClick={() => dispatch({ type: 'RESET' })}>Reset</button>
        </div>
    );
}
```

### Event Handlers

```typescript
import { ChangeEvent, MouseEvent } from 'react';

function Form() {
    // Input change
    const handleChange = (e: ChangeEvent<HTMLInputElement>) => {
        console.log(e.target.value);
    };

    // Button click
    const handleClick = (e: MouseEvent<HTMLButtonElement>) => {
        console.log(e.currentTarget);
    };

    // Form submit
    const handleSubmit = (e: FormEvent<HTMLFormElement>) => {
        e.preventDefault();
    };

    return (
        <form onSubmit={handleSubmit}>
            <input onChange={handleChange} />
            <button onClick={handleClick}>Submit</button>
        </form>
    );
}
```

### Custom Data Types in React

```typescript
// User type
type User = {
    id: number;
    name: string;
    email: string;
    role: 'admin' | 'user';
};

// API response type
type ApiResponse<T> = {
    data: T;
    status: number;
    message: string;
};

// Component with generic type
type ListProps<T> = {
    items: T[];
    renderItem: (item: T) => React.ReactNode;
};

function List<T>({ items, renderItem }: ListProps<T>) {
    return <ul>{items.map(renderItem)}</ul>;
}

// Usage
<List<User>
    items={users}
    renderItem={(user) => <li key={user.id}>{user.name}</li>}
/>
```

### Type Guards in React

```typescript
// Type guard for loading state
type LoadingState = { status: 'loading' };
type ErrorState = { status: 'error'; message: string };
type SuccessState<T> = { status: 'success'; data: T };

type AsyncState<T> = LoadingState | ErrorState | SuccessState<T>;

function UserProfile() {
    const [state, setState] = useState<AsyncState<User>>({ status: 'loading' });

    // Render based on state
    if (state.status === 'loading') {
        return <div>Loading...</div>;
    }

    if (state.status === 'error') {
        return <div>Error: {state.message}</div>;
    }

    // state is SuccessState<User> here
    return <div>Welcome, {state.data.name}</div>;
}
```

---

## Cheat Sheet

### Types Quick Reference

```
┌─────────────────────────────────────────────────────┐
│         TYPE DECLARATION SYNTAX                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Primitive                                          │
│  let x: string = 'hello';                           │
│  let y: number = 42;                                │
│  let z: boolean = true;                             │
│                                                     │
│  Array                                              │
│  let arr: string[] = ['a', 'b'];                    │
│  let arr2: Array<string> = ['a', 'b'];              │
│                                                     │
│  Object                                             │
│  type User = { name: string; age: number };         │
│  interface User { name: string; age: number }       │
│                                                     │
│  Union                                              │
│  let x: string | number;                            │
│  type Status = 'active' | 'inactive';               │
│                                                     │
│  Function                                           │
│  type Fn = (x: number) => string;                   │
│  let fn: (x: number) => string;                     │
│                                                     │
│  Tuple                                              │
│  let point: [number, number] = [10, 20];            │
│                                                     │
│  Optional                                           │
│  let x?: string;                                    │
│  type User = { name: string; age?: number };        │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Type Guards Cheat Sheet

```
┌─────────────────────────────────────────────────────┐
│         TYPE GUARD PATTERNS                         │
├─────────────────────────────────────────────────────┤
│                                                     │
│  typeof                                             │
│  if (typeof x === 'string') { }                     │
│  if (typeof x === 'number') { }                     │
│                                                     │
│  instanceof                                         │
│  if (x instanceof Error) { }                        │
│  if (x instanceof Date) { }                         │
│                                                     │
│  in operator                                        │
│  if ('property' in obj) { }                         │
│                                                     │
│  Array check                                        │
│  if (Array.isArray(x)) { }                          │
│                                                     │
│  Custom guard                                       │
│  function isString(x: unknown): x is string {       │
│      return typeof x === 'string';                  │
│  }                                                  │
│                                                     │
│  Discriminated union                                │
│  if (obj.type === 'success') { }                    │
│                                                     │
│  Truthiness                                         │
│  if (x) { /* x is truthy */ }                       │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Assertion Syntax

```
┌─────────────────────────────────────────────────────┐
│         TYPE ASSERTION SYNTAX                       │
├─────────────────────────────────────────────────────┤
│                                                     │
│  as keyword (preferred)                             │
│  let x = value as string;                           │
│  let len = (value as string).length;                │
│                                                     │
│  Angle brackets (avoid in JSX)                      │
│  let x = <string>value;                             │
│                                                     │
│  Non-null assertion                                 │
│  let x = value!;                                    │
│  value!.property;                                   │
│                                                     │
│  DOM assertions                                     │
│  const btn = document.querySelector('button') as HTMLButtonElement;│
│  const input = document.getElementById('x') as HTMLInputElement;  │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### React Types Reference

```
┌─────────────────────────────────────────────────────┐
│         REACT TYPE PATTERNS                         │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Component Props                                    │
│  type Props = { name: string };                     │
│  function Comp({ name }: Props) { }                 │
│                                                     │
│  useState                                           │
│  const [x, setX] = useState<Type>(initial);         │
│                                                     │
│  Event Handlers                                     │
│  onChange: (e: ChangeEvent<HTMLInputElement>) => void│
│  onClick: (e: MouseEvent<HTMLButtonElement>) => void│
│  onSubmit: (e: FormEvent<HTMLFormElement>) => void │
│                                                     │
│  useReducer                                         │
│  type Action = { type: 'ADD' } | { type: 'REMOVE' };│
│  function reducer(state: State, action: Action) { } │
│                                                     │
│  Children                                           │
│  type Props = { children: React.ReactNode };        │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Common Mistakes

```
AVOID:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
let x: any;                    // Defeats purpose of TS
value as any as TargetType;    // Double assertion
type Props = { onClick: Function }; // Too generic

DO INSTEAD:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
let x: unknown;                // Type-safe any
Use type guards                // Narrow properly
type Props = { onClick: () => void }; // Specific signature
```

---

## Summary

**Key Concepts:**

1. **Type vs Interface:** Use type for unions, interface for objects
2. **Inference vs Annotation:** Let TS infer simple types, annotate complex ones
3. **Type Narrowing:** Use typeof, instanceof, in to narrow unions
4. **Type Guards:** Custom functions with `is` keyword for complex checks
5. **Assertions:** Use `as` when you know better than TS (carefully!)
6. **unknown over any:** Safer alternative requiring type checks
7. **Discriminated Unions:** Common property with literal types for exhaustive checking
8. **React Patterns:** Typed props, hooks, reducers, and event handlers

**Golden Rules:**

- Prefer inference over annotation when obvious
- Use unknown instead of any
- Type guard instead of assert when possible
- Discriminated unions for state management
- Exhaustive checking with never type