Comprehensive Notes with Explanation

---

## 1. Problem Understanding

You are given:

- A sorted character array `letters`
    
- A target character `target`
    
- The array is circular
    

You must return the smallest character strictly greater than `target`.

If no such character exists, return the first element (circular behavior).

---

### Example

```text
letters = ['c','f','j']
target  = 'c'
Output  = 'f'
```

Circular order:

```text
c → f → j → c → f → ...
```

---
# 2. Core Idea

This is a **Ceiling Binary Search** problem with circular handling.

We are searching for:

first index i such that letters[i]>target\text{first index } i \text{ such that } letters[i] > target

If no such index exists:

return letters[0]return\ letters[0]

---

# 3. Binary Search Logic

## Rule

```text
If letters[mid] <= target → move right
If letters[mid] >  target → move left
```

Why?

Because we want the first element strictly greater than target.

---

# 4. Code

```java
class Solution {
    public char nextGreatestLetter(char[] letters, char target) {

        int start = 0;
        int end = letters.length - 1;

        while (start <= end) {

            int mid = start + (end - start) / 2;

            if (letters[mid] <= target) {
                start = mid + 1;
            } else {
                end = mid - 1;
            }
        }

        return letters[start % letters.length];
    }
}
```

---

# 5. Step-by-Step Explanation

## Step 1 — Initialize Boundaries

```text
start = 0
end   = letters.length - 1
```

This defines the search space.

---

## Step 2 — Loop Condition

```text
while (start <= end)
```

We shrink the search window until it collapses.

---

## Step 3 — Find Middle Safely

```java
int mid = start + (end - start) / 2;
```

Prevents integer overflow.

---

## Step 4 — Comparison Logic

### Case 1: letters[mid] <= target

```java
start = mid + 1;
```

Why?

Because:

- letters[mid] is too small
    
- Or equal (equal is not allowed)
    
- So answer must be to the right
    

---

### Case 2: letters[mid] > target

```java
end = mid - 1;
```

Why?

Because:

- This might be a valid answer
    
- But we check left side for a smaller valid one
    

---

## Step 5 — Loop Ends

Loop stops when:

start>endstart > end

At this point:

start=first index where letters[i] > targetstart = \text{first index where letters[i] > target}

If no such element exists:

start=letters.lengthstart = letters.length

---

# 6. Circular Handling

```java
return letters[start % letters.length];
```

Why modulo?

Case:

```text
letters = ['c','f','j']
target  = 'z'
```

Binary search ends with:

```text
start = 3
```

Index 3 is out of bounds.

But:

3mod  3=03 \mod 3 = 0

So:

```text
letters[0] = 'c'
```

Correct circular behavior.

---

# 7. Why `<=` Is Critical

Incorrect condition:

```java
if (letters[mid] < target)
```

Fails when target equals a letter.

Example:

```text
letters = ['c','f','j']
target  = 'c'
```

If you use `<`:

- mid=0 → 'c' < 'c' → false
    
- end moves left incorrectly
    
- returns 'c'
    
- Wrong
    

Correct condition:

```java
if (letters[mid] <= target)
```

Ensures equal values move right.

---

# 8. Visual Trace Example

Input:

```text
letters = ['c','f','j']
target  = 'c'
```

Initial:

```text
start=0, end=2
```

Pass 1:

```text
mid=1
letters[1]='f' > 'c'
end=0
```

Pass 2:

```text
mid=0
letters[0]='c' <= 'c'
start=1
```

Loop ends:

```text
start=1, end=0
```

Return:

```text
letters[1] = 'f'
```

---

# 9. Edge Cases

### Target smaller than all letters

```text
letters=['c','f','j'], target='a'
```

Result: 'c'

---

### Target equal to largest

```text
letters=['c','f','j'], target='j'
```

Result: 'c' (circular)

---

### Target greater than largest

```text
letters=['c','f','j'], target='z'
```

Result: 'c' (circular)

---

# 10. Complexity

Time Complexity:

O(log⁡n)O(\log n)

Space Complexity:

O(1)O(1)

---

# 11. Pattern Recognition

This problem is:

```text
Ceiling Binary Search + Circular Wrap
```

General pattern:

Find first element > targetFind\ first\ element\ >\ target

Then:

Return index % lengthReturn\ index\ \% \ length

---

# 12. Related Problems

- 35 — Search Insert Position (Ceiling Index)
    
- 704 — Binary Search
    
- 34 — First and Last Position
    
- 540 — Single Element in Sorted Array
    

---

# Final Summary

Binary search is not only for exact match.

It can also find:

- Ceiling
    
- Floor
    
- Lower bound
    
- Upper bound
    
- Insert position
    
- Next greater element
    

LeetCode 744 is a clean example of ceiling search with circular handling.