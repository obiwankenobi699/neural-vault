































---

```java
while(left < right):
    if PALINDROME:        if(s[left]!=s[right]) return false
    if REVERSE:           swap(left,right)  
    if CONTAINER:         move shorter height
    if VOWELS:            skip non-vowels
    left++; right--;
```

| **Difficulty** | **#** | **Problem**               | **Input** | **Pattern**    | **Time** | **Key Insight**           |
| -------------- | ----- | ------------------------- | --------- | -------------- | -------- | ------------------------- |
| **Easy**       | 125   | Valid Palindrome          | String    | 2Ptr + Clean   | O(n)     | Skip non-alpha, lowercase |
|                | 344   | Reverse String            | char[]    | 2Ptr Swap      | O(n)     | `left < right` → swap     |
|                | 9     | Palindrome Number         | int       | Reverse Digits | O(log n) | `num % 10`, reverse build |
|                | 2108  | First Palindromic String  | String[]  | Array + 2Ptr   | O(n²)    | Check each string         |
|                | 121   | Best Time Stock           | int[]     | Min/Max Ptr    | O(n)     | `max(0, prices[j]-min)`   |
| **Medium**     | 680   | Valid Palindrome II       | String    | 2Ptr + Skip1   | O(n)     | Allow 1 mismatch          |
|                | 541   | Reverse String II         | String    | Substring 2Ptr | O(n)     | `k` length chunks         |
|                | 345   | Reverse Vowels            | String    | Vowel 2Ptr     | O(n)     | `aeiouAEIOU` only         |
|                | 11    | Container With Most Water | int[]     | 2Ptr Area      | O(n)     | Move shorter pointer      |
|                | 15    | 3Sum                      | int[]     | Sort + 2Ptr    | O(n²)    | Skip duplicates           |
|                | 16    | 3Sum Closest              | int[]     | Sort + 2Ptr    | O(n²)    | Track closest sum         |












