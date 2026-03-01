
1. Basic Idea
    

Cycle Sort is an in-place sorting algorithm that works by placing every element directly into its correct position using the concept of permutation cycles.

Instead of repeatedly swapping adjacent elements, it calculates the exact position where an element should go and moves it there.

It minimizes the number of swaps.

---

2. Core Concept
    

For each element:

- Count how many elements are smaller than it.
    
- That count gives its correct index.
    
- Place it directly at that index.
    
- Continue the cycle until the starting position is restored.
    

This process forms a cycle of elements.

---

3. What Does “Cycle” Mean?
    

Suppose array:

4 3 2 1

Correct sorted array:

1 2 3 4

Look at positions:

4 should go to index 3  
1 should go to index 0  
2 should go to index 1  
3 should go to index 2

If you track movements:

4 → 1 → 4  
3 → 2 → 3

These movements form permutation cycles.

A cycle means:  
A group of elements that rotate among themselves to reach correct positions.

---

4. What Does “Permutation” Mean in Sorting?
    

Permutation means rearrangement of elements.

Any sorting process is basically converting one permutation into another (sorted order).

Example:

Original: 3 1 2  
Sorted: 1 2 3

The original array is just a permutation of sorted order.

Cycle sort works by decomposing permutation into cycles and fixing each cycle with minimal swaps.

---

5. Why Is It Called Minimum Swap Algorithm?
    

Cycle sort performs at most (n - number_of_cycles) swaps.

Worst case swaps: O(n)

While most O(n²) algorithms do O(n²) swaps, cycle sort does very few swaps.

---

6. Is Cycle Sort Single Pass?
    

Not exactly single pass like linear scan.

It has nested loops → so time complexity is O(n²).

But:

Each element is placed in correct position in one cycle movement.

It does not repeatedly move the same element like bubble sort.

---

7. Time Complexity
    

Worst Case: O(n²)  
Best Case: O(n²)  
Space Complexity: O(1)  
Swaps: O(n)

---

8. When To Use Cycle Sort
    

Use Cycle Sort when:

- You want minimum number of swaps
    
- Writing to memory is expensive
    
- Flash memory / EEPROM situations
    
- When swap cost is very high
    

Do NOT use when:

- You need fast time complexity
    
- Dataset is large
    
- Stability is required
    

---

9. Is It Stable?
    

No.

Cycle sort is not stable because equal elements may change relative order.

---

10. Complete Java Code
    

```java
import java.util.Arrays;

public class Main {

    static void cycleSort(int[] arr) {
        int n = arr.length;

        for (int cycleStart = 0; cycleStart < n - 1; cycleStart++) {

            int item = arr[cycleStart];
            int pos = cycleStart;

            // Find correct position
            for (int i = cycleStart + 1; i < n; i++) {
                if (arr[i] < item) {
                    pos++;
                }
            }

            // If already correct position
            if (pos == cycleStart) continue;

            // Skip duplicates
            while (item == arr[pos]) {
                pos++;
            }

            // Put item in correct position
            int temp = arr[pos];
            arr[pos] = item;
            item = temp;

            // Rotate rest of cycle
            while (pos != cycleStart) {

                pos = cycleStart;

                for (int i = cycleStart + 1; i < n; i++) {
                    if (arr[i] < item) {
                        pos++;
                    }
                }

                while (item == arr[pos]) {
                    pos++;
                }

                temp = arr[pos];
                arr[pos] = item;
                item = temp;
            }
        }
    }

    public static void main(String[] args) {
        int[] arr = {4, 3, 2, 1};
        cycleSort(arr);
        System.out.println(Arrays.toString(arr));
    }
}
```

---

11. Interview-Level Understanding
    

If interviewer asks:

Why use Cycle Sort?

Answer:  
Because it minimizes the number of swaps and is useful when memory writes are expensive.

If interviewer asks:

Why is it O(n²) if swaps are O(n)?

Answer:  
Because finding the correct position requires scanning remaining elements each time.

If interviewer asks:

What mathematical idea is used?

Answer:  
Permutation cycles.

---

12. Quick Comparison With Other Sorts
    

Bubble Sort  
Many swaps  
O(n²) time

Selection Sort  
Few swaps  
O(n²) time

Insertion Sort  
Adaptive  
O(n²) time

Cycle Sort  
Minimum swaps  
O(n²) time

---

13. When Cycle Sort Is Commonly Asked
    

- Minimum swaps to sort an array
    
- Count swaps required
    
- Detect permutation cycles
    
- Problems like “minimum swaps to sort array”
    

---

If you want next, I can explain:

- How cycle detection works mathematically
    
- How to solve minimum swaps problem using graph cycles
    
- Difference between cycle sort and minimum swap algorithm
    
- Advanced interview trick questions
    

Tell me what you want next.