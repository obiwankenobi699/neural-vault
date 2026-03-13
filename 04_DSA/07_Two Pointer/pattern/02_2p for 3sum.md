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
