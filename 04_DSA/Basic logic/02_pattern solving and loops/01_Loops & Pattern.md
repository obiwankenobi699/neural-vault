
# 1. Loops

Java has **four** types of loops:

|Loop|Use when|
|---|---|
|`for`|You know the **exact range**|
|`while`|You know the **condition**, not the count|
|`do-while`|You want to run **at least once**, then check|
|Built-in (forEach, streams)|Iterating **collections**|

```java
// for
for (int i = 0; i < n; i++) { }

// while
while (n < range) { }

// do-while — runs body first, checks condition after
do {
    // body runs at least once
} while (n < range);
```

---

# 2. For Loop

## When to Use

- You know the **exact start and end**
- You need a **counter variable** inside the loop
- Can be **nested** (loop inside a loop)

## Direction Rules

|Direction|Setup|When|
|---|---|---|
|`i++`|Set the **upper bound** as range|Number is increasing|
|`i--`|Set the **lower bound** as range|Number is decreasing|

```java
// Counting down: start at 0, go to -9
for (int i = 0; i > -10; i--) {
    System.out.println(i);
}
// Output: 0, -1, -2 ... -9
```

---

# 3. Pattern Printing

## Core Algorithm — 3 Questions to Ask First

```
1. How many LINES?            → controls the outer loop
2. How many COLUMNS per line? → controls the inner loop (static or dynamic?)
3. What to PRINT?             → *, number, space, or char
```

## The 5 Rules

|Rule|Explanation|
|---|---|
|R1 — Outer loop = lines|Outer loop always runs `n` times for `n` lines|
|R2 — Dynamic inner = use `i`|If column count changes row by row, make inner bound depend on `i`|
|R3 — Static inner = fixed number|If every row has same columns, inner bound is a constant|
|R4 — Space loop before star loop|To push stars right, print spaces first in a separate loop|
|R5 — Hollow = print only edges|Print `*` only when `j == 0` or `j == range - 1`|

---

# 4. Patterns

---

### Pattern 1 — Solid Rectangle

```
****
****
****
****
```

**Approach:** Both loops are fixed. Outer = rows, Inner = columns. No dynamic range needed.

```java
for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
        System.out.print("*");
    }
    System.out.println();
}
```

> `j < 4` is fixed — every row prints exactly 4 stars. No dynamic range involved.

---

### Pattern 2 — Hollow Rectangle

```
****
*  *
*  *
****
```

**Approach:** Same outer structure as Pattern 1. Only print `*` on the first row, last row, first column, or last column. Everything else is a space.

```java
int n = 4; // rows
int m = 4; // cols
for (int i = 0; i < n; i++) {
    for (int j = 0; j < m; j++) {
        if (i == 0 || i == n - 1 || j == 0 || j == m - 1) {
            System.out.print("*");
        } else {
            System.out.print(" ");
        }
    }
    System.out.println();
}
```

> Four edge conditions: top `i==0`, bottom `i==n-1`, left `j==0`, right `j==m-1`. Any cell matching none of these is hollow (space).

---

### Pattern 3 — Right Triangle (Increasing)

```
*
**
***
****
```

**Approach:** Inner loop bound is `i` (dynamic). As `i` grows each row, one more star prints.

```java
for (int i = 1; i <= n; i++) {
    for (int j = 0; j < i; j++) {
        System.out.print("*");
    }
    System.out.println();
}
```

> `j < i` makes the inner loop grow with the outer — row 1 prints 1 star, row 2 prints 2, and so on.

**Derivative — Numbers instead of stars:**

```
1
12
123
1234
```

```java
for (int i = 1; i <= n; i++) {
    for (int j = 1; j <= i; j++) {
        System.out.print(j);
    }
    System.out.println();
}
```

**Derivative — Same number repeated per row:**

```
1
22
333
4444
```

```java
for (int i = 1; i <= n; i++) {
    for (int j = 0; j < i; j++) {
        System.out.print(i);   // print i, not j
    }
    System.out.println();
}
```

---

### Pattern 4 — Hollow Right Triangle

```
*
**
*  *
*   *
*****
```

**Approach:** Same outer triangle structure as Pattern 3. Only print `*` on the left edge, right diagonal edge, or bottom row. Middle cells are spaces.

```java
for (int i = 1; i <= n; i++) {
    for (int j = 1; j <= i; j++) {
        if (j == 1 || j == i || i == n) {
            System.out.print("*");
        } else {
            System.out.print(" ");
        }
    }
    System.out.println();
}
```

> Three edge conditions: left `j==1`, diagonal `j==i`, bottom `i==n`. Rows 1 and 2 are always fully solid since there is no interior gap when range is 1 or 2.

