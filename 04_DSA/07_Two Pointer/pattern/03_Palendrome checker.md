

## Pattern 1: Pure Integer Palindrome

Use mathematical reversal without string conversion. Extract digits using modulo and division operations.

**Logic:** Reverse the integer digit by digit and compare with original. Negative numbers are never palindromes.

**Pseudocode:**

```java
if x < 0: return false
original = x
reversed = 0
while x > 0:
    digit = x % 10
    reversed = reversed * 10 + digit
    x = x / 10
return original == reversed
```

**Time:** O(log N) - number of digits  
**Space:** O(1)

**Key Points:**

- Use `x % 10` to extract last digit
- Use `x / 10` to remove last digit
- Build reversed number: `reversed * 10 + digit`
- Never use `x = x % 10` alone (loses all digits)

## Pattern 2: String/Character Palindrome

Use two pointers from opposite ends moving toward center. Compare characters while moving pointers.

**Logic:** Left pointer at start, right pointer at end. Compare and move inward until pointers meet or cross.

**Pseudocode:**

```java
left = 0
right = s.length - 1
while left < right:
    if s[left] != s[right]: return false
    left++
    right--
return true
```

**Time:** O(N)  
**Space:** O(1)

**Java Implementation:**

```java
public boolean isPalindrome(String s) {
    int left = 0;
    int right = s.length() - 1;
    
    while (left < right) {
        if (s.charAt(left) != s.charAt(right)) {
            return false;
        }
        left++;
        right--;
    }
    return true;
}
```

**Key Point:** Java strings use `s.charAt(index)` NOT `s[index]`. Arrays use `arr[index]` directly.

**Variations:**

**Case Insensitive (Java):**

```java
while (left < right) {
    if (Character.toLowerCase(s.charAt(left)) != 
        Character.toLowerCase(s.charAt(right))) {
        return false;
    }
    left++;
    right--;
}
```

**Skip Non-Alphanumeric (Java):**

```java
while (left < right) {
    while (left < right && !Character.isLetterOrDigit(s.charAt(left))) {
        left++;
    }
    while (left < right && !Character.isLetterOrDigit(s.charAt(right))) {
        right--;
    }
    if (Character.toLowerCase(s.charAt(left)) != 
        Character.toLowerCase(s.charAt(right))) {
        return false;
    }
    left++;
    right--;
}
```

## Pattern 3: Array Palindrome

Identical to string palindrome but works with array indices instead of characters.

**Logic:** Compare elements from both ends moving toward center.

**Pseudocode:**

```java
left = 0
right = arr.length - 1
while left < right:
    if arr[left] != arr[right]: return false
    left++
    right--
return true
```

**Time:** O(N)  
**Space:** O(1)

## Important: String vs Array Access in Java

**String:** Must use `charAt()`

```java
String s = "hello";
char c = s.charAt(0);  // ✓ CORRECT
char c = s[0];          // ✗ WRONG - compilation error
```

**Array:** Direct bracket access

```java
char[] arr = {'h', 'e', 'l', 'l', 'o'};
char c = arr[0];        // ✓ CORRECT
char c = arr.charAt(0); // ✗ WRONG - arrays don't have charAt()
```

**Why?** Strings are immutable objects in Java, not primitive arrays. The `charAt()` method provides controlled access to internal character data.

## Pattern 4: Linked List Palindrome

Find middle using fast-slow pointers, reverse second half, compare both halves.

**Logic:** Use Floyd's cycle detection to find middle, reverse from middle, compare first half with reversed second half.

**Pseudocode:**

```java
// Find middle
slow = head, fast = head
while fast != null and fast.next != null:
    slow = slow.next
    fast = fast.next.next

// Reverse second half
secondHalf = reverse(slow)

// Compare
firstHalf = head
while secondHalf != null:
    if firstHalf.val != secondHalf.val: return false
    firstHalf = firstHalf.next
    secondHalf = secondHalf.next
return true

// Helper: Reverse linked list
reverse(head):
    prev = null
    while head != null:
        next = head.next
        head.next = prev
        prev = head
        head = next
    return prev
```

**Time:** O(N)  
**Space:** O(1)

**Alternative (with extra space):**

```java
// Push all values to stack
stack = []
curr = head
while curr != null:
    stack.push(curr.val)
    curr = curr.next

// Compare with original
curr = head
while curr != null:
    if curr.val != stack.pop(): return false
    curr = curr.next
return true
```

**Time:** O(N)  
**Space:** O(N)

## Pattern 5: Palindrome Substring

Check if substring is palindrome by expanding around center or using two pointers on substring.

