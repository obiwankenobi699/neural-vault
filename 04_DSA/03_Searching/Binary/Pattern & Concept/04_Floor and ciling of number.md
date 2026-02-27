## Binary Search — What Do `start` and `end` Really Represent?

This is a foundational concept. If you understand this properly, binary search becomes easy in every variation.

---

# 1. Core Meaning of `start` and `end`

At any moment during binary search:

```
start → Left boundary of possible answer
end   → Right boundary of possible answer
```

They define the **current search space**.

Formally:

Search Space=[start,end]\text{Search Space} = [start, end]

Everything **outside** this range is already eliminated.

---

# 2. In Standard Binary Search (Exact Match)

We maintain:

start≤endstart \leq end

Loop condition:

while (start ≤ end)\textbf{while (start ≤ end)}

Interpretation:

- If `arr[mid] < target`  
    → All elements left of mid are useless  
    → Move `start = mid + 1`
    
- If `arr[mid] > target`  
    → All elements right of mid are useless  
    → Move `end = mid - 1`
    

So:

start=first possible index where answer may existstart = \text{first possible index where answer may exist} end=last possible index where answer may existend = \text{last possible index where answer may exist}

---

# 3. When Loop Ends

Loop stops when:

start>endstart > end

At this moment:

> [!NOTE]
> end=last element smaller than target

> [!NOTE]
> start=first element greater than targetend 
> 

This is why:

- Floor → return `end`
    
- Ceiling → return `start`
    

---

# 4. Visual Interpretation

![[04_DSA/03_Searching/Binary/Visual/Binarysearch.excalidraw.md#^frame=MK9ZelrYfVKH20rHxrER0|700]]