---

### Pattern 5 — Inverted Right Triangle

```
****
***
**
*
```

**Approach:** Inner loop decreases each row. Bound is `n - i` so it shrinks as `i` grows.

```java
for (int i = 0; i < n; i++) {
    for (int j = 0; j < n - i; j++) {
        System.out.print("*");
    }
    System.out.println();
}
```

> `j < n - i` — row 0 prints n stars, row 1 prints n-1, last row prints 1. The bound shrinks because `i` is subtracted from `n`.

---

### Pattern 6 — Inverted Hollow Right Triangle

```
*****
*   *
*  *
**
*
```

**Approach:** Same structure as Pattern 5. Only print `*` on the left edge, right (diagonal) edge, or top row. Middle cells are spaces.

```java
for (int i = 0; i < n; i++) {
    for (int j = 0; j < n - i; j++) {
        if (i == 0 || j == 0 || j == n - i - 1) {
            System.out.print("*");
        } else {
            System.out.print(" ");
        }
    }
    System.out.println();
}
```

> Three edge conditions: top row `i==0`, left edge `j==0`, right diagonal `j==n-i-1`. The diagonal shrinks each row exactly as the loop bound does.

---

### Pattern 7 — Staircase (Shifted Right)

```
****
  ***
    **
      *
```

**Approach:** Stars decrease each row AND shift right. Two loops per row: spaces first, then stars. Spaces = `i * 2`, Stars = `n - i`.

```java
for (int i = 0; i < n; i++) {
    for (int space = 0; space < i * 2; space++) {
        System.out.print(" ");
    }
    for (int j = 0; j < n - i; j++) {
        System.out.print("*");
    }
    System.out.println();
}
```

> Row structure: `spaces | stars`. As `i` increases, spaces grow by `i*2` and stars shrink by `n-i`. The block slides right while getting shorter every row.

---

### Pattern 8 — Half Pyramid (Centre-aligned, top only)

```
    *
   ***
  *****
 *******
*********
```

**Approach:** Spaces = `n - i`, Stars = `2*i - 1` (odd). Two inner loops: space loop then star loop. No ternary needed — only the top half.

```java
for (int i = 1; i <= n; i++) {
    for (int space = 0; space < n - i; space++) {
        System.out.print(" ");
    }
    for (int j = 0; j < 2 * i - 1; j++) {
        System.out.print("*");
    }
    System.out.println();
}
```

> `2*i - 1` gives odd star counts: row 1 gives 1, row 2 gives 3, row 3 gives 5. Odd counts keep the pyramid centred without needing the ternary mirror logic.

---

### Pattern 9 — Inverted Half Pyramid (Centre-aligned, bottom only)

```
*********
 *******
  *****
   ***
    *
```

**Approach:** Mirror of Pattern 8. Run `i` from `n` down to `1`. Same space and star formulas apply, traversed in reverse.

```java
for (int i = n; i >= 1; i--) {
    for (int space = 0; space < n - i; space++) {
        System.out.print(" ");
    }
    for (int j = 0; j < 2 * i - 1; j++) {
        System.out.print("*");
    }
    System.out.println();
}
```

> Exactly the same formulas as Pattern 8 — just run `i` from `n` to `1` instead of `1` to `n`. The pyramid flips automatically.

---

### Pattern 10 — Inverted Hollow Pyramid

```
*********
 *     *
  *   *
   * *
    *
```

**Approach:** Same structure as Pattern 9. Only print `*` on the top row, left edge, or right edge. Interior cells are spaces.

```java

public class MyClass {
  public static void main(String args[]) {
     int n = 7;
     
    for(int i=1;i<=n;i++){
        
        for(int s = 1;s<i;s++){
            System.out.print(" ");
        }
        for(int j=n;j>=2*i-1;j--){
           if(i==1 || i==n || j==2*i-1||j==n){
               System.out.print("*");
           }else{
               System.out.print(" ");
           }
        }
        System.out.println();
    }
  }
 
}
```

> Top row `i==n` prints all stars. Every other row only prints the two edge stars at `j==0` and `j==stars-1`. Interior is spaces.

---

### Pattern 11 — Left Diamond (Symmetric, Left-aligned)

```
*
**
***
**
*
```

**Approach:** Total rows = `2*n - 1`. First half increases, second half decreases. One ternary computes `range` for both halves in a single outer loop.

```java
public class MyClass {
  public static void main(String args[]) {
   int n = 4;
   for(int i=1;i<=2*n-1;i++){
    
    int range = (i<=n)?i:(2*n-i);
    for(int j=1;j<=range;j++){
        System.out.print("*");
    }
    System.out.println();
}
   
   
  }
}
```

