# Java Bean Class

A Java Bean is a reusable software component written in Java that follows specific conventions. It's a simple Java class that encapsulates multiple properties into a single object, making it easy to manipulate and transfer data between different parts of an application.

## Java Bean Conventions

```
┌─────────────────────────────────────────────────────────┐
│              JAVA BEAN REQUIREMENTS                     │
│                                                         │
│  1. ✓ Must have a no-argument constructor              │
│  2. ✓ Properties must be private                       │
│  3. ✓ Must have public getter/setter methods           │
│  4. ✓ Should implement Serializable (recommended)      │
│                                                         │
└─────────────────────────────────────────────────────────┘

        Example Structure:

    ┌──────────────────────────────────┐
    │      JavaBean Class              │
    ├──────────────────────────────────┤
    │  - private String property1      │
    │  - private int property2         │
    │  - private boolean property3     │
    ├──────────────────────────────────┤
    │  + public JavaBean()             │  ← No-arg constructor
    │  + public String getProperty1()  │  ← Getter methods
    │  + public void setProperty1()    │  ← Setter methods
    │  + public int getProperty2()     │
    │  + public void setProperty2()    │
    │  + public boolean isProperty3()  │  ← Boolean getter
    │  + public void setProperty3()    │
    └──────────────────────────────────┘
```

**Example Java Bean:**

```java
import java.io.Serializable;

public class Student implements Serializable {
    // Private properties
    private String name;
    private int age;
    private String email;
    
    // No-argument constructor
    public Student() {
    }
    
    // Getter and Setter methods
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public int getAge() {
        return age;
    }
    
    public void setAge(int age) {
        this.age = age;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
}
```

# Java.io.Serializable

Serializable is a marker interface in Java that enables an object to be converted into a byte stream for storage or transmission. When a class implements Serializable, its objects can be saved to files, sent over networks, or stored in databases.

## How Serialization Works

```
    SERIALIZATION PROCESS
    
    Java Object (in Memory)          Byte Stream (for storage/transfer)
    
    ┌──────────────────┐                ┌─────────────────────┐
    │  Student Object  │                │   Byte Stream       │
    │                  │                │                     │
    │  name = "John"   │  Serialize     │  01001010 01101111  │
    │  age = 25        │  ────────────> │  01101000 01101110  │
    │  email = "..."   │                │  00011001 ...       │
    └──────────────────┘                └─────────────────────┘
           │                                      │
           │                                      │
           │                                      ▼
           │                              ┌─────────────────┐
           │                              │   File          │
           │                              │   Network       │
           │                              │   Database      │
           │                              └─────────────────┘
           │                                      │
           │                                      │
           │                            Deserialize
           │                                      │
           │                                      ▼
    ┌──────────────────┐                ┌─────────────────────┐
    │  Student Object  │                │   Byte Stream       │
    │  (Reconstructed) │  <───────────  │   (Retrieved)       │
    │                  │  Deserialize   │                     │
    │  name = "John"   │                │  01001010 01101111  │
    │  age = 25        │                │  01101000 01101110  │
    │  email = "..."   │                │  00011001 ...       │
    └──────────────────┘                └─────────────────────┘
```

**Example with Serialization:**

```java
import java.io.*;

public class Student implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private String name;
    private int age;
    private transient String password; // Won't be serialized
    
    // Constructor, getters, setters...
}

// Serializing an object
public class SerializeDemo {
    public static void main(String[] args) {
        Student student = new Student();
        student.setName("John");
        student.setAge(25);
        
        // Serialize
        try (ObjectOutputStream out = new ObjectOutputStream(
                new FileOutputStream("student.ser"))) {
            out.writeObject(student);
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        // Deserialize
        try (ObjectInputStream in = new ObjectInputStream(
                new FileInputStream("student.ser"))) {
            Student s = (Student) in.readObject();
            System.out.println(s.getName()); // Output: John
        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}
```

