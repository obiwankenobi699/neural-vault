  ## Introduction to Number Systems

A number system is a mathematical notation for representing numbers using a consistent set of digits or symbols. Every number system is characterized by its base or radix, which determines how many unique digits are used to represent values. The two most fundamental number systems in computer science are the decimal system (base 10) used in everyday human computation and the binary system (base 2) used internally by all digital computers. Understanding the relationship between these systems and the ability to convert between them forms the foundation for advanced algorithmic techniques involving bit manipulation.

## Base 10 - Decimal Number System

The decimal number system uses ten distinct digits: 0, 1, 2, 3, 4, 5, 6, 7, 8, and 9. Each position in a decimal number represents a power of 10, with the rightmost position representing 10^0 (which equals 1), the next position representing 10^1 (which equals 10), and so on. This positional notation allows us to represent any integer value through weighted combinations of these digits.

Consider the decimal number 27. This can be decomposed as (2 × 10^1) + (7 × 10^0), which equals (2 × 10) + (7 × 1), resulting in 20 + 7 = 27. Similarly, the number 345 breaks down as (3 × 10^2) + (4 × 10^1) + (5 × 10^0), equal to 300 + 40 + 5. This weighted positional system scales to represent arbitrarily large numbers by adding more positions to the left.

The decimal system is intuitive for humans because we have ten fingers, making base-10 counting natural. However, computers cannot directly work with ten distinct states in their electronic circuits. Instead, they rely on binary representation where only two states are needed: on and off, represented as 1 and 0.

## Base 2 - Binary Number System

The binary number system uses only two digits: 0 and 1. Each position in a binary number represents a power of 2, with the rightmost bit (called the least significant bit or LSB) representing 2^0 (which equals 1), the next bit representing 2^1 (which equals 2), then 2^2 (which equals 4), and so forth. This system perfectly matches the physical reality of digital circuits where transistors operate in two states: conducting or non-conducting.

A binary number like 1101 can be decomposed as
$$
(1 × 2^3) + (1 × 2^2) + (0 × 2^1) + (1 × 2^0)
$$
which equals 8 + 4 + 0 + 1, resulting in the decimal value 13. Each bit position has exactly twice the value of the position to its right, creating an exponential progression: 1, 2, 4, 8, 16, 32, 64, 128, and so on.

Binary representation is fundamental to all computer operations. When you store an integer in memory, it exists as a sequence of bits. A 32-bit integer uses 32 binary digits to represent values, while a 64-bit integer uses 64 binary digits. Understanding binary representation enables direct manipulation of these bits through bitwise operations, which forms the basis for numerous algorithmic optimizations.

## Converting Decimal to Binary

Converting a decimal number to binary involves repeatedly dividing the number by 2 and recording the remainders. The remainders, read in reverse order from bottom to top, form the binary representation. This process continues until the quotient becomes zero.

To convert decimal 27 to binary, we perform the following divisions. First, 27 divided by 2 gives quotient 13 and remainder 1. Then 13 divided by 2 gives quotient 6 and remainder 1. Next, 6 divided by 2 gives quotient 3 and remainder 0. Then 3 divided by 2 gives quotient 1 and remainder 1. Finally, 1 divided by 2 gives quotient 0 and remainder 1. Reading the remainders from bottom to top yields 11011, which is the binary representation of 27.

```
27 ÷ 2 = 13 remainder 1  (LSB)
13 ÷ 2 = 6  remainder 1
6  ÷ 2 = 3  remainder 0
3  ÷ 2 = 1  remainder 1
1  ÷ 2 = 0  remainder 1  (MSB)

Binary: 11011
```

We can verify this result by converting back: 
$$
(1 × 16) + (1 × 8) + (0 × 4) + (1 × 2) + (1 × 1) = 16 + 8 + 0 + 2 + 1 = 27
$$
This bidirectional conversion process is essential for understanding how computers internally represent the numbers we work with in decimal notation.

