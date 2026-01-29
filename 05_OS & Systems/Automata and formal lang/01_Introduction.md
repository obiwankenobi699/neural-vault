## Types of Automata and Corresponding Languages

The **Chomsky Hierarchy** classifies formal languages and automata into four levels based on computational power:

### 1. **Type-3: Regular Languages**
- **Grammar**: Regular
- **Automaton**: **Finite Automaton (FA)** – DFA or NFA
- **Used for**: Lexical analysis, pattern matching, regular expressions
- **Example**: `a*b` (any number of 'a's followed by 'b') 

### 2. **Type-2: Context-Free Languages**
- **Grammar**: Context-Free
- **Automaton**: **Pushdown Automaton (PDA)**
- **Used for**: Parsing programming languages, syntax analysis
- **Example**: `a^n b^n` (equal number of 'a's and 'b's) 

### 3. **Type-1: Context-Sensitive Languages**
- **Grammar**: Context-Sensitive
- **Automaton**: **Linear Bounded Automaton (LBA)**
- **Used for**: Natural language processing, complex syntax rules
- **Example**: `a^n b^n c^n` 

### 4. **Type-0: Recursively Enumerable Languages**
- **Grammar**: Unrestricted
- **Automaton**: **Turing Machine (TM)**
- **Used for**: General computation, any computable problem
- **Example**: Halting problem

Each level includes all lower levels (proper inclusions), forming a hierarchy of increasing computational power.



