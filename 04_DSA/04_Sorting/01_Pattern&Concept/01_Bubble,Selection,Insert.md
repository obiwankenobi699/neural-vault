Below are **Bubble Sort, Selection Sort, and Insertion Sort** — all implemented using **swap method**, with short theory and patterns.

---

# BUBBLE SORT

Basic Idea  
Repeatedly compare adjacent elements and swap if they are in the wrong order.  
After every pass, the largest element moves to the end.

Pattern Observed

- Adjacent comparison
    
- Largest element fixed at the end after each pass
    
- Right side becomes sorted
    

Time Complexity  
Best Case: O(n) (if optimized)  
Average Case: O(n²)  
Worst Case: O(n²)  
Space: O(1)  
Stable: Yes

Code (Using Swap)

```java
import java.util.Arrays;

public class Main {

    static void swap(int[] arr, int a, int b) {
        int temp = arr[a];
        arr[a] = arr[b];
        arr[b] = temp;
    }

    static void bubbleSort(int[] arr) {
        for (int i = 0; i < arr.length - 1; i++) {
            boolean swapped = false;

            for (int j = 0; j < arr.length - i - 1; j++) {
                if (arr[j] > arr[j + 1]) {
                    swap(arr, j, j + 1);
                    swapped = true;
                }
            }

            if (!swapped) break;
        }
    }

    public static void main(String[] args) {
        int[] arr = {45, 56, 23, 98, 67};
        bubbleSort(arr);
        System.out.println(Arrays.toString(arr));
    }
}
```



![[04_DSA/04_Sorting/visual/BSI.excalidraw.md#^frame=Qzr9AYh0xhNMRhNriSTEd|700]]

---

# SELECTION SORT

Basic Idea  
Select the smallest element from the unsorted portion and place it at correct position.

Pattern Observed

- Find minimum
    
- Swap once per outer loop
    
- Left side becomes sorted
    

Time Complexity  
Best: O(n²)  
Average: O(n²)  
Worst: O(n²)  
Space: O(1)  
Stable: No

Code (Using Swap)

```java
import java.util.Arrays;

public class Main {

    static void swap(int[] arr, int a, int b) {
        int temp = arr[a];
        arr[a] = arr[b];
        arr[b] = temp;
    }

    static void selectionSort(int[] arr) {
        for (int i = 0; i < arr.length - 1; i++) {
            int minIndex = i;

            for (int j = i + 1; j < arr.length; j++) {
                if (arr[j] < arr[minIndex]) {
                    minIndex = j;
                }
            }

            swap(arr, i, minIndex);
        }
    }

    public static void main(String[] args) {
        int[] arr = {45, 56, 23, 98, 67};
        selectionSort(arr);
        System.out.println(Arrays.toString(arr));
    }
}
```



![[04_DSA/04_Sorting/visual/BSI.excalidraw.md#^frame=rpS2D6w2_nm4nHsMhZGId|700]]

---

# INSERTION SORT (Using Swap Version)

Basic Idea  
Take element and move it left until it reaches correct position in sorted part.

Pattern Observed

- Left side always sorted
    
- Compare with previous element
    
- Swap backward until correct position
    

Time Complexity  
Best: O(n)  
Average: O(n²)  
Worst: O(n²)  
Space: O(1)  
Stable: Yes  
Adaptive: Yes

Code (Using Swap)

```java
import java.util.Arrays;

public class Main {

    static void swap(int[] arr, int a, int b) {
        int temp = arr[a];
        arr[a] = arr[b];
        arr[b] = temp;
    }

    static void insertionSort(int[] arr) {
        for (int i = 1; i < arr.length; i++) {

            for (int j = i; j > 0; j--) {
                if (arr[j] < arr[j - 1]) {
                    swap(arr, j, j - 1);
                } else {
                    break;
                }
            }
        }
    }

    public static void main(String[] args) {
        int[] arr = {45, 56, 23, 98, 67};
        insertionSort(arr);
        System.out.println(Arrays.toString(arr));
    }
}
```

---

Clear Pattern Comparison

Bubble Sort  
Largest element moves right  
Adjacent comparisons

Selection Sort  
Smallest element moves left  
Single swap per pass

Insertion Sort  
Element moves left gradually  
Sorted part grows from left

---

Important Concept About Swap Version

All three have same Big-O complexity even when using swap.  
But insertion with shifting is slightly more efficient in practice because it reduces assignments.

---