## Converting Binary to Decimal

Converting binary to decimal involves multiplying each bit by its corresponding power of 2 and summing the results. Starting from the rightmost bit (LSB), each position represents progressively larger powers of 2 as you move left toward the most significant bit (MSB).

For the binary number 11011, we calculate:
$$
(1 × 2^4) + (1 × 2^3) + (0 × 2^2) + (1 × 2^1) + (1 × 2^0).
$$
This expands to 
$$
(1 × 16) + (1 × 8) + (0 × 4) + (1 × 2) + (1 × 1)
$$
which equals 16 + 8 + 0 + 2 + 1 = 27. Each bit that is set to 1 contributes its positional value to the final sum, while bits set to 0 contribute nothing.

```java
public static int binaryToDecimal(String binary) {
    int decimal = 0;
    int power = 0;
    
    // Process from right to left
    for (int i = binary.length() - 1; i >= 0; i--) {
        if (binary.charAt(i) == '1') {
            decimal += Math.pow(2, power);
        }
        power++;
    }
    
    return decimal;
}
```

This conversion can also be performed more efficiently using bit shifting, where each left shift of 1 multiplies the accumulated value by 2, matching the positional weights in binary representation.

## Bitwise AND Operation

The bitwise AND operation compares corresponding bits of two numbers and produces 1 only when both bits are 1. If either bit is 0, the result is 0. This operation is denoted by the ampersand symbol in most programming languages. The AND operation is useful for masking specific bits, checking if a bit is set, and extracting portions of a number.

When we compute 12 AND 10 in binary, we align the bits and perform the comparison position by position. The number 12 in binary is 1100, and 10 in binary is 1010. Comparing each position: (1 AND 1 = 1), (1 AND 0 = 0), (0 AND 1 = 0), (0 AND 0 = 0), yielding 1000 in binary, which equals 8 in decimal.

```java
int a = 12;  // Binary: 1100
int b = 10;  // Binary: 1010
int result = a & b;  // Result: 1000 (8 in decimal)

// Common use: Check if a number is even
boolean isEven = (num & 1) == 0;  // If LSB is 0, number is even
```

A practical application of AND is checking whether specific bits are set. To check if the third bit (from right, zero-indexed) is set in a number, we AND it with a mask that has only that bit set: (num & (1 << 3)). If the result is non-zero, the bit was set.

## Bitwise OR Operation

The bitwise OR operation compares corresponding bits and produces 1 if at least one of the bits is 1. Only when both bits are 0 does the result become 0. This operation uses the pipe symbol in most programming languages. OR is commonly used for setting specific bits or combining bit flags.

Computing 12 OR 10 in binary: 12 is 1100 and 10 is 1010. Position by position: (1 OR 1 = 1), (1 OR 0 = 1), (0 OR 1 = 1), (0 OR 0 = 0), yielding 1110 in binary, which equals 14 in decimal.

```java
int a = 12;  // Binary: 1100
int b = 10;  // Binary: 1010
int result = a | b;  // Result: 1110 (14 in decimal)

// Common use: Set specific bit to 1
int setBitThree = num | (1 << 3);  // Sets third bit to 1
```

The OR operation is essential in setting flags or permissions. When multiple boolean conditions need to be combined into a single integer, each bit can represent a different flag, and OR operations combine them without affecting already-set bits.

## Bitwise XOR Operation

The bitwise XOR (exclusive OR) operation produces 1 when the two bits are different and 0 when they are the same. XOR has unique mathematical properties that make it invaluable for certain algorithmic problems. The XOR operation is self-inverse, meaning that (a XOR b XOR b) equals a, which enables elegant solutions to problems involving pairs or duplicates.

Computing 12 XOR 10: With 1100 and 1010, we get (1 XOR 1 = 0), (1 XOR 0 = 1), (0 XOR 1 = 1), (0 XOR 0 = 0), yielding 0110 in binary, which equals 6 in decimal.

