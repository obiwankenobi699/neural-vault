Good 🔥 this is a **very important pattern question**:

> Check if array is sorted (ascending or descending)

But your code has multiple structural mistakes.

Let’s fix step-by-step.

---

# ❌ Problems in Your Code

### 1️⃣ `main` cannot return boolean

```java
public static boolean main(String[] args)
```

❌ Wrong  
`main` must be:

```java
public static void main(String[] args)
```

---

### 2️⃣ Missing braces `{}` after for loop

Your code:

```java
for(int i = 0;i<arr.length-1;i++)
    if(arr[i]>arr[i+1]){
        return false;
    }
```

Only first `if` is inside loop.

Second `if` is outside → error.

---

### 3️⃣ `i` is out of scope

This line:

```java
if( arr[i]<arr[i+1])
```

❌ `i` is not accessible here.

---

### 4️⃣ Logic is incorrect

You declared:

```java
boolean asc = true;
boolean dec = true;
```

But you never used them properly.

---

# ✅ Correct Pattern to Check Sorted

We check both ascending and descending.

---

## 🔥 Clean Working Version

```java
class Main {
    public static void main(String[] args) {

        int[] arr = {90,80,70,60,50,40,30,20};

        boolean asc = true;
        boolean dec = true;

        for(int i = 0; i < arr.length - 1; i++) {

            if(arr[i] > arr[i+1]) {
                asc = false;
            }

            if(arr[i] < arr[i+1]) {
                dec = false;
            }
        }

        if(asc)
            System.out.println("Array is sorted in ascending order");
        else if(dec)
            System.out.println("Array is sorted in descending order");
        else
            System.out.println("Array is not sorted");
    }
}
```

---

# 🧠 How This Logic Works

We assume both are true.

Then:

- If any element violates ascending → asc = false
    
- If any element violates descending → dec = false
    

At end:

|asc|dec|Meaning|
|---|---|---|
|true|false|Ascending|
|false|true|Descending|
|false|false|Not sorted|

---

# 🧠 Dry Run With Your Array

```text
90 80 70 60 50 40 30 20
```

Check:

90 > 80 → ascending false  
90 < 80 → descending remains true

Final:

asc = false  
dec = true

→ Descending sorted ✅

---

# 📊 Complexity

Time → O(n)  
Space → O(1)

---

# 🔥 Pattern Recognition

This belongs to:

> Monotonic array checking

Related LeetCode problem:

- 🔹 896 — Monotonic Array
    

---

# 🚀 Cleaner Version (Shorter)

```java
class Solution {
    public boolean isMonotonic(int[] arr) {

        boolean inc = true, dec = true;

        for(int i = 0; i < arr.length - 1; i++){
            if(arr[i] > arr[i+1]) inc = false;
            if(arr[i] < arr[i+1]) dec = false;
        }

        return inc || dec;
    }
}
```

---

You’re improving in:

- Loop control
    
- Boolean tracking
    
- Pattern thinking
    

If you want next:

- 🔥 How to check strictly increasing
    
- 🔥 How to detect peak element
    
- 🔥 Binary search in sorted array pattern sheet
    
- 🔥 15 must-know array patterns
    

Tell me your next focus 😎