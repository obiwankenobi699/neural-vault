# Prime Number Algorithms

## Prime Number Definition

A prime number is a natural number greater than 1 that is divisible only by 1 and itself. Numbers with more than two divisors are composite numbers. The number 1 is neither prime nor composite by convention.

## Basic Approach: Trial Division

The naive approach tests divisibility by checking every number from 2 to n-1. If any number divides evenly (remainder zero), the number is composite. This method guarantees correctness but exhibits O(n) time complexity, making it impractical for large numbers.

```java
public static boolean isPrimeBasic(int n) {
    if (n <= 1) return false;
    
    for (int i = 2; i < n; i++) {
        if (n % i == 0) {
            return false;  // Found divisor, not prime
        }
    }
    return true;  // No divisors found, is prime
}
```

The algorithm iterates through all candidates from 2 to n-1, performing modulo operations to test divisibility. For a number like 1,000,003, this requires nearly one million iterations.

## Square Root Optimization

A fundamental mathematical property states that if a number n is composite, it must have at least one divisor less than or equal to √n. This is because factors come in pairs: if n = a × b and both a and b are greater than √n, then a × b would exceed n, creating a contradiction.

Therefore, testing divisors only up to √n suffices to determine primality. This optimization reduces time complexity from O(n) to O(√n), a substantial improvement for large numbers.

```java
import java.lang.Math;

public static boolean isPrime(int n) {
    if (n == 1) {
        return false;
    }
    
    int range = (int)Math.sqrt(n);
    
    for (int i = 2; i <= range; i++) {
        if (n % i == 0) {
            return false;
        }
    }
    return true;
}
```

**Example:** For n = 100, instead of checking 98 numbers (2 through 99), we only check 8 numbers (2 through 10), since √100 = 10.

## Avoiding Square Root Function

Computing square roots involves floating-point arithmetic and can be computationally expensive. We can eliminate the Math.sqrt() call by rearranging the termination condition. Instead of `i <= √n`, we use the mathematically equivalent condition `i * i <= n`.

This substitution avoids the square root operation entirely while maintaining identical logic. The condition `i * i <= n` is equivalent to `i <= √n` but uses only integer multiplication.

```java
public static boolean isPrime(int n) {
    if (n == 1) {
        return false;
    }
    
    for (int i = 2; i * i <= n; i++) {
        if (n % i == 0) {
            return false;
        }
    }
    return true;
}
```

**Performance consideration:** Integer multiplication executes faster than square root computation on most processors. The condition `i * i <= n` evaluates in constant time per iteration.

## Sieve of Eratosthenes

When finding all prime numbers up to n, repeatedly calling isPrime() for each candidate number proves inefficient. The Sieve of Eratosthenes algorithm finds all primes up to n in O(n log log n) time by marking composite numbers rather than testing individual candidates.

The fundamental insight: if a number is prime, all its multiples are composite. The algorithm iteratively marks multiples of each discovered prime, leaving only primes unmarked.

```java
public static boolean[] sieveOfEratosthenes(int n) {
    boolean[] isPrime = new boolean[n + 1];
    Arrays.fill(isPrime, true);
    isPrime[0] = isPrime[1] = false;
    
    for (int i = 2; i * i <= n; i++) {
        if (isPrime[i]) {
            for (int j = i * i; j <= n; j += i) {
                isPrime[j] = false;
            }
        }
    }
    
    return isPrime;
}
```

**Algorithm steps:**

1. Initialize boolean array assuming all numbers are prime
2. Mark 0 and 1 as not prime
3. For each number i from 2 to √n:
    - If i is still marked prime, mark all multiples as composite
4. Remaining true values represent primes

## Inner Loop Analysis: Why j = i * i

The inner loop starts at `j = i * i` rather than `j = 2 * i` to avoid redundant work. All multiples of i smaller than i² have already been marked by smaller primes.

**Mathematical proof:** Consider i = 5 and examine its multiples:

- 5 × 1 = 5: The number i itself (remains prime)
- 5 × 2 = 10: Already marked by i = 2
- 5 × 3 = 15: Already marked by i = 3
- 5 × 4 = 20: Already marked by i = 2
- 5 × 5 = 25: First unmarked multiple

Any multiple i × k where k < i has a factor k smaller than i. Since we process numbers in ascending order, k was already processed as a prime, marking i × k as composite.

Starting at i² eliminates all redundant marking operations, significantly improving performance.

## Step Size: Why j += i

The increment `j += i` jumps directly to the next multiple of i, ensuring we visit only multiples. This is fundamentally different from `j++`, which would visit every number sequentially.

**Example with i = 3:**

```
j = 9   → mark 9  (3 × 3)
j = 12  → mark 12 (3 × 4)
j = 15  → mark 15 (3 × 5)
j = 18  → mark 18 (3 × 6)
```

Using `j++` would visit 9, 10, 11, 12, 13, 14, 15... but only multiples of 3 need marking. The increment `j += i` generates the arithmetic sequence of multiples: i², i²+i, i²+2i, i²+3i...

## Complete Example: n = 30

**Initial state:** All numbers marked prime (true)

**i = 2 (first prime):**

- Start: j = 2 × 2 = 4
- Mark: 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30
- Total: 15 numbers marked

**i = 3 (next prime):**