```java
int a = 12;  // Binary: 1100
int b = 10;  // Binary: 1010
int result = a ^ b;  // Result: 0110 (6 in decimal)

// XOR properties:
// a ^ 0 = a
// a ^ a = 0
// a ^ b ^ b = a

// Use case: Find unique number in array where all others appear twice
int findUnique(int[] nums) {
    int result = 0;
    for (int num : nums) {
        result ^= num;  // Pairs cancel out, leaving unique number
    }
    return result;
}
```

XOR is particularly powerful in problems involving finding missing numbers or detecting differences. Since XOR-ing a number with itself yields zero, and XOR-ing with zero leaves the number unchanged, arrays where every element appears twice except one can be solved in O(n) time with O(1) space using XOR.

## Bitwise NOT Operation

The bitwise NOT operation inverts all bits of a number, turning 0s into 1s and 1s into 0s. This operation is also called bitwise complement. In most systems using two's complement representation for signed integers, the NOT operation is related to negation but not identical to it due to the way negative numbers are represented.

For an 8-bit representation, NOT 12 (which is 00001100 in binary) produces 11110011. However, interpreting this result depends on whether we're using signed or unsigned integers. In unsigned interpretation, this is 243. In signed two's complement interpretation, this is -13.

```java
int a = 12;  // Binary: 00001100
int result = ~a;  // Binary: 11110011 (represents -13 in two's complement)

// Common use: Create bit mask
int mask = ~0;  // All bits set to 1
int clearBitThree = num & ~(1 << 3);  // Clear third bit
```

The NOT operation is frequently used in combination with AND to clear specific bits. To clear the third bit of a number, we create a mask with all bits set except the third, which can be done by NOT-ing a number that has only the third bit set.

## Left Shift Operation

The left shift operation moves all bits in a number to the left by a specified number of positions, filling the vacated rightmost positions with zeros. Each left shift by one position effectively multiplies the number by 2. Left shift is denoted by the double less-than symbol.

Shifting 5 (binary 0101) left by 2 positions produces 10100, which equals 20 in decimal. The original bits 0101 move two positions left, and two zeros fill in on the right. Mathematically, left shift by n positions is equivalent to multiplying by 2^n.

```java
int a = 5;   // Binary: 0101
int result = a << 2;  // Binary: 10100 (20 in decimal)

// Left shift by n = multiply by 2^n
// 5 << 2 = 5 * 2^2 = 5 * 4 = 20

// Common use: Compute powers of 2
int powerOfTwo = 1 << n;  // Computes 2^n
int setBit = num | (1 << pos);  // Set bit at position
```

Left shift operations are significantly faster than multiplication in most processors, making them valuable for performance-critical code when multiplying by powers of two. They are also essential for creating bit masks and manipulating individual bits.

## Right Shift Operation

The right shift operation moves all bits to the right by specified positions. There are two types: logical right shift (fills with zeros) and arithmetic right shift (preserves sign bit for signed numbers). The behavior depends on whether the number is signed or unsigned. Right shift by one position divides the number by 2, truncating any remainder.

Shifting 20 (binary 10100) right by 2 positions produces 00101, which equals 5 in decimal. The rightmost two bits (00) are discarded, and two zeros are added on the left for unsigned right shift.

```java
int a = 20;  // Binary: 10100
int result = a >> 2;  // Binary: 00101 (5 in decimal)

// Right shift by n = divide by 2^n (integer division)
// 20 >> 2 = 20 / 2^2 = 20 / 4 = 5

// Common use: Extract bit at position
boolean isBitSet = ((num >> pos) & 1) == 1;
int clearBit = num & ~(1 << pos);  // Clear bit at position
```

Arithmetic right shift preserves the sign of signed integers by replicating the sign bit (leftmost bit) rather than filling with zeros. This ensures that negative numbers remain negative after shifting. Logical right shift always fills with zeros regardless of the original sign.

## Two's Complement Representation

