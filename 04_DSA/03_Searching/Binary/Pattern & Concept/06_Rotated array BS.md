# ROTATED SORTED ARRAY - BINARY SEARCH

## Professional Quick Reference Guide

---

## Table of Contents

1. [Core Concepts](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#core-concepts)
2. [Finding Pivot](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#finding-pivot)
3. [Handling Duplicates](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#duplicates)
4. [Search in Rotated Array](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#search)
5. [Approach Comparison](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#comparison)
6. [LeetCode Problem Mapping](https://claude.ai/chat/1f251fa6-0735-438d-8a0e-209f2c147346#problems)

---

# 1. Core Concepts {#core-concepts}

## What is Pivot?

**Pivot** = Index of smallest element = Number of rotations = Split point

```java
Original: [1,2,3,4,5,6,7]
Rotated:  [4,5,6,7,1,2,3]
           
Pivot index = 4
Minimum = 1
Rotations = 4
```

## Array Structure

```java
[4,5,6,7 | 1,2,3]
 Larger  | Smaller
          ↑ pivot
```

**Key Property:** Both halves are sorted ascending.

---

# 2. Finding Pivot {#finding-pivot}

## Decision Rule

**Compare `nums[mid]` with `nums[end]`:**

```java
If nums[mid] > nums[end]:
  → mid is in left part
  → pivot is in right half
  → start = mid + 1

If nums[mid] ≤ nums[end]:
  → mid is in right part
  → pivot is at mid or left
  → end = mid
```

## Code (Distinct Elements)

```java
int findPivot(int[] nums) {
    int start = 0, end = nums.length - 1;

    while (start < end) {
        int mid = start + (end - start) / 2;

        if (nums[mid] > nums[end]) {
            start = mid + 1;
        } else {
            end = mid;
        }
    }

    return start;  // Pivot index
}
```

**Time Complexity:** O(log n)

**Usage:**

```
After finding pivot:
LEFT half  → [0, pivot-1]     (sorted)
RIGHT half → [pivot, n-1]     (sorted)

Apply normal binary search on appropriate half.
```

---

# 3. Handling Duplicates {#duplicates}

## Problem with Duplicates

```
Array: [3,3,3,3,1,3,3]

When nums[mid] == nums[end]:
  → Cannot determine which half pivot is in
  → Binary search loses direction
```

## Solution: Safe Shrinking

```java
int findPivot(int[] nums) {
    int start = 0, end = nums.length - 1;

    while (start < end) {
        int mid = start + (end - start) / 2;

        if (nums[mid] > nums[end]) {
            start = mid + 1;
        }
        else if (nums[mid] < nums[end]) {
            end = mid;
        }
        else {
            end--;  // Skip duplicate safely
        }
    }

    return start;
}
```

**Time Complexity:** O(n) worst case, O(log n) average

**Why `end--` works:** Reducing end by 1 does not remove pivot from search space, only shrinks uncertainty.

---

# 4. Search in Rotated Array (With Duplicates) {Single pass}

## Complete Solution

```java
class Solution {
    public boolean search(int[] nums, int target) {
        int start = 0;
        int end = nums.length - 1;

        while (start <= end) {
            int mid = start + (end - start) / 2;

            // Case 1: Found target
            if (nums[mid] == target) {
                return true;
            }

            // Case 2: Duplicates block decision
            if (nums[start] == nums[mid] && nums[mid] == nums[end]) {
                start++;
                end--;
            }

            // Case 3: Left half is sorted
            else if (nums[start] <= nums[mid]) {
                if (target >= nums[start] && target < nums[mid]) {
                    end = mid - 1;
                } else {
                    start = mid + 1;
                }
            }

            // Case 4: Right half is sorted
            else {
                if (target > nums[mid] && target <= nums[end]) {
                    start = mid + 1;
                } else {
                    end = mid - 1;
                }
            }
        }

        return false;
    }
}
```

## Logic Flow

**Step 1:** Check if `nums[mid] == target` → Return true

**Step 2:** If duplicates hide structure (`nums[start] == nums[mid] == nums[end]`)

- Cannot determine sorted half
- Safely shrink: `start++`, `end--`
- Worst case O(n), unavoidable with duplicates

**Step 3:** Identify which half is sorted

- If `nums[start] <= nums[mid]` → Left half sorted
- Otherwise → Right half sorted

**Step 4:** Check if target is in sorted half

- If yes → Search that half
- If no → Search other half

---

# 5. Approach Comparison {#comparison}

## Method Overview

|Approach|Use Case|Handles Duplicates?|Time Complexity|Use For|
|---|---|---|---|---|
|**Normal Binary Search**|Fully sorted array|N/A|O(log n)|Standard search|
|**Pivot-First + 2 Searches**|Rotated, distinct elements|Partial (unstable)|O(log n)|Find min, rotation count|
|**Single-Pass Modified**|Rotated (any)|Yes|O(log n) avg, O(n) worst|Search target|
|**Pivot-Finding Only**|Need minimum/count|Needs fix|O(log n) avg|Find minimum|

## Why Single-Pass Works Better

**Pivot-First Approach:**

- Assumes clean split
- Fails when duplicates blur boundaries
- Commits early to structure

**Single-Pass Approach:**

- Re-evaluates sorted half every iteration
- Does not commit early
- Dynamically adapts to duplicates
- Passes all test cases


## Sort without Single pass , Using Pivot



```java
class Solution {

    public boolean search(int[] nums, int target) {

        int p = searchMin(nums);

        // Search left half
        if (bs(nums, 0, p - 1, target)) return true;

        // Search right half
        return bs(nums, p, nums.length - 1, target);
    }

    public int searchMin(int[] nums) {

        int start = 0;
        int end = nums.length - 1;

        while (start < end) {

            int mid = start + (end - start) / 2;

            if (nums[mid] > nums[end]) {
                start = mid + 1;
            }
            else if (nums[mid] < nums[end]) {
                end = mid;
            }
            else {
                end--;   // duplicate handling
            }
        }

        return start;
    }

    public boolean bs(int[] nums, int start, int end, int target) {

        while (start <= end) {

            int mid = start + (end - start) / 2;

            if (nums[mid] == target)
                return true;

            if (nums[mid] < target)
                start = mid + 1;
            else
                end = mid - 1;
        }

        return false;
    }
}
```


![[04_DSA/03_Searching/Binary/Visual/Binarysearch.excalidraw.md#^frame=lqfOPTILBBzZ8J2QnYtKm|700]]



---

# 6. LeetCode Problem Mapping {#problems}

|#|Problem|Recommended Approach|Reason|
|---|---|---|---|
|**33**|Search in Rotated Sorted Array|Pivot-first OR Single-pass|No duplicates|
|**81**|Search in Rotated Sorted Array II|Single-pass only|Duplicates break pivot|
|**153**|Find Minimum in Rotated Sorted Array|Pivot-finding|No duplicates|
|**154**|Find Minimum in Rotated Sorted Array II|Pivot with duplicate handling|Has duplicates|
|**189**|Rotate Array|Not binary search|Different concept|

---


|Approach|When To Use|Handles Duplicates?|Time Complexity|Solves Which Type of Questions|
|---|---|---|---|---|
|**Normal Binary Search**|Fully sorted array|❌ Not needed|O(log n)|Standard search problems|
|**Pivot-First + 2 Binary Searches**|Rotated array with **distinct elements**|⚠ Partial (unstable)|O(log n)|Find minimum, rotation count, search target|
|**Single-Pass Modified Binary Search**|Rotated array (distinct or duplicates)|✅ Yes|O(log n) avg, O(n) worst|Search target in rotated array|
|**Pivot-Finding Only**|Need minimum / rotation count|⚠ Needs duplicate fix|O(log n) avg|Find minimum element|


