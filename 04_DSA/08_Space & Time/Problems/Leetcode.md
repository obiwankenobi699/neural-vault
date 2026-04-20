Below is your list converted into **Obsidian-compatible markdown tables** (clean, structured, and ready to paste into your notes).

---

# 📘 Easy (20 Problems)

|#|Problem No.|Title|Bitwise Concept|
|---|---|---|---|
|1|136|Single Number|XOR all|
|2|268|Missing Number|XOR 0..n|
|3|191|Number of 1 Bits|n & (n-1)|
|4|231|Power of Two|n & (n-1) == 0|
|5|693|Alternating Bits|n ^ (n>>1)|
|6|217|Contains Duplicate|Bit counting|
|7|326|Power of Three|Bit check|
|8|342|Power of Four|(n & (n-1)) && n%3|
|9|476|Number Complement|~n & mask|
|10|503|Next Greater Element II|Bit rotation|
|11|676|Magic Dictionary|Bit trie sim|
|12|744|Smallest Letter Greater|Bit position|
|13|796|Rotate String|Bit shift sim|
|14|821|Shortest Distance|Bit flags|
|15|844|Backspace Compare|Bit stack|
|16|883|Projection Area|Bit count|
|17|942|DI String Match|Bit position|
|18|965|Univalued Tree|Bit equality|
|19|1029|Two City Scheduling|Bit cost|
|20|1290|Binary to Decimal|Bit convert|

---

# 📙 Medium (25 Problems)

|#|Problem No.|Title|Bitwise Concept|
|---|---|---|---|
|21|190|Reverse Bits|Bit reversal|
|22|201|Range Bitwise AND|n & (n-1)|
|23|260|Single Number III|Two XOR passes|
|24|338|Counting Bits|n & (n-1)|
|25|371|Sum of Two Integers|XOR + carry|
|26|389|Find the Difference|XOR chars|
|27|405|Number to Hex|Shift + mask|
|28|421|Maximum XOR|Bit greedy|
|29|477|Total Hamming Distance|XOR count|
|30|540|Single Element Sorted|XOR adjacent|
|31|645|Set Mismatch|XOR all|
|32|670|Maximum Swap|Bit swap|
|33|762|Prime Set Bits|Bit count|
|34|829|Sequential Digits|Bit build|
|35|868|Binary Gap|Count zeros|
|36|898|ORs of Subarrays|Prefix OR|
|37|1375|Bulb Switcher III|Bit range|
|38|1442|XOR Triplets|XOR prefix|
|39|1521|Peak Element II|Bit peak|
|40|1614|Max Nesting Depth|Bit flag|
|41|1668|Max Repeating Substring|Bit match|
|42|1720|Decode XORed Array|XOR reconstruct|
|43|1865|Finding Pairs Sum|Bit sum|
|44|2144|Min Cost Candies|Bit count|
|45|2217|Fixed Digit Palindrome|Bit mirror|

---

# 📕 Hard (5 Problems)

|#|Problem No.|Title|Bitwise Concept|
|---|---|---|---|
|46|29|Divide Two Integers|Bit shift division|
|47|137|Single Number II|Bit state machine|
|48|169|Majority Element II|Bit voting|
|49|222|Count Tree Nodes|Bit height|
|50|615|Avg Salary Excluding|Bit sort|

---

# 🚀 Must Solve (Core Bitwise Set)

|Priority|Problem No.|Title|Core Idea|
|---|---|---|---|
|⭐|136|Single Number|XOR cancels duplicates|
|⭐|191|Number of 1 Bits|n & (n-1)|
|⭐|231|Power of Two|Single set bit|
|⭐|190|Reverse Bits|Bit swap|
|⭐|201|Range AND|Remove LSB|

---

# ✅ Bitwise Rules (Checklist)

```markdown
- Use only: & | ^ ~ << >>
- Avoid: DP, Trie, heavy arrays
- Key tricks:
  - n & (n-1)
  - n ^ mask
  - left/right shifts
```
