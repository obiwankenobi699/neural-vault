

1) Find the maximum number out of 3 number 

	```java
	import java.util.*;
class Main {
    public static void main(String[] args) {
     int a = 30;
     int b = 20;
     int c = 15;
     int max = a;
    if(b>max){
        max = b;
    }if(c>b){
        max = c;
    }
     
     System.out.print(max);
    }
}
	```

2)fabonacci series without recurssion

```java
import java.util.*;
class Main {
    public static void main(String[] args) {
  int a = 0;
  int b = 1;
  int c = 0;
 
    while(c<13){
        c = a+b;
        a = b;
        b = c;
        System.out.println(c);
    }
    System.out.println(c);
    }
}
```

3) Number with even number+ reverse  leetcode 1295

```java

import java.util.*;
class Main {
    public static void main(String[] args) {
        // int [] arr = {12,345,2,6,7896};
        // System.out.println(arr);
        
        int a = 123;
        int count = 0;
        int reverse = 0;
        while(a>0){
            int remove = a%10;
            a = a/10;
            count++;
            reverse = reverse*10+remove;
        }
          System.out.println(count);
        System.out.println(reverse);
    }
    
    
}
```


4) even digit in an array

```java
import java.util.*;
class Main {
    public static void main(String[] args) {
        int [] arr = {12,345,2,6,7896,123445,12345678};
        System.out.println(even(arr));
        
    }
    
    public static int even(int[]arr){
        int count = 0;
         for(int i=0;i<arr.length;i++){
            int number = arr[i];
            int ans = count(arr,number);
            
            if(ans%2==0){
                count++;
            }
         }
         return count;
    }
    
    public static int count(int[] arr,int number){
            int count=0;
            while(number>0){
                number = number/10;
                count++;
            }
        
        
        return count;
    }
    
}
```

5) armstrong number

```java
	// Online Java Compiler
// Use this editor to write, compile and run your Java code online
import java.util.*;
class Main {
    public static void main(String[] args) {
        int num = 153;
        int ans = 0;
        while(num>0){
            int digit = num %10;
            int armstrong = digit*digit*digit;
             ans = ans+armstrong;
              num = num/10;
        }
        System.out.print(ans);
        
    }
}
```

7) max wealth 

	```java
	// Online Java Compiler
// Use this editor to write, compile and run your Java code online
import java.util.*;
class Main {
    public static void main(String[] args) {
       int [][] num = {{1,5},{7,3},{3,5}};
       System.out.println(Arrays.deepToString(num));
       int max=0;
        for(int[] row:num){
            int cal = 0;
            for(int col:row){
                    cal = cal+col;
            }
              
              if(max<cal){
            max = cal;
        }
        }
        System.out.println(max);
        
        
        
    }
    

    
}
	```


