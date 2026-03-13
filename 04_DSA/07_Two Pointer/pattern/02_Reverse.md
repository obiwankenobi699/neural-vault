

1) reverse an array using for and while loop


```java

public class Main {
    public static void main(String[] args) {
        int[] arr = {1, 2, 3, 4, 5};

        System.out.print("Original: ");
        printArray(arr);

        reverseWhile(arr);   // or reverseFor(arr)
        System.out.print("Reversed: ");
        printArray(arr);
    }

    public static void printArray(int[] arr) {
        for (int x : arr) System.out.print(x + " ");
        System.out.println();
    }

    public static void reverseFor(int[] arr) {
        int n = arr.length;
        for (int i = 0; i < n / 2; i++) {
            int temp = arr[i];
            arr[i] = arr[n - 1 - i];
            arr[n - 1 - i] = temp;
        }
    }

    public static void reverseWhile(int[] arr) {
        int left = 0;
        int right = arr.length - 1;
        while (left < right) {
            int temp = arr[left];
            arr[left] = arr[right];
            arr[right] = temp;
            left++;
            right--;
        }
    }
}

```


2) reverse an int not possible 
two pinter cannot reverse so use digit reversing 

3) reverse an string 

```java

void reverseString(string &s) {
    int left = 0, right = s.length() - 1;
    while (left < right) {
        swap(s[left], s[right]);
        left++;
        right--;
    }
}   
```



