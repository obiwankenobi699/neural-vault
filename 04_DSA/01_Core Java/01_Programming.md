
---

## Table of Contents

1. [Type Systems: Static vs Dynamic Typing](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#1-type-systems)
2. [Compile Time vs Runtime](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#2-compile-time-vs-runtime)
3. [Memory Management: Stack and Heap](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#3-memory-management)
4. [Data Types](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#4-data-types)
5. [Operators and Precedence](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#5-operators)
6. [Primitive vs Non-Primitive Types](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#6-primitive-vs-non-primitive)
7. [Call by Value vs Call by Reference](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#7-parameter-passing)
8. [Understanding References with Real-World Examples](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#8-reference-examples)

---

# 1. Type Systems: Static vs Dynamic Typing {#1-type-systems}

## 1.1 Static Typing (Compile-Time Type Checking)

**Definition:** In statically-typed languages, variable types are known and checked at compile time. Once a variable is declared with a type, it cannot change.

**Characteristics:**

- Type must be declared explicitly or inferred at compile time
- Type checking happens before program execution
- Type errors caught during compilation
- Variables cannot change type after declaration
- Type information available during development

**Examples of Statically-Typed Languages:**

- Java
- C
- C++
- C#
- Go
- Rust
- TypeScript
- Swift
- Kotlin

**Code Example (Java):**

```java
// Static typing - type declared at compile time
int age = 25;              // age is integer type
String name = "Mukul";     // name is String type
double salary = 50000.50;  // salary is double type

// This will cause COMPILE-TIME ERROR
age = "Twenty Five";  // ERROR: cannot assign String to int
name = 123;           // ERROR: cannot assign int to String

// Type is fixed and enforced
age = 30;             // OK - still integer
name = "John";        // OK - still String
```

**Advantages of Static Typing:**

- Errors caught early (at compile time)
- Better performance (no runtime type checking)
- Better IDE support (autocomplete, refactoring)
- Self-documenting code (types visible)
- Easier to maintain large codebases
- Compiler optimizations possible

**Disadvantages of Static Typing:**

- More verbose code (type declarations)
- Less flexibility
- Longer development time initially
- Learning curve for complex type systems

---

## 1.2 Dynamic Typing (Runtime Type Checking)

**Definition:** In dynamically-typed languages, variable types are determined at runtime. Variables can hold values of any type and can change type during execution.

**Characteristics:**

- No explicit type declaration required
- Type checking happens during execution
- Variables can change type at runtime
- More flexible but error-prone
- Type errors discovered only when code executes

**Examples of Dynamically-Typed Languages:**

- Python
- JavaScript
- Ruby
- PHP
- Perl
- Lua

**Code Example (Python):**

```python
# Dynamic typing - type determined at runtime
age = 25              # age is int (inferred)
print(type(age))      # <class 'int'>

age = "Twenty Five"   # Now age is string - NO ERROR!
print(type(age))      # <class 'str'>

age = 30.5            # Now age is float - NO ERROR!
print(type(age))      # <class 'float'>

age = True            # Now age is boolean - NO ERROR!
print(type(age))      # <class 'bool'>

# Type can change freely at runtime
name = "Mukul"        # String
name = 123            # Now integer - perfectly valid
name = [1, 2, 3]      # Now list - still valid
```

**Advantages of Dynamic Typing:**

- Less verbose code
- Faster to write initially
- More flexible
- Easier for beginners
- Better for rapid prototyping
- Duck typing possible (if it walks like a duck...)

**Disadvantages of Dynamic Typing:**

- Errors discovered late (at runtime)
- Potential for more runtime errors
- Harder to maintain large codebases
- Less IDE support
- Performance overhead (runtime type checking)
- Need extensive testing

---

## 1.3 Static vs Dynamic Typing Comparison

```
Comparison Table

┌────────────────────┬─────────────────────┬─────────────────────┐
│ Feature            │ Static Typing       │ Dynamic Typing      │
├────────────────────┼─────────────────────┼─────────────────────┤
│ Type Declaration   │ Required/Inferred   │ Not required        │
│                    │ at compile time     │                     │
├────────────────────┼─────────────────────┼─────────────────────┤
│ Type Checking      │ Compile time        │ Runtime             │
├────────────────────┼─────────────────────┼─────────────────────┤
│ Type Changes       │ Not allowed         │ Allowed             │
├────────────────────┼─────────────────────┼─────────────────────┤
│ Error Detection    │ Early (compilation) │ Late (execution)    │
├────────────────────┼─────────────────────┼─────────────────────┤
│ Performance        │ Generally faster    │ Generally slower    │
├────────────────────┼─────────────────────┼─────────────────────┤
│ Code Verbosity     │ More verbose        │ Less verbose        │
├────────────────────┼─────────────────────┼─────────────────────┤
│ Flexibility        │ Less flexible       │ More flexible       │
├────────────────────┼─────────────────────┼─────────────────────┤
│ IDE Support        │ Excellent           │ Limited             │
├────────────────────┼─────────────────────┼─────────────────────┤
│ Large Projects     │ Better suited       │ Challenging         │
├────────────────────┼─────────────────────┼─────────────────────┤
│ Learning Curve     │ Steeper             │ Easier              │
└────────────────────┴─────────────────────┴─────────────────────┘
```

---

# 2. Compile Time vs Runtime {#2-compile-time-vs-runtime}

## 2.1 Compile Time

**Definition:** Compile time is the phase when source code is translated into machine code or bytecode by a compiler. This happens before the program executes.

**What Happens at Compile Time:**

- Source code syntax is checked
- Type checking (in statically-typed languages)
- Code is translated to machine code or intermediate code
- Optimization performed
- Errors detected and reported
- No program execution occurs

**Compile-Time Errors:**

- Syntax errors
- Type mismatches
- Undeclared variables
- Missing semicolons, brackets
- Wrong number of function arguments

```
Compilation Process Flow

Source Code          Compiler              Executable
(.java, .c)          Process               (.class, .exe)
    │                    │                      │
    │                    │                      │
    ▼                    ▼                      ▼
┌─────────┐         ┌─────────┐          ┌─────────┐
│ int x=5;│         │ Syntax  │          │ Machine │
│ String  │────────►│ Check   │─────────►│ Code or │
│ name =  │         │ Type    │          │ Bytecode│
│ "Mukul";│         │ Check   │          │         │
└─────────┘         └─────────┘          └─────────┘
                         │
                    ┌────▼────┐
                    │ Errors? │
                    └────┬────┘
                         │
                    If errors found:
                    Compilation STOPS
                    Program does NOT run
```

**Example (Java):**

```java
// Compile-time error examples
public class CompileTimeExample {
    public static void main(String[] args) {
        
        // Syntax error - missing semicolon
        int x = 10  // ERROR at compile time
        
        // Type error - wrong type assignment
        int age = "Twenty";  // ERROR at compile time
        
        // Undeclared variable
        System.out.println(salary);  // ERROR at compile time
        
        // Wrong method signature
        String text = "Hello";
        int length = text.length(5);  // ERROR - length() takes no args
    }
}

// These errors prevent compilation
// Program will NOT create .class file
// Program will NOT run
```

---

## 2.2 Runtime

**Definition:** Runtime is the phase when the compiled program is actually executing. This is when the program performs its intended operations.

**What Happens at Runtime:**

- Program instructions are executed
- Memory is allocated dynamically
- User input is processed
- Calculations are performed
- Exceptions may occur
- Program interacts with system resources

**Runtime Errors:**

- Division by zero
- Null pointer exceptions
- Array index out of bounds
- Stack overflow
- Out of memory
- File not found
- Network errors

```
Runtime Execution Flow

Program Start        Execution              Program End
     │                   │                      │
     │                   │                      │
     ▼                   ▼                      ▼
┌─────────┐         ┌─────────┐          ┌─────────┐
│ Load    │         │ Execute │          │ Clean   │
│ Program │────────►│ Instruc-│─────────►│ Up and  │
│ Into    │         │ tions   │          │ Exit    │
│ Memory  │         │ One by  │          │         │
└─────────┘         │ One     │          └─────────┘
                    └─────────┘
                         │
                    ┌────▼────┐
                    │Runtime  │
                    │Errors?  │
                    └────┬────┐
                         │
                    If error occurs:
                    Exception thrown
                    Program may crash
```

**Example (Java):**

```java
// Runtime error examples
public class RuntimeExample {
    public static void main(String[] args) {
        
        // Division by zero - runtime error
        int a = 10;
        int b = 0;
        int result = a / b;  // ArithmeticException at RUNTIME
        
        // Null pointer - runtime error
        String text = null;
        int length = text.length();  // NullPointerException at RUNTIME
        
        // Array index out of bounds - runtime error
        int[] numbers = {1, 2, 3};
        int value = numbers[5];  // ArrayIndexOutOfBoundsException at RUNTIME
        
        // These compile successfully but fail during execution
    }
}
```

---

## 2.3 Compile Time vs Runtime Comparison

```
Detailed Comparison

┌─────────────────────┬──────────────────────┬──────────────────────┐
│ Aspect              │ Compile Time         │ Runtime              │
├─────────────────────┼──────────────────────┼──────────────────────┤
│ When                │ Before execution     │ During execution     │
├─────────────────────┼──────────────────────┼──────────────────────┤
│ What Happens        │ Code translation     │ Code execution       │
│                     │ Type checking        │ Operations performed │
├─────────────────────┼──────────────────────┼──────────────────────┤
│ Common Errors       │ Syntax errors        │ Logic errors         │
│                     │ Type mismatches      │ Division by zero     │
│                     │ Undeclared variables │ Null references      │
│                     │ Missing symbols      │ Memory errors        │
├─────────────────────┼──────────────────────┼──────────────────────┤
│ Error Detection     │ Guaranteed before    │ May or may not occur │
│                     │ program runs         │ depending on path    │
├─────────────────────┼──────────────────────┼──────────────────────┤
│ Memory Allocation   │ Static (size known)  │ Dynamic (size varies)│
├─────────────────────┼──────────────────────┼──────────────────────┤
│ Can Be Prevented    │ Yes (fix code)       │ Sometimes (try-catch)│
├─────────────────────┼──────────────────────┼──────────────────────┤
│ Impact on User      │ No impact            │ Program may crash    │
│                     │ (user never sees)    │ (user affected)      │
└─────────────────────┴──────────────────────┴──────────────────────┘
```

---

# 3. Memory Management: Stack and Heap {#3-memory-management}

## 3.1 Program Memory Organization

When a program runs, the operating system allocates memory in different regions:

```
Memory Layout of a Program

High Memory Address
┌────────────────────────┐
│   STACK                │  ← Grows downward
│   - Local variables    │
│   - Function calls     │
│   - Parameters         │
│   - Return addresses   │
├────────────────────────┤
│                        │
│   Free Space           │
│                        │
├────────────────────────┤
│   HEAP                 │  ← Grows upward
│   - Dynamic allocation │
│   - Objects            │
│   - Arrays             │
├────────────────────────┤
│   BSS Segment          │
│   (Uninitialized data) │
├────────────────────────┤
│   Data Segment         │
│   (Initialized data)   │
├────────────────────────┤
│   Text/Code Segment    │
│   (Program instructions)│
└────────────────────────┘
Low Memory Address
```

---

## 3.2 Stack Memory

**Definition:** Stack is a region of memory that stores local variables, function parameters, and return addresses. It follows Last-In-First-Out (LIFO) principle.

**Characteristics:**

- Fixed size (determined at compile time)
- Very fast access (simple pointer manipulation)
- Automatically managed (no manual deallocation needed)
- Limited size (stack overflow if exceeded)
- Stores primitive types and references
- Memory deallocated when function returns
- Thread-specific (each thread has own stack)

**What is Stored on Stack:**

- Local variables (primitives)
- Function parameters
- Return addresses
- Reference variables (pointers to heap objects)
- Function call information

**Stack Operation Example:**

```
Stack Growth During Function Calls

main() starts:
┌────────────┐
│ int x = 10 │  ← Stack frame for main()
└────────────┘

main() calls foo(5):
┌────────────┐
│ return addr│  ← Stack frame for foo()
│ param: 5   │
│ int y = 20 │
├────────────┤
│ int x = 10 │  ← Stack frame for main()
└────────────┘

foo() calls bar():
┌────────────┐
│ return addr│  ← Stack frame for bar()
│ int z = 30 │
├────────────┤
│ return addr│  ← Stack frame for foo()
│ param: 5   │
│ int y = 20 │
├────────────┤
│ int x = 10 │  ← Stack frame for main()
└────────────┘

bar() returns:
┌────────────┐
│ return addr│  ← Stack frame for foo()
│ param: 5   │
│ int y = 20 │
├────────────┤
│ int x = 10 │  ← Stack frame for main()
└────────────┘

foo() returns:
┌────────────┐
│ int x = 10 │  ← Stack frame for main()
└────────────┘

LIFO: Last In, First Out
```

**Code Example (Java):**

```java
public class StackExample {
    public static void main(String[] args) {
        // All these are stored on STACK
        int age = 25;           // Primitive on stack
        double salary = 50000;  // Primitive on stack
        boolean isActive = true; // Primitive on stack
        
        // Reference variable stored on stack
        // But object it points to is on heap
        String name = "Mukul";  // 'name' reference on stack
                                // "Mukul" String object on heap
        
        calculateSum(10, 20);   // Parameters on stack
        
    } // When method ends, stack memory is freed automatically
    
    public static void calculateSum(int a, int b) {
        // 'a' and 'b' parameters stored on stack
        int sum = a + b;  // 'sum' local variable on stack
        System.out.println(sum);
    } // Stack frame deallocated when method returns
}
```

**Stack Overflow:**

```java
public class StackOverflowExample {
    // Infinite recursion causes stack overflow
    public static void recursiveMethod() {
        recursiveMethod();  // Keeps adding stack frames
        // Eventually: java.lang.StackOverflowError
    }
}
```

---

## 3.3 Heap Memory

**Definition:** Heap is a region of memory used for dynamic memory allocation. Objects are created on the heap and can be accessed from anywhere in the program.

**Characteristics:**

- Dynamic size (can grow as needed)
- Slower access than stack (requires pointer dereferencing)
- Manually managed in some languages (C, C++)
- Garbage collected in others (Java, Python, C#)
- Larger than stack
- Stores objects and arrays
- Shared among all threads
- Fragmentation can occur

**What is Stored on Heap:**

- Objects (class instances)
- Arrays
- Dynamically allocated data
- Strings (in Java)
- Collections (ArrayList, HashMap, etc.)

**Heap Memory Visualization:**

```
Heap Memory Structure

┌─────────────────────────────────────────┐
│  HEAP (Growing Upward)                  │
├─────────────────────────────────────────┤
│                                         │
│  Object 1: Person                       │
│  ┌─────────────────────┐                │
│  │ name: "Mukul"       │  ← Memory address: 0x1234
│  │ age: 25             │                │
│  │ height: 5.8         │                │
│  └─────────────────────┘                │
│                                         │
│  Object 2: Person                       │
│  ┌─────────────────────┐                │
│  │ name: "John"        │  ← Memory address: 0x5678
│  │ age: 30             │                │
│  │ height: 6.0         │                │
│  └─────────────────────┘                │
│                                         │
│  Array: int[]                           │
│  ┌─────────────────────┐                │
│  │ [10, 20, 30, 40]    │  ← Memory address: 0x9ABC
│  └─────────────────────┘                │
│                                         │
│  String: "Hello World"                  │
│  ┌─────────────────────┐                │
│  │ "Hello World"       │  ← Memory address: 0xDEF0
│  └─────────────────────┘                │
│                                         │
└─────────────────────────────────────────┘
```

**Code Example (Java):**

```java
public class HeapExample {
    public static void main(String[] args) {
        // Objects created on HEAP
        Person person1 = new Person("Mukul", 25);  
        // person1 reference variable: STACK
        // Person object: HEAP
        
        Person person2 = new Person("John", 30);
        // person2 reference variable: STACK
        // Person object: HEAP
        
        // Array created on HEAP
        int[] numbers = new int[5];
        // numbers reference variable: STACK
        // Array [0,0,0,0,0]: HEAP
        
        // String created on HEAP
        String message = new String("Hello");
        // message reference variable: STACK
        // String object: HEAP
        
    } // Objects remain on heap until garbage collected
}

class Person {
    String name;  // Stored on heap (part of object)
    int age;      // Stored on heap (part of object)
    
    Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
}
```

**Garbage Collection:**

```
When objects are no longer referenced, they become eligible for garbage collection

BEFORE:                          AFTER GC:
Stack:         Heap:              Stack:         Heap:
┌────────┐    ┌───────────┐      ┌────────┐    ┌───────────┐
│person1 │───►│Person obj1│      │person1 │───►│Person obj1│
└────────┘    └───────────┘      └────────┘    └───────────┘
┌────────┐    ┌───────────┐      ┌────────┐    
│person2 │───►│Person obj2│      │person2 │───► null
└────────┘    └───────────┘      └────────┘    

person2 = null;                   obj2 garbage collected
                                  Memory freed automatically
```

---

## 3.4 Stack vs Heap Comparison

```
Comprehensive Comparison

┌────────────────────┬─────────────────────┬─────────────────────┐
│ Feature            │ Stack               │ Heap                │
├────────────────────┼─────────────────────┼─────────────────────┤
│ Size               │ Small (1-8 MB)      │ Large (limited by   │
│                    │                     │ system RAM)         │
├────────────────────┼─────────────────────┼─────────────────────┤
│ Speed              │ Very fast           │ Slower              │
├────────────────────┼─────────────────────┼─────────────────────┤
│ Allocation         │ Automatic           │ Manual (new keyword)│
├────────────────────┼─────────────────────┼─────────────────────┤
│ Deallocation       │ Automatic           │ Garbage collector   │
│                    │ (when scope ends)   │ or manual (C/C++)   │
├────────────────────┼─────────────────────┼─────────────────────┤
│ Access Pattern     │ LIFO                │ Random access       │
├────────────────────┼─────────────────────┼─────────────────────┤
│ Stores             │ Primitives          │ Objects             │
│                    │ References          │ Arrays              │
│                    │ Local variables     │ Strings             │
├────────────────────┼─────────────────────┼─────────────────────┤
│ Scope              │ Local to function   │ Global (until GC)   │
├────────────────────┼─────────────────────┼─────────────────────┤
│ Thread Safety      │ Each thread has own │ Shared among threads│
├────────────────────┼─────────────────────┼─────────────────────┤
│ Fragmentation      │ No                  │ Yes (can occur)     │
├────────────────────┼─────────────────────┼─────────────────────┤
│ Error              │ Stack Overflow      │ Out of Memory       │
├────────────────────┼─────────────────────┼─────────────────────┤
│ Growth Direction   │ Downward (usually)  │ Upward              │
└────────────────────┴─────────────────────┴─────────────────────┘
```

---

# 4. Data Types {#4-data-types}

## 4.1 Overview of Data Types

Data types define what kind of value a variable can hold and what operations can be performed on it.

```
Data Type Hierarchy

                    Data Types
                        │
        ┌───────────────┴───────────────┐
        │                               │
    Primitive                      Non-Primitive
    (Basic Types)                  (Reference Types)
        │                               │
   ┌────┴────┐                     ┌────┴────┐
   │         │                     │         │
Numeric   Non-Numeric          Classes   Arrays
   │         │                     │         │
┌──┴──┐   ┌─┴─┐              Interfaces  Strings
│     │   │   │                  │
Integer Float  Boolean      Enumerations
│     │    │   Char
byte  float  
short double
int
long
```

---

## 4.2 Primitive Data Types

**Definition:** Primitive data types are the most basic data types built into the language. They store simple values directly in memory.

### Integer Types (Whole Numbers)

```
Integer Data Types in Java

┌──────────┬──────────┬─────────────────┬───────────────────────┐
│ Type     │ Size     │ Range           │ Example               │
├──────────┼──────────┼─────────────────┼───────────────────────┤
│ byte     │ 1 byte   │ -128 to 127     │ byte age = 25;        │
│          │ (8 bits) │                 │                       │
├──────────┼──────────┼─────────────────┼───────────────────────┤
│ short    │ 2 bytes  │ -32,768 to      │ short year = 2024;    │
│          │ (16 bits)│  32,767         │                       │
├──────────┼──────────┼─────────────────┼───────────────────────┤
│ int      │ 4 bytes  │ -2³¹ to 2³¹-1   │ int population =      │
│          │ (32 bits)│ (~-2B to ~2B)   │ 1000000;              │
├──────────┼──────────┼─────────────────┼───────────────────────┤
│ long     │ 8 bytes  │ -2⁶³ to 2⁶³-1   │ long distance =       │
│          │ (64 bits)│ (very large)    │ 123456789L;           │
└──────────┴──────────┴─────────────────┴───────────────────────┘

Note: Use 'L' suffix for long literals
```

### Floating-Point Types (Decimal Numbers)

```
Floating-Point Data Types in Java

┌──────────┬──────────┬─────────────────┬───────────────────────┐
│ Type     │ Size     │ Precision       │ Example               │
├──────────┼──────────┼─────────────────┼───────────────────────┤
│ float    │ 4 bytes  │ 6-7 decimal     │ float pi = 3.14f;     │
│          │ (32 bits)│ digits          │ float price = 99.99f; │
├──────────┼──────────┼─────────────────┼───────────────────────┤
│ double   │ 8 bytes  │ 15-16 decimal   │ double salary =       │
│          │ (64 bits)│ digits          │ 75000.50;             │
│          │          │                 │ double pi = 3.14159;  │
└──────────┴──────────┴─────────────────┴───────────────────────┘

Note: Use 'f' suffix for float literals
      double is default for decimal numbers
```

### Character Type

```
Character Data Type

┌──────────┬──────────┬─────────────────┬───────────────────────┐
│ Type     │ Size     │ Range           │ Example               │
├──────────┼──────────┼─────────────────┼───────────────────────┤
│ char     │ 2 bytes  │ 0 to 65,535     │ char letter = 'A';    │
│          │ (16 bits)│ (Unicode)       │ char digit = '5';     │
│          │          │                 │ char symbol = '@';    │
└──────────┴──────────┴─────────────────┴───────────────────────┘

Note: Uses single quotes ''
      Can store any Unicode character
```

### Boolean Type

```
Boolean Data Type

┌──────────┬──────────┬─────────────────┬───────────────────────┐
│ Type     │ Size     │ Values          │ Example               │
├──────────┼──────────┼─────────────────┼───────────────────────┤
│ boolean  │ 1 bit    │ true or false   │ boolean isActive =    │
│          │ (JVM     │                 │ true;                 │
│          │ specific)│                 │ boolean hasError =    │
│          │          │                 │ false;                │
└──────────┴──────────┴─────────────────┴───────────────────────┘

Note: Stores logical values only
      Not equivalent to 0 or 1 (unlike C)
```

**Code Example:**

```java
public class PrimitiveTypes {
    public static void main(String[] args) {
        // Integer types
        byte age = 25;              // Small whole numbers
        short year = 2024;          // Medium whole numbers
        int population = 1000000;   // Default for integers
        long distance = 9876543210L; // Large numbers (note L)
        
        // Floating-point types
        float price = 99.99f;       // Single precision (note f)
        double salary = 75000.50;   // Double precision (default)
        
        // Character type
        char grade = 'A';           // Single character
        char symbol = '@';          // Symbols
        
        // Boolean type
        boolean isStudent = true;   // Logical values
        boolean hasLicense = false;
        
        // All primitives stored directly on stack
        System.out.println("Age: " + age);
        System.out.println("Is Student: " + isStudent);
    }
}
```

---

## 4.3 Non-Primitive (Reference) Data Types

**Definition:** Non-primitive types are created by the programmer and are not defined by the language. They are called reference types because they refer to objects.

### Common Non-Primitive Types:

**1. Classes**

```java
// User-defined class
class Person {
    String name;
    int age;
    
    Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
}

// Usage
Person person = new Person("Mukul", 25);
// 'person' is reference variable (stack)
// Person object is on heap
```

**2. Strings**

```java
// String is a class (non-primitive)
String name = "Mukul";           // String literal
String message = new String("Hello"); // String object

// Strings are immutable in Java
name = name + " Kumar";  // Creates new String object
```

**3. Arrays**

```java
// Array of primitives
int[] numbers = {10, 20, 30, 40};
// numbers reference on stack
// array [10,20,30,40] on heap

// Array of objects
Person[] people = new Person[3];
people[0] = new Person("Mukul", 25);
people[1] = new Person("John", 30);
// people reference on stack
// array and Person objects on heap
```

**4. Interfaces**

```java
interface Drawable {
    void draw();
}

class Circle implements Drawable {
    public void draw() {
        System.out.println("Drawing circle");
    }
}
```

**5. Enumerations**

```java
enum Day {
    MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY
}

Day today = Day.MONDAY;
```

---

## 4.4 Primitive vs Non-Primitive Comparison

```
Key Differences

┌─────────────────────┬────────────────────┬────────────────────┐
│ Feature             │ Primitive          │ Non-Primitive      │
├─────────────────────┼────────────────────┼────────────────────┤
│ Definition          │ Built-in language  │ User-defined or    │
│                     │ types              │ complex types      │
├─────────────────────┼────────────────────┼────────────────────┤
│ Storage             │ Store actual value │ Store reference    │
│                     │                    │ (memory address)   │
├─────────────────────┼────────────────────┼────────────────────┤
│ Memory Location     │ Stack              │ Reference on stack │
│                     │                    │ Object on heap     │
├─────────────────────┼────────────────────┼────────────────────┤
│ Size                │ Fixed size         │ Variable size      │
├─────────────────────┼────────────────────┼────────────────────┤
│ Default Value       │ 0, 0.0, false, \0  │ null               │
├─────────────────────┼────────────────────┼────────────────────┤
│ Comparison          │ Use == operator    │ Use .equals()      │
│                     │ (compares values)  │ (compares content) │
├─────────────────────┼────────────────────┼────────────────────┤
│ Can be null         │ No                 │ Yes                │
├─────────────────────┼────────────────────┼────────────────────┤
│ Methods Available   │ No                 │ Yes                │
├─────────────────────┼────────────────────┼────────────────────┤
│ Examples            │ int, double, char  │ String, Arrays,    │
│                     │ boolean            │ Classes            │
└─────────────────────┴────────────────────┴────────────────────┘
```

---

# 5. Operators and Precedence {#5-operators}

## 5.1 Types of Operators

### Arithmetic Operators

```java
int a = 10, b = 3;

// Basic arithmetic
int sum = a + b;        // Addition: 13
int diff = a - b;       // Subtraction: 7
int product = a * b;    // Multiplication: 30
int quotient = a / b;   // Division: 3 (integer division)
int remainder = a % b;  // Modulus: 1

// Special cases
double result = 10.0 / 3;  // 3.333... (floating-point division)
int result2 = 10 / 3;      // 3 (integer division, no decimals)
```

### Assignment Operators

```java
int x = 10;      // Simple assignment

// Compound assignment
x += 5;   // x = x + 5  → 15
x -= 3;   // x = x - 3  → 12
x *= 2;   // x = x * 2  → 24
x /= 4;   // x = x / 4  → 6
x %= 4;   // x = x % 4  → 2
```

### Comparison (Relational) Operators

```java
int a = 10, b = 20;

boolean result1 = a == b;  // Equal to: false
boolean result2 = a != b;  // Not equal to: true
boolean result3 = a > b;   // Greater than: false
boolean result4 = a < b;   // Less than: true
boolean result5 = a >= 10; // Greater than or equal: true
boolean result6 = b <= 20; // Less than or equal: true
```

### Logical Operators

```java
boolean x = true, y = false;

// Logical AND (both must be true)
boolean result1 = x && y;  // false

// Logical OR (at least one must be true)
boolean result2 = x || y;  // true

// Logical NOT (inverts boolean)
boolean result3 = !x;      // false
boolean result4 = !y;      // true

// Short-circuit evaluation
boolean result5 = false && (10/0 > 0);  // false (doesn't evaluate second part)
```

### Unary Operators

```java
int a = 10;

// Increment/Decrement
int b = ++a;  // Pre-increment: a becomes 11, then b = 11
int c = a++;  // Post-increment: c = 11, then a becomes 12
int d = --a;  // Pre-decrement: a becomes 11, then d = 11
int e = a--;  // Post-decrement: e = 11, then a becomes 10

// Unary plus and minus
int positive = +10;   // Positive value
int negative = -10;   // Negative value

// Logical complement
boolean flag = true;
boolean opposite = !flag;  // false
```

### Bitwise Operators

```java
int a = 5;   // Binary: 0101
int b = 3;   // Binary: 0011

int result1 = a & b;   // AND: 0001 (1)
int result2 = a | b;   // OR: 0111 (7)
int result3 = a ^ b;   // XOR: 0110 (6)
int result4 = ~a;      // NOT: ...11111010 (-6)
int result5 = a << 1;  // Left shift: 1010 (10)
int result6 = a >> 1;  // Right shift: 0010 (2)
```

### Ternary Operator

```java
// Syntax: condition ? value_if_true : value_if_false

int age = 20;
String status = (age >= 18) ? "Adult" : "Minor";
// Result: "Adult"

int max = (a > b) ? a : b;  // Gets maximum of two numbers
```

---

## 5.2 Operator Precedence (Priority)

**Definition:** Operator precedence determines the order in which operators are evaluated in an expression. Higher precedence operators are evaluated first.

```
Operator Precedence Table (Highest to Lowest)

┌──────────┬─────────────────────────────┬────────────────────┐
│ Priority │ Operators                   │ Associativity      │
├──────────┼─────────────────────────────┼────────────────────┤
│ 1        │ ()  []  .                   │ Left to Right      │
│ (Highest)│ Parentheses, Array, Member  │                    │
├──────────┼─────────────────────────────┼────────────────────┤
│ 2        │ ++  --  !  ~  +  -          │ Right to Left      │
│          │ Unary operators             │                    │
├──────────┼─────────────────────────────┼────────────────────┤
│ 3        │ *  /  %                     │ Left to Right      │
│          │ Multiplication, Division    │                    │
├──────────┼─────────────────────────────┼────────────────────┤
│ 4        │ +  -                        │ Left to Right      │
│          │ Addition, Subtraction       │                    │
├──────────┼─────────────────────────────┼────────────────────┤
│ 5        │ <<  >>  >>>                 │ Left to Right      │
│          │ Bitwise shift               │                    │
├──────────┼─────────────────────────────┼────────────────────┤
│ 6        │ <  <=  >  >=                │ Left to Right      │
│          │ Relational                  │                    │
├──────────┼─────────────────────────────┼────────────────────┤
│ 7        │ ==  !=                      │ Left to Right      │
│          │ Equality                    │                    │
├──────────┼─────────────────────────────┼────────────────────┤
│ 8        │ &                           │ Left to Right      │
│          │ Bitwise AND                 │                    │
├──────────┼─────────────────────────────┼────────────────────┤
│ 9        │ ^                           │ Left to Right      │
│          │ Bitwise XOR                 │                    │
├──────────┼─────────────────────────────┼────────────────────┤
│ 10       │ |                           │ Left to Right      │
│          │ Bitwise OR                  │                    │
├──────────┼─────────────────────────────┼────────────────────┤
│ 11       │ &&                          │ Left to Right      │
│          │ Logical AND                 │                    │
├──────────┼─────────────────────────────┼────────────────────┤
│ 12       │ ||                          │ Left to Right      │
│          │ Logical OR                  │                    │
├──────────┼─────────────────────────────┼────────────────────┤
│ 13       │ ?:                          │ Right to Left      │
│          │ Ternary conditional         │                    │
├──────────┼─────────────────────────────┼────────────────────┤
│ 14       │ =  +=  -=  *=  /=  %=       │ Right to Left      │
│ (Lowest) │ Assignment operators        │                    │
└──────────┴─────────────────────────────┴────────────────────┘
```

---

## 5.3 Associativity: Left to Right vs Right to Left

**Definition:** Associativity determines the order of evaluation when operators have the same precedence.

### Left-to-Right Associativity (Most Operators)

```java
// Arithmetic operators: Left to Right
int result1 = 10 - 5 - 2;
// Evaluation: (10 - 5) - 2 = 5 - 2 = 3

int result2 = 20 / 4 / 2;
// Evaluation: (20 / 4) / 2 = 5 / 2 = 2

int result3 = 100 % 30 % 4;
// Evaluation: (100 % 30) % 4 = 10 % 4 = 2

// Multiplication and division: Left to Right
int result4 = 10 * 2 / 5;
// Evaluation: (10 * 2) / 5 = 20 / 5 = 4
```

### Right-to-Left Associativity (Special Cases)

**1. Assignment Operators**

```java
// Assignment: Right to Left
int a, b, c;
a = b = c = 10;
// Evaluation: a = (b = (c = 10))
// First: c = 10
// Then: b = 10
// Finally: a = 10

int x, y, z;
x = y = z = 5 + 3;
// Evaluation: x = (y = (z = (5 + 3)))
// First: 5 + 3 = 8
// Then: z = 8
// Then: y = 8
// Finally: x = 8
```

**2. Unary Operators**

```java
// Unary operators: Right to Left
int a = 10;
int result = -++a;
// Evaluation: -(++a)
// First: ++a (a becomes 11)
// Then: -11
// Result: -11

boolean flag = true;
boolean result2 = !!flag;
// Evaluation: !(!flag)
// First: !flag = false
// Then: !false = true
// Result: true
```

**3. POWER OPERATOR (Exponentiation) - Right to Left**

```java
// Note: Java doesn't have built-in power operator
// But languages like Python do: **

// Python example (Right to Left):
# result = 2 ** 3 ** 2
# Evaluation: 2 ** (3 ** 2)
# First: 3 ** 2 = 9
# Then: 2 ** 9 = 512
# Result: 512

// In Java, use Math.pow()
double result = Math.pow(2, Math.pow(3, 2));
// Same logic: 2^(3^2) = 2^9 = 512
```

**4. Ternary Operator**

```java
// Ternary: Right to Left
int a = 10, b = 20, c = 30;
int max = a > b ? a : b > c ? b : c;
// Evaluation: a > b ? a : (b > c ? b : c)
// First: b > c ? b : c → false ? 20 : 30 → 30
// Then: a > b ? a : 30 → false ? 10 : 30 → 30
// Result: 30
```

---

## 5.4 Complex Expression Evaluation Examples

**Example 1: Mixed Operators**

```java
int result = 10 + 20 * 3 / 2 - 5;

// Step-by-step evaluation:
// Precedence: * and / (left to right) > + and - (left to right)

// Step 1: 20 * 3 = 60
result = 10 + 60 / 2 - 5;

// Step 2: 60 / 2 = 30
result = 10 + 30 - 5;

// Step 3: 10 + 30 = 40 (left to right)
result = 40 - 5;

// Step 4: 40 - 5 = 35
result = 35;

// Final result: 35
```

**Example 2: With Parentheses**

```java
int result = (10 + 20) * (3 + 2) / 5;

// Parentheses have highest precedence
// Step 1: (10 + 20) = 30
result = 30 * (3 + 2) / 5;

// Step 2: (3 + 2) = 5
result = 30 * 5 / 5;

// Step 3: 30 * 5 = 150 (left to right)
result = 150 / 5;

// Step 4: 150 / 5 = 30
result = 30;

// Final result: 30
```

**Example 3: With Increment Operators**

```java
int a = 5;
int result = ++a * a++;

// Step 1: ++a (pre-increment)
// a becomes 6 first, then use 6
result = 6 * a++;

// Step 2: a++ (post-increment)
// Use current value 6, then a becomes 7
result = 6 * 6;

// Step 3: Multiply
result = 36;

// Final: result = 36, a = 7
```

**Example 4: Logical Operators**

```java
boolean result = true || false && false;

// Precedence: && > ||
// Step 1: false && false = false
result = true || false;

// Step 2: true || false = true
result = true;

// Final result: true

// With parentheses to change order:
boolean result2 = (true || false) && false;
// Step 1: (true || false) = true
result2 = true && false;
// Step 2: true && false = false
result2 = false;
// Final result: false
```

---

# 6. Primitive vs Non-Primitive: Deep Dive {#6-primitive-vs-non-primitive}

## 6.1 Memory Storage Difference

```
Memory Layout Comparison

PRIMITIVE TYPES (Value stored directly):

Stack:
┌────────────────────┐
│ int age = 25       │  ← Value 25 stored directly
├────────────────────┤
│ double price = 99.5│  ← Value 99.5 stored directly
├────────────────────┤
│ char grade = 'A'   │  ← Value 'A' stored directly
├────────────────────┤
│ boolean flag = true│  ← Value true stored directly
└────────────────────┘

NON-PRIMITIVE TYPES (Reference stored):

Stack:                     Heap:
┌────────────────────┐    ┌──────────────────────┐
│ Person p1          │───►│ Person object        │
│ (reference: 0x1234)│    │ name: "Mukul"        │
├────────────────────┤    │ age: 25              │
│ String name        │─┐  └──────────────────────┘
│ (reference: 0x5678)│ │
├────────────────────┤ │  ┌──────────────────────┐
│ int[] arr          │─┼─►│ String object        │
│ (reference: 0x9ABC)│ │  │ "Mukul"              │
└────────────────────┘ │  └──────────────────────┘
                       │
                       │  ┌──────────────────────┐
                       └─►│ Array object         │
                          │ [10, 20, 30, 40, 50] │
                          └──────────────────────┘
```

---

## 6.2 Comparison: == vs .equals()

### Primitive Types: Use ==

```java
// Primitives: == compares actual values
int a = 10;
int b = 10;
System.out.println(a == b);  // true (values are equal)

double x = 5.5;
double y = 5.5;
System.out.println(x == y);  // true (values are equal)

char c1 = 'A';
char c2 = 'A';
System.out.println(c1 == c2);  // true (values are equal)
```

### Non-Primitive Types: Use .equals()

```java
// Non-primitives: == compares references (memory addresses)
String str1 = new String("Hello");
String str2 = new String("Hello");

System.out.println(str1 == str2);      // false (different objects)
System.out.println(str1.equals(str2)); // true (same content)

// String literals are special (stored in String pool)
String str3 = "Hello";
String str4 = "Hello";
System.out.println(str3 == str4);      // true (same reference in pool)
```

```
Visual Explanation:

Stack:                     Heap:
┌────────────┐            ┌─────────────┐
│ str1: 0x100│───────────►│ "Hello"     │ (Object 1)
├────────────┤            └─────────────┘
│ str2: 0x200│───────┐
└────────────┘       │    ┌─────────────┐
                     └───►│ "Hello"     │ (Object 2)
                          └─────────────┘

str1 == str2 → Compares 0x100 == 0x200 → false
str1.equals(str2) → Compares content → true
```

---

## 6.3 Null Values

```java
// Primitives CANNOT be null
int age = null;        // COMPILE ERROR!
boolean flag = null;   // COMPILE ERROR!

// Non-primitives CAN be null
String name = null;    // OK - no object assigned
Person person = null;  // OK - no object assigned
int[] numbers = null;  // OK - no array assigned

// Null Pointer Exception
String text = null;
int length = text.length();  // NullPointerException at runtime!
```

---

## 6.4 Default Values

```java
class DefaultValues {
    // Instance variables (class level)
    
    // Primitive defaults
    int number;          // Default: 0
    double decimal;      // Default: 0.0
    boolean flag;        // Default: false
    char character;      // Default: '\u0000' (null character)
    
    // Non-primitive defaults
    String text;         // Default: null
    Person person;       // Default: null
    int[] array;         // Default: null
    
    void printDefaults() {
        System.out.println(number);    // 0
        System.out.println(decimal);   // 0.0
        System.out.println(flag);      // false
        System.out.println(text);      // null
    }
}

// Note: Local variables have NO default values
void method() {
    int x;
    System.out.println(x);  // COMPILE ERROR: variable not initialized
}
```

---

# 7. Call by Value vs Call by Reference {#7-parameter-passing}

## 7.1 Important: Java is ALWAYS Call by Value

**Key Concept:** Java ALWAYS passes arguments by value, but the behavior differs between primitives and objects because of what "value" means.

- For primitives: The actual value is copied
- For objects: The reference value (memory address) is copied

---

## 7.2 Call by Value (Primitives)

**Definition:** A copy of the actual value is passed to the method. Changes made to the parameter inside the method do NOT affect the original variable.

```java
public class CallByValueExample {
    public static void main(String[] args) {
        int number = 10;
        System.out.println("Before: " + number);  // 10
        
        modifyPrimitive(number);
        
        System.out.println("After: " + number);   // 10 (unchanged!)
    }
    
    static void modifyPrimitive(int n) {
        n = 20;  // Changes only the local copy
        System.out.println("Inside method: " + n);  // 20
    }
}
```

```
Memory Visualization:

BEFORE method call:
main():                  
┌────────────┐
│ number: 10 │
└────────────┘

DURING method call:
main():                  modifyPrimitive():
┌────────────┐          ┌────────────┐
│ number: 10 │          │ n: 10      │ ← Copy created
└────────────┘          └────────────┘

INSIDE method (n = 20):
main():                  modifyPrimitive():
┌────────────┐          ┌────────────┐
│ number: 10 │          │ n: 20      │ ← Only copy changed
└────────────┘          └────────────┘

AFTER method returns:
main():                  modifyPrimitive():
┌────────────┐          [Stack frame removed]
│ number: 10 │ ← Original unchanged!
└────────────┘
```

---

## 7.3 Call by Value (Objects) - The Confusion

**Reality:** Java passes the reference BY VALUE. The reference is copied, but both copies point to the SAME object.

```java
public class CallByValueObjectExample {
    public static void main(String[] args) {
        Person person = new Person("Mukul", 25);
        System.out.println("Before: " + person.name);  // Mukul
        
        modifyObject(person);
        
        System.out.println("After: " + person.name);   // John (changed!)
    }
    
    static void modifyObject(Person p) {
        p.name = "John";  // Modifies the same object
        System.out.println("Inside method: " + p.name);  // John
    }
}

class Person {
    String name;
    int age;
    
    Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
}
```

```
Memory Visualization:

BEFORE method call:
Stack:                     Heap:
┌────────────┐            ┌──────────────┐
│ person:    │───────────►│ Person       │
│ 0x1234     │            │ name: "Mukul"│
└────────────┘            │ age: 25      │
                          └──────────────┘

DURING method call (Reference copied):
Stack:                     Heap:
main():                    ┌──────────────┐
┌────────────┐        ┌──►│ Person       │
│ person:    │────────┘   │ name: "Mukul"│
│ 0x1234     │            │ age: 25      │
└────────────┘            └──────────────┘
                              ▲
modifyObject():               │
┌────────────┐                │
│ p: 0x1234  │────────────────┘
└────────────┘
Both references point to SAME object!

INSIDE method (p.name = "John"):
Stack:                     Heap:
main():                    ┌──────────────┐
┌────────────┐        ┌──►│ Person       │
│ person:    │────────┘   │ name: "John" │ ← Object modified
│ 0x1234     │            │ age: 25      │
└────────────┘            └──────────────┘
                              ▲
modifyObject():               │
┌────────────┐                │
│ p: 0x1234  │────────────────┘
└────────────┘

AFTER method returns:
Stack:                     Heap:
┌────────────┐            ┌──────────────┐
│ person:    │───────────►│ Person       │
│ 0x1234     │            │ name: "John" │ ← Change persists!
└────────────┘            │ age: 25      │
                          └──────────────┘
```

---

## 7.4 What if We Reassign the Reference?

```java
public class ReferenceReassignment {
    public static void main(String[] args) {
        Person person = new Person("Mukul", 25);
        System.out.println("Before: " + person.name);  // Mukul
        
        reassignReference(person);
        
        System.out.println("After: " + person.name);   // Mukul (unchanged!)
    }
    
    static void reassignReference(Person p) {
        p = new Person("John", 30);  // Creates NEW object
        System.out.println("Inside: " + p.name);  // John
    }
}
```

```
Memory Visualization:

BEFORE method call:
Stack:                     Heap:
┌────────────┐            ┌──────────────┐
│ person:    │───────────►│ Person       │ Object A
│ 0x1234     │            │ name: "Mukul"│
└────────────┘            │ age: 25      │
                          └──────────────┘

DURING method call (Reference copied):
Stack:                     Heap:
main():                    ┌──────────────┐
┌────────────┐        ┌──►│ Person       │ Object A
│ person:    │────────┘   │ name: "Mukul"│
│ 0x1234     │            │ age: 25      │
└────────────┘            └──────────────┘
                              ▲
reassignReference():          │
┌────────────┐                │
│ p: 0x1234  │────────────────┘
└────────────┘

INSIDE method (p = new Person(...)):
Stack:                     Heap:
main():                    ┌──────────────┐
┌────────────┐            │ Person       │ Object A
│ person:    │───────────►│ name: "Mukul"│
│ 0x1234     │            │ age: 25      │
└────────────┘            └──────────────┘
                          
reassignReference():       ┌──────────────┐
┌────────────┐            │ Person       │ Object B
│ p: 0x5678  │───────────►│ name: "John" │ (New object)
└────────────┘            │ age: 30      │
                          └──────────────┘
p now points to different object!
main's person still points to Object A

AFTER method returns:
Stack:                     Heap:
┌────────────┐            ┌──────────────┐
│ person:    │───────────►│ Person       │ Object A
│ 0x1234     │            │ name: "Mukul"│ ← Unchanged!
└────────────┘            │ age: 25      │
                          └──────────────┘
                          
                          ┌──────────────┐
                          │ Person       │ Object B
                          │ name: "John" │ (Eligible for GC)
                          │ age: 30      │
                          └──────────────┘
```

**Key Takeaway:** Reassigning the parameter creates a new object, but the original reference in the caller remains unchanged.

---

# 8. Understanding References with Real-World Examples {#8-reference-examples}

## 8.1 The Name-Person Analogy

### Scenario: Multiple Names for Same Person

```java
public class ReferenceExample {
    public static void main(String[] args) {
        // Create a Person object
        Person mukul = new Person("Mukul Kumar", 25);
        
        // Another reference to the SAME person
        Person son = mukul;
        
        // mukul and son both refer to the SAME Person object
        System.out.println("Via mukul: " + mukul.name);  // Mukul Kumar
        System.out.println("Via son: " + son.name);      // Mukul Kumar
        
        // Change through 'son' reference
        son.name = "Mukul Kumar Singh";
        
        // Change visible through BOTH references
        System.out.println("Via mukul: " + mukul.name);  // Mukul Kumar Singh
        System.out.println("Via son: " + son.name);      // Mukul Kumar Singh
        
        // Why? Because both point to SAME object
        System.out.println(mukul == son);  // true (same reference)
    }
}

class Person {
    String name;
    int age;
    
    Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
}
```

```
Memory Visualization: name = mukul, son = mukul

Stack:                          Heap:
┌─────────────┐                ┌────────────────────────┐
│ mukul:      │───────────────►│ Person object          │
│ 0x1234      │                │ ├─ name: "Mukul Kumar" │
├─────────────┤           ┌───►│ └─ age: 25             │
│ son:        │───────────┘    └────────────────────────┘
│ 0x1234      │
└─────────────┘
Both references point to SAME Person object!

Real-world analogy:
┌────────────────────────────────────────────────────┐
│ "mukul" = Reference variable (like a nickname)     │
│ "son" = Another reference variable (another name)  │
│ Person object = The actual person (Mukul Kumar)    │
│                                                    │
│ Just like one person can have multiple names:      │
│ - Legal name: Mukul Kumar                         │
│ - Nickname: mukul                                  │
│ - Relation: son                                    │
│                                                    │
│ All names refer to the SAME person!               │
└────────────────────────────────────────────────────┘
```

**Important Points:**

- `mukul` and `son` are reference variables (names/labels)
- They both store the same memory address (0x1234)
- There is only ONE Person object in memory
- Changes through any reference affect the same object
- The Person object exists independently of the references

---

## 8.2 Variable Assignment Examples

### Example 1: Primitive Assignment (a = 10, b = 10)

```java
public class PrimitiveAssignment1 {
    public static void main(String[] args) {
        // Separate assignments
        int a = 10;
        int b = 10;
        
        System.out.println("a = " + a);  // 10
        System.out.println("b = " + b);  // 10
        
        // Change a
        a = 20;
        
        System.out.println("After a = 20:");
        System.out.println("a = " + a);  // 20
        System.out.println("b = " + b);  // 10 (unchanged)
    }
}
```

```
Memory Visualization:

INITIAL STATE (a = 10, b = 10):
Stack:
┌────────────┐
│ a: 10      │  ← Separate memory location
├────────────┤
│ b: 10      │  ← Separate memory location
└────────────┘

Two independent variables
Each has its own copy of value 10

AFTER (a = 20):
Stack:
┌────────────┐
│ a: 20      │  ← Changed independently
├────────────┤
│ b: 10      │  ← Remains unchanged
└────────────┘

Key Point: a and b are completely independent
```

---

### Example 2: Primitive Assignment (a = 10, b = a)

```java
public class PrimitiveAssignment2 {
    public static void main(String[] args) {
        // a assigned first
        int a = 10;
        
        // b gets COPY of a's value
        int b = a;
        
        System.out.println("a = " + a);  // 10
        System.out.println("b = " + b);  // 10
        
        // Change a
        a = 20;
        
        System.out.println("After a = 20:");
        System.out.println("a = " + a);  // 20
        System.out.println("b = " + b);  // 10 (still unchanged)
        
        // Change b
        b = 30;
        
        System.out.println("After b = 30:");
        System.out.println("a = " + a);  // 20 (unchanged)
        System.out.println("b = " + b);  // 30
    }
}
```

```
Memory Visualization:

STATE 1 (a = 10):
Stack:
┌────────────┐
│ a: 10      │
└────────────┘

STATE 2 (b = a):
Stack:
┌────────────┐
│ a: 10      │
├────────────┤
│ b: 10      │  ← COPY of a's value
└────────────┘

b receives a copy of the value
Not a reference to a!

STATE 3 (a = 20):
Stack:
┌────────────┐
│ a: 20      │  ← Changed
├────────────┤
│ b: 10      │  ← Independent, unchanged
└────────────┘

STATE 4 (b = 30):
Stack:
┌────────────┐
│ a: 20      │  ← Unchanged
├────────────┤
│ b: 30      │  ← Changed independently
└────────────┘

Key Point: For primitives, assignment ALWAYS copies the value
a and b are completely independent after assignment
```

---

### Example 3: Object Assignment (Creates Alias)

```java
public class ObjectAssignment {
    public static void main(String[] args) {
        // Create one Person object
        Person a = new Person("Mukul", 25);
        
        // b gets COPY of reference (points to same object)
        Person b = a;
        
        System.out.println("a.name = " + a.name);  // Mukul
        System.out.println("b.name = " + b.name);  // Mukul
        
        // Change through b
        b.name = "John";
        
        System.out.println("After b.name = 'John':");
        System.out.println("a.name = " + a.name);  // John (changed!)
        System.out.println("b.name = " + b.name);  // John
        
        // Why? Because a and b point to SAME object
        System.out.println("a == b: " + (a == b));  // true
    }
}

class Person {
    String name;
    int age;
    
    Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
}
```

```
Memory Visualization:

STATE 1 (Person a = new Person("Mukul", 25)):
Stack:                     Heap:
┌────────────┐            ┌──────────────┐
│ a: 0x1234  │───────────►│ Person       │
└────────────┘            │ name: "Mukul"│
                          │ age: 25      │
                          └──────────────┘

STATE 2 (Person b = a):
Stack:                     Heap:
┌────────────┐            ┌──────────────┐
│ a: 0x1234  │───────────►│ Person       │
├────────────┤       ┌───►│ name: "Mukul"│
│ b: 0x1234  │───────┘    │ age: 25      │
└────────────┘            └──────────────┘

COPY of reference value (address)
Both point to SAME object

STATE 3 (b.name = "John"):
Stack:                     Heap:
┌────────────┐            ┌──────────────┐
│ a: 0x1234  │───────────►│ Person       │
├────────────┤       ┌───►│ name: "John" │ ← Modified
│ b: 0x1234  │───────┘    │ age: 25      │
└────────────┘            └──────────────┘

Change visible through BOTH references
Because there's only ONE object

Key Point: For objects, assignment copies the reference
a and b both point to the SAME object
Changes through one affect the other
```

---

### Example 4: Creating Truly Independent Objects

```java
public class IndependentObjects {
    public static void main(String[] args) {
        // Create FIRST Person object
        Person a = new Person("Mukul", 25);
        
        // Create SECOND Person object (independent)
        Person b = new Person("Mukul", 25);  // Same data, different object
        
        System.out.println("a.name = " + a.name);  // Mukul
        System.out.println("b.name = " + b.name);  // Mukul
        
        // Change through b
        b.name = "John";
        
        System.out.println("After b.name = 'John':");
        System.out.println("a.name = " + a.name);  // Mukul (unchanged!)
        System.out.println("b.name = " + b.name);  // John
        
        // Why? Because a and b point to DIFFERENT objects
        System.out.println("a == b: " + (a == b));  // false
        System.out.println("a.equals(b): " + (a.name.equals(b.name)));  // false
    }
}
```

```
Memory Visualization:

STATE 1 (Person a = new Person("Mukul", 25)):
Stack:                     Heap:
┌────────────┐            ┌──────────────┐
│ a: 0x1234  │───────────►│ Person       │ Object A
└────────────┘            │ name: "Mukul"│
                          │ age: 25      │
                          └──────────────┘

STATE 2 (Person b = new Person("Mukul", 25)):
Stack:                     Heap:
┌────────────┐            ┌──────────────┐
│ a: 0x1234  │───────────►│ Person       │ Object A
├────────────┤            │ name: "Mukul"│
│ b: 0x5678  │───────┐    │ age: 25      │
└────────────┘       │    └──────────────┘
                     │
                     │    ┌──────────────┐
                     └───►│ Person       │ Object B
                          │ name: "Mukul"│
                          │ age: 25      │
                          └──────────────┘

TWO separate objects with same data

STATE 3 (b.name = "John"):
Stack:                     Heap:
┌────────────┐            ┌──────────────┐
│ a: 0x1234  │───────────►│ Person       │ Object A
├────────────┤            │ name: "Mukul"│ ← Unchanged
│ b: 0x5678  │───────┐    │ age: 25      │
└────────────┘       │    └──────────────┘
                     │
                     │    ┌──────────────┐
                     └───►│ Person       │ Object B
                          │ name: "John" │ ← Changed
                          │ age: 25      │
                          └──────────────┘

Key Point: new keyword creates NEW object
a and b point to DIFFERENT objects
Changes to one do NOT affect the other
```

---

## 8.3 Complete Comparison Summary

```
┌──────────────────────────┬──────────────────────┬──────────────────────┐
│ Scenario                 │ Memory Layout        │ Behavior             │
├──────────────────────────┼──────────────────────┼──────────────────────┤
│ PRIMITIVES:              │                      │                      │
│ int a = 10;              │ a: 10 (separate)     │ Independent          │
│ int b = 10;              │ b: 10 (separate)     │ a change ≠ b change  │
├──────────────────────────┼──────────────────────┼──────────────────────┤
│ PRIMITIVES:              │                      │                      │
│ int a = 10;              │ a: 10                │ Independent          │
│ int b = a;               │ b: 10 (copy of value)│ a change ≠ b change  │
├──────────────────────────┼──────────────────────┼──────────────────────┤
│ OBJECTS (alias):         │ a: 0x1234 ─┐         │ Shared               │
│ Person a = new Person(); │            ├─►Object │ a change = b change  │
│ Person b = a;            │ b: 0x1234 ─┘         │ (same object)        │
├──────────────────────────┼──────────────────────┼──────────────────────┤
│ OBJECTS (independent):   │ a: 0x1234 ──►Object A│ Independent          │
│ Person a = new Person(); │ b: 0x5678 ──►Object B│ a change ≠ b change  │
│ Person b = new Person(); │ (two objects)        │ (different objects)  │
└──────────────────────────┴──────────────────────┴──────────────────────┘
```

---

## Conclusion

**Key Programming Fundamentals Learned:**

1. **Type Systems:**
    
    - Static typing: Type fixed at compile time
    - Dynamic typing: Type determined at runtime
2. **Compile Time vs Runtime:**
    
    - Compile time: Code translation, type checking
    - Runtime: Actual execution, dynamic operations
3. **Memory Management:**
    
    - Stack: Fast, automatic, local variables, primitives
    - Heap: Slower, managed, objects, arrays
4. **Data Types:**
    
    - Primitives: Store values directly (int, double, boolean, char)
    - Non-primitives: Store references (String, Arrays, Objects)
5. **Operators:**
    
    - Most operators: Left-to-right associativity
    - Special cases: Assignment, unary, power: Right-to-left
    - Precedence determines evaluation order
6. **Parameter Passing:**
    
    - Java is ALWAYS call by value
    - Primitives: Value copied
    - Objects: Reference copied (both point to same object)
7. **References:**
    
    - Multiple references can point to same object
    - Changing object through any reference affects all
    - Assignment creates alias for objects, copy for primitives

---

## END OF PROGRAMMING FUNDAMENTALS NOTES

**Document Created:** Complete Programming Basics Guide **Topics Covered:** Type systems, Memory, Data types, Operators, References, Parameter passing **Level:** Comprehensive with detailed examples and visualizations