Modern computers represent negative integers using two's complement notation. In this system, the leftmost bit (most significant bit) serves as the sign bit, where 0 indicates positive and 1 indicates negative. To negate a number in two's complement, invert all bits (apply NOT) and add 1. This representation allows the same circuitry to perform both addition and subtraction.

To represent -5 in 8-bit two's complement, we start with +5 (00000101), invert all bits to get 11111010, then add 1 to obtain 11111011. This binary pattern represents -5. The range of representable values in n-bit two's complement is from -(2^(n-1)) to (2^(n-1) - 1). For 8 bits, this is -128 to 127.

```java
// Converting positive to negative using two's complement
int positive = 5;   // Binary: 00000101
int negative = ~positive + 1;  // Binary: 11111011 (-5)

// This is equivalent to: negative = -positive
```

Understanding two's complement is crucial when working with bitwise operations on signed integers, as the sign bit participates in bitwise operations just like any other bit. This can lead to unexpected results if not properly considered.

## One's Complement

One's complement is an alternative method for representing negative numbers where negation is achieved simply by inverting all bits without adding 1. However, this system has limitations including two representations for zero (all zeros and all ones) and more complex arithmetic operations. One's complement is rarely used in modern systems but appears in certain networking protocols like IP checksum calculation.

In one's complement, -5 in 8 bits would be the inversion of 00000101, yielding 11111010. Notice this differs from two's complement by exactly 1. The range for n-bit one's complement is from -(2^(n-1) - 1) to (2^(n-1) - 1), with both +0 and -0 existing.

## Bit Manipulation Use Cases in Data Structures and Algorithms

Bit manipulation provides elegant solutions to numerous algorithmic problems that would otherwise require more complex data structures or higher time complexity. These techniques are particularly valuable in competitive programming, systems programming, and performance-critical applications.

### Finding Single Number

When an array contains elements where every element appears twice except one unique element, XOR provides an O(n) time and O(1) space solution. Since XOR of two identical numbers is zero and XOR is associative and commutative, all paired elements cancel out, leaving only the unique element.

```java
public int singleNumber(int[] nums) {
    int result = 0;
    for (int num : nums) {
        result ^= num;
    }
    return result;  // All pairs cancel, unique remains
}
```

This approach extends to variations where we need to find two unique numbers or where elements appear three times. The fundamental principle remains that XOR's self-canceling property eliminates duplicates.

### Counting Set Bits

Determining how many bits are set to 1 in a number's binary representation has applications in population counting, Hamming distance calculation, and various optimization problems. The Brian Kernighan algorithm provides an efficient solution that runs in time proportional to the number of set bits rather than the total number of bits.

```java
public int countSetBits(int n) {
    int count = 0;
    while (n > 0) {
        n = n & (n - 1);  // Removes rightmost set bit
        count++;
    }
    return count;
}

// Example: n = 13 (binary 1101)
// Iteration 1: 1101 & 1100 = 1100, count = 1
// Iteration 2: 1100 & 1011 = 1000, count = 2
// Iteration 3: 1000 & 0111 = 0000, count = 3
```

The operation (n & (n-1)) clears the rightmost set bit because subtracting 1 from n flips all bits after the rightmost set bit and flips the rightmost set bit itself. AND-ing with the original number then clears that bit.

### Power of Two Detection

Checking whether a number is a power of two can be done in constant time using bit manipulation. Powers of two have exactly one bit set in their binary representation. The expression (n & (n-1)) equals zero only when n is a power of two or when n is zero.

```java
public boolean isPowerOfTwo(int n) {
    return n > 0 && (n & (n - 1)) == 0;
}

// Examples:
// 8 (1000): 8 & 7 (0111) = 0 → true
// 6 (0110): 6 & 5 (0101) = 4 (0100) ≠ 0 → false
```

This technique works because (n-1) for a power of two flips all trailing zeros to ones and the single set bit to zero, making AND with n produce zero. For non-powers of two, multiple set bits ensure the AND produces a non-zero result.

