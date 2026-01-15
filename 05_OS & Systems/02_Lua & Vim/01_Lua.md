

## Data Types, Variables, Scopes & Everything

---

## Table of Contents

1. [Introduction to Lua](https://claude.ai/chat/a9f210c4-2570-4485-90f1-6755fa8f7fa6#introduction)
2. [Data Types](https://claude.ai/chat/a9f210c4-2570-4485-90f1-6755fa8f7fa6#data-types)
3. [Variables](https://claude.ai/chat/a9f210c4-2570-4485-90f1-6755fa8f7fa6#variables)
4. [Scopes](https://claude.ai/chat/a9f210c4-2570-4485-90f1-6755fa8f7fa6#scopes)
5. [Functions](https://claude.ai/chat/a9f210c4-2570-4485-90f1-6755fa8f7fa6#functions)
6. [Tables (Arrays & Dictionaries)](https://claude.ai/chat/a9f210c4-2570-4485-90f1-6755fa8f7fa6#tables)
7. [Metatables & OOP](https://claude.ai/chat/a9f210c4-2570-4485-90f1-6755fa8f7fa6#metatables)
8. [Modules & Require](https://claude.ai/chat/a9f210c4-2570-4485-90f1-6755fa8f7fa6#modules)
9. [Best Practices](https://claude.ai/chat/a9f210c4-2570-4485-90f1-6755fa8f7fa6#best-practices)

---

## Introduction to Lua

**Lua** is a lightweight, embeddable scripting language known for:

- Simple syntax
- Fast execution
- Easy C integration
- Used in: Game development (Roblox, WoW), embedded systems, scripting

```
LUA PHILOSOPHY:
───────────────
Keep it Simple, Small, and Fast
• Minimalist design
• Everything is a table
• Dynamic typing
• Garbage collected
```

---

## Data Types

### Basic Data Types

Lua has **8 basic types**:

```lua
-- 1. NIL (absence of value)
local x = nil
print(type(x))  -- Output: nil

-- 2. BOOLEAN
local is_true = true
local is_false = false
print(type(is_true))  -- Output: boolean

-- 3. NUMBER (both integer and float)
local integer = 42
local float = 3.14159
local scientific = 1.5e10  -- 1.5 × 10^10
print(type(integer))  -- Output: number
print(type(float))    -- Output: number

-- 4. STRING
local str1 = "Hello"
local str2 = 'World'
local str3 = [[Multi-line
string with 'quotes' and "double quotes"]]
print(type(str1))  -- Output: string

-- 5. FUNCTION
local func = function() return "I'm a function" end
print(type(func))  -- Output: function

-- 6. TABLE (arrays, dictionaries, objects)
local tbl = {1, 2, 3}
print(type(tbl))  -- Output: table

-- 7. USERDATA (C data structures)
-- Used for C integration, not commonly used directly

-- 8. THREAD (coroutines)
local co = coroutine.create(function() end)
print(type(co))  -- Output: thread
```

### Type Visualization:

```
LUA TYPE HIERARCHY:
───────────────────

        ┌─────────────┐
        │   VALUES    │
        └─────────────┘
              |
    ┌─────────┴─────────┬──────────┬──────────┐
    ↓                   ↓          ↓          ↓
┌────────┐      ┌──────────┐  ┌────────┐  ┌────────┐
│  nil   │      │ boolean  │  │ number │  │ string │
└────────┘      └──────────┘  └────────┘  └────────┘
                                              
    ┌──────────────────┬────────────┬──────────┐
    ↓                  ↓            ↓          ↓
┌────────┐      ┌──────────┐  ┌────────┐  ┌────────┐
│function│      │  table   │  │userdata│  │ thread │
└────────┘      └──────────┘  └────────┘  └────────┘
```

### Nil in Detail:

```lua
-- NIL: Represents absence of value

local a = nil
local b  -- Uninitialized = nil by default

print(a)  -- Output: nil
print(b)  -- Output: nil

-- Nil is falsy (evaluates to false in conditions)
if not a then
    print("a is nil or false")  -- This executes
end

-- Deleting table entries with nil
local person = {name = "John", age = 30}
person.age = nil  -- Removes 'age' field
print(person.age)  -- Output: nil
```

```
NIL BEHAVIOR:
─────────────
    
    Variable Assignment:
    ┌──────────────────┐
    │ local x = nil    │ ← Explicitly nil
    └──────────────────┘
    ┌──────────────────┐
    │ local y          │ ← Implicitly nil
    └──────────────────┘
    
    Boolean Context:
    ┌──────────────────────────┐
    │ if nil then ... end      │ ← FALSE
    │ if not nil then ... end  │ ← TRUE
    └──────────────────────────┘
    
    Table Deletion:
    ┌──────────────────────────┐
    │ tbl.key = nil            │ ← Removes key
    └──────────────────────────┘
```

### Numbers in Detail:

```lua
-- NUMBERS: Integer and Float unified

-- Integer
local int1 = 42
local int2 = -100
local hex = 0xFF  -- 255 in hexadecimal

-- Float
local float1 = 3.14
local float2 = -0.5
local exp = 2.5e3  -- 2500

-- Math operations
local sum = 10 + 20      -- 30
local diff = 10 - 5      -- 5
local prod = 10 * 3      -- 30
local div = 10 / 3       -- 3.333...
local floor_div = 10 // 3  -- 3 (floor division)
local mod = 10 % 3       -- 1 (modulo)
local power = 2 ^ 3      -- 8 (exponentiation)

-- Type checking
print(math.type(42))     -- Output: integer
print(math.type(3.14))   -- Output: float

-- Conversion
local str_num = "123"
local num = tonumber(str_num)  -- Convert string to number
print(num + 10)  -- Output: 133
```

### Strings in Detail:

```lua
-- STRINGS: Immutable sequences of characters

-- Declaration
local s1 = "Hello"
local s2 = 'World'
local s3 = [[Multi
line
string]]

-- Concatenation
local greeting = "Hello" .. " " .. "World"
print(greeting)  -- Output: Hello World

-- Length
print(#"Hello")  -- Output: 5

-- String methods
local text = "Lua Programming"
print(string.upper(text))     -- LUA PROGRAMMING
print(string.lower(text))     -- lua programming
print(string.sub(text, 1, 3)) -- Lua (substring)
print(string.find(text, "Pro")) -- 5 8 (start, end positions)
print(string.gsub(text, "Lua", "Python")) -- Python Programming

-- String formatting
local name = "Alice"
local age = 25
local msg = string.format("Name: %s, Age: %d", name, age)
print(msg)  -- Output: Name: Alice, Age: 25

-- Escape sequences
local escaped = "Line1\nLine2\tTabbed"
print(escaped)
-- Output:
-- Line1
-- Line2    Tabbed
```

```
STRING OPERATIONS:
──────────────────

Concatenation:
    "Hello" .. " " .. "World"
        ↓
    "Hello World"

Length Operator:
    #"Hello"
        ↓
        5

Substring:
    string.sub("Hello", 2, 4)
        ↓
       "ell"
    
    Index:  1   2   3   4   5
    String: H   e   l   l   o
            ↑       ↑       ↑
         start=2  end=4
```

### Booleans in Detail:

```lua
-- BOOLEAN: true or false

local is_valid = true
local is_empty = false

-- Logical operators
local a = true
local b = false

print(a and b)  -- false (AND)
print(a or b)   -- true (OR)
print(not a)    -- false (NOT)

-- Truthiness in Lua
-- ONLY false and nil are falsy
-- Everything else is truthy (including 0 and "")

if 0 then
    print("0 is truthy!")  -- This executes
end

if "" then
    print("Empty string is truthy!")  -- This executes
end

if false then
    print("Won't execute")
end

if nil then
    print("Won't execute")
end
```

```
TRUTHINESS TABLE:
─────────────────
Value          | Boolean Context
───────────────┼────────────────
nil            | FALSE
false          | FALSE
true           | TRUE
0              | TRUE  ← Different from C!
""             | TRUE  ← Different from JavaScript!
"false"        | TRUE
{}             | TRUE
```

---

## Variables

### Local vs Global Variables

```lua
-- GLOBAL VARIABLE (no 'local' keyword)
global_var = "I'm global"

-- LOCAL VARIABLE (with 'local' keyword)
local local_var = "I'm local"

-- Best practice: ALWAYS use 'local' unless you need global
```

### Variable Declaration Examples:

```lua
-- Example 1: Local variables
do
    local x = 10
    local y = 20
    local sum = x + y
    print(sum)  -- Output: 30
end
-- x, y, sum are not accessible here

-- Example 2: Multiple assignment
local a, b, c = 1, 2, 3
print(a, b, c)  -- Output: 1  2  3

-- Unequal assignments
local x, y = 1  -- x=1, y=nil
local p, q, r = 1, 2, 3, 4  -- p=1, q=2, r=3, 4 is discarded

-- Swapping variables
local m, n = 10, 20
m, n = n, m  -- Swap
print(m, n)  -- Output: 20  10
```

### Variable Scope Rules:

```lua
-- RULE 1: Local variables shadow outer variables
local x = "outer"

do
    local x = "inner"
    print(x)  -- Output: inner
end

print(x)  -- Output: outer


-- RULE 2: Variables persist in their block
local function example()
    local count = 0
    
    for i = 1, 5 do
        count = count + 1
        -- 'i' is local to the for loop
        -- 'count' is local to the function
    end
    
    -- 'i' is not accessible here
    print(count)  -- Output: 5
end

example()
-- 'count' is not accessible here
```

```
VARIABLE SCOPE VISUALIZATION:
──────────────────────────────

Global Scope:
┌─────────────────────────────────────┐
│ global_var = "accessible everywhere"│
│                                     │
│  Function Scope:                    │
│  ┌───────────────────────────────┐  │
│  │ local func_var = "in function"│  │
│  │                               │  │
│  │  Block Scope:                 │  │
│  │  ┌─────────────────────────┐  │  │
│  │  │ local block_var = "in  │  │  │
│  │  │ block only"             │  │  │
│  │  └─────────────────────────┘  │  │
│  │  block_var not accessible     │  │
│  └───────────────────────────────┘  │
│  func_var not accessible            │
└─────────────────────────────────────┘

Access Rules:
→ Inner can access outer
← Outer cannot access inner
```

---

## Scopes

### 1. Global Scope

```lua
-- Global scope: Accessible everywhere

-- WITHOUT 'local' keyword = GLOBAL
my_global = "I'm global"

function print_global()
    print(my_global)  -- Can access global
end

print_global()  -- Output: I'm global

-- Another file/module can access this too
```

```
GLOBAL SCOPE:
─────────────

┌─────────────────────────────────────┐
│         GLOBAL TABLE (_G)           │
│                                     │
│  my_global = "I'm global"           │
│  print_global = function() ... end  │
│  print = function() ... end         │
│  math = { ... }                     │
│  string = { ... }                   │
│                                     │
│  Accessible from ANYWHERE           │
└─────────────────────────────────────┘
```

### 2. Local Scope (Block)

```lua
-- Local scope: Limited to block

do
    local x = 10
    print(x)  -- Output: 10
end

print(x)  -- Output: nil (x not accessible)


-- If statement creates a scope
if true then
    local y = 20
    print(y)  -- Output: 20
end

print(y)  -- Output: nil


-- Loop creates a scope
for i = 1, 5 do
    local z = i * 2
    print(z)
end
-- i and z not accessible here
```

### 3. Function Scope

```lua
-- Function parameters and local variables are scoped to function

local function calculate(a, b)
    local result = a + b
    local message = "Result is " .. result
    return message
end

print(calculate(5, 3))  -- Output: Result is 8

-- a, b, result, message not accessible here
print(a)  -- Output: nil
```

### 4. Nested Scopes

```lua
-- Nested scopes: Inner can access outer

local outer = "I'm outer"

local function outer_func()
    local middle = "I'm middle"
    
    local function inner_func()
        local inner = "I'm inner"
        
        -- Can access all outer variables
        print(outer)   -- Output: I'm outer
        print(middle)  -- Output: I'm middle
        print(inner)   -- Output: I'm inner
    end
    
    inner_func()
    
    -- Cannot access inner
    print(inner)  -- Output: nil
end

outer_func()
```

```
NESTED SCOPE EXAMPLE:
─────────────────────

Outer Scope:
┌────────────────────────────────────────┐
│ local outer = "outer"                  │
│                                        │
│ Function Scope:                        │
│ ┌────────────────────────────────────┐ │
│ │ local middle = "middle"            │ │
│ │                                    │ │
│ │ Inner Function Scope:              │ │
│ │ ┌────────────────────────────────┐ │ │
│ │ │ local inner = "inner"          │ │ │
│ │ │                                │ │ │
│ │ │ Can access:                    │ │ │
│ │ │ • inner  ✓                     │ │ │
│ │ │ • middle ✓ (from parent)      │ │ │
│ │ │ • outer  ✓ (from grandparent) │ │ │
│ │ └────────────────────────────────┘ │ │
│ │                                    │ │
│ │ Can access:                        │ │
│ │ • middle ✓                         │ │
│ │ • outer  ✓                         │ │
│ │ • inner  ✗ (not accessible)       │ │
│ └────────────────────────────────────┘ │
│                                        │
│ Can access:                            │
│ • outer ✓                              │
│ • middle ✗                             │
│ • inner ✗                              │
└────────────────────────────────────────┘
```

### Accessing Global Scope (_G)

```lua
-- _G is the global table containing all global variables

-- Creating global variable
my_global = "Hello"

-- Accessing via _G
print(_G.my_global)  -- Output: Hello
print(_G["my_global"])  -- Output: Hello

-- Setting global via _G
_G.another_global = "World"
print(another_global)  -- Output: World

-- Listing all globals
for k, v in pairs(_G) do
    print(k, type(v))
end
-- Output: (all global variables)
-- print  function
-- math   table
-- string table
-- ...
```

### Example: Global vs Local Performance

```lua
-- GLOBAL (slower)
function test_global()
    counter = 0  -- Global
    for i = 1, 1000000 do
        counter = counter + 1
    end
end

-- LOCAL (faster)
function test_local()
    local counter = 0  -- Local
    for i = 1, 1000000 do
        counter = counter + 1
    end
end

-- Local is ~30% faster due to how Lua accesses variables
```

```
VARIABLE LOOKUP:
────────────────

Local Variable:
    Direct register/stack access
    ↓
    FAST ⚡

Global Variable:
    1. Look in current scope
    2. Look in _G table
    3. Hash table lookup
    ↓
    SLOWER 🐌

ALWAYS prefer local variables!
```

---

## Functions

### Function Basics

```lua
-- Method 1: Standard function declaration
function greet(name)
    return "Hello, " .. name
end

-- Method 2: Function as value (anonymous function)
local greet2 = function(name)
    return "Hello, " .. name
end

-- Method 3: Arrow-like syntax (Lua 5.4+)
local greet3 = function(name) return "Hello, " .. name end

-- Calling functions
print(greet("Alice"))  -- Output: Hello, Alice
print(greet2("Bob"))   -- Output: Hello, Bob
```

### Multiple Return Values

```lua
-- Functions can return multiple values
local function get_coordinates()
    return 10, 20, 30  -- Returns x, y, z
end

local x, y, z = get_coordinates()
print(x, y, z)  -- Output: 10  20  30

-- Capture fewer values
local x, y = get_coordinates()
print(x, y)  -- Output: 10  20

-- Ignore with _
local x, _, z = get_coordinates()
print(x, z)  -- Output: 10  30
```

### Variable Arguments (Varargs)

```lua
-- ... represents variable arguments

local function sum(...)
    local args = {...}  -- Pack into table
    local total = 0
    
    for i, v in ipairs(args) do
        total = total + v
    end
    
    return total
end

print(sum(1, 2, 3))        -- Output: 6
print(sum(10, 20, 30, 40)) -- Output: 100

-- Access varargs directly
local function print_all(...)
    for i = 1, select("#", ...) do
        local arg = select(i, ...)
        print(i, arg)
    end
end

print_all("a", "b", "c")
-- Output:
-- 1  a
-- 2  b
-- 3  c
```

### Closures

```lua
-- Closure: Function that captures outer variables

local function create_counter()
    local count = 0  -- Enclosed variable
    
    return function()
        count = count + 1
        return count
    end
end

local counter1 = create_counter()
local counter2 = create_counter()

print(counter1())  -- Output: 1
print(counter1())  -- Output: 2
print(counter1())  -- Output: 3

print(counter2())  -- Output: 1 (separate counter!)
print(counter2())  -- Output: 2
```

```
CLOSURE VISUALIZATION:
──────────────────────

create_counter() called twice:

Counter 1:
┌────────────────────────┐
│ Closure Environment    │
│ ┌────────────────────┐ │
│ │ count = 3          │ │ ← Private state
│ └────────────────────┘ │
│                        │
│ function()             │
│   count = count + 1    │
│   return count         │
│ end                    │
└────────────────────────┘

Counter 2:
┌────────────────────────┐
│ Closure Environment    │
│ ┌────────────────────┐ │
│ │ count = 2          │ │ ← Separate state!
│ └────────────────────┘ │
│                        │
│ function()             │
│   count = count + 1    │
│   return count         │
│ end                    │
└────────────────────────┘
```

### First-Class Functions

```lua
-- Functions are values: can be passed, returned, stored

-- Pass function as argument
local function execute(func, value)
    return func(value)
end

local function double(x)
    return x * 2
end

print(execute(double, 5))  -- Output: 10

-- Return function
local function create_multiplier(factor)
    return function(x)
        return x * factor
    end
end

local times_three = create_multiplier(3)
local times_five = create_multiplier(5)

print(times_three(10))  -- Output: 30
print(times_five(10))   -- Output: 50

-- Store in table
local operations = {
    add = function(a, b) return a + b end,
    sub = function(a, b) return a - b end,
    mul = function(a, b) return a * b end
}

print(operations.add(5, 3))  -- Output: 8
```

---

## Tables

Tables are Lua's only data structure - used for arrays, dictionaries, objects, modules, etc.

### Arrays (Indexed by Numbers)

```lua
-- Arrays start at index 1 (not 0!)
local fruits = {"apple", "banana", "cherry"}

print(fruits[1])  -- Output: apple
print(fruits[2])  -- Output: banana

-- Length operator
print(#fruits)  -- Output: 3

-- Iterating
for i = 1, #fruits do
    print(i, fruits[i])
end

-- Or with ipairs
for index, value in ipairs(fruits) do
    print(index, value)
end

-- Adding elements
fruits[4] = "date"
table.insert(fruits, "elderberry")  -- Append
table.insert(fruits, 2, "blueberry")  -- Insert at position 2

-- Removing elements
table.remove(fruits, 2)  -- Remove at index 2
local last = table.remove(fruits)  -- Remove and return last element
```

### Dictionaries (Key-Value Pairs)

```lua
-- Dictionary/Hash table
local person = {
    name = "Alice",
    age = 30,
    city = "NYC"
}

-- Access
print(person.name)     -- Output: Alice
print(person["age"])   -- Output: 30

-- Add/Update
person.job = "Engineer"
person["salary"] = 100000

-- Delete (set to nil)
person.city = nil

-- Iterate
for key, value in pairs(person) do
    print(key, value)
end
-- Output:
-- name    Alice
-- age     30
-- job     Engineer
-- salary  100000
```

### Mixed Tables

```lua
-- Tables can mix numeric and string keys
local mixed = {
    "first",   -- [1] = "first"
    "second",  -- [2] = "second"
    name = "Alice",
    age = 30,
    "third"    -- [3] = "third"
}

print(mixed[1])      -- Output: first
print(mixed.name)    -- Output: Alice
print(#mixed)        -- Output: 3 (only counts numeric indices)

-- Iterate numeric part
for i, v in ipairs(mixed) do
    print(i, v)
end

-- Iterate all
for k, v in pairs(mixed) do
    print(k, v)
end
```

### Nested Tables

```lua
-- Tables within tables
local company = {
    name = "TechCorp",
    employees = {
        {name = "Alice", role = "Engineer"},
        {name = "Bob", role = "Manager"},
        {name = "Carol", role = "Designer"}
    },
    address = {
        street = "123 Main St",
        city = "NYC",
        zip = "10001"
    }
}

-- Access nested data
print(company.employees[1].name)  -- Output: Alice
print(company.address.city)       -- Output: NYC

-- Iterate employees
for i, emp in ipairs(company.employees) do
    print(emp.name, emp.role)
end
```

```
NESTED TABLE STRUCTURE:
───────────────────────

company
├── name: "TechCorp"
├── employees (array)
│   ├── [1]
│   │   ├── name: "Alice"
│   │   └── role: "Engineer"
│   ├── [2]
│   │   ├── name: "Bob"
│   │   └── role: "Manager"
│   └── [3]
│       ├── name: "Carol"
│       └── role: "Designer"
└── address (table)
    ├── street: "123 Main St"
    ├── city: "NYC"
    └── zip: "10001"
```

### Table Reference vs Copy

```lua
-- Tables are REFERENCES, not copies

local original = {1, 2, 3}
local reference = original  -- Same table!

reference[1] = 999

print(original[1])  -- Output: 999 (changed!)

-- To copy, you must do it manually
local function shallow_copy(tbl)
    local copy = {}
    for k, v in pairs(tbl) do
        copy[k] = v
    end
    return copy
end

local original2 = {1, 2, 3}
local copy = shallow_copy(original2)

copy[1] = 999

print(original2[1])  -- Output: 1 (unchanged)
print(copy[1])       -- Output: 999
```

```
TABLE REFERENCE:
────────────────

Assignment by reference:
┌─────────────────┐
│   Memory        │
│  ┌───────────┐  │
│  │  {1,2,3}  │◄─┼─── original
│  └───────────┘  │
│       ↑         │
│       └─────────┼─── reference (same table!)
└─────────────────┘

Assignment by copy:
┌─────────────────┐
│   Memory        │
│  ┌───────────┐  │
│  │  {1,2,3}  │◄─┼─── original
│  └───────────┘  │
│                 │
│  ┌───────────┐  │
│  │  {1,2,3}  │◄─┼─── copy (different table)
│  └───────────┘  │
└─────────────────┘
```

---

## Metatables & OOP

Metatables allow you to change the behavior of tables.

### Basic Metatable

```lua
-- Create a table
local t = {value = 10}

-- Create a metatable
local mt = {
    __add = function(t1, t2)
        return t1.value + t2.value
    end,
    
    __tostring = function(t)
        return "MyTable: " .. t.value
    end
}

-- Set metatable
setmetatable(t, mt)

-- Now we can use operators
local t2 = {value = 20}
setmetatable(t2, mt)

print(t + t2)  -- Output: 30 (uses __add)
print(t)       -- Output: MyTable: 10 (uses __tostring)
```

### Metamethods

```lua
-- Common metamethods:

local mt = {
    __add = function(a, b) end,      -- a + b
    __sub = function(a, b) end,      -- a - b
    __mul = function(a, b) end,      -- a * b
    __div = function(a, b) end,      -- a / b
    __mod = function(a, b) end,      -- a % b
    __pow = function(a, b) end,      -- a ^ b
    __unm = function(a) end,         -- -a
    __concat = function(a, b) end,   -- a .. b
    __eq = function(a, b) end,       -- a == b
    __lt = function(a, b) end,       -- a < b
    __le = function(a, b) end,       -- a <= b
    __index = function(t, k) end,    -- t[k] when k doesn't exist
    __newindex = function(t, k, v) end,  -- t[k] = v
    __call = function(t, ...) end,   -- t(...)
    __tostring = function(t) end,    -- tostring(t)
    __len = function(t) end,         -- #t
}
```

### OOP with Metatables

```lua
-- Simple class implementation

-- Define class
local Person = {}
Person.__index = Person  -- Make Person the metatable

-- Constructor
function Person:new(name, age)
    local instance = setmetatable({}, Person)
    instance.name = name
    instance.age = age
    return instance
end

-- Methods
function Person:greet()
    print("Hello, I'm " .. self.name)
end

function Person:birthday()
    self.age = self.age + 1
    print(self.name .. " is now " .. self.age)
end

-- Create instances
local alice = Person:new("Alice", 30)
local bob = Person:new("Bob", 25)

alice:greet()     -- Output: Hello, I'm Alice
bob:greet()       -- Output: Hello, I'm Bob
alice:birthday()  -- Output: Alice is now 31
```

```
OOP STRUCTURE:
──────────────

Person (Class Table)
┌────────────────────────────┐
│ __index = Person           │
│ new = function() ... end   │
│ greet = function() ... end │
│ birthday = function() ...  │
└────────────────────────────┘
        ↑                ↑
        │                │
    metatable        metatable
        │                │
┌───────┴──────┐  ┌──────┴───────┐
│ alice        │  │ bob          │
│ name="Alice" │  │ name="Bob"   │
│ age=30       │  │ age=25       │
└──────────────┘  └──────────────┘

When alice:greet() is called:
1. Look for 'greet' in alice → Not found
2. Check metatable (__index = Person)
3. Look for 'greet' in Person → Found!
4. Call Person.greet(alice)
```

### Inheritance

```lua
-- Base class
local Animal = {}
Animal.__index = Animal

function Animal:new(name)
    local instance = setmetatable({}, Animal)
    instance.name = name
    return instance
end

function Animal:speak()
    print(self.name .. " makes a sound")
end

-- Derived class
local Dog = setmetatable({}, {__index = Animal})
Dog.__index = Dog

function Dog:new(name, breed)
    local instance = setmetatable(Animal.new(self, name), Dog)
    instance.breed = breed
    return instance
end

function Dog:speak()  -- Override
    print(self.name .. " barks!")
end

function Dog:fetch()  -- New method
    print(self.name .. " fetches the ball")
end

-- Usage
local animal = Animal:new("Generic")
local dog = Dog:new("Rex", "Labrador")

animal:speak()  -- Output: Generic makes a sound
dog:speak()     -- Output: Rex barks! (overridden)
dog:fetch()     -- Output: Rex fetches the ball
```

```
INHERITANCE STRUCTURE:
──────────────────────

        Animal (Base)
        ┌─────────────────┐
        │ __index = Animal│
        │ new()           │
        │ speak()         │
        └─────────────────┘
                ↑
                │ inherits (__index)
                │
        Dog (Derived)
        ┌─────────────────┐
        │ __index = Dog   │
        │ new()           │
        │ speak() ← override
        │ fetch() ← new   │
        └─────────────────┘
                ↑
                │ metatable
                │
        ┌───────┴─────────┐
        │ dog instance    │
        │ name = "Rex"    │
        │ breed = "Lab"   │
        └─────────────────┘

Method lookup:
1. Look in instance → Not found
2. Look in Dog → speak() found, use it
3. If not in Dog → Look in Animal
```

---

## Modules & Require

### Creating a Module

**File: mymath.lua**

```lua
-- mymath.lua - A simple module

local M = {}  -- Module table

-- Private variable (not exported)
local pi = 3.14159

-- Private function (not exported)
local function is_positive(x)
    return x > 0
end

-- Public function 1
function M.add(a, b)
    return a + b
end

-- Public function 2
function M.multiply(a, b)
    return a * b
end

-- Public function 3
function M.circle_area(radius)
    if not is_positive(radius) then
        error("Radius must be positive")
    end
    return pi * radius * radius
end

-- Public constant
M.VERSION = "1.0.0"

return M  -- Return the module table
```

### Using a Module

**File: main.lua**

```lua
-- Load the module
local mymath = require("mymath")

-- Use module functions
print(mymath.add(5, 3))         -- Output: 8
print(mymath.multiply(4, 7))    -- Output: 28
print(mymath.circle_area(5))    -- Output: 78.53975

-- Access module constant
print(mymath.VERSION)  -- Output: 1.0.0

-- Can't access private members
print(mymath.pi)         -- Output: nil (private)
print(mymath.is_positive)  -- Output: nil (private)
```

```
MODULE STRUCTURE:
─────────────────

mymath.lua:
┌──────────────────────────────┐
│ Module Table (M)             │
│ ┌──────────────────────────┐ │
│ │ add = function() ... end │ │ ← Exported
│ │ multiply = function()    │ │ ← Exported
│ │ circle_area = function() │ │ ← Exported
│ │ VERSION = "1.0.0"        │ │ ← Exported
│ └──────────────────────────┘ │
│                              │
│ Private (not in M):          │
│ • pi = 3.14159               │ ← NOT exported
│ • is_positive = function()   │ ← NOT exported
└──────────────────────────────┘
        ↓ return M
┌──────────────────────────────┐
│ main.lua                     │
│                              │
│ local mymath = require(...)  │
│ mymath.add() ✓               │
│ mymath.pi ✗ (nil)            │
└──────────────────────────────┘
```

### Module with Class

**File: person.lua**

```lua
-- person.lua - Person class module

local Person = {}
Person.__index = Person

function Person.new(name, age)
    local self = setmetatable({}, Person)
    self.name = name
    self.age = age
    return self
end

function Person:greet()
    return "Hello, I'm " .. self.name
end

function Person:get_age()
    return self.age
end

function Person:set_age(new_age)
    if new_age < 0 then
        error("Age cannot be negative")
    end
    self.age = new_age
end

return Person
```

**File: main.lua**

```lua
local Person = require("person")

local alice = Person.new("Alice", 30)
local bob = Person.new("Bob", 25)

print(alice:greet())    -- Output: Hello, I'm Alice
print(bob:get_age())    -- Output: 25

bob:set_age(26)
print(bob:get_age())    -- Output: 26
```

### Require Behavior

```lua
-- require() caches modules

-- First require loads and executes the module
local math1 = require("mymath")

-- Second require returns the cached version (doesn't reload)
local math2 = require("mymath")

-- They're the same table!
print(math1 == math2)  -- Output: true

-- If you need to reload, clear the cache
package.loaded["mymath"] = nil
local math3 = require("mymath")  -- Now it reloads
```

```
REQUIRE CACHE:
──────────────

First call:
    require("mymath")
        ↓
    1. Check package.loaded["mymath"]
       → Not found
    2. Load and execute mymath.lua
    3. Store result in package.loaded
    4. Return result
    
Second call:
    require("mymath")
        ↓
    1. Check package.loaded["mymath"]
       → Found! ✓
    2. Return cached result (fast!)

Cache Table (package.loaded):
┌────────────────────────────┐
│ "mymath" → module table    │
│ "person" → Person class    │
│ "string" → string lib      │
│ "math" → math lib          │
└────────────────────────────┘
```

### Search Path

```lua
-- Lua searches for modules in package.path

print(package.path)
-- Output (example):
-- ./?.lua;/usr/local/share/lua/5.4/?.lua;/usr/local/share/lua/5.4/?/init.lua

-- ? is replaced with module name
-- require("mymath") searches:
-- 1. ./mymath.lua
-- 2. /usr/local/share/lua/5.4/mymath.lua
-- 3. /usr/local/share/lua/5.4/mymath/init.lua

-- Add custom paths
package.path = package.path .. ";/my/custom/path/?.lua"
```

---

## Advanced Scope Examples

### Example 1: Closure Counter

```lua
local function create_counter()
    local count = 0  -- Captured by closure
    
    local function increment()
        count = count + 1
        return count
    end
    
    local function decrement()
        count = count - 1
        return count
    end
    
    local function get()
        return count
    end
    
    local function reset()
        count = 0
    end
    
    return {
        inc = increment,
        dec = decrement,
        get = get,
        reset = reset
    }
end

local counter = create_counter()

print(counter.inc())    -- Output: 1
print(counter.inc())    -- Output: 2
print(counter.dec())    -- Output: 1
print(counter.get())    -- Output: 1
counter.reset()
print(counter.get())    -- Output: 0
```

### Example 2: Private Variables (Encapsulation)

```lua
local function BankAccount(initial_balance)
    -- Private variables
    local balance = initial_balance or 0
    local transaction_history = {}
    
    -- Private function
    local function add_transaction(type, amount)
        table.insert(transaction_history, {
            type = type,
            amount = amount,
            timestamp = os.time()
        })
    end
    
    -- Public interface
    local account = {}
    
    function account.deposit(amount)
        if amount <= 0 then
            return false, "Amount must be positive"
        end
        balance = balance + amount
        add_transaction("deposit", amount)
        return true
    end
    
    function account.withdraw(amount)
        if amount <= 0 then
            return false, "Amount must be positive"
        end
        if amount > balance then
            return false, "Insufficient funds"
        end
        balance = balance - amount
        add_transaction("withdrawal", amount)
        return true
    end
    
    function account.get_balance()
        return balance
    end
    
    function account.get_history()
        -- Return copy, not original
        local copy = {}
        for i, t in ipairs(transaction_history) do
            copy[i] = {
                type = t.type,
                amount = t.amount,
                timestamp = t.timestamp
            }
        end
        return copy
    end
    
    return account
end

-- Usage
local my_account = BankAccount(1000)

my_account.deposit(500)
print(my_account.get_balance())  -- Output: 1500

my_account.withdraw(200)
print(my_account.get_balance())  -- Output: 1300

-- Can't access private variables
print(my_account.balance)  -- Output: nil (private!)

-- Get transaction history
local history = my_account.get_history()
for _, t in ipairs(history) do
    print(t.type, t.amount)
end
-- Output:
-- deposit    500
-- withdrawal 200
```

```
ENCAPSULATION:
──────────────

BankAccount Closure:
┌─────────────────────────────────┐
│ Private Scope:                  │
│ ┌─────────────────────────────┐ │
│ │ balance = 1300              │ │ ← Not accessible
│ │ transaction_history = {...} │ │ ← Not accessible
│ │ add_transaction() {...}     │ │ ← Not accessible
│ └─────────────────────────────┘ │
│                                 │
│ Public Interface (account):     │
│ ┌─────────────────────────────┐ │
│ │ deposit() {...}             │ │ ← Accessible
│ │ withdraw() {...}            │ │ ← Accessible
│ │ get_balance() {...}         │ │ ← Accessible
│ │ get_history() {...}         │ │ ← Accessible
│ └─────────────────────────────┘ │
└─────────────────────────────────┘
        ↓ return account
┌─────────────────────────────────┐
│ my_account (reference)          │
│ • Can call public methods       │
│ • Cannot access private data    │
└─────────────────────────────────┘
```

### Example 3: Module Pattern with Private State

```lua
-- config.lua
local M = {}

-- Private state
local settings = {
    debug_mode = false,
    max_connections = 100,
    timeout = 30
}

-- Private validation
local function validate_number(value, min, max)
    return type(value) == "number" and value >= min and value <= max
end

-- Public getters
function M.get(key)
    return settings[key]
end

function M.get_all()
    -- Return copy
    local copy = {}
    for k, v in pairs(settings) do
        copy[k] = v
    end
    return copy
end

-- Public setters with validation
function M.set_debug_mode(enabled)
    if type(enabled) ~= "boolean" then
        error("debug_mode must be boolean")
    end
    settings.debug_mode = enabled
end

function M.set_max_connections(num)
    if not validate_number(num, 1, 1000) then
        error("max_connections must be between 1 and 1000")
    end
    settings.max_connections = num
end

function M.set_timeout(seconds)
    if not validate_number(seconds, 1, 300) then
        error("timeout must be between 1 and 300 seconds")
    end
    settings.timeout = seconds
end

return M
```

```lua
-- main.lua
local config = require("config")

-- Get settings
print(config.get("debug_mode"))  -- Output: false

-- Set settings (with validation)
config.set_debug_mode(true)
config.set_max_connections(200)

-- Can't access private settings directly
print(config.settings)  -- Output: nil (private!)

-- Get all settings
local all = config.get_all()
for k, v in pairs(all) do
    print(k, v)
end
```

---

## Best Practices

### 1. Always Use Local Variables

```lua
-- ❌ BAD: Global variables
function calculate()
    result = 10 + 20  -- Pollutes global scope
    return result
end

-- ✅ GOOD: Local variables
function calculate()
    local result = 10 + 20
    return result
end
```

### 2. Declare Variables at the Top

```lua
-- ❌ BAD: Variables scattered
function process_data(items)
    for i = 1, #items do
        local item = items[i]
        -- ...
        local processed = transform(item)
        -- ...
    end
end

-- ✅ GOOD: Declare at top of scope
function process_data(items)
    local item, processed
    
    for i = 1, #items do
        item = items[i]
        processed = transform(item)
        -- ...
    end
end
```

### 3. Use Meaningful Names

```lua
-- ❌ BAD
local function f(x, y)
    local r = x * y
    return r
end

-- ✅ GOOD
local function calculate_area(width, height)
    local area = width * height
    return area
end
```

### 4. Avoid Deep Nesting

```lua
-- ❌ BAD: Deep nesting
function process(data)
    if data then
        if data.value then
            if data.value > 0 then
                return data.value * 2
            else
                return 0
            end
        else
            return nil
        end
    else
        return nil
    end
end

-- ✅ GOOD: Early returns
function process(data)
    if not data then return nil end
    if not data.value then return nil end
    if data.value <= 0 then return 0 end
    return data.value * 2
end
```

### 5. Use Tables for Multiple Returns

```lua
-- ❌ OKAY: Multiple return values (can be confusing)
function get_user()
    return "Alice", 30, "alice@email.com"
end
local name, age, email = get_user()

-- ✅ BETTER: Return table
function get_user()
    return {
        name = "Alice",
        age = 30,
        email = "alice@email.com"
    }
end
local user = get_user()
print(user.name)
```

### 6. Use Metatables for OOP

```lua
-- ✅ GOOD: Proper OOP pattern
local Class = {}
Class.__index = Class

function Class.new(value)
    local self = setmetatable({}, Class)
    self.value = value
    return self
end

function Class:method()
    return self.value
end

local obj = Class.new(42)
print(obj:method())
```

### 7. Check for nil Before Using

```lua
-- ❌ BAD: No nil check
function get_name(user)
    return user.name  -- Crashes if user is nil
end

-- ✅ GOOD: Nil check
function get_name(user)
    if not user then
        return nil
    end
    return user.name
end

-- ✅ BETTER: With default
function get_name(user)
    return user and user.name or "Unknown"
end
```

### 8. Use ipairs for Arrays, pairs for Tables

```lua
local array = {10, 20, 30}
local dict = {name = "Alice", age = 30}

-- ✅ Arrays: use ipairs (guaranteed order)
for i, v in ipairs(array) do
    print(i, v)
end

-- ✅ Dictionaries: use pairs (no guaranteed order)
for k, v in pairs(dict) do
    print(k, v)
end
```

---

## Common Patterns & Idioms

### Pattern 1: Default Values

```lua
-- Set default if value is nil
function greet(name)
    name = name or "Guest"
    print("Hello, " .. name)
end

greet()          -- Output: Hello, Guest
greet("Alice")   -- Output: Hello, Alice
```

### Pattern 2: Ternary Operator (Simulation)

```lua
-- Lua doesn't have ternary, but you can simulate it
local age = 20
local status = (age >= 18) and "Adult" or "Minor"
print(status)  -- Output: Adult

-- Be careful with false!
local value = false
local result = value and "yes" or "no"
print(result)  -- Output: no (because false is falsy)
```

### Pattern 3: Guard Clauses

```lua
function divide(a, b)
    if b == 0 then
        return nil, "Cannot divide by zero"
    end
    return a / b
end

local result, err = divide(10, 0)
if not result then
    print("Error:", err)
else
    print("Result:", result)
end
```

### Pattern 4: Factory Pattern

```lua
local function create_animal(type)
    local animals = {
        dog = function() return {sound = "Woof!"} end,
        cat = function() return {sound = "Meow!"} end,
        cow = function() return {sound = "Moo!"} end
    }
    
    local factory = animals[type]
    if not factory then
        error("Unknown animal type: " .. type)
    end
    
    return factory()
end

local dog = create_animal("dog")
print(dog.sound)  -- Output: Woof!
```

### Pattern 5: Iterator Pattern

```lua
-- Custom iterator
local function range(from, to, step)
    step = step or 1
    local i = from - step
    
    return function()
        i = i + step
        if i <= to then
            return i
        end
    end
end

-- Usage
for num in range(1, 10, 2) do
    print(num)
end
-- Output: 1 3 5 7 9
```

---

## Quick Reference Card

```
╔═══════════════════════════════════════════════════════════╗
║                    LUA QUICK REFERENCE                    ║
╠═══════════════════════════════════════════════════════════╣
║ VARIABLES:                                                ║
║   local x = 10        -- Local (ALWAYS prefer)            ║
║   y = 20              -- Global (avoid)                   ║
║   local a, b = 1, 2   -- Multiple assignment              ║
║                                                           ║
║ DATA TYPES:                                               ║
║   nil, boolean, number, string, function, table, thread   ║
║                                                           ║
║ OPERATORS:                                                ║
║   +  -  *  /  //  %  ^   -- Arithmetic                    ║
║   ==  ~=  <  >  <=  >=   -- Comparison                    ║
║   and  or  not           -- Logical                       ║
║   ..                     -- Concatenation                 ║
║   #                      -- Length                        ║
║                                                           ║
║ CONTROL FLOW:                                             ║
║   if cond then ... elseif ... else ... end                ║
║   while cond do ... end                                   ║
║   repeat ... until cond                                   ║
║   for i = 1, 10 do ... end                                ║
║   for k, v in pairs(tbl) do ... end                       ║
║                                                           ║
║ FUNCTIONS:                                                ║
║   function name(params) ... end                           ║
║   local f = function(params) ... end                      ║
║   function name(...) end  -- Varargs                      ║
║   return value1, value2   -- Multiple returns             ║
║                                                           ║
║ TABLES:                                                   ║
║   local t = {1, 2, 3}     -- Array                        ║
║   local t = {x=1, y=2}    -- Dictionary                   ║
║   t[key] = value          -- Set                          ║
║   value = t[key]          -- Get                          ║
║   #t                      -- Length                       ║
║                                                           ║
║ MODULES:                                                  ║
║   local M = {}                                            ║
║   function M.func() ... end                               ║
║   return M                                                ║
║   local mod = require("module")                           ║
║                                                           ║
║ OOP:                                                      ║
║   Class = {}                                              ║
║   Class.__index = Class                                   ║
║   function Class.new() ... end                            ║
║   function Class:method() ... end                         ║
║   local obj = Class.new()                                 ║
╚═══════════════════════════════════════════════════════════╝
```

---

## Complete Example: Todo List Application

```lua
-- todo.lua - Complete application demonstrating all concepts

local TodoList = {}
TodoList.__index = TodoList

-- Constructor
function TodoList.new()
    local self = setmetatable({}, TodoList)
    self.tasks = {}
    self.next_id = 1
    return self
end

-- Add task
function TodoList:add(description)
    if not description or description == "" then
        return nil, "Description cannot be empty"
    end
    
    local task = {
        id = self.next_id,
        description = description,
        completed = false,
        created_at = os.time()
    }
    
    self.tasks[self.next_id] = task
    self.next_id = self.next_id + 1
    
    return task.id
end

-- Complete task
function TodoList:complete(id)
    local task = self.tasks[id]
    if not task then
        return false, "Task not found"
    end
    
    task.completed = true
    task.completed_at = os.time()
    return true
end

-- Delete task
function TodoList:delete(id)
    if not self.tasks[id] then
        return false, "Task not found"
    end
    
    self.tasks[id] = nil
    return true
end

-- Get all tasks
function TodoList:get_all()
    local all = {}
    for id, task in pairs(self.tasks) do
        table.insert(all, task)
    end
    return all
end

-- Get pending tasks
function TodoList:get_pending()
    local pending = {}
    for id, task in pairs(self.tasks) do
        if not task.completed then
            table.insert(pending, task)
        end
    end
    return pending
end

-- Get completed tasks
function TodoList:get_completed()
    local completed = {}
    for id, task in pairs(self.tasks) do
        if task.completed then
            table.insert(completed, task)
        end
    end
    return completed
end

-- Display tasks
function TodoList:display()
    print("\n=== TODO LIST ===")
    
    local all = self:get_all()
    if #all == 0 then
        print("No tasks")
        return
    end
    
    for _, task in ipairs(all) do
        local status = task.completed and "[✓]" or "[ ]"
        print(string.format("%s %d. %s", status, task.id, task.description))
    end
    
    print(string.format("\nTotal: %d | Pending: %d | Completed: %d",
        #all, #self:get_pending(), #self:get_completed()))
end

-- Main program
local function main()
    local todos = TodoList.new()
    
    -- Add tasks
    todos:add("Learn Lua basics")
    todos:add("Understand scopes")
    todos:add("Build a project")
    
    -- Display
    todos:display()
    
    -- Complete a task
    todos:complete(1)
    
    -- Display again
    todos:display()
    
    -- Add more
    todos:add("Master metatables")
    
    -- Delete a task
    todos:delete(2)
    
    -- Final display
    todos:display()
end

-- Run
main()
```

**Output:**

```
=== TODO LIST ===
[ ] 1. Learn Lua basics
[ ] 2. Understand scopes
[ ] 3. Build a project

Total: 3 | Pending: 3 | Completed: 0

=== TODO LIST ===
[✓] 1. Learn Lua basics
[ ] 2. Understand scopes
[ ] 3. Build a project

Total: 3 | Pending: 2 | Completed: 1

=== TODO LIST ===
[✓] 1. Learn Lua basics
[ ] 3. Build a project
[ ] 4. Master metatables

Total: 3 | Pending: 2 | Completed: 1
```

---

## Summary

**Key Takeaways:**

1. **Always use `local`** - Faster and prevents global pollution
2. **Tables are everything** - Arrays, dictionaries, objects, modules
3. **Metatables enable OOP** - `__index`, constructors, methods
4. **Closures capture scope** - Powerful for encapsulation
5. **Modules export tables** - `require()` caches modules
6. **Functions are first-class** - Pass, return, store in tables
7. **Nil and false are falsy** - Everything else is truthy
8. **Arrays start at 1** - Not 0 like other languages!

Lua's simplicity and flexibility make it perfect for embedding, game scripting, and rapid prototyping!