## Key Points about Serializable

- **serialVersionUID**: A unique identifier for versioning serialized objects
- **transient keyword**: Prevents specific fields from being serialized
- **static fields**: Not serialized (they belong to the class, not instances)
- **Parent class**: If parent isn't Serializable, child class must handle parent's state

# Java Bean Properties

Java Bean properties are the attributes of a bean that can be accessed and modified through getter and setter methods. Properties follow specific naming conventions that allow tools and frameworks to automatically discover and manipulate them.

## Property Naming Conventions

```
┌───────────────────────────────────────────────────────────────┐
│              PROPERTY NAMING RULES                            │
├───────────────────────────────────────────────────────────────┤
│                                                               │
│  Property Type    │  Getter Method   │  Setter Method        │
│  ────────────────────────────────────────────────────────────│
│  String name      │  getName()       │  setName(String)      │
│  int age          │  getAge()        │  setAge(int)          │
│  boolean active   │  isActive()      │  setActive(boolean)   │
│  double salary    │  getSalary()     │  setSalary(double)    │
│                                                               │
└───────────────────────────────────────────────────────────────┘

Pattern:
    private Type propertyName;
           │         │
           │         └─> First letter lowercase
           │
           └─> Any valid Java type

    public Type getPropertyName() {     ← "get" + Capitalized property
        return propertyName;
    }
    
    public void setPropertyName(Type value) {  ← "set" + Capitalized property
        this.propertyName = value;
    }
    
    Special case for boolean:
    public boolean isPropertyName() {    ← "is" instead of "get"
        return propertyName;
    }
```

## Types of Properties

```
┌─────────────────────────────────────────────────────────────┐
│                   PROPERTY TYPES                            │
└─────────────────────────────────────────────────────────────┘

1. SIMPLE PROPERTY
   ┌──────────────────────────┐
   │ private String name;     │  ← Single value
   │ public String getName()  │
   │ public void setName()    │
   └──────────────────────────┘

2. INDEXED PROPERTY
   ┌────────────────────────────────────────┐
   │ private String[] courses;              │  ← Array/List
   │ public String[] getCourses()           │
   │ public void setCourses(String[])       │
   │ public String getCourses(int index)    │  ← Individual access
   │ public void setCourses(int, String)    │
   └────────────────────────────────────────┘

3. BOUND PROPERTY
   ┌────────────────────────────────────────┐
   │ Notifies listeners when changed        │
   │                                        │
   │ PropertyChangeSupport support;         │
   │ public void setName(String name) {     │
   │     String old = this.name;            │
   │     this.name = name;                  │
   │     support.firePropertyChange(        │
   │         "name", old, name);            │
   │ }                                      │
   └────────────────────────────────────────┘

4. CONSTRAINED PROPERTY
   ┌────────────────────────────────────────┐
   │ Listeners can veto changes             │
   │                                        │
   │ VetoableChangeSupport support;         │
   │ public void setAge(int age)            │
   │     throws PropertyVetoException {     │
   │     support.fireVetoableChange(        │
   │         "age", this.age, age);         │
   │     this.age = age;                    │
   │ }                                      │
   └────────────────────────────────────────┘
```

# Types of Java Beans

Java Beans can be categorized based on their usage and characteristics:

```
┌─────────────────────────────────────────────────────────────┐
│                  TYPES OF JAVA BEANS                        │
└─────────────────────────────────────────────────────────────┘

1. ENTITY BEANS (Data Beans)
   ┌────────────────────────────────────┐
   │  Purpose: Represent data/entities  │
   │                                    │
   │  ┌──────────────┐                  │
   │  │   Student    │                  │
   │  ├──────────────┤                  │
   │  │ - id         │ Corresponds to   │
   │  │ - name       │ database table   │
   │  │ - email      │ or data model    │
   │  └──────────────┘                  │
   │                                    │
   │  Used in: JPA, Hibernate, ORM     │
   └────────────────────────────────────┘

2. SESSION BEANS (Business Logic Beans)
   ┌────────────────────────────────────┐
   │  Purpose: Encapsulate business     │
   │           logic and operations     │
   │                                    │
   │  ┌──────────────────────┐          │
   │  │ AccountService       │          │
   │  ├──────────────────────┤          │
   │  │ + deposit()          │          │
   │  │ + withdraw()         │          │
   │  │ + getBalance()       │          │
   │  │ + transfer()         │          │
   │  └──────────────────────┘          │
   │                                    │
   │  Types: Stateful, Stateless,      │
   │         Singleton                  │
   └────────────────────────────────────┘

3. MESSAGE-DRIVEN BEANS (MDB)
   ┌────────────────────────────────────┐
   │  Purpose: Handle asynchronous      │
   │           messages                 │
   │                                    │
   │    ┌────────┐      ┌──────────┐   │
   │    │Message │ ───> │   MDB    │   │
   │    │ Queue  │      │ Process  │   │
   │    └────────┘      └──────────┘   │
   │                                    │
   │  Used in: JMS, message processing │
   └────────────────────────────────────┘
```

## Detailed Bean Type Examples

### 1. Entity Bean (Data Bean)

```java
import java.io.Serializable;

public class Employee implements Serializable {
    private int id;
    private String name;
    private String department;
    private double salary;
    
    public Employee() {} // Required no-arg constructor
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getDepartment() { return department; }
    public void setDepartment(String department) { 
        this.department = department; 
    }
    
    public double getSalary() { return salary; }
    public void setSalary(double salary) { this.salary = salary; }
}
```

### 2. Stateless Session Bean

```java
import javax.ejb.Stateless;

@Stateless
public class CalculatorBean implements Serializable {
    
    public int add(int a, int b) {
        return a + b;
    }
    
    public int subtract(int a, int b) {
        return a - b;
    }
    
    public int multiply(int a, int b) {
        return a * b;
    }
}
```

### 3. Stateful Session Bean

```java
import javax.ejb.Stateful;

@Stateful
public class ShoppingCartBean implements Serializable {
    private List<String> items = new ArrayList<>();
    
    public void addItem(String item) {
        items.add(item);
    }
    
    public void removeItem(String item) {
        items.remove(item);
    }
    
    public List<String> getItems() {
        return items;
    }
    
    public void checkout() {
        // Process checkout
        items.clear();
    }
}
```

## Bean Lifecycle Comparison

```
┌──────────────────────────────────────────────────────────────┐
│             BEAN LIFECYCLE COMPARISON                        │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  ENTITY BEAN              SESSION BEAN (Stateless)           │
│  ───────────              ─────────────────────              │
│                                                              │
│  Create ──┐               Create ──┐                         │
│           │                        │                         │
│           ▼                        ▼                         │
│  Persist in DB            Pool of instances                  │
│           │                        │                         │
│           │                        │                         │
│  ┌────────┴────────┐      ┌───────┴────────┐               │
│  │                 │      │                │                │
│  │   Read/Update   │      │  Method calls  │                │
│  │   from clients  │      │  (no state)    │                │
│  │                 │      │                │                │
│  └────────┬────────┘      └───────┬────────┘               │
│           │                        │                         │
│           ▼                        ▼                         │
│  Remove from DB           Return to pool                     │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

## When to Use Each Type

**Entity Beans**: Use when you need to represent data that maps to database tables, such as User, Product, Order, or any domain model object.

**Session Beans (Stateless)**: Use for operations that don't require maintaining state between method calls, such as calculations, validations, or stateless services.

**Session Beans (Stateful)**: Use when you need to maintain conversational state across multiple method calls, such as shopping carts, multi-step wizards, or user sessions.

**Message-Driven Beans**: Use for asynchronous processing, handling queued messages, or event-driven architectures.