### Swapping Without Temporary Variable

XOR's properties enable swapping two variables without using a temporary variable, saving memory in space-constrained environments. This works because XOR is self-inverse: applying XOR with the same value twice returns the original value.

```java
public void swap(int a, int b) {
    a = a ^ b;  // a now contains a^b
    b = a ^ b;  // b = (a^b) ^ b = a
    a = a ^ b;  // a = (a^b) ^ a = b
}

// Verification:
// Initial: a=5 (0101), b=3 (0011)
// Step 1: a = 5^3 = 6 (0110)
// Step 2: b = 6^3 = 5 (0101)
// Step 3: a = 6^5 = 3 (0011)
// Final: a=3, b=5
```

While elegant, this technique should be used cautiously in practice as modern compilers optimize temporary variable swaps effectively, and the XOR method can be less readable and may not be faster on modern architectures.

### Generating Subsets

Bit manipulation provides an intuitive way to generate all subsets of a set. For a set with n elements, there are 2^n possible subsets, corresponding to n-bit binary numbers from 0 to 2^n - 1. Each bit indicates whether the corresponding element is included in the subset.

```java
public List<List<Integer>> subsets(int[] nums) {
    List<List<Integer>> result = new ArrayList<>();
    int n = nums.length;
    int totalSubsets = 1 << n;  // 2^n
    
    for (int mask = 0; mask < totalSubsets; mask++) {
        List<Integer> subset = new ArrayList<>();
        for (int i = 0; i < n; i++) {
            if ((mask & (1 << i)) != 0) {  // Check if i-th bit is set
                subset.add(nums[i]);
            }
        }
        result.add(subset);
    }
    return result;
}

// For nums = [1,2,3]:
// mask = 0 (000): []
// mask = 1 (001): [1]
// mask = 2 (010): [2]
// mask = 3 (011): [1,2]
// mask = 4 (100): [3]
// mask = 5 (101): [1,3]
// mask = 6 (110): [2,3]
// mask = 7 (111): [1,2,3]
```

This approach systematically generates all possible combinations by iterating through all possible bit patterns, making subset generation simple and efficient.

## Common Patterns and Observations in Bit Manipulation

### Pattern 1: Isolating Rightmost Set Bit

To isolate the rightmost set bit of a number, use the expression (n & -n) or (n & (~n + 1)). This works because -n in two's complement flips all bits and adds 1, which preserves only the rightmost set bit when AND-ed with n.

```java
int n = 12;  // Binary: 1100
int rightmost = n & -n;  // Result: 0100 (4)

// Application: Finding position of rightmost set bit
int position = (int)(Math.log(n & -n) / Math.log(2));
```

This pattern appears in algorithms for finding the lowest common ancestor in binary indexed trees and in various bit manipulation puzzles.

### Pattern 2: Clearing Bits After Position

To clear all bits after a specific position i (keeping bits from i onwards), create a mask of all ones and left shift by (i+1), then AND with the number.

```java
int clearBitsAfter(int n, int i) {
    int mask = (-1 << (i + 1));
    return n & mask;
}

// Example: clear bits after position 2 in 1011011
// mask = 11111000
// result = 1011000
```

This technique is useful in range bit manipulation problems and when working with fixed-width binary representations.

### Pattern 3: Updating Specific Bit

To update a specific bit to a given value (0 or 1), first clear the bit using AND with inverted mask, then set it using OR with the value shifted to the correct position.

```java
int updateBit(int n, int i, int value) {
    int mask = ~(1 << i);  // Clear bit i
    return (n & mask) | (value << i);  // Set bit i to value
}
```

This pattern combines multiple bit operations to achieve precise control over individual bits, essential in systems programming and low-level data manipulation.

### Pattern 4: Checking Power Relationships

Several number theory properties can be checked efficiently using bit manipulation. Checking if a number is a multiple of a power of two, finding the next power of two, and rounding to nearest power of two all have elegant bit manipulation solutions.

