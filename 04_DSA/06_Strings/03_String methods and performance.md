

```java
import java.util.*;
class Main {
    public static void main(String[] args) {
        for(int i=0;i<26;i++){
            System.out.println((char)('a'+i)+"");
        }
    }
}

performance of string adding and manipulation is very slow so java have a string builder also in this loop when a+b= ab is a new object , a+b+c=abc is a new obect so it making 27 new objects each concat is a new object 
```

```java
import java.util.*;
class Main {
    public static void main(String[] args) {
    StringBuilder builder = new StringBuilder();
        for(int i=0;i<26;i++){
            Char char = (char)('a'+i);
            builder.append(char);
        }
    }
}
```



System.out.printf();
%d → int         → 42
%f → float/double → 3.14
%s → String      → "hello"
%c → char        → 'A'
%b → boolean     → true/false
printf()

some basic sting method
uppercase lowercase
strip
charAt
indexof 
Arrays.toStrng and deepToString
