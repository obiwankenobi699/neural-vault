# Recursion in Programming

## Introduction to Recursion

Recursion is a programming technique where a function calls itself to solve a problem by breaking it down into smaller, similar subproblems. Each recursive call works on a simpler version of the original problem until a base case is reached that can be solved directly without further recursion.

![[04_DSA/05_Recursion/views/1.excalidraw.md#^frame=uEF59d3b]]

## Why Use Recursion

Traditional iterative approaches require writing separate functions or loops for repetitive tasks. Recursion provides an elegant alternative by allowing a single function to call itself with different parameters, making code more concise and easier to reason about for certain problem types. The key advantage is that recursion naturally maps to problems that have a recursive structure, such as tree traversals, divide-and-conquer algorithms, and mathematical sequences.

## Non-Recursive vs Recursive Approach

Consider the problem of printing numbers from 1 to 5. The non-recursive approach requires defining multiple functions, each calling the next one in sequence:

```java
static void print1(int n) {
    System.out.println(n);
    print2(2);
}

static void print2(int n) {
    System.out.println(n);
    print3(3);
}

static void print3(int n) {
    System.out.println(n);
    print4(4);
}
```

This approach is rigid and does not scale well. If we need to print 100 numbers, we would need 100 separate functions. The recursive approach solves this by using a single function that calls itself:

```java
static void print(int n) {
    if (n == 5) {
        System.out.println(5);
        return;
    }
    System.out.println(n);
    print(n + 1);
}
```

The recursive version is cleaner, scalable, and requires only changing the base condition to handle different ranges.

## Components of Recursion

Every recursive function must have two essential components to function correctly. The base condition determines when the recursion should stop, preventing infinite loops. Without a base condition, the function would call itself indefinitely until the program crashes due to stack overflow. The recursive call is where the function invokes itself with modified parameters, typically moving closer to the base condition with each call.

## Base Condition

The base condition is the termination criterion for recursion. It defines the simplest case that can be solved directly without further recursive calls. In the example above, when n equals 5, the function prints 5 and returns without making another recursive call. This stops the chain of function calls and allows the program to complete. Properly defining the base condition is critical because an incorrect or missing base condition will cause infinite recursion.

```java
if (n == 5) {
    System.out.println(5);
    return;
}
```

## Recursive Call and Stack Behavior

When a function makes a recursive call, the current function execution is paused and a new instance of the function is placed on the call stack. Each recursive call creates a new stack frame containing the function's local variables and parameters. The stack grows with each recursive call until the base condition is reached. Once the base case returns, the stack begins to unwind, resuming each paused function call in reverse order.

```java
print(n + 1);  // Creates new stack frame with n+1
```

In the example, calling `print(1)` results in the following stack behavior:

- `print(1)` is called, prints 1, then calls `print(2)`
- `print(2)` is called, prints 2, then calls `print(3)`
- `print(3)` is called, prints 3, then calls `print(4)`
- `print(4)` is called, prints 4, then calls `print(5)`
- `print(5)` hits the base condition, prints 5, and returns
- Stack unwinds as each function completes

## Recursion Tree

A recursion tree is a visual representation of how recursive calls branch out during execution. Each node in the tree represents a function call, and edges represent the recursive calls made from that function. The tree helps visualize the flow of execution and understand the complexity of recursive algorithms.

For a Fibonacci-like recursion pattern where `f(n)` calls both `f(n-1)` and `f(n-2)`, the tree shows how a single call branches into multiple recursive calls:

```
       f(4)
      /    \
   f(3)  +  f(2)
   / \      / \
f(2)+f(1) f(1)+f(0)
/ \
f(1)+f(0)
```

Each level of the tree represents a recursive depth, and the leaves of the tree represent base cases. The tree structure reveals that some subproblems may be computed multiple times, which is important for understanding time complexity and identifying opportunities for optimization through techniques like memoization.

## Types of Recurrence Relations

Recurrence relations can be classified into different categories based on their structure and behavior. Linear recurrence relations involve a constant number of recursive calls at each level, typically one or two calls that progress sequentially through the problem space. The Fibonacci sequence is a classic example of linear recurrence where each term depends on the previous two terms. Divide and conquer recurrence relations split the problem into multiple independent subproblems, solve each recursively, and combine the results. Examples include binary search, merge sort, and quicksort where the problem is divided into smaller portions at each recursive step.

## Recurrence Relations

A recurrence relation is a mathematical formula that expresses a recursive function in terms of itself with different arguments. When implementing recursion, writing out the recurrence relation helps formalize the problem structure and analyze time complexity. The recurrence relation explicitly shows how the current problem depends on smaller subproblems.

For the Fibonacci sequence, the recurrence relation is expressed as:

```
fib(n) = fib(n-1) + fib(n-2)
```

This notation captures the essence of the recursive algorithm: to compute the nth Fibonacci number, we sum the two preceding Fibonacci numbers. The recurrence relation provides a clear specification of the algorithm and serves as a foundation for complexity analysis using methods like the Master Theorem or recursion tree analysis.

## Fibonacci Implementation Example

The Fibonacci sequence demonstrates the key components of a recursive function in a practical context. The implementation must handle computation, state updates, base case checking, termination, processing, and the recursive call:

```java
public static void print(int a, int b, int c) {
    c = a + b;                           // COMPUTE: calculate next value
    a = b; b = c;                        // UPDATE STATE: shift values
    if (c == 13) {                       // BASE CASE: termination condition
        System.out.println(c);
        return;                          // TERMINATE: stop recursion
    }
    System.out.println(c);               // PROCESS: output current value
    print(a, b, c);                      // RECURSIVE CALL: continue sequence
}
```

This structure illustrates the typical flow of a recursive function: compute the necessary values, check if the base case is reached, process the current state, and make the recursive call with updated parameters. Each step serves a specific purpose in the overall recursive algorithm.

## Tail Recursion

Tail recursion occurs when the recursive call is the last operation performed in the function. There are no pending operations after the recursive call returns. In the example provided, the `print(n + 1)` call is in tail position because nothing happens after it returns. Tail recursion is significant because many compilers and interpreters can optimize it into an iterative loop, eliminating the overhead of multiple stack frames and preventing stack overflow for deep recursions.

```java
static void print(int n) {
    if (n == 5) {
        System.out.println(5);
        return;
    }
    System.out.println(n);
    print(n + 1);  // Tail recursion - last operation
}
```

## Key Considerations

When working with recursion, several factors must be considered. Stack space is limited, so very deep recursions can cause stack overflow errors. Each recursive call consumes stack memory for storing local variables and return addresses. Performance can be a concern because function calls have overhead, and naive recursive solutions may recompute the same subproblems multiple times. Readability is often improved with recursion for problems with natural recursive structure, but it can be harder to debug than iterative solutions. Understanding the recursion tree helps identify inefficiencies and opportunities for optimization through dynamic programming or memoization techniques.

## Common Patterns

Recursion is particularly well-suited for certain problem types. Tree and graph traversal naturally fit recursive patterns because each node can recursively process its children. Divide and conquer algorithms like merge sort and quicksort break problems into smaller subproblems recursively. Backtracking problems such as solving mazes or generating permutations use recursion to explore different paths. Mathematical sequences like Fibonacci numbers, factorials, and greatest common divisors have recursive definitions that map directly to recursive implementations.

## Binary Search with Recursion

Binary search is an excellent example of divide and conquer recursion applied to sorted arrays. The algorithm repeatedly divides the search space in half, eliminating the half that cannot contain the target value. This approach reduces the problem size logarithmically with each recursive call:

```java
public static int binarySearch(int s, int e, int t, int[] arr) {
    if (s > e) {
        return -1;  // Base case: element not found
    }
    
    int mid = s + (e - s) / 2;
    
    if (arr[mid] == t) {
        return mid;  // Base case: element found
    }
    
    if (arr[mid] < t) {
        return binarySearch(mid + 1, e, t, arr);  // Search right half
    }
    
    return binarySearch(s, mid - 1, t, arr);  // Search left half
}
```

The recursive structure naturally matches the problem definition. Each call examines the middle element and recursively searches the appropriate half of the array. The base cases handle both successful searches (element found) and unsuccessful searches (search space exhausted).

## Understanding Return in Recursion

A critical concept in recursion is understanding what the return statement actually does. The statement `return binarySearch(mid+1, e, t, arr)` does not add new parameters to your arguments. Instead, it returns the result of the function call as an integer value. The return statement does not change the original parameters s, e, t, and arr in the calling function. The caller receives one integer value, which is either the index of the found element or -1 to indicate failure.

Consider the flow when searching for 58 in the array [12, 24, 36, 47, 58, 61]:

```
binarySearch(0, 5, 58, arr)
    ↓ returns result of
binarySearch(3, 5, 58, arr)
    ↓ returns result of
binarySearch(4, 5, 58, arr)
    → returns 4
        ↑ result flows up
        ↑ result flows up
ans = 4
```

The return values propagate up through the call stack. Each recursive call returns its result to the caller, which in turn returns that result to its caller, until the original call receives the final answer.

## Parameter Scope in Recursion

Each recursive call creates a new stack frame with its own local copy of parameters. The parameters s, e, t, and arr are local to each specific call frame. When a recursive call is made with new argument values, those values exist only in the new stack frame and do not affect the parameters in the calling frame:

```java
public static int binarySearch(int s, int e, int t, int[] arr) {
    // s, e, t, arr are LOCAL to THIS call frame only
    if (arr[mid] == t) return mid;
    return binarySearch(mid + 1, e, t, arr);  // NEW call = NEW parameters
}
```

Each recursive call operates with a new set of parameter values. The return statement means "give the result to the parent frame." This separation of stack frames is fundamental to how recursion maintains state across multiple simultaneous function invocations.

## Visual Stack Representation

The call stack for binary search can be visualized as a series of nested function calls, each with its own parameter values:

```
main()
  └─ binarySearch(0, 5, 58, arr)
      └─ binarySearch(3, 5, 58, arr)
          └─ binarySearch(4, 5, 58, arr) → returns 4
                                              ↑↑↑ result flows back up
```

Each level of indentation represents a deeper level in the call stack. When the deepest call finds the target and returns 4, that value propagates back up through each waiting call frame until it reaches the original caller in main. Understanding this stack structure is essential for debugging recursive functions and predicting their behavior.

## Common Recursion Mistakes

A frequent error in recursive functions is comparing the wrong values in the base condition. For instance, comparing arr[mid] with mid (the index) instead of arr[mid] with t (the target value) will cause infinite recursion because the condition will never be satisfied correctly. The correct comparison must check the actual element value against the search target:

```java
if (arr[mid] == t) {  // Compare VALUE, not index
    return mid;
}
```

This type of logical error can be difficult to spot but causes severe problems including stack overflow from infinite recursion. Careful attention to what each variable represents (index versus value) prevents such mistakes.

## Example: Complete Recursive Function

```java
public class RecursionExample {
    public static void main(String[] args) {
        print(1);
    }

    static void print(int n) {
        // Base condition: stop when n reaches 5
        if (n == 5) {
            System.out.println(5);
            return;
        }
        
        // Print current number
        System.out.println(n);
        
        // Recursive call with n+1
        print(n + 1);
    }
}
```

This example demonstrates all key components: a clear base condition that prevents infinite recursion, a recursive call that moves toward the base case by incrementing n, and tail recursion where the recursive call is the final operation. The function elegantly handles the task that would otherwise require multiple separate functions in a non-recursive approach.

## Example: Complete Binary Search Implementation

```java
import java.util.*;

class Main {
    public static void main(String[] args) {
        int[] arr = {12, 24, 36, 47, 58, 61};
        int target = 58;
        int ans = binarySearch(0, arr.length - 1, target, arr);
        System.out.print(ans);  // Output: 4
    }
    
    public static int binarySearch(int s, int e, int t, int[] arr) {
        if (s > e) {
            return -1;  // Element not found
        }
        
        int mid = s + (e - s) / 2;
        
        if (arr[mid] == t) {
            return mid;  // Element found at mid
        }
        
        if (arr[mid] < t) {
            return binarySearch(mid + 1, e, t, arr);  // Search right
        }
        
        return binarySearch(s, mid - 1, t, arr);  // Search left
    }
}
```

This binary search implementation showcases recursion in a divide and conquer algorithm. The function has two base cases: one for when the element is found (return the index) and one for when the search space is exhausted (return -1). The recursive calls systematically narrow the search range by half with each invocation, demonstrating how recursion naturally expresses algorithms that divide problems into smaller subproblems. The time complexity is O(log n) due to the halving of the search space at each step, and the space complexity is O(log n) due to the recursion depth on the call stack.