- Start: j = 3 × 3 = 9
- Mark: 9, 12, 15, 18, 21, 24, 27, 30
- Total: 8 numbers marked (some already marked)

**i = 4:** Skipped (already marked composite by i = 2)

**i = 5 (next prime):**

- Start: j = 5 × 5 = 25
- Mark: 25, 30
- Total: 2 numbers marked

**i = 6:** Loop terminates since 6² = 36 > 30

**Final primes up to 30:** 2, 3, 5, 7, 11, 13, 17, 19, 23, 29

## Outer Loop Termination: Why i * i <= n

The outer loop only processes primes up to √n because any composite number larger than √n must have at least one prime factor less than or equal to √n. All composites with factors larger than √n have already been marked by their smaller prime factors.

**Example:** For n = 30, √30 ≈ 5.48

- Stop checking after i = 5
- Numbers like 6, 7, 8, 9, 10 need not be checked as starting points
- Any composites involving these as factors were already marked

## Complexity Analysis

**Time Complexity:** O(n log log n)

The algorithm marks each composite number exactly once by its smallest prime factor. The number of operations for prime p is approximately n/p. Summing over all primes gives:

n/2 + n/3 + n/5 + n/7 + ... = n(1/2 + 1/3 + 1/5 + 1/7 + ...)

The sum of reciprocals of primes grows as log log n, yielding O(n log log n) total complexity.

**Space Complexity:** O(n)

Requires boolean array of size n+1 to store primality information for all numbers up to n.

## Optimization: Why Each Multiple Marked Once

Each composite number gets marked exactly once by its smallest prime factor. This ensures no redundant work occurs. When we process prime p, we mark all multiples p², p²+p, p²+2p, ... None of these were previously marked by smaller primes because p is the smallest prime dividing them.

This single-marking property guarantees the algorithm's efficiency, making it vastly superior to repeated trial division.

## Performance Comparison

For finding all primes up to n = 1,000,000:

**Trial division approach:**

- Call isPrime() for each number: 1,000,000 calls
- Each call tests up to √n divisors: ~1,000 operations
- Total: ~1,000,000,000 operations

**Sieve of Eratosthenes:**

- Single pass marks all composites
- Total operations: ~n log log n ≈ 3,500,000 operations
- **Speed improvement: ~300x faster**

## Practical Applications

Prime number algorithms find applications in cryptography (RSA encryption), hash table sizing (prime-sized tables reduce collisions), pseudo-random number generation, and algorithm optimization (prime moduli in hash functions).

The sieve algorithm particularly suits scenarios requiring all primes within a range, such as generating encryption keys, mathematical research, or competitive programming problems involving prime factorization.

## Code Variants

**Finding count of primes:**

```java
public static int countPrimes(int n) {
    boolean[] isPrime = sieveOfEratosthenes(n);
    int count = 0;
    for (int i = 2; i <= n; i++) {
        if (isPrime[i]) count++;
    }
    return count;
}
```

**Listing all primes:**

```java
public static List<Integer> listPrimes(int n) {
    boolean[] isPrime = sieveOfEratosthenes(n);
    List<Integer> primes = new ArrayList<>();
    for (int i = 2; i <= n; i++) {
        if (isPrime[i]) primes.add(i);
    }
    return primes;
}
```

## Edge Cases

**n = 1:** Not prime by definition. Return false or exclude from prime list.

**n = 2:** The only even prime number. Handle explicitly or ensure algorithm marks it correctly.

**Large n:** For very large ranges, consider segmented sieve to reduce memory usage. Standard sieve requires O(n) space which becomes prohibitive for n > 10⁸.

## Memory Optimization

For extremely large ranges, the boolean array can be optimized using bit manipulation, storing 8 boolean values per byte. This reduces memory usage by factor of 8, enabling larger ranges within memory constraints.

```java
// Bit-packed version (advanced)
int[] isPrime = new int[(n + 31) / 32];  // Each int holds 32 bits
```

## Key Takeaways

The square root optimization reduces single prime checks from O(n) to O(√n). The condition `i * i <= n` avoids expensive square root operations while maintaining identical logic. Sieve of Eratosthenes finds all primes up to n in O(n log log n) time, significantly faster than repeated trial division. Starting the inner loop at i² eliminates redundant marking operations. Incrementing by i ensures we visit only multiples, avoiding unnecessary iterations. Each composite number is marked exactly once by its smallest prime factor, guaranteeing efficiency.

Binary search in maths
to find the square root of a number

Root Algo

1. Binary search

```java
import java.util.*;
import java.lang.Math;
public class MyClass {
  public static void main(String args[]) {
 
    int n = 40;
    int power = 3;
    double result = bs(n);
    double decimal = 0.1;
    for(double i=0;i<=power;i++){
        while(result*result<=40){
            result +=decimal;
        }
        result -=decimal;
        decimal /=10;
    }
    System.out.printf("%.3f",result);
    }
    
    public static double bs(int n){
        
        int start = 1; int end = n;double ans = 0.0;
        while(start<=end){
           int mid = start+(end-start)/2;
            
            if(mid<=n/mid){
                start = mid+1;
                ans = mid;
               
            }else{
                end = mid-1;
               
            }
        }
        return ans;
    }
}
```
>approach:

2.Newtonn Raphson Method