```java
// Check if n is multiple of 2^k
boolean isMultipleOfPowerOf2(int n, int k) {
    int powerOf2 = 1 << k;
    return (n & (powerOf2 - 1)) == 0;
}

// Find next power of 2 greater than or equal to n
int nextPowerOf2(int n) {
    n--;
    n |= n >> 1;
    n |= n >> 2;
    n |= n >> 4;
    n |= n >> 8;
    n |= n >> 16;
    return n + 1;
}
```

These patterns demonstrate how bit manipulation can replace arithmetic operations with faster bitwise operations while maintaining correctness.

## Intuitive Understanding of Bit Manipulation in DSA

The key intuition behind bit manipulation in data structures and algorithms is recognizing that binary representation provides direct access to the fundamental building blocks of numbers. Every integer is ultimately a collection of powers of two, and bitwise operations let us manipulate these powers directly rather than working with the composite decimal value. This granular control enables optimizations that arithmetic operations cannot achieve.

When approaching a problem, consider whether it involves detecting patterns in binary representation, working with sets represented as bit masks, or performing operations that align with powers of two. Common indicators that bit manipulation might help include: problems involving pairs or duplicates, subset generation, operations on ranges that are powers of two, and situations requiring constant space for tracking boolean states.

The efficiency of bit manipulation stems from how modern processors implement these operations at the hardware level. Bitwise operations typically execute in a single CPU cycle, making them significantly faster than arithmetic operations like multiplication or division. This performance advantage, combined with the ability to pack multiple boolean values into a single integer, makes bit manipulation indispensable for high-performance computing.

Understanding bit manipulation also develops deeper insight into how computers represent and process information. Every high-level data structure ultimately resolves to bits in memory, and comprehending this fundamental representation illuminates both the capabilities and limitations of computational systems. The elegance of bit manipulation solutions often reveals mathematical structure that is obscured by higher-level abstractions.

## Practical Example: Complete Implementation

```java
public class BitManipulationExamples {
    
    // Convert decimal to binary string
    public static String decimalToBinary(int n) {
        if (n == 0) return "0";
        StringBuilder binary = new StringBuilder();
        while (n > 0) {
            binary.insert(0, n % 2);
            n /= 2;
        }
        return binary.toString();
    }
    
    // Convert binary string to decimal
    public static int binaryToDecimal(String binary) {
        int decimal = 0;
        int power = 0;
        for (int i = binary.length() - 1; i >= 0; i--) {
            if (binary.charAt(i) == '1') {
                decimal += (1 << power);
            }
            power++;
        }
        return decimal;
    }
    
    // Check if bit at position i is set
    public static boolean isBitSet(int n, int i) {
        return ((n >> i) & 1) == 1;
    }
    
    // Set bit at position i
    public static int setBit(int n, int i) {
        return n | (1 << i);
    }
    
    // Clear bit at position i
    public static int clearBit(int n, int i) {
        return n & ~(1 << i);
    }
    
    // Toggle bit at position i
    public static int toggleBit(int n, int i) {
        return n ^ (1 << i);
    }
    
    // Count number of set bits
    public static int countSetBits(int n) {
        int count = 0;
        while (n > 0) {
            n &= (n - 1);
            count++;
        }
        return count;
    }
    
    public static void main(String[] args) {
        int num = 27;
        System.out.println("Decimal: " + num);
        System.out.println("Binary: " + decimalToBinary(num));
        System.out.println("Set bits: " + countSetBits(num));
        System.out.println("Is bit 3 set: " + isBitSet(num, 3));
        System.out.println("After setting bit 2: " + setBit(num, 2));
        System.out.println("After clearing bit 3: " + clearBit(num, 3));
    }
}
```

This comprehensive implementation demonstrates the fundamental operations used throughout bit manipulation problems in data structures and algorithms, providing a practical foundation for solving complex computational challenges efficiently.

