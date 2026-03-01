- Missing Number → range **0 to n**
    
- Find Duplicates → range **1 to n**



> [!NOTE]
> we can solve this using 2 methods 
> cycle sort and XOR 
> 
> in Cycle sort if 
> 0 to n take 
> currect as arr[i]; because 
> 
> 0 value at 0 index, 1 value at 1 index
> 1 to n take
> currect as arr[i] -1;
> 1 value at 0
> 


---

# PROBLEM STATEMENT

You are given an array `nums` containing `n` distinct numbers in the range:

0 to n

Exactly one number is missing.

You must return that missing number.

Example:  
Input: [3,0,1]  
Output: 2

---

CORE IDEA (Cyclic Sort Pattern)

Since numbers are from 0 to n:

- Every number should be at index = value
    
- Example:  
    nums[0] = 0  
    nums[1] = 1  
    nums[2] = 2
    

So we:

1. Place every number at its correct index.
    
2. Then scan for mismatch.
    
3. If no mismatch → missing number is n.
    

---

YOUR FINAL CORRECT CODE

```java
class Solution {
    public int missingNumber(int[] nums) {
        int[] check = sort(nums);

        for(int i=0;i<nums.length;i++){
           if(nums[i]!=i) return i;
        }

        return nums.length;
    }

    public int[] sort(int[]nums){

        int i = 0;
        while(i<nums.length){
            int currect = nums[i];
            if(currect<nums.length && nums[i]  != nums[currect]){
                swap(nums,i,currect);
            }else{
                i++;
            }
        }
        return nums;
    }

    public  void swap(int[]nums,int a,int b){
        int temp = nums[a];
        nums[a] = nums[b];
        nums[b] = temp;
    }
}
```

---

# STEP-BY-STEP LOGIC EXPLANATION

1. Cyclic Placement
    

```java
int currect = nums[i];
if(currect < nums.length && nums[i] != nums[currect])
```

Important part:  
`currect < nums.length`

Why?

Because n has no index in array of size n.

If nums[i] == n:  
We must NOT try:  
nums[n] → that causes ArrayIndexOutOfBounds.

So we only place numbers 0 to n-1.

> [!NOTE]
> nums = [2,0]
> 
> At i = 0:
> 
> currect = nums[0] = 2
> 
> Now if you do:
> 
> nums[currect] → nums[2]
> 
> But index 2 does not exist.
> 
> ArrayIndexOutOfBoundsException.
> 
> Crash.
> 
> That is why we check:
> 
> currect < nums.length

> [!NOTE]
> 0-n element
> 0-n index
> 
> if one element missing
> 0-n element
> 0-n-1 index
> 


---

2. After Sorting
    

Array becomes something like:

Index: 0 1 2 3  
Value: 0 1 3 4

Now:

nums[2] != 2  
So 2 is missing.

---

3. Why Final Return Is nums.length
    

Case 1:  
Mismatch found → return index.

Case 2:  
Everything matches → missing number must be n.

Example:  
Input: [0,1]

After sort:  
[0,1]

All match → missing = 2 → which is nums.length.

---

TIME COMPLEXITY

Cyclic Sort = O(n)

Why not O(n²)?

Because:  
Each number is swapped at most once to correct position.

Space Complexity = O(1)

---

# COMMON MISTAKES YOU MADE

1. Returning -1
    

Earlier you wrote:

```java
return -1;
```

Wrong because problem guarantees exactly one missing number.

If no mismatch found → missing is n.

Correct return:

```java
return nums.length;
```

---

2. Looping Till nums.length - 1
    

Earlier you used:

```java
for(int i=0;i<nums.length-1;i++)
```

Wrong.

You must check entire array because missing number might be at last index.

---

3. Not Checking currect < nums.length
    

Earlier version:

```java
if(nums[i] != nums[currect])
```

This causes crash when nums[i] == n.

Correct version:

```java
if(currect < nums.length && nums[i] != nums[currect])
```

---

INTERVIEW LEVEL UNDERSTANDING

If interviewer asks:

Why does cyclic sort work here?

Answer:  
Because numbers are in fixed range 0 to n, and correct index equals value.

If interviewer asks:

Why check currect < nums.length?

Answer:  
Because n does not have a valid index in an array of size n.

If interviewer asks:

Why is time complexity O(n)?

Answer:  
Each element is swapped at most once into correct position.

---

PATTERN RECOGNITION FOR FUTURE QUESTIONS

Use Cyclic Sort when:

- Numbers are in range 0 to n
    
- Numbers are in range 1 to n
    
- Missing number problems
    
- Duplicate number problems
    
- First missing positive problems
    
