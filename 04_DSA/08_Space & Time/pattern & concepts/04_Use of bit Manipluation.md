
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


```java
public class MyClass {
  public static void main(String args[]) {
    int n = 7;
    int count = 0;
    while(n>0){
        int left = n&1;
        n = n>>1;
        if(left==1){
            count+=1;
        }
    }

    if(count==1){
        System.out.print("Num is even");
    }else{
        System.out.println("Num IS odd");
    }
    System.out.println(count);
  }
}
```
> **Approach:** Check the rightmost bit. If it's 1, number is odd, otherwise even.
> Calculate the number of one's 

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

| Goal             | Trick         | Example: 12 (1100) |
| ---------------- | ------------- | ------------------ |
| Rightmost set    | `N & -N`      | `4 (0100)`         |
| Remove rightmost | `N & (N-1)`   | `8 (1000)`         |
| Leftmost set     | Fill + shift  | `8 (1000)`         |
| Count set bits   | `popcount(N)` | `2`                |
| Toggle bit       | `N ^ (1<<k)`  | Varies             |


### 5. Find the N magic Number

```java
public class MyClass {
  public static void main(String args[]) {
    int base = 5;
    int n = 6;
    int ans = 0;
    int power = 1;
    while(n>0){
     int last =  n&1;
     n = n>>1;
     power = power*base;
     ans = last*power+ans;
    }
    System.out.print(ans);
  }
}
```

>Approach: increase the base of every position and multiply it with its binary it leads to verify if its present or now , remove the last element by doin & and shift pointer 


## XOR Operation Use Cases

### Key Properties

$$ \begin{align} a \oplus a &= 0 \quad \text{(self-cancelling)} \ a \oplus 0 &= a \quad \text{(identity)} \ a \oplus b &= b \oplus a \quad \text{(commutative)} \ (a \oplus b) \oplus c &= a \oplus (b \oplus c) \quad \text{(associative)} \end{align} $$

### 1.Find Unique Element in Array

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

### XOR 0 to N-1

in xor only multiple of 4 stays rest get diluted example
0 = 0
0^1 = 1
0^1^2 = 2
0^1^2^3 = 0
0^1^2^3^4 = 4
0^1^2^3^4^5 = 1
we use mod not for loop to do because it decrease time complexity and for loop out of bound 
so its follow a cycle of n%4

- If **n % 4 == 0**, result = n
    
- If **n % 4 == 1**, result = 1
    
- If **n % 4 == 2**, result = n + 1
    
- If **n % 4 == 3**, result = 0

```java
def xor_0_to_n(n):
    mod = n % 4
    if mod == 0:
        return n
    elif mod == 1:
        return 1
    elif mod == 2:
        return n + 1
    else:  # mod == 3
        return 0

# Example: XOR from 0 to 9
print(xor_0_to_n(9))  # Output: 1   
```
>Approach: we know the outcome of xor so we predict the n using the outcome 
>as if n%4 = =0 it means the vale maybe 4,8,16 etc
>if n%4 == 3 it means return 0 so we already have a predicted outcome it decrease the use of loop and time complexity 

### 3. XOR  n to N-1

```java
public class XorRange {
    static int xorUpto(int n) {
        // XOR 0 to n pattern: repeats every 4
        int rem = n % 4;
        if(rem == 0) return n;
        if(rem == 1) return 1;
        if(rem == 2) return n+1;
        return 0;  // rem == 3
    }
    
    static int xorRange(int l, int r) {
        return xorUpto(r) ^ xorUpto(l-1);
    }
    
    public static void main(String[] args) {
        System.out.println(xorRange(3,9));  // 101 ✓
        // 0^1 = 1 → XOR(0→2)=1^2=3 → 102^3=101
    }
}

```
> use start value to decrease it and xor with the output of 1 to 9 so it become 
> 3 - 9 

### 3 XOR INVERT
```java
int complement(int n, int bits) {
    int mask = (1 << bits) - 1;  // 4 bits → 1111
    return n ^ mask;
}

// Usage
int n = 10;  // 1010
int ans = complement(n, 4);  // 1010 ^ 1111 = 0101 ✓

```

>Approach we can invert any binary number using XOR 
>1111+1 = 1000 and 1000-1=1111








---
## Pascal Tree

```Normal
Row n | Pascal entries    | Sum = 1<<n
0     | 1                 | 1 = 1<<0
1     | 1 1               | 2 = 1<<1  
2     | 1 2 1             | 4 = 1<<2
3     | 1 3 3 1           | 8 = 1<<3 ✓
4     | 1 4 6 4 1         | 16 = 1<<4

```

```binary 
Row n | Binary rep | Sum (2^n)
0     |    1       | 1
1     |   10       | 2  
2     |  100       | 4
3     | 1000       | 8 ✓

```

>Approach:Here lift shift take place n-1 times and output is 2^n  times 
>so we using 1<< n-1
>


```java
public class MyClass {
  public static void main(String args[]) {
    int n = 5;
    int ans = 0;
 for(int i=0;i<=n;i++){
     ans = 1<<n;
 }

    System.out.println(ans);
  }
}
```

## Power Calculator in logn times


```java


public class MyClass {
  public static void main(String args[]) {
   int base = 3;
   int n = 6;
   int result = 1;
   while(n>0){
       if((n&1)==1){
        result = result*base;
       }
       n  = n>>1;
       base = base*base;
   }
   System.out.println(result);

    
  }
}
```

>Approach: We know base Double so Double the base and multiply with its bit and then multiple everybase
>3**6 and 6 = 110 in bits double the base 1*27*1*9*0*3 

```
3^6 (n=110b) - Binary Exponentiation

Start: result=1, base=3
     │
┌───▼──┐  ┌───▼──┐  ┌───▼──┐
│n=6   │  │n=3   │  │n=1   │
│&1=0  │  │&1=1  │  │&1=1  │
│skip  │◄─┤*9=9  │◄─┤*81   │
│base9 │  │base81│  │=729 ✓ │
└───▲──┘  └───▲──┘  └───▲──┘
    │          │          │
    └──────────┼──────────┘
               │
        3 loops = O(log n)!

```

