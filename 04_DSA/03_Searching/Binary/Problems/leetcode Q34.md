You are very close to solving **LeetCode 34 – Find First and Last Position of Element in Sorted Array**, but your code has several structural mistakes.

I will:

1. Point out the errors clearly
    
2. Fix your code with minimal changes
    
3. Explain the binary search pattern used here
    

---

# ❌ Errors in Your Code

### 1. Wrong return statement

```java
return int[] ans;
```

This is invalid syntax.

Correct:

```java
return ans;
```

---

### 2. Wrong method parameter type

You wrote:

```java
public int find(int nums,int target,boolean findinL)
```

`nums` must be an array:

```java
public int find(int[] nums, int target, boolean findInLeft)
```

---

### 3. Typo in variable name

```java
if(findinLL)
```

Variable declared as `findinL`.

---

### 4. Loop condition is wrong

You used:

```java
while(start < end)
```

This may skip last element.

Correct:

```java
while(start <= end)
```

---

### 5. `return ans;` inside loop

You placed:

```java
return ans;
```

inside the loop.  
That exits after first iteration.

It must be outside the loop.

---

---

# ✅ Corrected Version (Using Your Logic)

```java
class Solution {
    public int[] searchRange(int[] nums, int target) {

        int[] ans = {-1, -1};

        ans[0] = find(nums, target, true);   // first occurrence
        ans[1] = find(nums, target, false);  // last occurrence

        return ans;
    }

    public int find(int[] nums, int target, boolean findInLeft) {

        int ans = -1;
        int start = 0;
        int end = nums.length - 1;

        while (start <= end) {

            int mid = start + (end - start) / 2;

            if (nums[mid] < target) {
                start = mid + 1;
            } 
            else if (nums[mid] > target) {
                end = mid - 1;
            } 
            else {
                ans = mid;

                if (findInLeft) {
                    end = mid - 1;   // search left side
                } else {
                    start = mid + 1; // search right side
                }
            }
        }

        return ans;
    }
}
```

---

# 🧠 How This Works

We run binary search twice.

## First call → find first occurrence

When target found:

- Save index
    
- Move left to check if earlier occurrence exists
    

```java
end = mid - 1;
```

---

## Second call → find last occurrence

When target found:

- Save index
    
- Move right to check if later occurrence exists
    

```java
start = mid + 1;
```

---

# Example

Input:

```text
nums = [5,7,7,8,8,10]
target = 8
```

First search → finds index 3  
Then moves left → stops  
Result: 3

Second search → finds index 4  
Moves right → stops  
Result: 4

Output:

```text
[3,4]
```

---

# ⏱ Complexity

Time Complexity:

O(log⁡n)O(\log n)

We run binary search twice.

Space Complexity:

O(1)O(1)

---

# 🧠 Pattern Used

This is called:

Binary Search for Boundaries

You modify binary search to:

- Continue searching even after finding target
    
- Bias search left or right
    

---

# 🔑 Key Insight

Whenever you see:

- First occurrence
    
- Last occurrence
    
- Lower bound
    
- Upper bound
    

Think:

Binary Search with directional bias

---

If you want, I can now explain:

- Difference between lower bound and upper bound
    
- Clean boundary-search template
    
- Or make Obsidian-ready notes for this pattern