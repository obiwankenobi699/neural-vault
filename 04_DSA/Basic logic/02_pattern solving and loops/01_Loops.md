
# 1.Loops

In java we have four types of loops 
- for loop
- while loop
- do while loop
- buildin loops
-

```java
for(int i=0;i<any number;i++){
	initialize;range;increment
}
```

```java
while(n<range){
}
```


```java
do{
	//condition
	}  while(n<range){
		
	}
```

So we can Perform task which we want to repeat multiple times

# 2.For Loop

## use

1.The for loops is different from another loop by its syntax 
2.we use for loop when we know the exact range of our work
3.for loop can be nested 


### Space area

There are two ways to run our loop 

i++ :set higest bound of range + number must be increasing
i--: set lower bound of range + number must be decreasing 

```java
import java.util.*;
class Main {
    public static void main(String[] args) {
        for(int i = 0;i>-10;i--){
            System.out.println(i);
        }
    }
}
output:0,-1 To -9
```


# Pattern

This is the very Basic Pattern 
```
*
**
***
****
```

## algo to print

1. The outer loops run to print number of lines
	in above example there are 4 lines so outer loop run 4 times

2. The inner loop run according to the patern structure:-
		if our pattern increment then we use i++ and we set upper bound range
		if our pattern Column increase or Decrease then it means our range must be
		Dynamic and our range increase or decrease over the period

3. What do we Need to print ?

```java
import java.util.*;
class Main {
    public static void main(String[] args) {
        for(int i=0;i<5;i++){  // outer loop 0 to 4 : 4 Lines
           
            for(int j=0;j<i;j++){ // j<i For Dynamic bound ,i++ bcz pattern inc+1
                  System.out.print("*"); // print in a single line
            }
            System.out.println(); // provite pattern to next line
        }
    }
}
```



### Some Patterns
>1) pattern

```
****
****
****
****
```

```java
import java.util.*;
class Main {
    public static void main(String[] args) {
        for(int i=0;i<4;i++){ // number of line is 4
           
            for(int j=0;j<4;j++){ // j<4 no dynamic range bcz we want 0-4 in all
                  System.out.print("*");
            }
            System.out.println();
        }
    }
}
```

---

>2)pattern

```
*
**
***
****
```

```java
import java.util.*;
class Main {
    public static void main(String[] args) {
        for(int i=0;i<5;i++){  // outer loop 0 to 4 : 4 Lines
           
            for(int j=0;j<i;j++){ // j<i For Dynamic bound ,i++ bcz pattern inc+1
                  System.out.print("*"); // print in a single line
            }
            System.out.println(); // provite pattern to next line
        }
    }
}
```

>3)pattern

```
****
***
**
*
```

```java
import java.util.*;
class Main {
    public static void main(String[] args) {
        for(int i=0;i<5;i++){
           
            for(int j=4;j>i;j--){
                  System.out.print("*");
            }
            System.out.println();
        }
    }
}
```

```java
import java.util.*;
class Main {
    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        int n = in.nextInt();
        for(int i=0;i<n;i++){
           
            for(int j=0;j<n-i;j++){
                  System.out.print("*");
            }
            System.out.println();
        }
    }
}
```


>4)

```
*
**
***
**
**
```


![[pattern.excelidraw|700]]

```java

import java.util.*;
class Main {
    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        int n = in.nextInt();
        for(int i=1;i<2*n;i++){
           int range = i>n? 2*n-i:i;
            for(int j=0;j<range;j++){
                  System.out.print("*");
            }
            System.out.println();
           
        }
    }
}
```

>5)

```
  *
 **
***
 **
  *
```

```java
import java.util.*;
class Main {
    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        int n = in.nextInt();
        for(int i=1;i<2*n;i++){
             int range = i>n? 2*n-i:i;
             for(int space =0;space<n-range;space++){
                 System.out.print(" ");
             }
            for(int j=0;j<range;j++){
                  System.out.print("*");
            }
            System.out.println();
           
        }
    }
}
```


>6)

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

```java
import java.util.*;

class Main {
    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        int n = in.nextInt();

        for (int i = 1; i < 2 * n; i++) {

            int range = (i > n) ? 2 * n - i : i;

            // Left spaces
            for (int space = 0; space < n - range; space++) {
                System.out.print(" ");
            }

            // Stars (odd count)
            for (int j = 0; j < 2 * range - 1; j++) {
                System.out.print("*");
            }

            System.out.println();
        }
    }
}
```

```java
import java.util.*;
class Main {
    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        int n = in.nextInt();
        for(int i=1;i<2*n;i++){
            int range = i>n?2*n-i:i;
            
            for(int space = 0;space<n-range;space++){
                System.out.print(" ");
            }
            for(int j=0;j<range;j++){
                System.out.print("* ");
            }
            System.out.println();
        }
    }
}
```

>7)

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

```java
import java.util.*;
class Main {
    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        int n = in.nextInt();
        for(int i=1;i<2*n;i++){
            int range = i>n?2*n-i:i;
            
            for(int space = 0;space<n-range;space++){
                System.out.print(" ");
            }
            for(int j=0;j<range;j++){
                if(j==0 || j==range-1 ){
                System.out.print("* ");
                }else{
                    System.out.print(" ");
                }
            }
            System.out.println();
        }
    }
}
```

>8)


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





```java
import java.util.*;

class Main {
    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        int n = in.nextInt();

        for (int i = 1; i <= 2 * n; i++) {

            int stars = (i <= n) ? (n - i + 1) : (i - n);
            int spaces = 2 * (n - stars);

            // Left stars
            for (int j = 0; j < stars; j++) {
                System.out.print("*");
            }

            // Middle spaces
            for (int j = 0; j < spaces; j++) {
                System.out.print(" ");
            }

            // Right stars
            for (int j = 0; j < stars; j++) {
                System.out.print("*");
            }

            System.out.println();
        }
    }
}
```