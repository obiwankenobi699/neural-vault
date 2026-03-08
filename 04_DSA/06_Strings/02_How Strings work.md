
---

## Table of Contents

1. [println() Method Overloading](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#println)
2. [Object Printing and Hash Code](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#hashcode)
3. [toString() Override for Pretty Printing](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#tostring)
4. [String Concatenation](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#concatenation)
5. [String Immutability](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#immutability)

---

# 1. println() Method Overloading {#println}

## Theory

When you call `println()`, Java has **multiple versions** of this method. It selects the correct one based on **parameter type**.

## Small Example

```java
System.out.println(56);        // Calls println(int)
System.out.println("Hello");   // Calls println(String)
System.out.println(true);      // Calls println(boolean)

Person p = new Person();
System.out.println(p);         // Calls println(Object)
```

**Key Point:** Parameter type determines which println() executes.

## Available println() Methods

```java
println(int)      → for numbers
println(String)   → for text
println(boolean)  → for true/false
println(char)     → for single character
println(Object)   → for any object (calls toString())
```

## null Handling

```java
System.out.println(null);  // Output: "null"
// No NullPointerException, safely prints "null" string
```

---

# 2. Object Printing and Hash Code {#hashcode}

## Theory

When you print an object **without overriding toString()**, you get **gibberish alphanumeric** like `Person@15db9742`.

This is: **ClassName@hashCode**

## Small Example

```java
class Person {
    String name = "Mukul";
    int age = 25;
}

Person p = new Person();
System.out.println(p);
// Output: Person@15db9742  ← Hash code (gibberish)
```

## What is Hash Code?

**Hash code** = A number representing object's memory location

```
Person@15db9742
  ↑         ↑
Class   Hash code
name    (in hexadecimal)
```

## Why Hash Code Appears?

**Reason:** Java doesn't know how to represent your custom object meaningfully.

**Default toString() method:**

```java
public String toString() {
    return getClass().getName() + "@" + Integer.toHexString(hashCode());
}
```

## Two Objects, Different Hash Codes

```java
Person p1 = new Person("Mukul", 25);
Person p2 = new Person("Mukul", 25);

System.out.println(p1);  // Person@15db9742
System.out.println(p2);  // Person@6d06d69c

// Same data, but different objects in memory
// → Different hash codes
```

---

# 3. toString() Override for Pretty Printing {#tostring}

## Theory

To get **readable output** instead of hash code, we **override toString()** method.

**Flow:**

```
println(Object)
    ↓
calls Object.toString()
    ↓
If overridden → Your custom string
If not → ClassName@hashCode
```

## Small Example: Without Override

```java
class Student {
    String name;
    int id;
    
    Student(String name, int id) {
        this.name = name;
        this.id = id;
    }
    // No toString() override
}

Student s = new Student("John", 101);
System.out.println(s);
// Output: Student@15db9742  ← Not helpful!
```

## Small Example: With Override

```java
class Student {
    String name;
    int id;
    
    Student(String name, int id) {
        this.name = name;
        this.id = id;
    }
    
    @Override
    public String toString() {
        return "Student{name='" + name + "', id=" + id + "}";
    }
}

Student s = new Student("John", 101);
System.out.println(s);
// Output: Student{name='John', id=101}  ← Readable!
```

## How It Works

```
System.out.println(student)
        ↓
println(Object obj)
        ↓
obj.toString()  ← Calls YOUR overridden version
        ↓
Returns: "Student{name='John', id=101}"
        ↓
Prints to terminal
```

**Key Point:** Your custom toString() **overrides** default implementation, giving meaningful output.

---

# 4. String Concatenation {#concatenation}

## Theory: Operator Overloading

**Important Rule:** Java does **NOT** allow operator overloading, **EXCEPT for String concatenation** using `+`.

```java
// ONLY this works:
String text = "Hello" + " World";  ✓

// You CANNOT do this with custom objects:
Person p1 = new Person();
Person p2 = new Person();
// Person p3 = p1 + p2;  ✗ ERROR!
```

## String + Object = Automatic toString() Call

```java
Person p = new Person("Mukul", 25);
String info = "Person: " + p;

// Behind the scenes:
// 1. Call p.toString()
// 2. Get "Person{name='Mukul', age=25}"
// 3. Concatenate: "Person: " + "Person{name='Mukul', age=25}"
```

## Small Example: Concatenation

```java
class Person {
    String name;
    int age;
    
    Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    @Override
    public String toString() {
        return name + "(" + age + ")";
    }
}

Person p = new Person("Mukul", 25);
System.out.println("Info: " + p);
// Output: Info: Mukul(25)
// Automatic toString() call!
```

## Concatenation with Different Types

```java
// String + int
String s1 = "Number: " + 42;      // "Number: 42"

// String + boolean
String s2 = "Active: " + true;    // "Active: true"

// String + Object
Person p = new Person("A", 20);
String s3 = "Person: " + p;       // Calls p.toString()
```

## Character Addition (Important!)

```java
// Example 1: String first → Concatenation
System.out.println("Result: " + 'A' + 1);
// Output: "Result: A1"
// Left-to-right: "Result: " + 'A' = "Result: A"
//                "Result: A" + 1 = "Result: A1"

// Example 2: Char first → Arithmetic (ASCII)
System.out.println('A' + 1);
// Output: 66
// 'A' ASCII = 65, so 65 + 1 = 66

// Example 3: Arithmetic then concat
System.out.println('A' + 1 + " Result");
// Output: "66 Result"
// 'A' + 1 = 66 (arithmetic)
// 66 + " Result" = "66 Result" (concatenation)
```

**Rule:** When String is involved, `+` becomes concatenation. Without String, it's arithmetic.

---

# 5. String Immutability {#immutability}

## Theory

**Strings are immutable** = Once created, they **cannot be changed**.

Concatenation creates a **new object**, doesn't modify the existing one.

## Small Example

```java
String s1 = "Hello";
String s2 = s1 + " World";

// What happens:
// 1. "Hello" object created
// 2. "Hello World" NEW object created
// 3. s2 points to new object
// 4. Original "Hello" unchanged

System.out.println(s1);  // "Hello" (unchanged)
System.out.println(s2);  // "Hello World" (new object)
```

## Memory Visualization

```
After: String s2 = s1 + " World";

Stack:              Heap:
┌──────────┐       ┌──────────────┐
│ s1: 0x100│──────►│ "Hello"      │ 0x100
├──────────┤       ├──────────────┤
│ s2: 0x200│──────►│ "Hello World"│ 0x200
└──────────┘       └──────────────┘

Two separate objects in memory!
```

## New Object Creation

```java
String s = "Hello";
s = s + " World";

// Step-by-step:
// 1. Create "Hello" object
// 2. Concatenate: creates NEW "Hello World" object
// 3. s reference updates to new object
// 4. Original "Hello" may be garbage collected
```

## Problem in Loops

```java
// Bad: Creates 1000 objects!
String result = "";
for (int i = 0; i < 1000; i++) {
    result = result + i;  // New object each iteration
}

// Good: Use StringBuilder (modifies same object)
StringBuilder sb = new StringBuilder();
for (int i = 0; i < 1000; i++) {
    sb.append(i);
}
String result = sb.toString();
```

---

## Quick Reference Summary

### println() Selection

|Call|Method Used|
|---|---|
|`println(56)`|`println(int)`|
|`println("Hi")`|`println(String)`|
|`println(true)`|`println(boolean)`|
|`println(person)`|`println(Object)` → calls toString()|

### toString() Results

|Scenario|Output|
|---|---|
|No override|`ClassName@hashCode` (gibberish)|
|With override|Your custom string|

### Concatenation Behavior

|Expression|Result|Type|
|---|---|---|
|`"A" + 1`|`"A1"`|Concatenation|
|`'A' + 1`|`66`|Arithmetic (ASCII)|
|`"A" + 1 + 2`|`"A12"`|Left-to-right concat|
|`1 + 2 + "A"`|`"3A"`|Arithmetic first, then concat|

---

## Key Takeaways

1. **println() overloading:** Java picks method based on parameter type
    
2. **Hash code:** Default object representation = `ClassName@hashCode`
    
3. **toString() override:** Makes object printing readable and meaningful
    
4. **String concatenation:** Only operator overloading allowed in Java
    
5. **Automatic toString() call:** Happens when object concatenated with String
    
6. **String immutability:** Concatenation creates new objects, doesn't modify existing
    
7. **Character arithmetic:** `'A' + 1` = `66` (ASCII), but `"A" + 1` = `"A1"` (concat)
    

---

## Complete Mini Example

```java
class Person {
    String name;
    int age;
    
    Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    @Override
    public String toString() {
        return "Person{name='" + name + "', age=" + age + "}";
    }
    
    public static void main(String[] args) {
        // println() with different types
        System.out.println(56);           // int
        System.out.println("Hello");      // String
        
        // Object without toString() override
        // Would show: Person@15db9742
        
        // Object with toString() override
        Person p = new Person("Mukul", 25);
        System.out.println(p);
        // Output: Person{name='Mukul', age=25}
        
        // String concatenation with object
        String info = "Info: " + p;
        System.out.println(info);
        // Output: Info: Person{name='Mukul', age=25}
        
        // Character arithmetic vs concatenation
        System.out.println('A' + 1);           // 66 (arithmetic)
        System.out.println("Result: " + 'A' + 1);  // "Result: A1" (concat)
        
        // String immutability
        String s1 = "Hello";
        String s2 = s1 + " World";  // Creates new object
        System.out.println(s1);      // "Hello" (unchanged)
        System.out.println(s2);      // "Hello World" (new)
    }
}
```

**Output:**

```
56
Hello
Person{name='Mukul', age=25}
Info: Person{name='Mukul', age=25}
66
Result: A1
Hello
Hello World
```

---

## END OF STRING NOTES

so in java to learn string lets take a example of println() when we give println(56) a int it print a string in terminal there are multiple println() functions so which println will take taht argument so it depends onn parameter if our parameter is number our println having number argument will activate so our parameter can be an object or a int or a string or a null so for null there is a check null pointer exception and if we print object what we get a gibrish alphanumeric which is a hash code its the string representation of object so to pretty print we have to override println() have its on too string as i told you early that println() print in string in terminal so it also using tostring so to print our object we have to pretty print by giving a object specific tostring() unlike println() using default toString() if you noticed we are giving a fuction to pretty print inside println so here our explicit giving function override println() ok but there is a Q why string representation of a object is an hash ? in java concatination works very differently as operator overloading is not allow in java accepy strings if we add string with any complex object it convert to object (char)('a'+1) after concat formation of new object take place

make notes out of it