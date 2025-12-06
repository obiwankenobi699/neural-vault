---
title:
  "{ Title }":
tags:
created:
  "{ date }":
updated:
  "{ date }":
---

# **Data Serialization and Deserialization**

## **1. What is Serialization?**

**Serialization** is the process of converting an in-memory data structure into a format that can be:

- stored (file, database)
    
- transmitted (network request)
    
- cached
    
- logged
    
- queued
    

### Common serialization formats:

- **JSON**
    
- **YAML**
    
- **XML**
    
- **Protocol Buffers**
    
- **MessagePack**
    
- **Avro**
    

### Example (JavaScript → JSON)

```js
const user = { name: "Mukul", age: 22 };
const json = JSON.stringify(user);
```

Result (serialized):

```json
{"name":"Mukul","age":22}
```

---

## **2. What is Deserialization?**

**Deserialization** is the reverse process — converting the serialized format back into an in-memory object.

### Example (JSON → JavaScript object)

```js
const json = '{"name":"Mukul","age":22}';
const user = JSON.parse(json);
```

Now `user` is a normal JS object again.

---

# **3. Why Do We Use Serialization?**

### Data transfer

APIs send/receive data in JSON because it is lightweight and universal.

### Persistent storage

Saving app config or user data into files:

- `.json`
    
- `.yaml`
    
- `.toml`
    

### Microservices

Services serialize data to send through:

- HTTP
    
- gRPC (proto)
    
- Message queues (Kafka/RabbitMQ)
    

### Caching

Tools like Redis store serialized data.

### Containers / Workflows

YAML is used for:

- Docker Compose
    
- Kubernetes
    
- GitHub Actions
    

---

# **4. Example: YAML Serialization**

Human-readable serialization format.

```yaml
user:
  name: Mukul
  age: 22
```

Deserialization (example Python):

```python
import yaml

data = yaml.safe_load("""
user:
  name: Mukul
  age: 22
""")
```

---

# **5. Serialization vs. Encoding**

**Encoding** = converting text between formats (UTF-8, Base64).  
**Serialization** = converting objects into storable formats.

Example:  
Base64 is NOT serialization, it is encoding.

---

# **6. Real World Example (GitHub Actions)**

GitHub sends workflow context as **JSON serialization**:

```yaml
steps:
  - name: Print event
    run: echo "${{ toJson(github.event) }}"
```

The workflow engine deserializes it so you can access:

```yaml
github.event.pull_request.title
```

---

# **7. Summary**

|Concept|Meaning|
|---|---|
|Serialization|Object → string/file/transmittable format|
|Deserialization|String/file → object|
|Formats|JSON, YAML, XML, ProtoBuf, Avro|
|Used in|APIs, storage, microservices, CI/CD, caching|

---

If you want, I can give you:

- **Serialization vs Object Mapping (ORM)**
    
- **Binary vs Text serialization**
    
- **Serialization security risks**
    
- **Serialization examples in Python, JS, Go, Rust**
    

Just tell me!
# **YAML Notes Based on Example**

## **1. Key–Value Pairs**

YAML stores data as simple `key: value` pairs.

Example from your file:

```yaml
chai_type: masala chai
temperature: hot
brewing_time: 5
```

Keys are strings. Values may be:

- strings
    
- numbers
    
- booleans
    
- sequences
    
- objects
    

---

## **2. Strings & Quoting**

YAML auto-detects strings, but when something looks like a number with letters (e.g. `3.4v`), you must quote it.

Example:

```yaml
version: "3.4v"
```

---

## **3. Nested Objects (Mappings)**

Objects are created by indenting with spaces.

Example:

```yaml
chai_recepy:
  base: black_tea
  milk: whole_milk
```

Indentation defines structure — **never use tabs**, only spaces.

---

## **4. Block Scalars (Multiline Strings)**

Using `|` allows multi-line values:

```yaml
chai_type_two: |
  black_tea
  whole_milk
  34
```

This keeps line breaks exactly as written.

---

## **5. Lists (Sequences)**

Lists use `-`:

```yaml
features:
  - good
  - healthy
  - tasty
```

---

## **6. Lists of Objects**

Each item can itself be an object (mapping):

Incorrect YAML tried to mix mapping + list. Correct form:

```yaml
variety_chai:
  - v: Traditional
    ingredients:
      - masala
      - ginger
      - cardimon
  
  - v: Modern
    ingredients:
      - chocolate
      - honey
      - green
```

Each list item here contains:

- a key `v`
    
- an object `ingredients` which itself contains a list
    

---

## **7. YAML Structure Summary**

Your YAML uses:

- **Scalars**: `"3.4v"`, `hot`, `5`
    
- **Mappings (Objects)**: `chai_recepy: {...}`
    
