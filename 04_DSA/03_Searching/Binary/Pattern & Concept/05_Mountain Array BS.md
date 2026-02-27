

## Table of Contents

1. [Mountain Array - Find Peak](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#mountain-peak)
2. [Bitonic Array - Search Target](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#bitonic-search)
3. [Key Patterns](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#patterns)

---

# 1. Mountain Array - Find Peak {#mountain-peak}

## Problem Definition

**Mountain Array Properties:**

- Strictly increasing
- Then strictly decreasing
- Has exactly one peak

```
Array: [1, 3, 5, 7, 6, 4, 2]
                    ↑
                  Peak = 7 (index 3)
```

**Goal:** Find index where element is maximum.

---

## Key Observation

At any index `mid`:

```
If arr[mid] < arr[mid+1]:
  → In increasing slope
  → Peak is on the right
  → start = mid + 1

If arr[mid] > arr[mid+1]:
  → In decreasing slope
  → Peak is on left (including mid)
  → end = mid
```

---

## Algorithm

```java
class Solution {
    public int peakIndexInMountainArray(int[] arr) {
        int start = 0;
        int end = arr.length - 1;

        while (start < end) {
            int mid = start + (end - start) / 2;

            if (arr[mid] < arr[mid + 1]) {
                start = mid + 1;  // Peak is right
            } else {
                end = mid;         // Peak is left or at mid
            }
        }

        return start;  // or end (both are same)
    }
}
```

**Why `start < end` not `start <= end`?**

- We compare `mid` with `mid + 1`
- Need to ensure `mid + 1` is valid
- Loop terminates when `start == end` (peak found)

**Time Complexity:** O(log n)

---

# 2. Bitonic Array - Search Target {#bitonic-search}

## Problem Definition

**Bitonic Array:** Mountain array where we need to find a target value.

```
Array: [1, 3, 8, 12, 9, 5, 2]
                   ↑ peak
```

---

## Optimal Strategy (O(log n))

**Three Steps:**

### Step 1: Find Peak (O(log n))

Use mountain peak algorithm.

**Result:** Array splits into:

```
Left side  (ascending)  : [0 → peak]
Right side (descending) : [peak+1 → end]
```

### Step 2: Search Left Side (O(log n))

Binary search on `[0 → peak]` with ascending order.

**If found → Return immediately** (guarantees minimum index if duplicates exist)

### Step 3: Search Right Side (O(log n))

Binary search on `[peak+1 → end]` with descending order.

---

## Complete Solution

```java
class Solution {

    public int searchBitonic(int[] arr, int target) {
        int peak = findPeak(arr);

        // Search left (ascending)
        int left = binarySearch(arr, target, 0, peak, true);
        if (left != -1) return left;

        // Search right (descending)
        return binarySearch(arr, target, peak + 1, arr.length - 1, false);
    }

    private int findPeak(int[] arr) {
        int start = 0;
        int end = arr.length - 1;

        while (start < end) {
            int mid = start + (end - start) / 2;

            if (arr[mid] < arr[mid + 1]) {
                start = mid + 1;
            } else {
                end = mid;
            }
        }

        return start;
    }

    private int binarySearch(int[] arr, int target,
                             int start, int end,
                             boolean ascending) {

        while (start <= end) {
            int mid = start + (end - start) / 2;

            if (arr[mid] == target) return mid;

            if (ascending) {
                // Normal binary search
                if (arr[mid] < target)
                    start = mid + 1;
                else
                    end = mid - 1;
            } else {
                // Reverse binary search (descending)
                if (arr[mid] < target)
                    end = mid - 1;
                else
                    start = mid + 1;
            }
        }

        return -1;
    }
}
```

---

## Logic Breakdown

### Why Search Left First?

```
Array: [1, 2, 3, 4, 5, 3, 1]
            ↑           ↑
         index 2     index 5

Target = 3
```

If target appears twice:

- Smaller index always in left (ascending) side
- Must return minimum index
- Therefore, search left first

### Why `peak + 1` for Right Search?

```
Left search:  [0 → peak]       (includes peak)
Right search: [peak+1 → end]   (excludes peak)

No overlap, no duplicate work
```

Peak already checked in left search, no need to check again.

### Ascending vs Descending Binary Search

**Ascending (left side):**

```java
if (arr[mid] < target)
    start = mid + 1;  // Go right
else
    end = mid - 1;    // Go left
```

**Descending (right side):**

```java
if (arr[mid] < target)
    end = mid - 1;    // Go left (smaller values on left in descending)
else
    start = mid + 1;  // Go right
```

**Key Insight:** Comparison is reversed for descending order.

---

# 3. Key Patterns {#patterns}

## Pattern Recognition

**When you see:**

- Increasing then decreasing
- Single maximum
- Bitonic array
- Mountain array

**Think:**

```
Compare mid with mid+1
Shrink toward the slope direction
```

## Comparison Table

|Problem Type|Strategy|Time Complexity|
|---|---|---|
|**Find Peak**|Compare `arr[mid]` with `arr[mid+1]`|O(log n)|
|**Search in Bitonic**|1. Find peak<br>2. Binary search left<br>3. Binary search right|O(log n)|
|**Multiple Peaks**|Different algorithm (not covered here)|-|

## Template Summary

**Mountain Peak:**

```java
while (start < end) {
    mid = start + (end - start) / 2;
    if (arr[mid] < arr[mid+1])
        start = mid + 1;  // Go right
    else
        end = mid;        // Go left (include mid)
}
return start;
```

**Bitonic Search:**

```java
1. peak = findPeak(arr)
2. result = binarySearch(arr, target, 0, peak, ascending=true)
3. if not found: binarySearch(arr, target, peak+1, end, ascending=false)
```

---

## Important Notes

**Bitonic Array Insight:**

- Treat as two sorted arrays glued together
- Left part: sorted ascending
- Right part: sorted descending
- Apply correct binary search to each part

**Peak Element:**

- Always exists in valid mountain/bitonic array
- Splits array into ascending and descending halves
- Must be found first for search operations

**Order-Agnostic Binary Search:**

- Ascending: normal comparisons
- Descending: reversed comparisons
- Boolean flag determines which to use

---

## Quick Decision Guide

**Need to find peak only?**

- Use mountain peak algorithm
- Single pass, O(log n)

**Need to search for target?**

- Step 1: Find peak
- Step 2: Binary search left (ascending)
- Step 3: Binary search right (descending)
- Total: O(log n)

**Why not linear search?**

- Linear: O(n)
- Binary approach: O(log n)
- Maintains efficiency of binary search

---

## Key Takeaways

**Mountain Peak Finding:**

- Compare with next element
- Move toward increasing direction
- Converge to peak

**Bitonic Search:**

- Find peak first (splits array)
- Left side ascending, right side descending
- Apply appropriate binary search to each

**Search Order Matters:**

- Always search left (ascending) first
- Guarantees minimum index for duplicates
- Right search only if not found in left

**Loop Condition:**

- Use `start < end` for peak finding
- Use `start <= end` for target search
- Different because of comparison logic

---
![[04_DSA/03_Searching/Binary/Visual/Binarysearch.excalidraw.md#^frame=FaklgsjJAYqr23HKSuXcd|700]]