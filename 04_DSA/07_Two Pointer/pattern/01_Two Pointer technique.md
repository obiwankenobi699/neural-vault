

## What is Two Pointer

Two pointer is an algorithmic technique that uses two references to traverse a data structure, typically an array or linked list. The pointers move according to specific patterns to solve problems efficiently, often reducing time complexity from O(N²) to O(N). This technique is particularly effective when the data structure has some ordering or when we need to find pairs or subarrays satisfying certain conditions.

## When to Use Two Pointer

Use two pointer technique when the problem involves sorted arrays, finding pairs with specific properties, detecting cycles in linked lists, reversing or rearranging elements, checking palindromes, or optimizing window-based operations. The key indicator is when a brute force nested loop approach can be optimized by intelligent pointer movement based on problem constraints.

## Pattern 1: Opposite Direction

Two pointers start at opposite ends of the array and move toward each other. One pointer starts at index 0 (left) and another at index n-1 (right). Pointers move based on comparison logic until they meet or cross. This pattern works best with sorted arrays or when checking symmetry.

```java
// Example: Two Sum in Sorted Array
public int[] twoSum(int[] arr, int target) {
    int left = 0;
    int right = arr.length - 1;
    
    while (left < right) {
        int sum = arr[left] + arr[right];
        
        if (sum == target) {
            return new int[]{left, right};
        } else if (sum < target) {
            left++;  // Need larger sum
        } else {
            right--;  // Need smaller sum
        }
    }
    return new int[]{-1, -1};
}
```

Common problems: Two sum in sorted array, container with most water, valid palindrome, trapping rain water, three sum problems.

## Pattern 2: Same Direction (Fast and Slow)

Both pointers start at the beginning and move in the same direction at different speeds. The slow pointer moves one step at a time while the fast pointer moves two or more steps. This pattern is essential for cycle detection and finding middle elements.

```java
// Example: Detect Cycle in Linked List
public boolean hasCycle(ListNode head) {
    ListNode slow = head;
    ListNode fast = head;
    
    while (fast != null && fast.next != null) {
        slow = slow.next;        // Move 1 step
        fast = fast.next.next;   // Move 2 steps
        
        if (slow == fast) {
            return true;  // Cycle detected
        }
    }
    return false;
}
```

Common problems: Cycle detection, finding middle of linked list, remove nth node from end, happy number, linked list intersection.

## Pattern 3: Sliding Window (Same Direction with Gap)

Two pointers maintain a window of elements, both moving forward but maintaining a specific window size or condition. The right pointer expands the window and the left pointer contracts it based on constraints. This pattern is optimal for subarray or substring problems.

```java
// Example: Longest Substring Without Repeating Characters
public int lengthOfLongestSubstring(String s) {
    HashSet<Character> set = new HashSet<>();
    int left = 0;
    int maxLength = 0;
    
    for (int right = 0; right < s.length(); right++) {
        while (set.contains(s.charAt(right))) {
            set.remove(s.charAt(left));
            left++;  // Shrink window
        }
        set.add(s.charAt(right));
        maxLength = Math.max(maxLength, right - left + 1);
    }
    return maxLength;
}
```

Common problems: Maximum sum subarray, minimum window substring, longest substring without repeating characters, fruit into baskets, permutation in string.

## Pattern 4: Merge or Partition

Two pointers traverse two different arrays or sections simultaneously to merge or partition elements. Each pointer moves independently based on comparison or condition logic. This pattern is fundamental in merge operations and partitioning algorithms.

```java
// Example: Merge Two Sorted Arrays
public void merge(int[] arr1, int[] arr2, int[] result) {
    int i = 0, j = 0, k = 0;
    
    while (i < arr1.length && j < arr2.length) {
        if (arr1[i] <= arr2[j]) {
            result[k++] = arr1[i++];
        } else {
            result[k++] = arr2[j++];
        }
    }
    
    while (i < arr1.length) result[k++] = arr1[i++];
    while (j < arr2.length) result[k++] = arr2[j++];
}
```

Common problems: Merge sorted arrays, partition array, Dutch national flag, sort colors, intersection of arrays.

## Problem Reference Table

|Problem|Pattern|Key Insight|
|---|---|---|
|Two Sum (Sorted)|Opposite Direction|Move pointers based on sum comparison|
|Three Sum|Opposite Direction|Fix one element, two pointer on rest|
|Container With Most Water|Opposite Direction|Move pointer with smaller height|
|Trapping Rain Water|Opposite Direction|Track max heights from both sides|
|Valid Palindrome|Opposite Direction|Compare characters from both ends|
|Remove Duplicates|Same Direction|Slow tracks unique, fast scans ahead|
|Move Zeroes|Same Direction|Slow for non-zero position, fast scans|
|Linked List Cycle|Fast and Slow|Fast catches slow if cycle exists|
|Middle of Linked List|Fast and Slow|When fast ends, slow is at middle|
|Remove Nth From End|Fast and Slow|Gap of N between pointers|
|Maximum Subarray Sum|Sliding Window|Expand right, contract left on condition|
|Longest Substring K Distinct|Sliding Window|Maintain character count in window|
|Minimum Window Substring|Sliding Window|Expand to satisfy, contract to minimize|
|Permutation in String|Sliding Window|Fixed size window with frequency match|
|Merge Sorted Arrays|Merge Pattern|Compare and merge from both arrays|
|Sort Colors|Partition|Three pointers for three regions|
|Squares of Sorted Array|Opposite Direction|Larger absolute values at ends|
|Backspace String Compare|Opposite Direction|Process from end, handle backspaces|

## Time and Space Complexity

Most two pointer solutions achieve O(N) time complexity by traversing the array or list once with intelligent pointer movement, replacing the O(N²) complexity of nested loops. Space complexity is typically O(1) as only a constant number of pointers and variables are used, though sliding window problems may require additional data structures like hash maps or sets for tracking elements within the window.

## Key Recognition Patterns

Identify two pointer opportunities when the problem involves finding pairs or triplets summing to a target in sorted data, checking for palindromes or symmetry, detecting cycles or finding positions in linked lists, working with sorted arrays where comparison logic applies, optimizing brute force O(N²) solutions that compare all pairs, partitioning or rearranging elements based on conditions, or finding optimal subarrays or substrings with specific properties.

## Common Template

```java
// Opposite Direction Template
int left = 0;
int right = arr.length - 1;
while (left < right) {
    if (condition_met) {
        // Process and return or record result
    } else if (need_to_increase) {
        left++;
    } else {
        right--;
    }
}

// Same Direction Template
int slow = 0;
for (int fast = 0; fast < arr.length; fast++) {
    if (condition_met) {
        // Process arr[fast]
        slow++;
    }
}

// Sliding Window Template
int left = 0;
for (int right = 0; right < arr.length; right++) {
    // Add arr[right] to window
    while (window_invalid) {
        // Remove arr[left] from window
        left++;
    }
    // Update result with valid window
}
```

The two pointer technique transforms many problems from quadratic to linear time complexity by eliminating redundant comparisons through intelligent pointer movement based on problem-specific logic.