- **Sequences (Lists)**: `features: [...]`
    
- **Block Scalars**: `chai_type_two: | ...`
    
- **Nested Lists inside Objects**: `variety_chai: ...`
    

---

# **Final Clean YAML From Your Code**

```yaml
version: "3.4v"
chai_type: masala chai
temperature: hot
brewing_time: 5

chai_recepy:
  base: black_tea
  milk: whole_milk

chai_type_two: |
  black_tea
  whole_milk
  34

features:
  - good
  - healthy
  - tasty

variety_chai:
  - v: Traditional
    ingredients:
      - masala
      - ginger
      - cardimon
  
  - v: Modern
    ingredients:
      - chocolate
      - honey
      - green
```

---

YAML **does not have pointers** like C or references like JavaScript — **but it _does_ support anchors and aliases**, which behave almost like _pointers_.

These are the **closest thing to pointers in YAML**.

---

# ✔ YAML Pointers = **Anchors (&) and Aliases (*)**

### Example

```yaml
base_chai: &chai_base
  tea: black_tea
  milk: whole_milk
  sugar: medium

masala_chai:
  <<: *chai_base
  spice: masala

ginger_chai:
  <<: *chai_base
  spice: ginger
```

---

# ✔ What’s happening?

- **&chai_base** → anchor  
    Think of this as saving a block of data in memory.
    
- ***chai_base** → alias  
    Think of this as a pointer referencing the anchor.
    
- **<<:** → merge operator  
    It merges the referenced map into the current map.
    

---

# ✔ Visual Model (Pointer-like behavior)

```
&chai_base  ----------------------+
                                   |
                                   v
masala_chai receives the same structure
ginger_chai receives the same structure
```

Both `masala_chai` and `ginger_chai` now share the same base configuration.

---

# ✔ Why this is pointer-like?

- If your YAML parser supports merges, modifying the anchor affects all aliases.
    
- It prevents duplication.
    
- It keeps data DRY (Don’t Repeat Yourself).
    

---

# ✔ Another Simple Pointer Example

```yaml
defaults: &def
  port: 8080
  host: localhost

dev:
  settings: *def

prod:
  settings:
    <<: *def
    port: 80
```

---

# ✔ Pointer to a list

```yaml
tea_list: &tea_items
  - assam
  - darjeeling

morning_tea:
  items: *tea_items

evening_tea:
  items: *tea_items
```

---

If you want, I can also make:

- a complete **YAML cheatsheet** including pointers, lists, maps
    
- examples for Kubernetes, GitHub Actions, Ansible
    
- deeply nested structures with anchors
    

Just say the word!

YAML has **type tags**, written with **!!**, that explicitly tell the parser what data type something should be.

Here are the three you asked about: **!!str**, **!!int**, **!!set** — with examples and explanation.

---

# ✔ **1. !!str** — Force value to be a string

Even if the value _looks like a number_, YAML will treat it as a **string**.

### Example

```yaml
age: !!str 25
hex: !!str 0xFF
number_like: !!str "12345"
```

### Why use it?

- Prevent YAML from auto-converting numbers, dates, timestamps.
    
- Protect values like ZIP codes, phone numbers, IDs.
    

---

# ✔ **2. !!int** — Force value to be an integer

Even if the value is quoted or looks like a string, it becomes an integer.

### Example

```yaml
age: !!int "25"
hex: !!int "0xFF"      # YAML can convert hex → int
binary: !!int "0b1010" # → 10
```

### Use when:

- You want strict typing.
    
- You want to ensure something stays numeric.
    

---

# ✔ **3. !!set** — A YAML Set (unique keys, no values)

Sets in YAML are **maps with null values**, but with a special tag.

### Example

```yaml
fruits: !!set
  apple: null
  mango: null
  banana: null
```

Equivalent meaning:

- apple ∈ fruits
    
- mango ∈ fruits
    
- banana ∈ fruits  
    (no duplicates allowed)
    

### Another way (JSON-like)

```yaml
numbers: !!set { 1, 2, 3, 4 }
```

---

# ✔ Combined Example (for your notes)

```yaml
config:
  port: !!int "8080"
  env: !!str production
  unique_items: !!set
    alpha: null
    beta: null
    gamma: null
```

---

# ✔ Summary Table

|Tag|Meaning|Example|
|---|---|---|
|**!!str**|Force string|`value: !!str 123`|
|**!!int**|Force integer|`count: !!int "10"`|
|**!!set**|Set type|`items: !!set { a, b, c }`|

---

If you want, I can give you:

- **YAML Cheatsheet**
    
- **All YAML data types** (float, bool, null, timestamp, map merge, anchors)
    
- **Kubernetes YAML examples**
    
- **GitHub Actions YAML examples**
    

Just tell me!