> `range = i > n ? 2*n - i : i` mirrors the count at midpoint `n`. Think of it as two triangles joined back to back — the ternary handles both halves automatically.

---

### Pattern 12 — Right Diamond (Right-aligned)

```
  *
 **
***
 **
  *
```

**Approach:** Same as Pattern 11, but add a space loop before stars to push them right. Spaces = `n - range`.

```java

public class MyClass {
  public static void main(String args[]) {
   int n = 4;
   for(int i=1;i<=2*n-1;i++){
    int range = (i<=n)?i:(2*n-i);
    for(int s=4;s>=range;s--){
        System.out.print(" ");
    }
    for(int j=1;j<=range;j++){
        System.out.print("*");
    }
    System.out.println();
}
   
   
  }
}
```

> Three loops per row: spaces then stars then newline. Spaces fill the left gap so stars appear right-aligned. This is Rule 4 applied to the diamond shape.

---

### Pattern 13 — Full Diamond (Centre-aligned)

```
    *
   ***
  *****
 *******
*********
 *******
  *****
   ***
    *
```

**Approach:** Stars per row = `2 * range - 1` (always odd). Spaces = `n - range`. Same ternary `range` as Patterns 11 and 12, just with a wider star loop.

```java

public class MyClass {
  public static void main(String args[]) {
   int n = 4;
   for(int i=1;i<=2*n-1;i++){
    int range = (i<=n)?i:(2*n-i);
    for(int s=4;s>=range;s--){
        System.out.print(" ");
    }
    for(int j=1;j<=2*range-1;j++){
        System.out.print("*");
    }
    System.out.println();
}
   
   
  }
}
```

> `2 * range - 1` always gives odd counts: range 1 gives 1 star, range 2 gives 3, range 3 gives 5. Odd counts keep the diamond centred symmetrically.

**Derivative — Spaced stars:**

```
    *
   * *
  * * *
```

```java
// Replace the inner star loop with:
for (int j = 0; j < range; j++) {
    System.out.print("* ");
}
```

---

### Pattern 14 — Hollow Diamond

```
    *
   * *
  *   *
 *     *
*       *
 *     *
  *   *
   * *
    *
```

**Approach:** Build on Pattern 13. Print stars only at the left and right edges of each star loop (Rule 5). Check `j == 0 || j == range - 1` inside, print space otherwise.

```java
for (int i = 1; i < 2 * n; i++) {
    int range = (i > n) ? 2 * n - i : i;

    for (int space = 0; space < n - range; space++) {
        System.out.print(" ");
    }
    for (int j = 0; j < range; j++) {
        if (j == 0 || j == range - 1) {
            System.out.print("* ");
        } else {
            System.out.print("  ");
        }
    }
    System.out.println();
}
```

> When `range == 1` (the very tip), `j==0` and `j==range-1` point to the same cell, so the tip star prints correctly with no special case needed.

---

### Pattern 15 — Hourglass

```
********
***  ***
**    **
*      *
*      *
**    **
***  ***
********
```

**Approach:** Stars shrink from outside toward centre, then grow back. Compute `stars` and `spaces` per row separately from `i`. Row = left stars + spaces + right stars.

```java
for (int i = 1; i <= 2 * n; i++) {
    int stars  = (i <= n) ? (n - i + 1) : (i - n);
    int spaces = 2 * (n - stars);

    for (int j = 0; j < stars; j++)  System.out.print("*");
    for (int j = 0; j < spaces; j++) System.out.print(" ");
    for (int j = 0; j < stars; j++)  System.out.print("*");

    System.out.println();
}
```

> Three inner loops every row: `stars | spaces | stars`. Stars and spaces are computed arithmetically from `i` — no dynamic bound, just variables controlling loop count.

---

### Pattern 16 — Hollow Triangle (Centre-aligned)

```
   *
  * *
 *   *
*******
```

**Approach:** Spaces decrease each row (`n - i`). Print stars only on left edge, right edge, or bottom row. Interior is spaces. Stars are separated by a gap to show the hollow.

```java
for (int i = 1; i <= n; i++) {
    for (int space = 0; space < n - i; space++) {
        System.out.print(" ");
    }
    for (int j = 1; j <= i; j++) {
        if (j == 1 || j == i || i == n) {
            System.out.print("*");
        } else {
            System.out.print(" ");
        }
        if (j < i) System.out.print(" "); // gap between columns
    }
    System.out.println();
}
```

