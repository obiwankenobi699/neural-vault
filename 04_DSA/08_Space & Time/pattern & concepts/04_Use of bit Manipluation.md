
## AND Operation Use Cases

### 1. Check Odd/Even

Any number AND with 1 gives the LSB (Least Significant Bit). If LSB is 1, the number is odd. If LSB is 0, the number is even.

$$ \begin{align} 1 & 1 &= 1 \quad \text{(odd)} \ 0 & 1 &= 0 \quad \text{(even)} \end{align} $$

```java
import java.util.*;

public class MyClass {
    public static void main(String args[]) {
        int x = 10;
        if ((x & 1) == 1) {
            System.out.println("Odd");
        } else {
            System.out.println("Even");
        }
    }
}
```

> **Approach:** Check the rightmost bit. If it's 1, number is odd, otherwise even.

### 2. Find i-th Bit of a Number

To find the bit at position i, create a mask by left shifting 1 by (i-1) positions, then AND with the number.

$$ \text{mask} = 1 << (i-1) $$

$$ \text{bit} = \text{number} & \text{mask} $$

**Example:** Find 4th bit of 41 (binary: 101001)

```
41 = 00101001
mask = 00001000 (1 << 3)
result = 00001000 (non-zero means bit is set)
```

```java
import java.util.*;

public class MyClass {
    public static void main(String args[]) {
        int x = 41;  // Binary: 101001
        int n = 4;   // 4th bit (1-indexed)
        
        int mask = 1 << (n - 1);     // 1 << 3 = 8 (1000₂)
        int value = x & mask;        // 101001 & 1000 = 1000
        
        int bit = (value != 0) ? 1 : 0;
        System.out.print(bit);  // Output: 1
    }
}
```

> **Approach:** Left shift 1 by (i-1) positions to create mask. AND with number. Non-zero result means bit is set.

### 3. Reset/Clear Bit at Position i

To clear the i-th bit, create a mask with all bits set except the i-th position, then AND with the number.

$$ \text{mask} = \sim(1 << (i-1)) $$

$$ \text{result} = \text{number} & \text{mask} $$

```java
import java.util.*;

public class MyClass {
    public static void main(String args[]) {
        int x = 41;  // 00101001 (41)
        int n = 5;   // 5th bit (1-indexed)
        
        // Reset 5th bit to 0
        x &= ~(1 << (n-1));
        
        System.out.println("Original: " + Integer.toBinaryString(41)); // 101001
        System.out.println("After reset: " + Integer.toBinaryString(x)); // 100001
        System.out.println("Decimal: " + x);  // 33
    }
}
```

> **Approach:** Create mask with NOT of (1 << (i-1)). This gives all 1s except at position i. AND with number clears that bit.

### 4. Find Position of Rightmost and Leftmost Set Bit

For finding rightmost set bit position:

$$
 \text{rightmost_set_bit} = N & (-N) 
$$

**Why it works:** -N is two's complement of N (flip bits and add 1). AND-ing N with -N isolates only the rightmost set bit.

## XOR Operation Use Cases

### Key Properties

$$ \begin{align} a \oplus a &= 0 \quad \text{(self-cancelling)} \ a \oplus 0 &= a \quad \text{(identity)} \ a \oplus b &= b \oplus a \quad \text{(commutative)} \ (a \oplus b) \oplus c &= a \oplus (b \oplus c) \quad \text{(associative)} \end{align} $$

### Find Unique Element in Array

When all elements appear twice except one, XOR all elements. Pairs cancel out (a ⊕ a = 0), leaving the unique element.

**Example:** Array [1, 2, 3, 4, 1, 2, 3]

```
Step-by-step:
unique = 0
0 ^ 1 = 1
1 ^ 2 = 3
3 ^ 3 = 0
0 ^ 4 = 4
4 ^ 1 = 5
5 ^ 2 = 7
7 ^ 3 = 4  ← Final answer
```

**Bit-level visualization:**

```
Array: [1, 2, 3, 4, 1, 2, 3]
Bits:  [01, 10, 11, 100, 01, 10, 11]

Bit 0: 1^0^1^0^1^0^1 = 0 (even count)
Bit 1: 0^1^1^0^0^1^1 = 0 (even count)
Bit 2: 0^0^0^1^0^0^0 = 1 (odd count)

Result: 100 = 4
```

```java
import java.util.*;

public class MyClass {
    public static void main(String args[]) {
        int[] x = {1, 2, 3, 4, 1, 2, 3};
        int unique = 0;
        for (int n : x) {
            unique = n ^ unique;
        }
        System.out.print(unique);  // Output: 4
    }
}
```

> **Approach:** XOR accumulates because it's associative and commutative. Each pair cancels (a ⊕ a = 0), leaving only the unique element. XOR counts bits modulo 2 per position: odd occurrences = 1, even = 0.

## Quick Reference Table

|Operation|Use Case|Formula|
|---|---|---|
|`n & 1`|Check odd/even|LSB = 1 → odd|
|`n & (1 << i)`|Check i-th bit|Non-zero → set|
|`n & ~(1 << i)`|Clear i-th bit|Inverted mask|
|`n & (n-1)`|Clear rightmost set bit|Used in bit counting|
|`n & -n`|Isolate rightmost set bit|Two's complement trick|
|`a ^ a`|Cancel pairs|Always 0|
|`a ^ 0`|Identity|Returns a|
|`a ^ b ^ b`|Find unique|b cancels, leaves a|