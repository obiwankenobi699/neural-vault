4# BEGINNER DSA NOTES - JAVA

## Complete Guide: Logic, Intuition, and Problem Solving

---

## Table of Contents

1. [Fundamental Operators: Division (/) and Modulus (%)](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#operators)
2. [Core Problem-Solving Patterns](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#patterns)
3. [Essential Beginner Problems](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#problems)
4. [Array Manipulation Basics](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#arrays)
5. [Number Manipulation Techniques](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#numbers)
6. [Logic Building Exercises](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#logic-exercises)

---

# 1. Fundamental Operators: Division (/) and Modulus (%) {#operators}

## 1.1 Division Operator (/)

**Purpose:** Divides one number by another and returns the quotient (whole part).

**Key Characteristics:**

- Integer division truncates decimal part
- Used to remove digits, scale down numbers, or find quotients

**Common Use Cases:**

### A) Removing Last Digit from Number

```java
int number = 2345;
int withoutLastDigit = number / 10;  // Result: 234

// Explanation:
// 2345 / 10 = 234.5 → truncated to 234
```

**Intuition:** Dividing by 10 shifts digits one place to the right, effectively removing the last digit.

### B) Counting Digits in Number

```java
int number = 12345;
int digitCount = 0;

while (number > 0) {
    number = number / 10;  // Remove last digit
    digitCount++;
}

System.out.println("Total digits: " + digitCount);  // 5
```

**Intuition:** Each division by 10 removes one digit. Count iterations until number becomes 0.

### C) Finding Quotient

```java
int dividend = 17;
int divisor = 5;
int quotient = dividend / divisor;  // 3

// 17 / 5 = 3 (remainder ignored)
```

---

## 1.2 Modulus Operator (%)

**Purpose:** Returns the remainder after division.

**Key Characteristics:**

- Extracts patterns, cycles, or specific digits
- Useful for checking divisibility, extracting last digit

**Common Use Cases:**

### A) Extracting Last Digit

```java
int number = 2345;
int lastDigit = number % 10;  // Result: 5

// Explanation:
// 2345 % 10 = remainder when dividing by 10 = 5
```

**Intuition:** Any number % 10 gives the ones place digit (last digit).

### B) Checking Even or Odd

```java
int number = 42;

if (number % 2 == 0) {
    System.out.println("Even");
} else {
    System.out.println("Odd");
}
```

**Intuition:** Even numbers are divisible by 2 (remainder 0), odd numbers leave remainder 1.

### C) Checking Divisibility

```java
int number = 15;

if (number % 3 == 0) {
    System.out.println("Divisible by 3");
}

if (number % 5 == 0) {
    System.out.println("Divisible by 5");
}
```

**Intuition:** If remainder is 0, the number is perfectly divisible.

### D) Cycle Detection / Pattern Repetition

```java
// Print day of week based on day number
int day = 15;
String[] days = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};

System.out.println(days[day % 7]);

// Intuition: Days repeat every 7 days
// 15 % 7 = 1 → Monday
```

---

## 1.3 Combined Usage: / and %

**Most Common Pattern:** Extracting and processing all digits of a number.

```java
int number = 2345;

while (number > 0) {
    int lastDigit = number % 10;   // Extract last digit
    System.out.println(lastDigit);  // Process it
    number = number / 10;           // Remove last digit
}

// Output: 5, 4, 3, 2 (digits in reverse order)
```

**Flow Diagram:**

```
number = 2345

Iteration 1:
  lastDigit = 2345 % 10 = 5
  number = 2345 / 10 = 234

Iteration 2:
  lastDigit = 234 % 10 = 4
  number = 234 / 10 = 23

Iteration 3:
  lastDigit = 23 % 10 = 3
  number = 23 / 10 = 2

Iteration 4:
  lastDigit = 2 % 10 = 2
  number = 2 / 10 = 0

Loop ends (number = 0)
```

**Quick Reference:**

|Operation|Purpose|Example|
|---|---|---|
|`num % 10`|Get last digit|2345 % 10 = 5|
|`num / 10`|Remove last digit|2345 / 10 = 234|
|`num % 2`|Check even/odd|7 % 2 = 1 (odd)|
|`num % n`|Check divisibility|15 % 5 = 0 (divisible)|

---

# 2. Core Problem-Solving Patterns {#patterns}

# NOTE:For Pointer Value


```
# NOTE

**Variables declared INSIDE a loop block `{}` reset automatically each iteration.**

## **When it resets:**

java

`for(int i=0; i<5; i++){     int x = 0;     // ← RESETS to 0 every iteration    x++;    System.out.println(x);  // Prints: 1,1,1,1,1 }`

## **When it DOESN'T reset:**

java

`int x = 0;         // ← OUTSIDE loop for(int i=0; i<5; i++){     x++;           // ← Same x, accumulates } System.out.println(x);  // Prints: 5`

## **Your LeetCode case:**

java

`for(int i=0; i<nums.length; i++){     int digits = 0;      // ← RESET every number    while(number>0){        digits++;        // Counts THIS number only    }    if(digits%2==0) count++;  // count accumulates (outside) }`

## **Scope Rule (simple):**

text

`{                    // Block start     int x = 0;       // Born here    // x lives only here }                    // x dies here, fresh copy next time`

**Inside `{}` = temporary** → **resets each loop.**  
**Outside `{}` = permanent** → **accumulates forever.**

That's why your original `count` (outside) became 15, but `digits` (inside) resets perfectly!
```

## 2.1 Array Sum Pattern

**Concept:** Accumulate values by iterating through collection.

**Template:**

```java
int[] arr = {10, 20, 30, 40, 50};
int sum = 0;  // Initialize accumulator

for (int num : arr) {
    sum += num;  // Add each element
}

System.out.println("Sum: " + sum);  // 150
```

**Intuition:**

- Start with initial value (usually 0)
- Visit each element once
- Update accumulator with each element
- Final accumulator contains result

**Variations:**

```java
// Product of all elements
int product = 1;  // Start with 1 for multiplication
for (int num : arr) {
    product *= num;
}

// Count elements
int count = 0;
for (int num : arr) {
    count++;
}

// Sum of even numbers only
int evenSum = 0;
for (int num : arr) {
    if (num % 2 == 0) {
        evenSum += num;
    }
}
```

---

## 2.2 Digit Extraction Pattern

**Concept:** Process individual digits of a number using % and /.

**Template:**

```java
int number = 2345;

while (number > 0) {
    int digit = number % 10;   // Extract
    // Process digit here
    number = number / 10;      // Move to next digit
}
```

**Intuition:**

- Extract digits from right to left
- Use % 10 to get last digit
- Use / 10 to remove last digit
- Continue until number becomes 0

**Common Applications:**

```java
// Sum of digits
int num = 2345;
int sum = 0;
while (num > 0) {
    sum += num % 10;
    num /= 10;
}
// Result: 2 + 3 + 4 + 5 = 14

// Count digits
int num = 2345;
int count = 0;
while (num > 0) {
    count++;
    num /= 10;
}
// Result: 4 digits

// Reverse number
int num = 2345;
int reversed = 0;
while (num > 0) {
    int digit = num % 10;
    reversed = reversed * 10 + digit;
    num /= 10;
}
// Result: 5432
```

---

## 2.3 Two-Pointer Pattern

**Concept:** Use two indices to traverse array from different directions.

**Template:**

```java
int[] arr = {1, 2, 3, 4, 5};
int left = 0;
int right = arr.length - 1;

while (left < right) {
    // Process elements at left and right
    // Move pointers
    left++;
    right--;
}
```

**Intuition:**

- Start from both ends
- Move towards center
- Useful for reversing, finding pairs, palindrome checking

**Example: Reverse Array**

```java
int[] arr = {1, 2, 3, 4, 5};
int left = 0;
int right = arr.length - 1;

while (left < right) {
    // Swap elements
    int temp = arr[left];
    arr[left] = arr[right];
    arr[right] = temp;
    
    left++;
    right--;
}
// Result: [5, 4, 3, 2, 1]
```

---

## 2.4 Frequency Counting Pattern

**Concept:** Count occurrences of elements or conditions.

**Template:**

```java
int[] arr = {1, 2, 2, 3, 3, 3, 4};

// Count specific element
int target = 3;
int count = 0;
for (int num : arr) {
    if (num == target) {
        count++;
    }
}
```

**Advanced: Using Array as Frequency Table**

```java
// Count frequency of digits 0-9
int number = 112233;
int[] freq = new int[10];  // Index represents digit

while (number > 0) {
    int digit = number % 10;
    freq[digit]++;
    number /= 10;
}

// freq[1] = 2, freq[2] = 2, freq[3] = 2
```

---

# 3. Essential Beginner Problems {#problems}

## 3.1 Sum of All Elements in Array

**Problem:** Calculate the total sum of all elements in an array.

**Logic:**

- Initialize sum to 0
- Add each element to sum
- Return final sum

**Java Solution:**

```java
public class ArraySum {
    public static int sumArray(int[] arr) {
        int sum = 0;
        
        for (int num : arr) {
            sum += num;
        }
        
        return sum;
    }
    
    public static void main(String[] args) {
        int[] numbers = {10, 20, 30, 40, 50};
        int result = sumArray(numbers);
        System.out.println("Sum: " + result);  // 150
    }
}
```

**Time Complexity:** O(n) - visit each element once **Space Complexity:** O(1) - only use sum variable

---

## 3.2 Find Maximum Value in Array

**Problem:** Find the largest element in an array.

**Logic:**

- Assume first element is maximum
- Compare each element with current maximum
- Update maximum if larger element found

**Java Solution:**

```java
public class FindMax {
    public static int findMaximum(int[] arr) {
        // Handle edge case
        if (arr == null || arr.length == 0) {
            throw new IllegalArgumentException("Array is empty");
        }
        
        int max = arr[0];  // Assume first element is max
        
        for (int i = 1; i < arr.length; i++) {
            if (arr[i] > max) {
                max = arr[i];  // Update max
            }
        }
        
        return max;
    }
    
    public static void main(String[] args) {
        int[] numbers = {45, 12, 78, 23, 90, 34};
        int maximum = findMaximum(numbers);
        System.out.println("Maximum: " + maximum);  // 90
    }
}
```

**Intuition:**

```
arr = [45, 12, 78, 23, 90, 34]

Start: max = 45
Check 12: 12 < 45, no change
Check 78: 78 > 45, max = 78
Check 23: 23 < 78, no change
Check 90: 90 > 78, max = 90
Check 34: 34 < 90, no change

Final: max = 90
```

**Time Complexity:** O(n) **Space Complexity:** O(1)

---

## 3.3 Find Minimum Value in Array

**Problem:** Find the smallest element in an array.

**Logic:**

- Assume first element is minimum
- Compare each element with current minimum
- Update minimum if smaller element found

**Java Solution:**

```java
public class FindMin {
    public static int findMinimum(int[] arr) {
        if (arr == null || arr.length == 0) {
            throw new IllegalArgumentException("Array is empty");
        }
        
        int min = arr[0];  // Assume first element is min
        
        for (int i = 1; i < arr.length; i++) {
            if (arr[i] < min) {
                min = arr[i];  // Update min
            }
        }
        
        return min;
    }
    
    public static void main(String[] args) {
        int[] numbers = {45, 12, 78, 23, 90, 34};
        int minimum = findMinimum(numbers);
        System.out.println("Minimum: " + minimum);  // 12
    }
}
```

**Time Complexity:** O(n) **Space Complexity:** O(1)

---

## 3.4 Sum of Two Largest Numbers in Array

**Problem:** Find the two largest numbers and return their sum.

**Logic:**

- Track two variables: largest and second largest
- Iterate through array once
- Update both variables appropriately

**Java Solution:**

```java
public class TwoLargestSum {
    public static int sumOfTwoLargest(int[] arr) {
        if (arr == null || arr.length < 2) {
            throw new IllegalArgumentException("Array must have at least 2 elements");
        }
        
        // Initialize first and second largest
        int first = Integer.MIN_VALUE;
        int second = Integer.MIN_VALUE;
        
        for (int num : arr) {
            if (num > first) {
                // New largest found
                second = first;  // Old first becomes second
                first = num;     // New first
            } else if (num > second && num != first) {
                // New second largest found
                second = num;
            }
        }
        
        return first + second;
    }
    
    public static void main(String[] args) {
        int[] numbers = {45, 12, 78, 23, 90, 34};
        int sum = sumOfTwoLargest(numbers);
        System.out.println("Sum of two largest: " + sum);  // 90 + 78 = 168
    }
}
```

**Step-by-Step Intuition:**

```
arr = [45, 12, 78, 23, 90, 34]

Initialize: first = -∞, second = -∞

Check 45: 45 > -∞
  → second = -∞, first = 45

Check 12: 12 < 45 but 12 > -∞
  → second = 12, first = 45

Check 78: 78 > 45
  → second = 45, first = 78

Check 23: 23 < 78 but 23 < 45
  → no change

Check 90: 90 > 78
  → second = 78, first = 90

Check 34: 34 < 90 but 34 < 78
  → no change

Final: first = 90, second = 78
Sum = 90 + 78 = 168
```

**Time Complexity:** O(n) **Space Complexity:** O(1)

---

## 3.5 Reverse a Number

**Problem:** Reverse the digits of a number.

**Logic:**

- Extract last digit using % 10
- Build reversed number by multiplying by 10 and adding digit
- Remove last digit using / 10

**Java Solution:**

```java
public class ReverseNumber {
    public static int reverse(int num) {
        int reversed = 0;
        
        while (num > 0) {
            int digit = num % 10;           // Extract last digit
            reversed = reversed * 10 + digit;  // Add to reversed
            num = num / 10;                  // Remove last digit
        }
        
        return reversed;
    }
    
    public static void main(String[] args) {
        int number = 2345;
        int result = reverse(number);
        System.out.println("Reversed: " + result);  // 5432
    }
}
```

**Step-by-Step:**

```
number = 2345, reversed = 0

Iteration 1:
  digit = 2345 % 10 = 5
  reversed = 0 * 10 + 5 = 5
  number = 2345 / 10 = 234

Iteration 2:
  digit = 234 % 10 = 4
  reversed = 5 * 10 + 4 = 54
  number = 234 / 10 = 23

Iteration 3:
  digit = 23 % 10 = 3
  reversed = 54 * 10 + 3 = 543
  number = 23 / 10 = 2

Iteration 4:
  digit = 2 % 10 = 2
  reversed = 543 * 10 + 2 = 5432
  number = 2 / 10 = 0

Loop ends, result = 5432
```

**Time Complexity:** O(log n) - number of digits **Space Complexity:** O(1)

---

## 3.6 Palindrome Number

**Problem:** Check if a number reads the same forwards and backwards.

**Logic:**

- Reverse the number
- Compare with original
- If same, it's a palindrome

**Java Solution:**

```java
public class PalindromeCheck {
    public static boolean isPalindrome(int num) {
        int original = num;
        int reversed = 0;
        
        while (num > 0) {
            int digit = num % 10;
            reversed = reversed * 10 + digit;
            num = num / 10;
        }
        
        return original == reversed;
    }
    
    public static void main(String[] args) {
        System.out.println(isPalindrome(121));   // true
        System.out.println(isPalindrome(12321)); // true
        System.out.println(isPalindrome(123));   // false
    }
}
```

**Examples:**

- 121: Reversed = 121 (Same) → Palindrome
- 12321: Reversed = 12321 (Same) → Palindrome
- 123: Reversed = 321 (Different) → Not palindrome

**Time Complexity:** O(log n) **Space Complexity:** O(1)

---

## 3.7 Sum of Digits

**Problem:** Calculate the sum of all digits in a number.

**Logic:**

- Extract each digit using % 10
- Add to sum
- Remove digit using / 10

**Java Solution:**

```java
public class SumOfDigits {
    public static int sumDigits(int num) {
        int sum = 0;
        
        while (num > 0) {
            sum += num % 10;  // Add last digit
            num /= 10;        // Remove last digit
        }
        
        return sum;
    }
    
    public static void main(String[] args) {
        int number = 2345;
        int result = sumDigits(number);
        System.out.println("Sum of digits: " + result);  // 2+3+4+5 = 14
    }
}
```

**Time Complexity:** O(log n) **Space Complexity:** O(1)

---

## 3.8 Armstrong Number

**Problem:** Check if sum of cubes of digits equals the number itself.

**Definition:** A number is Armstrong if: abc = a³ + b³ + c³

**Logic:**

- Extract each digit
- Cube it and add to sum
- Compare sum with original number

**Java Solution:**

```java
public class ArmstrongNumber {
    public static boolean isArmstrong(int num) {
        int original = num;
        int sum = 0;
        
        while (num > 0) {
            int digit = num % 10;
            sum += digit * digit * digit;  // Cube of digit
            num /= 10;
        }
        
        return sum == original;
    }
    
    public static void main(String[] args) {
        System.out.println(isArmstrong(153));  // true: 1³+5³+3³ = 1+125+27 = 153
        System.out.println(isArmstrong(370));  // true: 3³+7³+0³ = 27+343+0 = 370
        System.out.println(isArmstrong(123));  // false: 1³+2³+3³ = 1+8+27 = 36 ≠ 123
    }
}
```

**Examples:**

- 153 = 1³ + 5³ + 3³ = 1 + 125 + 27 = 153 ✓
- 370 = 3³ + 7³ + 0³ = 27 + 343 + 0 = 370 ✓
- 371 = 3³ + 7³ + 1³ = 27 + 343 + 1 = 371 ✓

**Time Complexity:** O(log n) **Space Complexity:** O(1)

---

## 3.9 Prime Number Check

**Problem:** Determine if a number has only two divisors (1 and itself).

**Logic:**

- Check divisibility from 2 to √n
- If any number divides evenly, not prime
- Optimization: Only check up to square root

**Java Solution:**

```java
public class PrimeCheck {
    public static boolean isPrime(int num) {
        // Handle edge cases
        if (num <= 1) return false;
        if (num == 2) return true;
        if (num % 2 == 0) return false;
        
        // Check odd divisors up to √n
        for (int i = 3; i <= Math.sqrt(num); i += 2) {
            if (num % i == 0) {
                return false;  // Found divisor, not prime
            }
        }
        
        return true;  // No divisors found, prime
    }
    
    public static void main(String[] args) {
        System.out.println(isPrime(7));   // true
        System.out.println(isPrime(15));  // false (divisible by 3 and 5)
        System.out.println(isPrime(29));  // true
    }
}
```

**Why √n?**

```
If n = 36:
Divisors: 1, 2, 3, 4, 6, 9, 12, 18, 36

Notice: After √36 = 6, divisors are pairs:
  1 × 36
  2 × 18
  3 × 12
  4 × 9
  6 × 6  ← √36

After 6, we only find complements of divisors we already found.
So checking up to √n is sufficient.
```

**Time Complexity:** O(√n) **Space Complexity:** O(1)

---

## 3.10 Factorial

**Problem:** Calculate n! = n × (n-1) × (n-2) × ... × 1

**Logic:**

- Multiply all numbers from 1 to n
- Use loop or recursion

**Java Solution (Iterative):**

```java
public class Factorial {
    public static long factorial(int n) {
        if (n < 0) {
            throw new IllegalArgumentException("Negative numbers don't have factorials");
        }
        
        long result = 1;
        
        for (int i = 2; i <= n; i++) {
            result *= i;
        }
        
        return result;
    }
    
    public static void main(String[] args) {
        System.out.println(factorial(5));  // 120 (5×4×3×2×1)
        System.out.println(factorial(0));  // 1 (by definition)
        System.out.println(factorial(7));  // 5040
    }
}
```

**Java Solution (Recursive):**

```java
public class FactorialRecursive {
    public static long factorial(int n) {
        // Base case
        if (n <= 1) {
            return 1;
        }
        
        // Recursive case
        return n * factorial(n - 1);
    }
    
    public static void main(String[] args) {
        System.out.println(factorial(5));  // 120
    }
}
```

**Recursion Flow:**

```
factorial(5)
= 5 × factorial(4)
= 5 × 4 × factorial(3)
= 5 × 4 × 3 × factorial(2)
= 5 × 4 × 3 × 2 × factorial(1)
= 5 × 4 × 3 × 2 × 1
= 120
```

**Time Complexity:** O(n) **Space Complexity:** O(1) iterative, O(n) recursive (call stack)

---

## 3.11 Fibonacci Series

**Problem:** Generate Fibonacci sequence where each number is sum of previous two.

**Logic:**

- F(0) = 0, F(1) = 1
- F(n) = F(n-1) + F(n-2)

**Java Solution (Iterative):**

```java
public class Fibonacci {
    public static void printFibonacci(int n) {
        if (n <= 0) return;
        
        int a = 0, b = 1;
        
        System.out.print(a + " ");  // Print F(0)
        
        if (n == 1) return;
        
        System.out.print(b + " ");  // Print F(1)
        
        for (int i = 2; i < n; i++) {
            int next = a + b;
            System.out.print(next + " ");
            a = b;
            b = next;
        }
    }
    
    public static void main(String[] args) {
        printFibonacci(10);  // 0 1 1 2 3 5 8 13 21 34
    }
}
```

**Java Solution (Recursive):**

```java
public class FibonacciRecursive {
    public static int fibonacci(int n) {
        // Base cases
        if (n == 0) return 0;
        if (n == 1) return 1;
        
        // Recursive case
        return fibonacci(n - 1) + fibonacci(n - 2);
    }
    
    public static void main(String[] args) {
        for (int i = 0; i < 10; i++) {
            System.out.print(fibonacci(i) + " ");
        }
        // Output: 0 1 1 2 3 5 8 13 21 34
    }
}
```

**Sequence Explanation:**

```
F(0) = 0
F(1) = 1
F(2) = F(1) + F(0) = 1 + 0 = 1
F(3) = F(2) + F(1) = 1 + 1 = 2
F(4) = F(3) + F(2) = 2 + 1 = 3
F(5) = F(4) + F(3) = 3 + 2 = 5
F(6) = F(5) + F(4) = 5 + 3 = 8
...
```

**Time Complexity:**

- Iterative: O(n)
- Recursive: O(2^n) - very slow!

**Space Complexity:**

- Iterative: O(1)
- Recursive: O(n) - call stack

---

## 3.12 GCD (Greatest Common Divisor)

**Problem:** Find largest number that divides both given numbers.

**Logic:** Use Euclidean Algorithm

- GCD(a, b) = GCD(b, a % b)
- Continue until b becomes 0
- Result is a

**Java Solution:**

```java
public class GCD {
    public static int gcd(int a, int b) {
        while (b != 0) {
            int temp = b;
            b = a % b;
            a = temp;
        }
        return a;
    }
    
    public static void main(String[] args) {
        System.out.println(gcd(48, 18));  // 6
        System.out.println(gcd(100, 50)); // 50
        System.out.println(gcd(17, 13));  // 1 (coprime)
    }
}
```

**Step-by-Step Example:** GCD(48, 18)

```
Step 1: a=48, b=18
  48 % 18 = 12
  a=18, b=12

Step 2: a=18, b=12
  18 % 12 = 6
  a=12, b=6

Step 3: a=12, b=6
  12 % 6 = 0
  a=6, b=0

b=0, so GCD = 6
```

**Recursive Solution:**

```java
public class GCDRecursive {
    public static int gcd(int a, int b) {
        if (b == 0) {
            return a;
        }
        return gcd(b, a % b);
    }
    
    public static void main(String[] args) {
        System.out.println(gcd(48, 18));  // 6
    }
}
```

**Time Complexity:** O(log min(a,b)) **Space Complexity:** O(1) iterative, O(log min(a,b)) recursive

---

# 4. Array Manipulation Basics {#arrays}

## 4.1 Reverse an Array

**Problem:** Reverse elements in-place using two pointers.

**Logic:**

- Use two pointers: start and end
- Swap elements
- Move pointers towards center

**Java Solution:**

```java
public class ReverseArray {
    public static void reverse(int[] arr) {
        int left = 0;
        int right = arr.length - 1;
        
        while (left < right) {
            // Swap elements
            int temp = arr[left];
            arr[left] = arr[right];
            arr[right] = temp;
            
            // Move pointers
            left++;
            right--;
        }
    }
    
    public static void main(String[] args) {
        int[] numbers = {1, 2, 3, 4, 5};
        
        System.out.println("Original: " + java.util.Arrays.toString(numbers));
        reverse(numbers);
        System.out.println("Reversed: " + java.util.Arrays.toString(numbers));
        // Output: [5, 4, 3, 2, 1]
    }
}
```

**Visualization:**

```
Initial: [1, 2, 3, 4, 5]
         ↑           ↑
       left        right

Step 1: Swap 1 and 5
        [5, 2, 3, 4, 1]
            ↑     ↑
          left   right

Step 2: Swap 2 and 4
        [5, 4, 3, 2, 1]
               ↑
           left=right (stop)
```

**Time Complexity:** O(n) **Space Complexity:** O(1)

---

## 4.2 Linear Search

**Problem:** Find if element exists in array.

**Logic:**

- Check each element sequentially
- Return index if found
- Return -1 if not found

**Java Solution:**

```java
public class LinearSearch {
    public static int search(int[] arr, int target) {
        for (int i = 0; i < arr.length; i++) {
            if (arr[i] == target) {
                return i;  // Found at index i
            }
        }
        return -1;  // Not found
    }
    
    public static void main(String[] args) {
        int[] numbers = {45, 12, 78, 23, 90, 34};
        
        System.out.println(search(numbers, 78));  // 2
        System.out.println(search(numbers, 100)); // -1
    }
}
```

**Time Complexity:** O(n) - worst case check all elements **Space Complexity:** O(1)

---

## 4.3 Binary Search

**Problem:** Find element in sorted array efficiently.

**Logic:**

- Divide array in half repeatedly
- Compare target with middle element
- Search left or right half based on comparison

**Java Solution:**

```java
public class BinarySearch {
    public static int binarySearch(int[] arr, int target) {
        int left = 0;
        int right = arr.length - 1;
        
        while (left <= right) {
            int mid = left + (right - left) / 2;  // Avoid overflow
            
            if (arr[mid] == target) {
                return mid;  // Found
            } else if (arr[mid] < target) {
                left = mid + 1;  // Search right half
            } else {
                right = mid - 1;  // Search left half
            }
        }
        
        return -1;  // Not found
    }
    
    public static void main(String[] args) {
        int[] numbers = {10, 20, 30, 40, 50, 60, 70};  // Must be sorted
        
        System.out.println(binarySearch(numbers, 40));  // 3
        System.out.println(binarySearch(numbers, 25));  // -1
    }
}
```

**Example Search for 40:**

```
Array: [10, 20, 30, 40, 50, 60, 70]
        
Iteration 1:
  left=0, right=6, mid=3
  arr[3]=40 → Found!
```

**Example Search for 60:**

```
Array: [10, 20, 30, 40, 50, 60, 70]

Iteration 1:
  left=0, right=6, mid=3
  arr[3]=40 < 60 → search right
  left=4

Iteration 2:
  left=4, right=6, mid=5
  arr[5]=60 → Found!
```

**Time Complexity:** O(log n) - much faster than linear search **Space Complexity:** O(1)

---

## 4.4 Count Frequency of Element

**Problem:** Count how many times an element appears in array.

**Java Solution:**

```java
public class CountFrequency {
    public static int countOccurrences(int[] arr, int target) {
        int count = 0;
        
        for (int num : arr) {
            if (num == target) {
                count++;
            }
        }
        
        return count;
    }
    
    public static void main(String[] args) {
        int[] numbers = {1, 2, 3, 2, 4, 2, 5};
        
        System.out.println("2 appears: " + countOccurrences(numbers, 2) + " times");  // 3
        System.out.println("5 appears: " + countOccurrences(numbers, 5) + " times");  // 1
    }
}
```

**Time Complexity:** O(n) **Space Complexity:** O(1)

---

## 4.5 Find Second Largest Element

**Problem:** Find the second largest element in array.

**Logic:**

- Track largest and second largest
- Update both as you traverse

**Java Solution:**

```java
public class SecondLargest {
    public static int findSecondLargest(int[] arr) {
        if (arr.length < 2) {
            throw new IllegalArgumentException("Array must have at least 2 elements");
        }
        
        int first = Integer.MIN_VALUE;
        int second = Integer.MIN_VALUE;
        
        for (int num : arr) {
            if (num > first) {
                second = first;
                first = num;
            } else if (num > second && num != first) {
                second = num;
            }
        }
        
        if (second == Integer.MIN_VALUE) {
            throw new IllegalArgumentException("No second largest element");
        }
        
        return second;
    }
    
    public static void main(String[] args) {
        int[] numbers = {45, 12, 78, 23, 90, 34};
        System.out.println("Second largest: " + findSecondLargest(numbers));  // 78
    }
}
```

**Time Complexity:** O(n) **Space Complexity:** O(1)

---

# 5. Number Manipulation Techniques {#numbers}

## 5.1 Check Even or Odd

**Java Solution:**

```java
public class EvenOdd {
    public static boolean isEven(int num) {
        return num % 2 == 0;
    }
    
    public static void main(String[] args) {
        System.out.println(isEven(42));  // true
        System.out.println(isEven(17));  // false
    }
}
```

**Time Complexity:** O(1)

---

## 5.2 Swap Two Numbers

**Method 1: Using Temporary Variable**

```java
public class SwapWithTemp {
    public static void swap(int a, int b) {
        System.out.println("Before: a=" + a + ", b=" + b);
        
        int temp = a;
        a = b;
        b = temp;
        
        System.out.println("After: a=" + a + ", b=" + b);
    }
    
    public static void main(String[] args) {
        swap(10, 20);
        // Before: a=10, b=20
        // After: a=20, b=10
    }
}
```

**Method 2: Without Temporary Variable (Arithmetic)**

```java
public class SwapWithoutTemp {
    public static void swap(int a, int b) {
        System.out.println("Before: a=" + a + ", b=" + b);
        
        a = a + b;  // a = 10 + 20 = 30
        b = a - b;  // b = 30 - 20 = 10
        a = a - b;  // a = 30 - 10 = 20
        
        System.out.println("After: a=" + a + ", b=" + b);
    }
    
    public static void main(String[] args) {
        swap(10, 20);
    }
}
```

**Method 3: Using XOR (Bitwise)**

```java
public class SwapXOR {
    public static void swap(int a, int b) {
        System.out.println("Before: a=" + a + ", b=" + b);
        
        a = a ^ b;  // XOR
        b = a ^ b;
        a = a ^ b;
        
        System.out.println("After: a=" + a + ", b=" + b);
    }
    
    public static void main(String[] args) {
        swap(10, 20);
    }
}
```

---

## 5.3 Count Digits in Number

**Java Solution:**

```java
public class CountDigits {
    public static int countDigits(int num) {
        if (num == 0) return 1;
        
        int count = 0;
        
        while (num > 0) {
            count++;
            num /= 10;
        }
        
        return count;
    }
    
    public static void main(String[] args) {
        System.out.println(countDigits(12345));  // 5
        System.out.println(countDigits(0));      // 1
        System.out.println(countDigits(999));    // 3
    }
}
```

**Time Complexity:** O(log n)

---

## 5.4 Find Sum of Even and Odd Digits Separately

**Java Solution:**

```java
public class SumEvenOddDigits {
    public static void sumEvenOddDigits(int num) {
        int evenSum = 0;
        int oddSum = 0;
        
        while (num > 0) {
            int digit = num % 10;
            
            if (digit % 2 == 0) {
                evenSum += digit;
            } else {
                oddSum += digit;
            }
            
            num /= 10;
        }
        
        System.out.println("Sum of even digits: " + evenSum);
        System.out.println("Sum of odd digits: " + oddSum);
    }
    
    public static void main(String[] args) {
        sumEvenOddDigits(12345);
        // Sum of even digits: 6 (2+4)
        // Sum of odd digits: 9 (1+3+5)
    }
}
```

---

# 6. Logic Building Exercises {#logic-exercises}

## 6.1 Check if Array is Sorted

**Problem:** Determine if array is sorted in ascending order.

**Java Solution:**

```java
public class IsSorted {
    public static boolean isSorted(int[] arr) {
        for (int i = 0; i < arr.length - 1; i++) {
            if (arr[i] > arr[i + 1]) {
                return false;  // Found descending pair
            }
        }
        return true;  // All pairs in ascending order
    }
    
    public static void main(String[] args) {
        System.out.println(isSorted(new int[]{1, 2, 3, 4, 5}));    // true
        System.out.println(isSorted(new int[]{1, 3, 2, 4}));       // false
        System.out.println(isSorted(new int[]{5, 5, 5, 5}));       // true
    }
}
```

---

## 6.2 Find Missing Number in Array (1 to n)

**Problem:** Array contains numbers 1 to n with one missing. Find it.

**Logic:** Sum of 1 to n = n×(n+1)/2. Subtract array sum from this.

**Java Solution:**

```java
public class MissingNumber {
    public static int findMissing(int[] arr) {
        int n = arr.length + 1;  // Total numbers including missing
        int expectedSum = n * (n + 1) / 2;
        
        int actualSum = 0;
        for (int num : arr) {
            actualSum += num;
        }
        
        return expectedSum - actualSum;
    }
    
    public static void main(String[] args) {
        int[] numbers = {1, 2, 4, 5, 6};  // 3 is missing
        System.out.println("Missing number: " + findMissing(numbers));  // 3
    }
}
```

**Example:**

```
Array: [1, 2, 4, 5, 6]
n = 6 (since one is missing)

Expected sum = 6×7/2 = 21
Actual sum = 1+2+4+5+6 = 18

Missing = 21 - 18 = 3
```

**Time Complexity:** O(n) **Space Complexity:** O(1)

---

## 6.3 Remove Duplicates from Sorted Array

**Problem:** Remove duplicates in-place from sorted array.

**Java Solution:**

```java
public class RemoveDuplicates {
    public static int removeDuplicates(int[] arr) {
        if (arr.length == 0) return 0;
        
        int uniqueIndex = 0;  // Position for next unique element
        
        for (int i = 1; i < arr.length; i++) {
            if (arr[i] != arr[uniqueIndex]) {
                uniqueIndex++;
                arr[uniqueIndex] = arr[i];
            }
        }
        
        return uniqueIndex + 1;  // Length of unique elements
    }
    
    public static void main(String[] args) {
        int[] numbers = {1, 1, 2, 2, 2, 3, 4, 4, 5};
        int newLength = removeDuplicates(numbers);
        
        System.out.print("Unique elements: ");
        for (int i = 0; i < newLength; i++) {
            System.out.print(numbers[i] + " ");
        }
        // Output: 1 2 3 4 5
    }
}
```

**Time Complexity:** O(n) **Space Complexity:** O(1)

---

## 6.4 Move Zeros to End

**Problem:** Move all zeros to end of array while maintaining order of non-zeros.

**Java Solution:**

```java
public class MoveZeros {
    public static void moveZerosToEnd(int[] arr) {
        int nonZeroIndex = 0;
        
        // Move all non-zeros to front
        for (int i = 0; i < arr.length; i++) {
            if (arr[i] != 0) {
                arr[nonZeroIndex] = arr[i];
                nonZeroIndex++;
            }
        }
        
        // Fill remaining with zeros
        while (nonZeroIndex < arr.length) {
            arr[nonZeroIndex] = 0;
            nonZeroIndex++;
        }
    }
    
    public static void main(String[] args) {
        int[] numbers = {1, 0, 2, 0, 3, 0, 4};
        
        System.out.println("Before: " + java.util.Arrays.toString(numbers));
        moveZerosToEnd(numbers);
        System.out.println("After: " + java.util.Arrays.toString(numbers));
        // Before: [1, 0, 2, 0, 3, 0, 4]
        // After: [1, 2, 3, 4, 0, 0, 0]
    }
}
```

**Time Complexity:** O(n) **Space Complexity:** O(1)

---

## 6.5 Find Pair with Given Sum

**Problem:** Find if two numbers in array add up to target sum.

**Java Solution:**

```java
import java.util.HashSet;

public class PairSum {
    public static boolean hasPairWithSum(int[] arr, int target) {
        HashSet<Integer> seen = new HashSet<>();
        
        for (int num : arr) {
            int complement = target - num;
            
            if (seen.contains(complement)) {
                System.out.println("Pair found: " + num + " + " + complement + " = " + target);
                return true;
            }
            
            seen.add(num);
        }
        
        return false;
    }
    
    public static void main(String[] args) {
        int[] numbers = {2, 7, 11, 15};
        System.out.println(hasPairWithSum(numbers, 9));   // true (2+7)
        System.out.println(hasPairWithSum(numbers, 20));  // false
    }
}
```

**Time Complexity:** O(n) **Space Complexity:** O(n)

---

## 6.6 Rotate Array by K Positions

**Problem:** Rotate array elements to right by k positions.

**Java Solution:**

```java
public class RotateArray {
    public static void rotate(int[] arr, int k) {
        int n = arr.length;
        k = k % n;  // Handle k > n
        
        // Reverse entire array
        reverse(arr, 0, n - 1);
        
        // Reverse first k elements
        reverse(arr, 0, k - 1);
        
        // Reverse remaining elements
        reverse(arr, k, n - 1);
    }
    
    private static void reverse(int[] arr, int start, int end) {
        while (start < end) {
            int temp = arr[start];
            arr[start] = arr[end];
            arr[end] = temp;
            start++;
            end--;
        }
    }
    
    public static void main(String[] args) {
        int[] numbers = {1, 2, 3, 4, 5};
        
        System.out.println("Before: " + java.util.Arrays.toString(numbers));
        rotate(numbers, 2);
        System.out.println("After rotating by 2: " + java.util.Arrays.toString(numbers));
        // Before: [1, 2, 3, 4, 5]
        // After: [4, 5, 1, 2, 3]
    }
}
```

**Example: Rotate [1,2,3,4,5] by 2**

```
Step 1: Reverse entire array
  [1,2,3,4,5] → [5,4,3,2,1]

Step 2: Reverse first k=2 elements
  [5,4,3,2,1] → [4,5,3,2,1]

Step 3: Reverse remaining elements
  [4,5,3,2,1] → [4,5,1,2,3]
```

**Time Complexity:** O(n) **Space Complexity:** O(1)

---

## Quick Reference: Time Complexities

|Problem|Time Complexity|Space Complexity|
|---|---|---|
|Sum of array|O(n)|O(1)|
|Find max/min|O(n)|O(1)|
|Reverse number|O(log n)|O(1)|
|Palindrome check|O(log n)|O(1)|
|Prime check|O(√n)|O(1)|
|Factorial|O(n)|O(1) iterative|
|Fibonacci|O(n) iterative, O(2^n) recursive|O(1) / O(n)|
|Linear search|O(n)|O(1)|
|Binary search|O(log n)|O(1)|
|Reverse array|O(n)|O(1)|

---

## Practice Strategy

**Week 1-2: Master Basics**

- Sum, max, min in arrays
- Reverse numbers and arrays
- Even/odd, prime checks
- Digit extraction problems

**Week 3-4: Intermediate**

- Two-pointer technique
- Binary search
- Frequency counting
- Armstrong, palindrome numbers

**Week 5-6: Advanced Patterns**

- GCD, LCM
- Array rotations
- Finding pairs with sum
- Removing duplicates

**Daily Practice Routine:**

1. Solve 2-3 problems
2. Implement without looking at solution
3. Optimize your solution
4. Compare time/space complexity
5. Write test cases

---

## Common Mistakes to Avoid

1. **Array Index Out of Bounds**

```java
// Wrong
for (int i = 0; i <= arr.length; i++)  // <= causes error

// Correct
for (int i = 0; i < arr.length; i++)
```

2. **Integer Overflow**

```java
// Wrong for large numbers
int factorial = 1;

// Better
long factorial = 1L;
```

3. **Not Handling Edge Cases**

```java
// Always check:
if (arr == null || arr.length == 0) {
    // Handle empty array
}
```

4. **Off-by-One Errors**

```java
// Common in loops
while (num > 0)  // Correct
while (num >= 0) // May cause infinite loop with 0
```

5. **Not Initializing Variables**

```java
int sum;  // Not initialized
sum += 10; // Error!

// Correct
int sum = 0;
sum += 10;
```

---

## END OF BEGINNER DSA NOTES

**Document Created:** Beginner DSA Guide for Java **Topics Covered:** Operators, Patterns, 20+ Problems with Solutions **Focus:** Logic building, Intuition, Time/Space complexity **Level:** Beginner to Early Intermediate

[^1]: 
