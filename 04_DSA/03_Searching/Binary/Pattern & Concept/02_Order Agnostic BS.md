---
title: 02_Order Agnostic BS
tags: [coding, Java, Searching, notes]
created: 2026-02-23
updated: 2026-02-23
---

### 1. Problem Overview

>Sometimes an array is sorted, but we do not know whether it is sorted in ascending or descending order.  
In such cases, we first determine the order of sorting, then apply binary search accordingly.

This technique is called **Order-Agnostic Binary Search**.

---

## 2. Step 1 – Determine Sorting Order

Instead of looping through the entire array, we can determine the order in constant time.

If the first element is smaller than the last element, the array is ascending.  
Otherwise, it is descending.

```java
boolean asc = arr[0] < arr[arr.length - 1];
```

Time Complexity: O(1)
[[02_Find Array is Sorted in which way]]


---

## 3. Step 2 – Apply Binary Search Based on Order

Binary search logic slightly changes depending on whether the array is ascending or descending.

### Standard Binary Search Loop

```java
while (start <= end) {
    int mid = start + (end - start) / 2;

    if (arr[mid] == target) {
        return mid;
    }

    // Adjust start or end here
}
```

Important: Always use  
`start + (end - start) / 2`  
to avoid integer overflow.

---

## 4. Comparison Logic

### If Array is Ascending

If `arr[mid] < target`, move right.  
If `arr[mid] > target`, move left.

```java
if (arr[mid] < target) {
    start = mid + 1;
} else {
    end = mid - 1;
}
```

---

### If Array is Descending

The comparison reverses.

If `arr[mid] < target`, move left.  
If `arr[mid] > target`, move right.

```java
if (arr[mid] < target) {
    end = mid - 1;
} else {
    start = mid + 1;
}
```

---

## 5. Complete Implementation

```java
class Solution {
    public static int orderAgnosticBinarySearch(int[] arr, int target) {

        int start = 0;
        int end = arr.length - 1;

        boolean asc = arr[start] < arr[end];

        while (start <= end) {

            int mid = start + (end - start) / 2;

            if (arr[mid] == target) {
                return mid;
            }

            if (asc) {
                if (arr[mid] < target) {
                    start = mid + 1;
                } else {
                    end = mid - 1;
                }
            } else {
                if (arr[mid] < target) {
                    end = mid - 1;
                } else {
                    start = mid + 1;
                }
            }
        }

        return -1;
    }
}
```

---

## 6. Time and Space Complexity

Time Complexity: O(log n)  
Space Complexity: O(1)

---

## 7. General Binary Search Pattern

Whenever you see:

- “Sorted array”
    
- “Search target”
    
- “Find position”
    

Use this template:

```java
while (start <= end) {
    int mid = start + (end - start) / 2;

    if (arr[mid] == target)
        return mid;

    adjust start or end;
}
```

---

## 8. When to Use Order-Agnostic Binary Search

Use this approach when:

- The array is sorted.
    
- The sorting order is not explicitly specified.
    
- You need to search efficiently in O(log n).
    

---

## 9. Related LeetCode Problems

- 704 – Binary Search
    
- 35 – Search Insert Position
    
- 34 – Find First and Last Position of Element in Sorted Array
    
- 33 – Search in Rotated Sorted Array
    
- 153 – Find Minimum in Rotated Sorted Array
    
- 852 – Peak Index in a Mountain Array
    
- 1095 – Find in Mountain Array
    

---

## 10. Key Takeaway

Binary search depends entirely on ordering.  
If the array order changes, the comparison logic must also change.

The overall structure remains the same; only the direction of movement differs.

This pattern forms the foundation for many advanced search problems.