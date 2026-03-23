# Regular Expression Reference

## Basic Grep Commands

**Exact Match**

```bash
grep -w "Pattern" file.name
```

**Find Files Containing Pattern**

```bash
grep -l "Pattern" .
```

**Recursive Search in Directory**

```bash
grep -lr "Pattern" .
```

The -r flag performs recursive search in current directory and subdirectories.

**Extended Regex with Character Classes**

```bash
grep -E "[a-z]" file.name
```

The -E flag enables extended regex syntax.

**Word Boundary Matching**

```bash
grep -oE '\b[a-z]{2}ve\b' file.name
```

The -o flag returns only the matched portion. Word boundaries ensure precise matching without exceeding specified limits.

## Core Regex Symbols

**Positional Anchors**

Start of line: `^` matches the beginning of a line. Example `^abc` matches "abc123" and "abc" but not "xabc".

End of line: `$` matches the end of a line. Example `abc$` matches "123abc" and "abc" but not "abcx".

**Quantifiers**

Plus: `+` matches one or more occurrences. Example `a+` matches "a", "aa", "aaa" but not empty string.

Asterisk: `*` matches zero or more occurrences. Example `a*` matches empty string, "a", "aa".

**Escape Character**

Backslash: `\` treats special characters as literals. Example `\.` matches "file.txt" (literal dot) but not "filext".

## Context-Dependent Caret Behavior

The caret symbol `^` has different meanings based on position.

Outside brackets: Start of line anchor. Example `^abc` matches lines beginning with "abc".

Inside brackets: Negation operator. Example `[^abc]` matches any character that is NOT a, b, or c (such as d, e, f).

## Practical Examples

**Line Position Matching**

```bash
grep -E "^Mukul" file.txt          # Lines starting with "Mukul"
grep -E "gmail\.com$" file.txt     # Lines ending with "gmail.com"
```

**Quantifier Usage**

```bash
grep -E "a+b+" file.txt            # One or more 'a' followed by one or more 'b'
```

**Special Character Escaping**

```bash
grep -E "email\?" file.txt         # Literal question mark in "email?"
```

## Character Classes

Square brackets define character sets. `[a-z]` matches any lowercase letter. `[0-9]` matches any digit. `[^0-9]` matches any non-digit character.

## Common Patterns

Email validation: `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`

This pattern matches standard email format with alphanumeric characters, dots, underscores in local part, followed by @ symbol, domain name, and top-level domain of at least two characters.

IP address: `^([0-9]{1,3}\.){3}[0-9]{1,3}$`

URL path: `^/[a-zA-Z0-9/_-]+$`

## Performance Considerations

Anchored patterns (using ^ and $) execute faster than unanchored patterns because the regex engine knows exactly where to start and stop matching. Word boundaries improve precision and reduce false positives in search results.

---

## Regex Beyond Terminal: Compilers and Data Science

Terminal grep commands require typing grep repeatedly for different patterns. Regex compilers and programming language integrations provide efficient pattern matching without repetitive commands. This proves essential for data science workflows where feature engineering requires extracting structured information from unstructured text.

## Special Character Classes

**Digit Matching**

`\d` matches any digit (0-9). Equivalent to `[0-9]`.

`\D` matches any non-digit character. Equivalent to `[^0-9]`.

**Whitespace Matching**

`\s` matches any whitespace (space, tab, newline). Equivalent to `[ \t\n\r\f\v]`.

`\S` matches any non-whitespace character. Equivalent to `[^ \t\n\r\f\v]`.

**Word Boundaries**

`\b` matches position between word and non-word character. Does not consume characters.

`\B` matches position NOT at word boundary.

**Word Characters**

`\w` matches word characters (letters, digits, underscore). Equivalent to `[a-zA-Z0-9_]`.

`\W` matches non-word characters. Equivalent to `[^a-zA-Z0-9_]`.

## Forward Slash vs Backslash Usage

**Backslash `\`:** Escape character in regex patterns. Used before special characters to treat them literally or to create special sequences like `\d`, `\s`, `\w`. Example: `\.` matches literal period, `\d` matches digit.

**Forward Slash `/`:** Delimiter in some programming languages (JavaScript, Perl) to denote regex pattern boundaries. Example: `/pattern/flags`. Not part of the pattern itself but syntax for defining regex in code.

In grep and most contexts, backslash is the escape character. Forward slash typically appears in programming language regex syntax: `let pattern = /\d+/g;`

## Character Class Negation

Square brackets with caret create negated character classes matching any character NOT in the set.

`[^,.]` matches any character except comma or period. This pattern reads "match one character that is neither comma nor period."

Practical application: `^[^,.]+` extracts text until first comma or period. In CSV parsing, this extracts the name field before the comma delimiter.

```bash
# Extract names from CSV (everything before first comma)
grep -o '^[^,.]\+' data.csv
```

## Data Science Regex Patterns

Consider this sample CSV dataset:

```
name,order_date,amount,status
Mukul,2026-03-01,150.50,shipped
Priya,2026-03-15,89.99,pending
Rahul,2026-03-22,299.00,delivered
Anita,2026-03-10,45.25,cancelled
VikraM,2026-03-18,178.75,shipped
```

**Common Extraction Patterns**

Lines starting with uppercase letter: `^[A-Z]` matches "Mukul", "Priya", "Rahul".

Lines ending with period: `\.$` matches sentences ending with punctuation.

Perfect sentences: `^[A-Z].*\.$` matches complete sentences starting uppercase and ending with period.

Whole words: `\bword\b` or use `-w` flag. Matches "will" but not "swill".

CSV name extraction: `^[^,.]+` captures everything before first comma or period.

Date extraction: `\d{4}-\d{2}-\d{2}` matches ISO format dates like "2026-03-01".

Currency amounts: `[0-9]+(\.[0-9]{2})?` matches "150.50", "89.99", or "299" (optional decimal).

Digit with optional separator: `\d[\-,.]?` matches "1-", "1,", "1.", or standalone digit.

## Grouping and Backreferences

Parentheses create capture groups that can be referenced later using backreferences.

**Finding Repeated Characters**

Pattern: `(\d)\1+` matches digit followed by itself one or more times.

- Matches: "999", "000", "88", "11" in "999000999" and "8712388411235"
- Group `(\d)` captures one digit
- Backreference `\1` requires same digit to repeat
- Quantifier `+` requires at least one repetition

Pattern: `(\d)\1{2,}` matches digit repeated at least three times total (original plus two more).

- Matches: "999", "000" in "999000999"
- Requires minimum three consecutive identical digits

**String Repetition**

Pattern: `(\w)\1+` finds repeated letters in words.

- "mississippi": matches "ss", "ss", "pp", "ii"
- "bookkeeping": matches "oo", "kk", "ee"
- "aggressive": matches "gg", "ss"

**Grouping Syntax**

Capturing group: `(pattern)` captures matched text for later use.

Non-capturing group: `(?:pattern)` groups without capturing (better performance when backreference not needed).

Named group: `(?P<name>pattern)` assigns name to captured group (Python syntax).

## Regex in Pandas for Data Science

Pandas provides powerful regex integration through string methods enabling feature engineering on DataFrame columns.

**Basic String Extraction**

```python
import pandas as pd