> The extra `" "` after each star (except the last in the row) spaces them apart so the hollow interior is visible. Bottom row `i==n` overrides the edge check and fills completely.

---

### Pattern 17 — Number Pyramid

```
    1
   121
  12321
 1234321
```

**Approach:** Print spaces, then count up `1..i`, then count back down `i-1..1`. Four loops total per row: spaces, ascending, descending, newline.

```java
for (int i = 1; i <= n; i++) {
    for (int s = 0; s < n - i; s++)   System.out.print(" ");
    for (int j = 1; j <= i; j++)       System.out.print(j);
    for (int j = i - 1; j >= 1; j--)  System.out.print(j);
    System.out.println();
}
```

> The palindrome effect: ascending loop prints `1..i`, descending prints `i-1..1`. Two counting loops in opposite directions around the same pivot `i`.

---

# 5. Pattern Decision Tree

```
Start
│
├── All rows same length?
│     ├── YES → Static inner loop  (j < fixed_number)
│     └── NO  → Dynamic inner loop (j < i  or  j < n-i)
│
├── Need to push right?
│     └── YES → Add space loop BEFORE star loop  (spaces = n - range)
│
├── Symmetric (grows then shrinks)?
│     └── YES → Use ternary:  range = i > n ? 2*n - i : i
│
├── Stars count is odd per row?
│     └── YES → Use  2 * range - 1  as star count
│
└── Hollow?
      ├── Rectangle → if (i==0 || i==n-1 || j==0 || j==m-1)
      ├── Triangle  → if (j==1 || j==i   || i==n)
      └── Diamond   → if (j==0 || j==range-1)
```

---

# 6. Quick Reference — Inner Loop Bounds

|Pattern|Inner loop bound|Key idea|
|---|---|---|
|1 Solid rectangle|`j < cols`|Fixed every row|
|2 Hollow rectangle|`j < cols` + if-else|Edge check on `i` and `j`|
|3 Right triangle|`j < i`|Grows with `i`|
|4 Hollow right triangle|`j < i` + if-else|Edge check on `j==1`, `j==i`, `i==n`|
|5 Inverted triangle|`j < n - i`|Shrinks with `i`|
|6 Inverted hollow triangle|`j < n - i` + if-else|Edge check on `i==0`, `j==0`, `j==n-i-1`|
|7 Staircase|spaces `i*2`, stars `n-i`|Two loops, arithmetic bounds|
|8 Half pyramid|stars `2*i-1`, spaces `n-i`|Odd count, no ternary needed|
|9 Inverted half pyramid|same formulas, `i` goes `n to 1`|Same as above, reversed|
|10 Inverted hollow pyramid|same + if-else|Edge check on `i==n`, `j==0`, `j==stars-1`|
|11 Left diamond|`j < range` where `range = i>n ? 2*n-i : i`|Ternary mirrors at `n`|
|12 Right diamond|same + space loop before|Space loop = `n - range`|
|13 Full diamond|`j < 2*range - 1`|Odd star count|
|14 Hollow diamond|`j < range` + if-else|Edge check on `j==0`, `j==range-1`|
|15 Hourglass|compute `stars` and `spaces` separately|Three inner loops|
|16 Hollow triangle|`j < i` + if-else + gap|Edge check with space gap between stars|
|17 Number pyramid|count up `j<=i` then down `j>=1`|Two loops in opposite directions|

---

# 7. Pattern Family Tree

```
Solid Rectangle (1)
│
├── Hollow Rectangle (2)              add edge if-else on i and j
│
└── Right Triangle (3)                dynamic inner: j < i
    │
    ├── Number derivatives            print j or i instead of *
    ├── Hollow Right Triangle (4)     add edge if-else
    │
    └── Inverted Triangle (5)         flip to j < n-i
        │
        ├── Inverted Hollow (6)       add edge if-else
        └── Staircase (7)             add space loop before stars

Half Pyramid (8)                      stars = 2*i-1, spaces = n-i
│
└── Inverted Half Pyramid (9)         run i from n down to 1
    │
    └── Inverted Hollow Pyramid (10)  add edge if-else inside star loop

Left Diamond (11)                     ternary range, single star loop
│
├── Right Diamond (12)                add space loop before stars
│
└── Full Diamond (13)                 stars = 2*range-1
    │
    ├── Spaced Stars derivative       print "* " instead of "*"
    └── Hollow Diamond (14)           edge if-else inside star loop

Hourglass (15)                        separate stars/spaces, 3 inner loops

Hollow Triangle (16)                  space + edge if-else + gap between stars

Number Pyramid (17)                   space + ascending + descending loops
```