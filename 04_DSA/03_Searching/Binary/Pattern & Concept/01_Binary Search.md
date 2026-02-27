---
title: Binary Search
tags:
created: 2026-02-23
updated: 2026-02-23
---


> **Related Topics:** none

---


>Binary Search is an efficient algorithm to find the **position of a target element** in a **sorted array**.

It works by repeatedly dividing the search interval in half.

**Key Points:**

1. Works only on **sorted arrays** (ascending or descending).
2. **Divide & Conquer** approach → reduces search space by half every time.
3. Time complexity:
    - **Best case:** O(1) (target found at the middle)
    - **Average & Worst case:** O(log n)
4. Space complexity:
    - **Iterative:** O(1)
    - **Recursive:** O(log n) due to call stack

---

##  Binary Search Formula (for mid index)

To avoid integer overflow when computing mid:

$$
[

\text{mid} = \text{low} + \frac{\text{high} - \text{low}}{2}

]
$$

**Where:**

- `low` = starting index of search interval
- `high` = ending index of search interval

---

## ** Steps of Binary Search**

1. Set `low = 0` and `high = n - 1`
2. Compute `mid = low + (high - low)/2`
3. Compare `arr[mid]` with `target`
    - If `arr[mid] == target` → found, return `mid`
    - If `arr[mid] < target` → search **right half** (`low = mid + 1`)
    - If `arr[mid] > target` → search **left half** (`high = mid - 1`)
4. Repeat steps 2–3 until `low > high` → target not found

---

##  Diagram
![[04_DSA/03_Searching/Binary/Visual/Binarysearch.excalidraw.md#^clippedframe=B4zALRWtNO_wJ_HeHtN9h|700]]

---

###  Code

```java
public static int binarySearch(int[] arr, int target) {
    int low = 0;
    int high = arr.length - 1;

    while (low <= high) {
        int mid = low + (high - low) / 2;

        if (arr[mid] == target) return mid;
        else if (arr[mid] < target) low = mid + 1;
        else high = mid - 1;
    }

    return -1; // target not found
}

```