**Logic:** For each possible center, expand outward while characters match.

**Pseudocode (Expand Around Center):**

```java
for i from 0 to n-1:
    // Odd length palindrome (single center)
    expandAroundCenter(s, i, i)
    // Even length palindrome (two centers)
    expandAroundCenter(s, i, i+1)

expandAroundCenter(s, left, right):
    while left >= 0 and right < s.length and s[left] == s[right]:
        // Record palindrome [left, right]
        left--
        right++
```

**Time:** O(N²)  
**Space:** O(1)

## LeetCode Problems by Pattern

|Problem|Type|Pattern|Key Technique|
|---|---|---|---|
|9. Palindrome Number|Integer|Pure Int|Reverse digits mathematically|
|125. Valid Palindrome|String|Two Pointer|Skip non-alphanumeric, case insensitive|
|234. Palindrome Linked List|LinkedList|Fast-Slow + Reverse|Find middle, reverse second half|
|680. Valid Palindrome II|String|Two Pointer|Allow one deletion, check both options|
|5. Longest Palindromic Substring|String|Expand Center|Check all centers|
|647. Palindromic Substrings|String|Expand Center|Count all palindromes|
|131. Palindrome Partitioning|String|Backtracking + DP|Split into palindromic substrings|
|214. Shortest Palindrome|String|KMP / Two Pointer|Add minimum chars to front|
|409. Longest Palindrome|String|Hash Map|Count character frequencies|
|516. Longest Palindromic Subsequence|String|DP|LCS with reverse|
|1312. Minimum Insertion Steps|String|DP|Make string palindrome|
|336. Palindrome Pairs|String Array|Trie / Hash|Find concatenation palindromes|

## Common Mistakes and Fixes

**Mistake 1:** Using bracket notation on String in Java

```java
// WRONG - Compilation error
String s = "hello";
if (s[0] == 'h') { }

// CORRECT
if (s.charAt(0) == 'h') { }
```

**Mistake 2:** Using `x = x % 10` alone for integer palindrome

```java
// WRONG
while (x > 0) {
    x = x % 10;  // Loses all digits except last
}

// CORRECT
while (x > 0) {
    digit = x % 10;
    reversed = reversed * 10 + digit;
    x = x / 10;
}
```

**Mistake 3:** Not handling negative integers

```java
// WRONG
public boolean isPalindrome(int x) {
    // Negative numbers treated as positive
}

// CORRECT
if (x < 0) return false;
```

**Mistake 4:** Not skipping non-alphanumeric in string palindrome

```java
// WRONG - fails for "A man, a plan, a canal: Panama"
if (s.charAt(left) != s.charAt(right)) return false;

// CORRECT
while (left < right && !Character.isLetterOrDigit(s.charAt(left))) left++;
while (left < right && !Character.isLetterOrDigit(s.charAt(right))) right--;
```

**Mistake 5:** Using string conversion when not allowed

```java
// WRONG for LeetCode 9 (pure integer)
String s = String.valueOf(x);

// CORRECT
int reversed = 0;
while (x > 0) {
    reversed = reversed * 10 + x % 10;
    x /= 10;
}
```

## Optimization: Half Reversal for Integer

Instead of reversing entire integer, reverse only half and compare.

**Pseudocode:**

```java
if x < 0 or (x % 10 == 0 and x != 0): return false

reversed = 0
while x > reversed:
    reversed = reversed * 10 + x % 10
    x = x / 10

// Check: x == reversed (odd digits) or x == reversed/10 (even digits)
return x == reversed or x == reversed / 10
```

**Example:** 12321

- After loop: x = 12, reversed = 123
- Check: 12 == 123/10 → true

**Time:** O(log N)  
**Space:** O(1)

## Decision Tree

```java
Is input an integer?
├─ Yes → Use math reversal (Pattern 1)
│         Avoid string conversion unless allowed
│
└─ No → Is it a string/array?
    ├─ Yes → Use two pointers (Pattern 2/3)
    │         Handle case sensitivity and special chars
    │
    └─ No → Is it a linked list?
        └─ Yes → Use fast-slow + reverse (Pattern 4)
                 Or use stack (O(N) space)
```

## Quick Reference

**Integer:** Reverse digits → `reversed * 10 + x % 10`  
**String:** Two pointers → `left++, right--`  
**Array:** Two pointers → Same as string  
**LinkedList:** Find middle + reverse → Compare halves  
**Substring:** Expand center → Check all centers

All palindrome problems follow the core principle of symmetry checking from opposite ends or center expansion.