df = pd.DataFrame({
    'name': ['Mukul', 'Priya', 'Rahul', 'Anita', 'VikraM'],
    'order_date': ['2026-03-01', '2026-03-15', '2026-03-22', '2026-03-10', '2026-03-18'],
    'amount': ['150.50', '89.99', '299.00', '45.25', '178.75'],
    'status': ['shipped', 'pending', 'delivered', 'cancelled', 'shipped']
})

# Extract year from date
df['year'] = df['order_date'].str.extract(r'(\d{4})')

# Extract month from date
df['month'] = df['order_date'].str.extract(r'\d{4}-(\d{2})')

# Extract day from date
df['day'] = df['order_date'].str.extract(r'\d{4}-\d{2}-(\d{2})')
```

**Email Extraction and Validation**

```python
# Sample data with emails
emails_df = pd.DataFrame({
    'text': [
        'Contact: mukul.m.mishra@ieee.org',
        'Email me at yashbahuguna918@gmail.com',
        'Invalid email: user@domain',
        'Reach out: 266cse2324@rkgit.edu.in'
    ]
})

# Extract email addresses
email_pattern = r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'
emails_df['email'] = emails_df['text'].str.extract(f'({email_pattern})')

# Validate email format (returns True/False)
emails_df['has_valid_email'] = emails_df['text'].str.contains(email_pattern, regex=True)

# Extract domain from email
emails_df['domain'] = emails_df['email'].str.extract(r'@([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})')
```

**Phone Number Extraction**

```python
phone_df = pd.DataFrame({
    'contact': [
        'Call: +91-9876543210',
        'Mobile: 8123456789',
        'Phone: (011) 2345-6789',
        'Text: 555.123.4567'
    ]
})

# Extract 10-digit phone numbers
phone_df['phone'] = phone_df['contact'].str.extract(r'(\d{10})')

# Extract with country code
phone_df['full_phone'] = phone_df['contact'].str.extract(r'(\+?\d{1,3}[-.\s]?\d{10})')
```

**Date and Time Extraction**

```python
datetime_df = pd.DataFrame({
    'log': [
        'Error at 2026-03-23 14:30:45',
        'Warning on 2026-03-22 09:15:00',
        'Info: 2026-03-21 23:59:59',
        'Debug 2026-03-20 00:00:01'
    ]
})

# Extract full datetime
datetime_pattern = r'(\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2})'
datetime_df['timestamp'] = datetime_df['log'].str.extract(datetime_pattern)

# Extract only date
datetime_df['date'] = datetime_df['log'].str.extract(r'(\d{4}-\d{2}-\d{2})')

