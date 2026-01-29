---
title:
  "{ Title }":
tags:
  - OS
created:
  "{ date }":
updated:
  "{ date }":
---
# Complete Compiler Design Guide

A comprehensive technical reference covering compiler architecture, language processing systems, parsing algorithms, and code generation from high-level languages to machine code.

---

## Table of Contents

1. [Introduction to Compilers](#introduction-to-compilers)
2. [Language Processing System](#language-processing-system)
3. [Compiler Phases Overview](#compiler-phases-overview)
4. [Lexical Analysis](#lexical-analysis)
5. [Syntax Analysis](#syntax-analysis)
6. [Context-Free Grammars](#context-free-grammars)
7. [Semantic Analysis](#semantic-analysis)
8. [Intermediate Code Generation](#intermediate-code-generation)
9. [Code Optimization](#code-optimization)
10. [Target Code Generation](#target-code-generation)
11. [Assembly and Linking](#assembly-and-linking)
12. [Symbol Tables](#symbol-tables)
13. [Error Handling](#error-handling)

---

## Introduction to Compilers

### Definition

A **compiler** is a system software that translates programs written in a high-level programming language into machine-executable code. The compiler performs multiple transformations while preserving semantic correctness and optimizing performance.

### Core Responsibilities

A compiler must:

- **Translate**: Convert high-level abstractions to machine instructions
- **Validate**: Detect syntax, semantic, and type errors
- **Optimize**: Improve code efficiency in terms of speed, memory, and power
- **Preserve**: Maintain program semantics throughout transformation
- **Adapt**: Generate code specific to target architecture

### Compiler vs Interpreter

```
COMPILER:
Source Code → [Compilation] → Machine Code → [Execution] → Output
(Translation happens once, execution is fast)

INTERPRETER:
Source Code → [Interpretation + Execution] → Output
(Translation and execution happen together, slower but more flexible)
```

### The Compilation Ocean - Overview

```
                         ⚓ START ⚓
                             |
                    Source Code (C/Java/Rust)
                             |
        +--------------------+--------------------+
        |                    |                    |
        |     THE COMPILATION OCEAN               |
        |                    |                    |
        |    +===============+=================+  |
        |    |   COMPILER TRANSFORMATION       |  |
        |    |   (Multiple Phases)             |  |
        |    +===============+=================+  |
        |                    |                    |
        +--------------------+--------------------+
                             |
                    Machine Code Output
                             |
                         ⚓ END ⚓
```

---

## Language Processing System

The complete language processing system extends beyond the compiler itself, forming an integrated toolchain from source code to executable program.

### Complete Processing Pipeline

```
                        THE LANGUAGE PROCESSING VOYAGE
                        
                            ⛵ SOURCE CODE ⛵
                         (High-Level Language)
                           program.c / .java
                                  |
                                  |
                    +-------------v-------------+
                    |                           |
                    |      PREPROCESSOR         |
                    |  (Macro Expansion Fleet)  |
                    |                           |
                    |  - #include expansion     |
                    |  - #define substitution   |
                    |  - Conditional compile    |
                    |  - Comment removal        |
                    |                           |
                    +-------------+-------------+
                                  |
                         Pure Source Code
                                  |
                    +-------------v-------------+
                    |                           |
                    |        COMPILER           |
                    |   (Translation Vessel)    |
                    |                           |
                    |  +---------------------+  |
                    |  | Lexical Analysis    |  |
                    |  +---------------------+  |
                    |  | Syntax Analysis     |  |
                    |  +---------------------+  |
                    |  | Semantic Analysis   |  |
                    |  +---------------------+  |
                    |  | IR Generation       |  |
                    |  +---------------------+  |
                    |  | Optimization        |  |
                    |  +---------------------+  |
                    |  | Code Generation     |  |
                    |  +---------------------+  |
                    |                           |
                    +-------------+-------------+
                                  |
                         Assembly Language
                            program.s / .asm
                                  |
                    +-------------v-------------+
                    |                           |
                    |       ASSEMBLER           |
                    |  (Binary Conversion Ship) |
                    |                           |
                    |  - Convert mnemonics      |
                    |  - Generate opcodes       |
                    |  - Create symbol table    |
                    |  - Produce object code    |
                    |                           |
                    +-------------+-------------+
                                  |
                    Relocatable Object Code
                         program.o / .obj
                                  |
                    +-------------v-------------+
                    |                           |
                    |     LINKER / LOADER       |
                    |   (Assembly Dock)         |
                    |                           |
                    |  LINKER:                  |
                    |  - Combine object files   |
                    |  - Resolve symbols        |
                    |  - Relocation             |
                    |  - Library linking        |
                    |                           |
                    |  LOADER:                  |
                    |  - Load into memory       |
                    |  - Address binding        |
                    |  - Initialize runtime     |
                    |  - Start execution        |
                    |                           |
                    +-------------+-------------+
                                  |
                          Executable Binary
                           a.out / .exe
                                  |
                    +-------------v-------------+
                    |                           |
                    |   RUNNING PROGRAM         |
                    |  (At Sea - Executing)     |
                    |                           |
                    |  - Process in memory      |
                    |  - CPU executing          |
                    |  - I/O operations         |
                    |                           |
                    +---------------------------+
```

### Component Summary

| Component    | Input              | Output                   | Purpose                        |
|--------------|-------------------|--------------------------|--------------------------------|
| Preprocessor | Source with macros | Pure source code         | Expand macros, include files   |
| Compiler     | Pure source        | Assembly language        | Translate to low-level code    |
| Assembler    | Assembly           | Object code              | Convert to machine code        |
| Linker       | Object files       | Executable binary        | Combine modules, resolve refs  |
| Loader       | Executable         | Process in memory        | Load and start execution       |

### Why Intermediate Representation?

Modern compilers use an **Intermediate Representation (IR)** to decouple language-specific front-end from machine-specific back-end.

```
        RETARGETABLE COMPILER ARCHITECTURE
        
 C      C++     Java     Rust      (Source Languages)
  \      |       |       /
   \     |       |      /
    +----+-------+-----+
    |                  |
    |   COMMON IR      |  <- Language-independent optimization
    |   (SSA, TAC)     |
    |                  |
    +----+-------+-----+
         |       |      \
        /        |       \
     x86       ARM      RISC-V    (Target Architectures)
```

**Benefits:**

- N languages × M machines = N + M implementations (not N × M)
- Language-independent optimizations
- Machine-independent optimizations
- Easier to add new languages or targets

**Common IR Forms:**

- Three-Address Code (TAC)
- Static Single Assignment (SSA)
- LLVM IR
- Java Bytecode
- WebAssembly

---

## Compiler Phases Overview

The compiler is organized into distinct phases, each performing specific transformations. Phases are grouped into front-end (analysis), middle-end (optimization), and back-end (synthesis).

### The Compiler Ship - Internal Structure

```
    +--------------------------------------------------------+
    |                                                        |
    |                   COMPILER VESSEL                      |
    |                                                        |
    |  +==================================================+  |
    |  |              FRONT-END (Analysis)                |  |
    |  |          (Language Dependent)                    |  |
    |  +==================================================+  |
    |  |                                                  |  |
    |  |  +--------------------------------------------+  |  |
    |  |  |    LEXICAL ANALYZER (Scanner)            |  |  |
    |  |  |    Character Stream -> Token Stream      |  |  |
    |  |  +--------------------+---------------------+  |  |
    |  |                       |                        |  |
    |  |  +--------------------v---------------------+  |  |
    |  |  |    SYNTAX ANALYZER (Parser)              |  |  |
    |  |  |    Token Stream -> Parse Tree / AST      |  |  |
    |  |  +--------------------+---------------------+  |  |
    |  |                       |                        |  |
    |  |  +--------------------v---------------------+  |  |
    |  |  |    SEMANTIC ANALYZER                     |  |  |
    |  |  |    Type Checking, Scope Resolution       |  |  |
    |  |  +--------------------+---------------------+  |  |
    |  |                       |                        |  |
    |  +=======================+========================+  |
    |                          |                           |
    |  +=======================v========================+  |
    |  |            MIDDLE-END (Optimization)            |  |
    |  |         (Language & Machine Independent)        |  |
    |  +==================================================+  |
    |  |                                                  |  |
    |  |  +--------------------------------------------+  |  |
    |  |  | INTERMEDIATE CODE GENERATOR                |  |  |
    |  |  | AST -> IR (Three-Address Code / SSA)       |  |  |
    |  |  +--------------------+---------------------+  |  |
    |  |                       |                        |  |
    |  |  +--------------------v---------------------+  |  |
    |  |  |    CODE OPTIMIZER                        |  |  |
    |  |  |    Machine-Independent Optimizations     |  |  |
    |  |  +--------------------+---------------------+  |  |
    |  |                       |                        |  |
    |  +=======================+========================+  |
    |                          |                           |
    |  +=======================v========================+  |
    |  |             BACK-END (Synthesis)                |  |
    |  |           (Machine Dependent)                   |  |
    |  +==================================================+  |
    |  |                                                  |  |
    |  |  +--------------------------------------------+  |  |
    |  |  |    CODE GENERATOR                          |  |  |
    |  |  |    IR -> Target Machine Code               |  |  |
    |  |  |                                            |  |  |
    |  |  |  - Instruction selection                   |  |  |
    |  |  |  - Register allocation                     |  |  |
    |  |  |  - Instruction scheduling                  |  |  |
    |  |  +--------------------+---------------------+  |  |
    |  |                       |                        |  |
    |  |  +--------------------v---------------------+  |  |
    |  |  | MACHINE-DEPENDENT OPTIMIZER              |  |  |
    |  |  | Peephole, Register optimization          |  |  |
    |  |  +--------------------------------------------+  |  |
    |  |                                                  |  |
    |  +==================================================+  |
    |                                                        |
    +--------------------------------------------------------+
```

### Supporting Components

These components are used throughout all phases:

```
+----------------------------------------------+
|          SYMBOL TABLE MANAGER                |
|                                              |
|  Stores information about identifiers:       |
|  - Name, Type, Scope                         |
|  - Memory location                           |
|  - Attributes (const, static, etc.)          |
|                                              |
|  Used by ALL phases                          |
+----------------------------------------------+

+----------------------------------------------+
|          ERROR HANDLER                       |
|                                              |
|  Detects and reports errors:                 |
|  - Lexical errors                            |
|  - Syntax errors                             |
|  - Semantic errors                           |
|  - Runtime errors (if applicable)            |
|                                              |
|  Used by ALL phases                          |
+----------------------------------------------+
```

### Data Flow Through Compiler

```
Source Code
    |
    +---> [Lexical Analyzer] ---> Token Stream
    |
    +---> [Syntax Analyzer] ---> Parse Tree / AST
    |
    +---> [Semantic Analyzer] ---> Annotated AST 
    |
    +---> [IR Generator] ---> Intermediate Representation
    |
    +---> [Optimizer] ---> Optimized IR
    |
    +---> [Code Generator] ---> Target Code (Assembly)
```

---

## Lexical Analysis

The lexical analyzer (scanner) is the first phase of compilation. It reads the source program as a character stream and groups characters into meaningful sequences called **lexemes**, producing **tokens**.

### The Scanner Lighthouse

```
                         ⚓ INPUT ⚓
                    Character Stream
                    "int x = 10;"
                          |
        +-----------------+-----------------+
        |                 |                 |
        |    LEXICAL ANALYZER (Scanner)     |
        |                 |                 |
        |  +==============+==============+  |
        |  |    Pattern Recognition      |  |
        |  |                             |  |
        |  |  +------------------------+ |  |
        |  |  | Regular Expressions    | |  |
        |  |  | Finite Automata (DFA)  | |  |
        |  |  +------------------------+ |  |
        |  +=============================+  |
        |                 |                 |
        |  Tasks:         |                 |
        |  1. Read chars  |                 |
        |  2. Skip whitespace               |
        |  3. Skip comments                 |
        |  4. Recognize tokens              |
        |  5. Build symbol table entries    |
        |  6. Report lexical errors         |
        |                 |                 |
        +-----------------+-----------------+
                          |
                      Token Stream
                  <KEYWORD, int>
                  <ID, x>
                  <ASSIGN, =>
                  <NUMBER, 10>
                  <SEMICOLON, ;>
                          |
                      ⚓ OUTPUT ⚓
```

### Token Structure

Each token consists of a token name and an optional attribute value:

```
<Token Name, Attribute Value>
```

**Examples:**

```
"int"       ->  <KEYWORD, int>
"x"         ->  <ID, "x">             (pointer to symbol table)
"="         ->  <ASSIGN, "=">
"10"        ->  <NUMBER, 10>
";"         ->  <SEMICOLON, ";">
"while"     ->  <KEYWORD, while>
"count"     ->  <ID, "count">
```

### Token Categories

| Token Type   | Examples                           | Description                    |
|-------------|-----------------------------------|--------------------------------|
| KEYWORDS    | if, else, while, for, int, return | Reserved words                 |
| IDENTIFIERS | variable_name, func_name          | User-defined names             |
| LITERALS    | 123, 3.14, "hello", 'a'          | Constant values                |
| OPERATORS   | +, -, *, /, ==, !=, &&, \|\|      | Arithmetic and logical ops     |
| PUNCTUATION | ;, ,, {, }, (, ), [, ]           | Delimiters and separators      |
| WHITESPACE  | spaces, tabs, newlines            | Usually ignored                |
| COMMENTS    | //, /* */                         | Ignored by scanner             |

### Lexical Analysis Example

**Source Code:**

```c
int sum = 0;
while (sum < 100) {
    sum = sum + 1;
}
```

**Token Stream:**

```
<KEYWORD, int>
<ID, sum>
<ASSIGN, =>
<NUMBER, 0>
<SEMICOLON, ;>
<KEYWORD, while>
<LPAREN, (>
<ID, sum>
<RELOP, <>
<NUMBER, 100>
<RPAREN, )>
<LBRACE, {>
<ID, sum>
<ASSIGN, =>
<ID, sum>
<PLUS, +>
<NUMBER, 1>
<SEMICOLON, ;>
<RBRACE, }>
```

### Regular Expressions and Finite Automata

Lexical analysis is based on regular expressions and finite automata.

**Regular Expression Example for Identifiers:**

```
letter = [a-zA-Z]
digit = [0-9]
identifier = letter (letter | digit)*
```

**Finite Automaton for Identifiers:**

```
          letter
    +---------------+
    |               |
    v               |
  (Start) --letter--> ((Accept))
                       ^
                       |
                    letter|digit
```

### Lexical Error Detection

**Common Lexical Errors:**

- Illegal characters (e.g., `@`, `#` in some languages)
- Malformed string literals
- Unterminated comments
- Invalid number formats

**Example:**

```c
int 123abc = 10;  // Error: identifier cannot start with digit
```

---

## Syntax Analysis

The syntax analyzer (parser) is the second phase of compilation. It checks whether the token stream conforms to the grammatical structure of the language and builds a parse tree or abstract syntax tree (AST).

### The Parser Navigation System

```
                         ⚓ INPUT ⚓
                       Token Stream
                  <KEYWORD, int> <ID, x> ...
                          |
        +-----------------+-----------------+
        |                 |                 |
        |     SYNTAX ANALYZER (Parser)      |
        |                 |                 |
        |  +==============+==============+  |
        |  |  Grammar-Based Recognition  |  |
        |  |                             |  |
        |  |  +------------------------+ |  |
        |  |  | Context-Free Grammar   | |  |
        |  |  | Parse Table / Stack    | |  |
        |  |  +------------------------+ |  |
        |  +=============================+  |
        |                 |                 |
        |  Tasks:         |                 |
        |  1. Check syntax                  |
        |  2. Build parse tree              |
        |  3. Report syntax errors          |
        |  4. Error recovery                |
        |                 |                 |
        +-----------------+-----------------+
                          |
                   Parse Tree / AST
                          |
                      ⚓ OUTPUT ⚓
```

### Parse Tree vs Abstract Syntax Tree

**Parse Tree (Concrete Syntax Tree):**

Contains all grammatical details including terminals and non-terminals.

**Abstract Syntax Tree (AST):**

Removes unnecessary grammatical structure, keeping only semantic information.

**Example for:** `x = a + b`

**Parse Tree:**

```
            <assignment>
               /    \
              /      \
           <ID>    <ASSIGN>  <expr>
            |         |        /  \
            x         =    <expr> <op> <expr>
                             |     |     |
                            <ID>   +    <ID>
                             |           |
                             a           b
```

**Abstract Syntax Tree:**

```
          =
         / \
        x   +
           / \
          a   b
```

The AST is more compact and easier to process in subsequent phases.

### Parser Types

Parsers are classified based on parsing direction and grammar class:

```
                    PARSER TAXONOMY
                         
                       PARSERS
                         |
         +---------------+---------------+
         |                               |
    TOP-DOWN                        BOTTOM-UP
         |                               |
    +---------+                    +---------+
    |         |                    |         |
Recursive   LL(k)                LR(k)    Operator
Descent                          Family   Precedence
            |                      |
         LL(1)              +------+------+
                            |      |      |
                          LR(0)  SLR   LALR  CLR(1)
```

**Top-Down Parsing:**

- Constructs parse tree from root to leaves
- Starts with start symbol, expands non-terminals
- Examples: Recursive descent, LL(1)

**Bottom-Up Parsing:**

- Constructs parse tree from leaves to root
- Starts with input, reduces to start symbol
- Examples: LR(0), SLR, LALR, CLR(1)
- Used in tools like YACC/Bison

### Parsing Example

**Grammar:**

```
E -> E + T | T
T -> T * F | F
F -> ( E ) | id
```

**Input:** `id + id * id`

**Leftmost Derivation:**

```
E
=> E + T
=> T + T
=> F + T
=> id + T
=> id + T * F
=> id + F * F
=> id + id * F
=> id + id * id
```

---

## Context-Free Grammars

Context-free grammars (CFGs) are the formal basis for syntax analysis. A CFG specifies the syntactic structure of a programming language.

### CFG Definition

A context-free grammar G is a 4-tuple:

```
G = (V, T, P, S)

Where:
V = Set of non-terminals (variables)
T = Set of terminals (tokens)
P = Set of production rules
S = Start symbol (S ∈ V)
```

**Production Rule Format:**

```
A -> α

Where:
A = Non-terminal (left-hand side)
α = String of terminals and/or non-terminals (right-hand side)
```

### Grammar Example

**Simple Expression Grammar:**

```
E -> E + T       (Addition)
E -> T           (Single term)
T -> T * F       (Multiplication)
T -> F           (Single factor)
F -> ( E )       (Parenthesized expression)
F -> id          (Identifier)
```

**Components:**

- Non-terminals: `E` (Expression), `T` (Term), `F` (Factor)
- Terminals: `+`, `*`, `(`, `)`, `id`
- Start symbol: `E`

### Derivation Process

A derivation is a sequence of grammar rule applications.

**Leftmost Derivation:**

Always expand the leftmost non-terminal first.

**Rightmost Derivation:**

Always expand the rightmost non-terminal first.

**Example:** Derive `id + id * id`

**Leftmost:**

```
E
=> E + T                (Apply E -> E + T)
=> T + T                (Apply E -> T)
=> F + T                (Apply T -> F)
=> id + T               (Apply F -> id)
=> id + T * F           (Apply T -> T * F)
=> id + F * F           (Apply T -> F)
=> id + id * F          (Apply F -> id)
=> id + id * id         (Apply F -> id)
```

### Parse Tree Construction

```
                    E
                   /|\
                  / | \
                 E  +  T
                 |    /|\
                 T   / | \
                 |  T  *  F
                 |  |     |
                 F  F    id
                 |  |
                id id
```

### Ambiguous Grammars

A grammar is **ambiguous** if a string can have multiple parse trees.

**Example Ambiguous Grammar:**

```
E -> E + E
E -> E * E
E -> id
```

**String:** `id + id * id`

**Two possible parse trees:**

```
Tree 1:              Tree 2:
    E                    E
   /|\                  /|\
  E + E                E * E
 /|\  |               |  /|\
E * E id             id E + E
|   |                   |   |
id  id                 id  id

(id + id) * id       id + (id * id)
```

**Solution:** Rewrite grammar to enforce precedence and associativity.

**Unambiguous Grammar:**

```
E -> E + T | T
T -> T * F | F
F -> ( E ) | id
```

This grammar enforces:
- `*` has higher precedence than `+`
- Both operators are left-associative

### Grammar Types in Chomsky Hierarchy

```
                    CHOMSKY HIERARCHY
                         
    +-----------------------------------------------+
    |  Type 0: Unrestricted (Recursively Enum.)    |
    |                                               |
    |  +------------------------------------------+ |
    |  |  Type 1: Context-Sensitive               | |
    |  |                                          | |
    |  |  +-------------------------------------+ | |
    |  |  |  Type 2: Context-Free               | | |
    |  |  |  (Used in programming languages)    | | |
    |  |  |                                     | | |
    |  |  |  +--------------------------------+ | | |
    |  |  |  |  Type 3: Regular               | | | |
    |  |  |  |  (Used in lexical analysis)    | | | |
    |  |  |  +--------------------------------+ | | |
    |  |  +-------------------------------------+ | |
    |  +------------------------------------------+ |
    +-----------------------------------------------+
```

**For Compilers:**

- **Regular grammars (Type 3):** Lexical analysis
- **Context-free grammars (Type 2):** Syntax analysis

---

## Semantic Analysis

The semantic analyzer is the third phase of compilation. While syntax analysis checks grammatical structure, semantic analysis ensures the program makes sense according to language semantics.

### The Semantic Inspection Harbor

```
                         ⚓ INPUT ⚓
                    Parse Tree / AST
                          |
        +-----------------+-----------------+
        |                 |                 |
        |    SEMANTIC ANALYZER              |
        |  (Meaning Verification Station)   |
        |                 |                 |
        |  +==============+==============+  |
        |  |    Semantic Checks          |  |
        |  |                             |  |
        |  |  +------------------------+ |  |
        |  |  | Type Checking          | |  |
        |  |  | Scope Resolution       | |  |
        |  |  | Declaration Checking   | |  |
        |  |  | Function Signature     | |  |
        |  |  +------------------------+ |  |
        |  +=============================+  |
        |                 |                 |
        |  Uses:          |                 |
        |  - Symbol Table |                 |
        |  - Type Rules   |                 |
        |  - AST          |                 |
        |                 |                 |
        +-----------------+-----------------+
                          |
                  Annotated AST
               (with type information)
                          |
                      ⚓ OUTPUT ⚓
```

### Tasks of Semantic Analysis

**1. Type Checking:**

Ensure operations are performed on compatible types.

```c
int x = 10;
x = "hello";   // ERROR: incompatible types
```

**2. Declaration Checking:**

Ensure all variables are declared before use.

```c
x = 10;        // ERROR: 'x' not declared
int x;
```

**3. Scope Resolution:**

Ensure identifiers are used in correct scope.

```c
void func() {
    int x = 10;
}

void main() {
    x = 20;    // ERROR: 'x' not in scope
}
```

**4. Function Signature Matching:**

Ensure function calls match declarations.

```c
int add(int a, int b) {
    return a + b;
}

int main() {
    add(10);           // ERROR: wrong number of arguments
    add(10, "hello");  // ERROR: wrong argument type
}
```

**5. Label Checking:**

Ensure labels and goto statements are valid.

**6. Array Bounds (Static):**

Check array declarations and static indices.

### Type Systems

```
                    TYPE SYSTEM HIERARCHY
                         
                      TYPE SYSTEM
                         |
         +---------------+---------------+
         |                               |
    STATIC TYPING                   DYNAMIC TYPING
    (Compile-time)                  (Runtime)
         |                               |
    C, C++, Java                   Python, JavaScript
    Rust, Go
         |
    +----+----+
    |         |
  WEAK    STRONG
  TYPING  TYPING
    |         |
    C      Java, Rust
```

**Static Typing:** Type checking at compile-time
**Dynamic Typing:** Type checking at runtime
**Strong Typing:** No implicit type conversions
**Weak Typing:** Allows implicit type conversions

### Type Checking Example

**Source Code:**

```c
int x = 10;
float y = 3.14;
x = y;              // May cause precision loss
```

**Semantic Analysis:**

```
1. Check 'x' declaration: int (OK)
2. Check 'y' declaration: float (OK)
3. Check assignment 'x = y':
   - LHS type: int
   - RHS type: float
   - Type conversion: float -> int (may lose precision)
   - Action: Issue warning or error depending on language rules
```

### Annotated AST

After semantic analysis, the AST is annotated with type information:

```
          = (type: void)
         / \
        x   y
    (int)   (float)
```

### Semantic Error Examples

**Type Mismatch:**

```c
int x;
x = "hello";       // ERROR: cannot assign string to int
```

**Undeclared Variable:**

```c
y = 10;            // ERROR: 'y' not declared
```

**Scope Violation:**

```c
{
    int x = 10;
}
x = 20;            // ERROR: 'x' out of scope
```

**Function Signature Mismatch:**

```c
int add(int a, int b);
add(10, 20, 30);   // ERROR: too many arguments
```

**Duplicate Declaration:**

```c
int x = 10;
int x = 20;        // ERROR: 'x' already declared
```

---

## Intermediate Code Generation

The intermediate code generator translates the AST into an intermediate representation (IR). The IR is machine-independent and easier to optimize than source code or target code.

### The Translation Dock

```
                         ⚓ INPUT ⚓
                    Annotated AST
                          |
        +-----------------+-----------------+
        |                 |                 |
        |  INTERMEDIATE CODE GENERATOR      |
        |   (Translation Station)           |
        |                 |                 |
        |  +==============+==============+  |
        |  |  AST -> IR Conversion       |  |
        |  |                             |  |
        |  |  IR Forms:                  |  |
        |  |  - Three-Address Code (TAC) |  |
        |  |  - Quadruples               |  |
        |  |  - Triples                  |  |
        |  |  - SSA Form                 |  |
        |  +=============================+  |
        |                 |                 |
        |  Properties:    |                 |
        |  - Machine independent            |
        |  - Easy to optimize               |
        |  - Simple structure               |
        |                 |                 |
        +-----------------+-----------------+
                          |
                Intermediate Representation
                  (Three-Address Code)
                          |
                      ⚓ OUTPUT ⚓
```

### Three-Address Code (TAC)

Three-address code is a linearized representation where each instruction has at most three operands.

**General Form:**

```
result = operand1 operator operand2
```

**TAC Instructions:**

```
1. Assignment:        x = y op z
2. Unary operation:   x = op y
3. Copy:              x = y
4. Unconditional jump: goto L
5. Conditional jump:  if x relop y goto L
6. Function call:     call p, n
7. Return:            return y
8. Array access:      x = y[i]
9. Array assignment:  x[i] = y
10. Pointer ops:      x = &y, x = *y, *x = y
```

### TAC Generation Example

**Source Code:**

```c
x = a + b * c;
```

**AST:**

```
      =
     / \
    x   +
       / \
      a   *
         / \
        b   c
```

**Three-Address Code:**

```
t1 = b * c
t2 = a + t1
x = t2
```

### Control Flow in TAC

**If Statement:**

**Source:**

```c
if (a < b) {
    x = 1;
} else {
    x = 0;
}
```

**TAC:**

```
    if a < b goto L1
    x = 0
    goto L2
L1: x = 1
L2: ...
```

**While Loop:**

**Source:**

```c
while (a < b) {
    x = x + 1;
}
```

**TAC:**

```
L1: if a < b goto L2
    goto L3
L2: t1 = x + 1
    x = t1
    goto L1
L3: ...
```

### IR Representations

```
                IR REPRESENTATION FORMS
                         
         +-----------+-----------+----------+
         |           |           |          |
        TAC      Quadruples   Triples    SSA
         |           |           |          |
    Most common  Tuple form  No temp   Single
    in compilers             vars    assignment
```

**Quadruples:**

```
| Op  | Arg1 | Arg2 | Result |
|-----|------|------|--------|
| *   | b    | c    | t1     |
| +   | a    | t1   | t2     |
| =   | t2   |      | x      |
```

**Triples:**

```
| Op  | Arg1 | Arg2 |
|-----|------|------|
| *   | b    | c    |  (0)
| +   | a    | (0)  |  (1)
| =   | x    | (1)  |  (2)
```

**Static Single Assignment (SSA):**

Each variable is assigned exactly once.

```
Original:       SSA Form:
x = a + b       x1 = a + b
x = x * c       x2 = x1 * c
x = x + d       x3 = x2 + d
```

---

## Code Optimization

Code optimization improves the intermediate representation to produce faster, smaller, or more power-efficient code while preserving semantics.

### The Optimization Workshop

```
                         ⚓ INPUT ⚓
                  Intermediate Code (IR)
                          |
        +-----------------+-----------------+
        |                 |                 |
        |      CODE OPTIMIZER               |
        |   (Performance Enhancement)       |
        |                 |                 |
        |  +==============+==============+  |
        |  |  Optimization Techniques    |  |
        |  |                             |  |
        |  |  Machine-Independent:       |  |
        |  |  - Constant folding         |  |
        |  |  - Dead code elimination    |  |
        |  |  - Common subexpr elim      |  |
        |  |  - Loop optimization        |  |
        |  |                             |  |
        |  |  Machine-Dependent:         |  |
        |  |  - Register allocation      |  |
        |  |  - Instruction selection    |  |
        |  |  - Peephole optimization    |  |
        |  +=============================+  |
        |                 |                 |
        +-----------------+-----------------+
                          |
                    Optimized IR
                          |
                      ⚓ OUTPUT ⚓
```

### Machine-Independent Optimizations

These optimizations work on IR and don't depend on target architecture.

#### 1. Constant Folding

Replace compile-time computable expressions with their results.

**Before:**

```
x = 3 + 5
y = 10 * 2
```

**After:**

```
x = 8
y = 20
```

#### 2. Constant Propagation

Replace variables with their constant values.

**Before:**

```
x = 5
y = x + 10
z = y * 2
```

**After:**

```
x = 5
y = 15
z = 30
```

#### 3. Dead Code Elimination

Remove code that never executes or whose results are never used.

**Before:**

```
x = 5
y = 10
x = 20      // Previous assignment to x is dead
z = y + 1
t = 100     // t is never used, this is dead
```

**After:**

```
y = 10
x = 20
z = y + 1
```

#### 4. Common Subexpression Elimination

Avoid recomputing the same expression.

**Before:**

```
t1 = a + b
t2 = c * d
t3 = a + b     // Same as t1
t4 = c * d     // Same as t2
```

**After:**

```
t1 = a + b
t2 = c * d
t3 = t1
t4 = t2
```

#### 5. Loop Invariant Code Motion

Move computations that don't change inside a loop outside the loop.

**Before:**

```
for (i = 0; i < 100; i++) {
    x = y + z;        // y + z doesn't change in loop
    a[i] = x * i;
}
```

**After:**

```
x = y + z;
for (i = 0; i < 100; i++) {
    a[i] = x * i;
}
```

#### 6. Strength Reduction

Replace expensive operations with cheaper equivalents.

**Before:**

```
for (i = 0; i < 100; i++) {
    x = i * 4;        // Multiplication
}
```

**After:**

```
for (i = 0; i < 100; i++) {
    x = i << 2;       // Bit shift (faster)
}
```

Or:

```
x = 0;
for (i = 0; i < 100; i++) {
    x = x + 4;        // Addition instead of multiplication
}
```

#### 7. Copy Propagation

Replace copies with original values.

**Before:**

```
x = y
z = x + 10
```

**After:**

```
x = y
z = y + 10
```

### Machine-Dependent Optimizations

These optimizations depend on target architecture.

#### 1. Register Allocation

Assign variables to CPU registers for faster access.

```
    MEMORY vs REGISTERS
    
Memory Access:          Register Access:
    MOV R1, [x]            MOV R1, R2
    ADD R1, [y]            ADD R1, R3
    MOV [z], R1            MOV R4, R1
    
    Slow (multiple        Fast (single
    memory accesses)      cycle operations)
```

#### 2. Instruction Selection

Choose optimal machine instructions for IR operations.

**Example:**

```
IR:  x = x + 1

Possible Assemblies:
1. MOV R1, x       2. INC [x]
   ADD R1, 1
   MOV x, R1
   
Option 2 is faster and smaller
```

#### 3. Peephole Optimization

Examine small instruction windows and replace with better sequences.

**Before:**

```
MOV R1, R2
MOV R2, R1     // Redundant
```

**After:**

```
MOV R1, R2
```

**Before:**

```
ADD R1, 0      // No-op
```

**After:**

```
(removed)
```

### Optimization Levels

Compilers typically offer multiple optimization levels:

| Level | Description          | Trade-off                |
|-------|---------------------|--------------------------|
| -O0   | No optimization      | Fast compilation         |
| -O1   | Basic optimization   | Moderate improvement     |
| -O2   | Aggressive optimize  | Standard for production  |
| -O3   | Maximum optimize     | Longer compilation       |
| -Os   | Optimize for size    | Smaller binaries         |
| -Ofast| Aggressive + unsafe  | May break strict standards |

### Optimization Example

**Original Code:**

```c
int sum = 0;
for (int i = 0; i < 100; i++) {
    sum = sum + 5 * 10;
}
```

**Step 1 - Constant Folding:**

```
5 * 10 = 50
```

**Step 2 - Loop Invariant Motion:**

```c
int sum = 0;
int temp = 50;
for (int i = 0; i < 100; i++) {
    sum = sum + temp;
}
```

**Step 3 - Strength Reduction:**

```c
int sum = 0;
for (int i = 0; i < 100; i++) {
    sum = sum + 50;
}
```

**Step 4 - Loop Optimization (if compiler is smart enough):**

```c
int sum = 100 * 50;  // = 5000
```

---

## Target Code Generation

The code generator translates optimized IR into target machine code (usually assembly language).

### The Code Forge

```
                         ⚓ INPUT ⚓
                     Optimized IR
                          |
        +-----------------+-----------------+
        |                 |                 |
        |    TARGET CODE GENERATOR          |
        |   (Machine Code Smithy)           |
        |                 |                 |
        |  +==============+==============+  |
        |  |  Code Generation Tasks      |  |
        |  |                             |  |
        |  |  - Instruction selection    |  |
        |  |  - Register allocation      |  |
        |  |  - Instruction ordering     |  |
        |  |  - Memory management        |  |
        |  |  - Address calculation      |  |
        |  +=============================+  |
        |                 |                 |
        |  Target: x86, ARM, RISC-V, etc.   |
        |                 |                 |
        +-----------------+-----------------+
                          |
                   Assembly Code
                   (Target Machine)
                          |
                      ⚓ OUTPUT ⚓
```

### Code Generation Tasks

#### 1. Instruction Selection

Map IR operations to target machine instructions.

**Example (x86):**

```
IR:               Assembly:
t1 = a + b        MOV EAX, a
                  ADD EAX, b
                  MOV t1, EAX
```

#### 2. Register Allocation

Assign variables and temporaries to limited CPU registers.

**Register Allocation Strategies:**

- Graph coloring
- Linear scan
- Live range analysis

**Example:**

```
IR:               Registers:
t1 = a + b        R1 = a, R2 = b
t2 = t1 * c       R3 = R1 + R2
t3 = t2 - d       R4 = R3 * c
                  R5 = R4 - d
```

#### 3. Instruction Ordering

Arrange instructions to minimize pipeline stalls.

#### 4. Address Calculation

Compute memory addresses for variables.

**Stack Frame Layout:**

```
    +------------------+  <- Stack Pointer (SP)
    | Local Variables  |
    +------------------+
    | Saved Registers  |
    +------------------+
    | Return Address   |
    +------------------+
    | Parameters       |
    +------------------+  <- Frame Pointer (FP)
    | Previous Frame   |
    +------------------+
```

### Code Generation Example

**IR:**

```
t1 = a + b
t2 = t1 * c
x = t2
```

**Target Code (x86):**

```assembly
MOV  EAX, [a]      ; Load a into EAX
ADD  EAX, [b]      ; Add b to EAX (EAX = a + b)
MOV  EBX, [c]      ; Load c into EBX
IMUL EBX           ; Multiply EAX by EBX (EAX = EAX * c)
MOV  [x], EAX      ; Store result in x
```

**Target Code (ARM):**

```assembly
LDR  R0, [a]       ; Load a into R0
LDR  R1, [b]       ; Load b into R1
ADD  R2, R0, R1    ; R2 = R0 + R1 (a + b)
LDR  R3, [c]       ; Load c into R3
MUL  R4, R2, R3    ; R4 = R2 * R3
STR  R4, [x]       ; Store R4 in x
```

### Register Allocation Graph Coloring

**Live Ranges:**

```
IR:               Live Ranges:
a = ...           a: [1-5]
b = ...           b: [2-6]
c = a + b         c: [3-7]
d = a * c         d: [4-8]
e = b + d         e: [5-9]
```

**Interference Graph:**

```
    a ---- c
    |  \   |
    |   \  |
    |    \ |
    b ---- d ---- e
```

Variables that are live at the same time interfere and need different registers.

**Graph Coloring:**

Assign colors (registers) such that no adjacent nodes have the same color.

---

## Assembly and Linking

After code generation, the assembly code is converted to machine code by the assembler, and multiple object files are combined by the linker.

### Assembly Process

```
                         ⚓ INPUT ⚓
                    Assembly Language
                       program.s / .asm
                          |
        +-----------------+-----------------+
        |                 |                 |
        |        ASSEMBLER                  |
        |   (Binary Encoder)                |
        |                 |                 |
        |  +==============+==============+  |
        |  |  Assembly Tasks             |  |
        |  |                             |  |
        |  |  - Convert mnemonics        |  |
        |  |  - Generate opcodes         |  |
        |  |  - Resolve labels           |  |
        |  |  - Create relocation info   |  |
        |  |  - Build symbol table       |  |
        |  +=============================+  |
        |                 |                 |
        +-----------------+-----------------+
                          |
                 Relocatable Object Code
                     program.o / .obj
                          |
                      ⚓ OUTPUT ⚓
```

### Assembler Functions

**1. Mnemonic Translation:**

```
Assembly:         Machine Code:
MOV EAX, 5        B8 05 00 00 00
ADD EAX, EBX      01 D8
```

**2. Symbol Resolution:**

```
Assembly:
    JMP label
    ...
label:
    MOV EAX, 10
    
The assembler calculates the offset to 'label'
```

**3. Two-Pass Assembly:**

**Pass 1:**
- Build symbol table
- Assign addresses to labels

**Pass 2:**
- Generate machine code
- Fill in addresses

### Linking Process

```
        +-----------------+-----------------+
        |                 |                 |
        |         LINKER                    |
        |   (Module Combiner)               |
        |                 |                 |
        |  +==============+==============+  |
        |  |  Linking Tasks              |  |
        |  |                             |  |
        |  |  - Combine object files     |  |
        |  |  - Resolve external symbols |  |
        |  |  - Relocation               |  |
        |  |  - Library linking          |  |
        |  +=============================+  |
        |                 |                 |
        +-----------------+-----------------+
```

### Linking Example

**File 1 (main.c):**

```c
extern int add(int, int);

int main() {
    int x = add(10, 20);
    return 0;
}
```

**File 2 (add.c):**

```c
int add(int a, int b) {
    return a + b;
}
```

**Object Files:**

```
main.o:
- Defines: main
- References: add (external)

add.o:
- Defines: add
- References: (none)
```

**Linker:**

1. Combines main.o and add.o
2. Resolves reference to 'add' in main.o
3. Produces executable

### Relocation

Relocation adjusts addresses when combining object files.

**Before Linking:**

```
main.o:           add.o:
Address 0x0000    Address 0x0000
...               ...
CALL add          add:
                  ...
                  RET
```

**After Linking:**

```
Executable:
Address 0x1000: main code
Address 0x1050: CALL 0x2000  (adjusted address)
Address 0x2000: add code
```

### Static vs Dynamic Linking

**Static Linking:**

Libraries are copied into executable at link time.

- Larger executable
- No external dependencies
- Faster execution

**Dynamic Linking:**

Libraries are loaded at runtime.

- Smaller executable
- Shared libraries (DLL, SO)
- Easier updates

```
                    LINKING TYPES
                         
                      LINKING
                         |
         +---------------+---------------+
         |                               |
    STATIC LINKING                 DYNAMIC LINKING
         |                               |
    - All in one exe              - Shared libraries
    - Larger size                 - Smaller size
    - No dependencies             - Runtime dependencies
    - a.out includes libc         - a.out uses libc.so
```

### Loading

The loader loads the executable into memory and starts execution.

**Loader Tasks:**

1. Allocate memory
2. Load executable into memory
3. Set up stack and heap
4. Initialize registers
5. Transfer control to entry point (main)

---

## Symbol Tables

The symbol table is a data structure that stores information about identifiers (variables, functions, classes) used in the program.

### Symbol Table Structure

```
    THE SYMBOL TABLE REPOSITORY
    
+----------------------------------------------------------+
|                    SYMBOL TABLE                          |
+----------------------------------------------------------+
| Name    | Type  | Scope | Address | Size | Attributes   |
|---------|-------|-------|---------|------|--------------|
| x       | int   | local | 0x1000  | 4    | -            |
| y       | float | local | 0x1004  | 4    | -            |
| add     | func  | global| 0x2000  | -    | params: 2    |
| MAX     | const | global| -       | -    | value: 100   |
| counter | int   | global| 0x3000  | 4    | static       |
+----------------------------------------------------------+
```

### Symbol Table Information

**For each identifier, store:**

- **Name**: Identifier string
- **Type**: Data type (int, float, struct, etc.)
- **Scope**: Where it's visible (global, local, block)
- **Address**: Memory location or offset
- **Size**: Memory size in bytes
- **Attributes**: const, static, volatile, etc.

**For functions:**

- Parameter types and count
- Return type
- Local variables

### Scope Management

```
        SCOPE HIERARCHY (NESTED SCOPES)
        
            Global Scope
                |
        +-------+-------+
        |               |
    Function 1      Function 2
        |               |
    +---+---+       Block 1
    |       |           |
  Block  Block      Block 2
```

**Symbol Table Organization:**

**Option 1: Multiple Tables**

- Separate table for each scope
- Tables organized in stack/tree

**Option 2: Single Table with Scope Field**

- One table with scope level
- Hash table with scope tracking

### Symbol Table Operations

```c
// Insert symbol
insert(name, type, scope, address, size, attributes)

// Lookup symbol
entry = lookup(name, scope)

// Delete symbol (when exiting scope)
delete(name, scope)

// Enter new scope
enterScope()

// Exit current scope
exitScope()
```

### Hashing for Symbol Tables

Symbol tables often use hash tables for O(1) average lookup time.

**Hash Function Example:**

```c
int hash(char *name) {
    int h = 0;
    for (int i = 0; name[i] != '\0'; i++) {
        h = (h * 31 + name[i]) % TABLE_SIZE;
    }
    return h;
}
```

**Collision Resolution:**

- Chaining (linked lists)
- Open addressing (linear probing, quadratic probing)

---

## Error Handling

Error handling is a critical component that runs throughout compilation, detecting and reporting errors at each phase.

### The Error Lighthouse System

```
                    ERROR DETECTION NETWORK
                    
        +-----------------------------------------+
        |           ERROR HANDLER                 |
        |                                         |
        |    Monitors all compilation phases      |
        +-----------------------------------------+
                    |          |          |
        +-----------+          |          +-----------+
        |                      |                      |
        v                      v                      v
    LEXICAL              SYNTAX                 SEMANTIC
    ERRORS               ERRORS                  ERRORS
        |                      |                      |
   Invalid              Missing               Type
   tokens               syntax                mismatch
```

### Error Categories

#### 1. Lexical Errors

Detected during lexical analysis.

**Examples:**

```c
int 123abc = 10;      // Identifier can't start with digit
int x = @5;           // Invalid character '@'
char *s = "hello;     // Unterminated string
```

#### 2. Syntax Errors

Detected during parsing.

**Examples:**

```c
if (x > 5            // Missing closing parenthesis
{
    x = 10
}                    // Missing semicolon

int x =              // Missing expression
```

#### 3. Semantic Errors

Detected during semantic analysis.

**Examples:**

```c
int x;
x = "hello";         // Type mismatch

y = 10;              // Undeclared variable

int func(int a, int b);
func(10);            // Wrong number of arguments

void test() {
    int x = 10;
}
int main() {
    x = 20;          // Variable out of scope
}
```

#### 4. Logical Errors

Not detected by compiler (program compiles but doesn't work as intended).

**Examples:**

```c
// Infinite loop
for (int i = 0; i >= 0; i++) {  // Should be i < 10
    // ...
}

// Wrong formula
area = length * length;  // Should be length * width
```

### Error Recovery Strategies

Compilers use various strategies to continue after detecting an error.

#### 1. Panic Mode

Skip tokens until a synchronizing token is found.

**Synchronizing tokens:** semicolon, closing brace, end of statement

```c
if (x > 5 {          // Error: missing )
    x = 10;
}                    // Recover at }
```

#### 2. Phrase-Level Recovery

Perform local corrections.

```c
if x > 5 {           // Error: missing (
// Compiler inserts ( and continues
```

#### 3. Error Productions

Add error productions to grammar.

```
statement -> if ( expr ) statement
           | if error ) statement     // Missing (
```

#### 4. Global Correction

Find minimum changes to make program syntactically correct (expensive, rarely used).

### Error Reporting

**Good Error Message Components:**

1. **Location**: File, line, column
2. **Error type**: Lexical, syntax, semantic
3. **Description**: What went wrong
4. **Suggestion**: How to fix

**Example:**

```
main.c:10:5: error: undeclared identifier 'x'
    x = 10;
    ^
Did you mean 'y'?
```

**Poor Error Message:**

```
Error
```

### Error Message Examples

**Lexical Error:**

```
error: invalid suffix "abc" on integer constant
    int x = 123abc;
                ^^^
```

**Syntax Error:**

```
error: expected ';' before '}' token
    x = 10
          ^
          ;
}
```

**Semantic Error:**

```
error: incompatible types when assigning to type 'int' from type 'char *'
    int x = "hello";
            ^~~~~~~
```

---

## Advanced Topics

### LL vs LR Parsing

```
                    PARSER COMPARISON
                    
           LL PARSING              LR PARSING
                |                       |
    +-----------+-----------+  +--------+--------+
    |                       |  |        |        |
Top-Down              Predictive   Bottom-Up   Shift-Reduce
Leftmost derivation              Rightmost derivation
                                 (reverse)
    
Properties:               Properties:
- Left-to-right scan      - Left-to-right scan
- Leftmost derivation     - Rightmost derivation (rev)
- Lookahead (1)           - Lookahead (0, 1, k)
- Simpler                 - More powerful
- Recursive descent       - Table-driven
- LL(1) grammar           - LR(0), SLR, LALR, CLR
```

### LL(1) Parsing

**Requirements:**

- No left recursion
- No ambiguity
- Disjoint FIRST sets for alternatives

**Example LL(1) Grammar:**

```
S -> A | B
A -> a A b | ε
B -> b B a | ε
```

**Parsing Table:**

|     | a   | b   | $   |
|-----|-----|-----|-----|
| S   | A   | B   | -   |
| A   | aAb | ε   | ε   |
| B   | -   | bBa | ε   |

### LR Parsing

**LR Parser Types:**

```
                    LR FAMILY
                         
                      LR(k)
                         |
         +---------------+---------------+
         |               |               |
      LR(0)            SLR            LALR          CLR(1)
         |               |               |             |
    Simplest        Simple LR      Look-Ahead LR   Canonical LR
    Least power     More power     Most practical   Most powerful
                                   (used in YACC)
```

**LR Parsing Algorithm:**

```
1. Initialize stack with start state
2. Repeat:
   a. If action[state, lookahead] = shift s:
      - Push lookahead and state s onto stack
      - Advance input
   b. If action[state, lookahead] = reduce A -> β:
      - Pop 2*|β| symbols from stack
      - Push A and goto[state, A]
   c. If action[state, lookahead] = accept:
      - Parsing successful
   d. If action[state, lookahead] = error:
      - Report error
```

### LLVM Architecture

LLVM is a modern compiler infrastructure used by many languages (C, C++, Rust, Swift).

```
                    LLVM ARCHITECTURE
                    
    Source            LLVM              Target
    Languages         Core              Platforms
        |               |                  |
    C --|          +----+----+         |-- x86
    C++ |          |         |         |-- ARM
    Rust|----->  LLVM IR  <---------|-- RISC-V
    Swift|         |         |         |-- WebAssembly
    Go  |          +----+----+         |-- NVPTX (GPU)
        |               |                  |
        
    Frontend       Middle-End         Backend
    (Clang,        (Optimizer)        (CodeGen)
     Rustc)
```

**LLVM IR Example:**

```llvm
define i32 @add(i32 %a, i32 %b) {
entry:
  %sum = add i32 %a, %b
  ret i32 %sum
}
```

### Just-In-Time (JIT) Compilation

JIT compilers compile code at runtime.

```
                    JIT COMPILATION
                    
Source Code
    |
    v
Bytecode/IR  <-- Compile once
    |
    v
[Interpreter] -----> [JIT Compiler] -----> Machine Code
    |                     |                      |
    |                     v                      |
    |              Hot code detection            |
    |                     |                      |
    +---------------------+----------------------+
                          |
                          v
                    Fast Execution
```

**Used in:**

- Java (HotSpot JVM)
- JavaScript (V8 engine)
- .NET (CLR)
- Python (PyPy)

---

## Summary

### Complete Compilation Flow

```
Source Code
   |
   v
[Preprocessor]
   |
   v
Pure Source
   |
   v
[Lexical Analyzer]  <-- Regular Expressions, DFA
   |
   v
Token Stream
   |
   v
[Syntax Analyzer]   <-- Context-Free Grammar, Parse Table
   |
   v
Parse Tree / AST
   |
   v
[Semantic Analyzer] <-- Type Checking, Scope Resolution
   |
   v
Annotated AST
   |
   v
[IR Generator]
   |
   v
Intermediate Code (TAC, SSA)
   |
   v
[Optimizer]         <-- Constant Folding, CSE, Loop Opt
   |
   v
Optimized IR
   |
   v
[Code Generator]    <-- Instruction Selection, Reg Alloc
   |
   v
Assembly Code
   |
   v
[Assembler]
   |
   v
Object Code
   |
   v
[Linker]            <-- Symbol Resolution, Relocation
   |
   v
Executable
   |
   v
[Loader]
   |
   v
Running Program
```

### Key Concepts Summary

**Lexical Analysis:**

- Input: Character stream
- Output: Token stream
- Basis: Regular expressions, finite automata

**Syntax Analysis:**

- Input: Token stream
- Output: Parse tree / AST
- Basis: Context-free grammars
- Algorithms: LL, LR parsing

**Semantic Analysis:**

- Input: AST
- Output: Annotated AST
- Tasks: Type checking, scope resolution

**Intermediate Representation:**

- Forms: TAC, SSA, quadruples
- Purpose: Machine-independent optimization

**Optimization:**

- Machine-independent: Constant folding, CSE, loop optimization
- Machine-dependent: Register allocation, instruction scheduling

**Code Generation:**

- Input: Optimized IR
- Output: Assembly code
- Tasks: Instruction selection, register allocation

**Assembly and Linking:**

- Assembler: Assembly → Object code
- Linker: Object files → Executable
- Loader: Executable → Running process

---

## References and Further Reading

**Classic Compiler Texts:**

- "Compilers: Principles, Techniques, and Tools" (Dragon Book) - Aho, Lam, Sethi, Ullman
- "Engineering a Compiler" - Cooper and Torczon
- "Modern Compiler Implementation in C/Java/ML" - Appel

**Online Resources:**

- Stanford CS143 (Compilers course)
- LLVM documentation
- GCC internals documentation

**Tools:**

- Lex/Flex (Lexical analyzer generator)
- Yacc/Bison (Parser generator)
- LLVM (Compiler infrastructure)
- ANTLR (Parser generator)

---

*End of Compiler Design Guide*

## Compile Time vs Runtime

- **Compile Time**: The phase when source code is translated into an intermediate form (like bytecode). For Java, `javac` compiles `.java` files into `.class` files. In Python (CPython), this is when `.py` files are turned into bytecode (`.pyc`). 
    
- **Runtime**: The phase when the program is actually executing. The JVM or Python Virtual Machine (PVM) runs the code, interprets bytecode, and manages memory, threads, and JIT compilation. 
    

Runtime systemsystem that provides behavior needed by running code; primarily implements portions of an execution model

[Wikipedia](https://en.wikipedia.org/wiki/Runtime_system)

## What is JIT (Just-In-Time) Compilation?

**JIT (Just-In-Time) compilation** is a performance optimization that happens **at runtime**.  Instead of interpreting bytecode line by line every time, the JIT compiler:

1. **Monitors code execution** to find "hot spots" (frequently used methods or loops). 
    
2. **Compiles those hot spots** into native machine code. 
    
3. **Caches and reuses** the compiled code for future calls. 
    

This means the first run might be slower, but repeated execution becomes much faster. 

### Example: In Java (JVM)

- **Step 1**: `javac` compiles Java code → bytecode (compile time). 
    
- **Step 2**: JVM loads bytecode and interprets it (runtime). 
    
- **Step 3**: JIT identifies a frequently called method → compiles it to machine code. 
    
- **Step 4**: Future calls use the compiled machine code directly (faster execution). 
    

### Example: In Python

- **CPython**: No JIT — interprets bytecode every time. 
    
- **PyPy**: Has a JIT — compiles hot loops into machine code at runtime, making it much faster for long-running programs. 
    

## Why JIT Matters

- **Speed**: Machine code runs faster than interpreted bytecode. 
    
- **Adaptability**: JIT uses real-time data (e.g., which methods are called often) to optimize better than static compilers. 
    
- **Platform Optimization**: JIT generates code tailored to the current CPU architecture. 
    

But JIT adds complexity and memory usage, and benefits only code that runs multiple times.