# Extract only time
datetime_df['time'] = datetime_df['log'].str.extract(r'(\d{2}:\d{2}:\d{2})')

# Convert to datetime object
datetime_df['timestamp'] = pd.to_datetime(datetime_df['timestamp'])
```

**URL and Domain Extraction**

```python
url_df = pd.DataFrame({
    'text': [
        'Visit https://www.example.com/page',
        'Check http://subdomain.site.org',
        'Link: https://api.service.io/v1/endpoint',
        'Go to www.simple.com'
    ]
})

# Extract full URL
url_pattern = r'https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}[^\s]*'
url_df['url'] = url_df['text'].str.extract(f'({url_pattern})')

# Extract domain only
url_df['domain'] = url_df['url'].str.extract(r'https?://([a-zA-Z0-9.-]+)')

# Extract protocol
url_df['protocol'] = url_df['url'].str.extract(r'(https?)')
```

**Currency and Numeric Extraction**

```python
# Using original CSV data
df['amount_numeric'] = df['amount'].str.extract(r'([0-9]+\.[0-9]{2})')
df['amount_numeric'] = df['amount_numeric'].astype(float)

# Extract integers only
df['whole_dollars'] = df['amount'].str.extract(r'([0-9]+)\.')

# Extract cents only
df['cents'] = df['amount'].str.extract(r'\.([0-9]{2})')
```

**Text Cleaning with Regex**

```python
messy_df = pd.DataFrame({
    'product': [
        'Widget-123 (blue)',
        'Gadget_456 [red]',
        'Tool@789 {green}',
        'Item#999 <yellow>'
    ]
})

# Remove all special characters except hyphen
messy_df['clean_product'] = messy_df['product'].str.replace(r'[^a-zA-Z0-9\s-]', '', regex=True)

# Extract product ID (numbers)
messy_df['product_id'] = messy_df['product'].str.extract(r'(\d+)')

# Extract color (text in parentheses/brackets)
messy_df['color'] = messy_df['product'].str.extract(r'[\(\[\{<]([a-z]+)[\)\]\}>]')
```

**Finding Duplicates with Grouping**

```python
duplicate_df = pd.DataFrame({
    'numbers': ['123456789', '999000999', '8712388411235'],
    'words': ['mississippi', 'bookkeeping', 'aggressive']
})

# Find repeated digits (3+ consecutive)
duplicate_df['repeated_digits'] = duplicate_df['numbers'].str.findall(r'(\d)\1{2,}')

# Find repeated letters
duplicate_df['repeated_letters'] = duplicate_df['words'].str.findall(r'(\w)\1+')

# Count number of repetitions
duplicate_df['repetition_count'] = duplicate_df['repeated_letters'].apply(len)
```

**Advanced: Multiple Capture Groups**

```python
# Complex log parsing
log_df = pd.DataFrame({
    'log_entry': [
        '[2026-03-23 14:30:45] ERROR: Database connection failed',
        '[2026-03-23 14:31:00] WARNING: High memory usage',
        '[2026-03-23 14:31:15] INFO: Task completed successfully'
    ]
})

# Extract multiple fields simultaneously
pattern = r'\[(\d{4}-\d{2}-\d{2})\s(\d{2}:\d{2}:\d{2})\]\s(\w+):\s(.+)'
extracted = log_df['log_entry'].str.extract(pattern)
extracted.columns = ['date', 'time', 'level', 'message']

# Combine with original dataframe
result = pd.concat([log_df, extracted], axis=1)
```

## Common Data Science Regex Patterns

**Email validation:** `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`

**Phone (US):** `\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}`

**Phone (India):** `(\+91[-\s]?)?\d{10}`

**Date (ISO):** `\d{4}-\d{2}-\d{2}`

**Date (US):** `\d{1,2}/\d{1,2}/\d{4}`

**Time (24hr):** `\d{2}:\d{2}(:\d{2})?`

**IP Address:** `\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}`

**URL:** `https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}[^\s]*`

**Credit Card:** `\d{4}[\s-]?\d{4}[\s-]?\d{4}[\s-]?\d{4}`

**Postal Code (US):** `\d{5}(-\d{4})?`

**Currency:** `\$?\s?\d+(\.\d{2})?`

## Regex Flags in Pandas

Pandas str methods support regex flags for case-insensitive matching and other behaviors.

```python
# Case-insensitive search
df['text'].str.contains('pattern', case=False, regex=True)

# Multiple line mode (^ and $ match line boundaries)
df['text'].str.replace(r'^start', 'new', regex=True)

# Find all occurrences (not just first)
df['text'].str.findall(r'pattern')
```

## Performance Tips for Data Science

Use compiled regex patterns for repeated operations to improve performance.

```python
import re

# Compile pattern once
email_pattern = re.compile(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}')

# Use compiled pattern
df['email'] = df['text'].str.extract(email_pattern.pattern)
```

For very large datasets, consider vectorized string operations over row-by-row regex application. Pandas string methods are optimized for vectorized operations and significantly outperform Python loops with regex.