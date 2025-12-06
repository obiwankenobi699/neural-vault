---
title: 02_Entropy in ML
tags:
  - ML
  - Applied
created: 2025-11-15
updated:
  "{ date }":
---

---


**Information Theory** is a branch of applied mathematics and computer science that deals with **quantifying information** — essentially measuring how much “uncertainty” is removed when we gain new data.

In Machine Learning, this theory helps us **understand how well a feature (or attribute)** can **reduce uncertainty** in predicting a target variable.
When building a **Decision Tree**, we use information theory to **decide which attribute to split on** at each step. The goal is to **maximize information gain** — i.e., to choose the feature that gives us the most useful information about the output class.

In simpler terms:

> Information theory helps decision trees make decisions by choosing the attribute that gives the most “clarity” (reduces the most confusion or randomness) about the target class.

---

## ⚖️ **Entropy**

**Entropy** is a key concept in information theory. It measures the **amount of uncertainty or impurity** in a dataset.

If a dataset has **pure classes** (all examples belong to one category), its entropy is **zero** — meaning there’s **no uncertainty**.
If the dataset is **mixed equally** (half one class, half another), entropy is **maximum**, meaning **high uncertainty**.
The mathematical formula for entropy is:
$$

H(S)=−
i=1
C
∑

	​

p
i
	​

log
2
	​

(p
i
	​

)
$$


Where:

- S → Entropy of dataset
- C -> No of Class 
- pi → Probability of class 
- log2​(pi​) → Logarithm base 2 (because information is measured in bits)

**Example:**  
If a dataset has 10 samples — 6 positive and 4 negative:

$$
H(S)=−[0.6log2​(0.6)+0.4log2​(0.4)]=0.971
$$


So, the entropy is 0.971 bits, indicating moderate uncertainty.



---
## 📉 **Information Gain (IG)**

^e1aa4e

**Information Gain** measures the **reduction in entropy** achieved when splitting a dataset based on a particular attribute.
It tells us **how much information** a feature gives about the target variable.
The feature with the **highest Information Gain** is chosen as the **root or internal node** in a Decision Tree.

The formula for Information Gain is:

$$
IG(S,A)=H(S)−v∈Values(A)∑​∣S∣∣Sv​∣​H(Sv​)
$$

Where:

* IG(S, A) → Information Gain for attribute (A)
* H(S) → Entropy of the parent dataset before split
* H(S_v) → Entropy of subset (S_v) after splitting on value (v)
* (\frac{|S_v|}{|S|}) → Weighted proportion of subset or no of value / total value

**Interpretation:**

* High Information Gain → Attribute gives **clear separation** of classes.
* Low Information Gain → Attribute adds **little to no clarity**.

**Example:**
If entropy before split (H(S) = 0.971), and weighted average entropy after splitting (H(S, A) = 0.5),
then
$$
IG(S,A)=0.971−0.5=0.471
$$
So, the attribute **A** gives **0.471 bits** of useful information.

---

## 🌳 **Relation Between All Concepts**

| Concept                | Meaning                                             | Formula                        | Used In                         |    |   |           |                                 |
| ---------------------- | --------------------------------------------------- | ------------------------------ | ------------------------------- | -- | - | --------- | ------------------------------- |
| **Information Theory** | Framework for measuring uncertainty and information | —                              | Basis for ML splitting criteria |    |   |           |                                 |
| **Entropy**            | Measures impurity or uncertainty in dataset         | (H(S) = -\sum p_i \log_2(p_i)) | Decision Tree nodes             |    |   |           |                                 |
| **Information Gain**   | Reduction in entropy after splitting                | (IG(S,A) = H(S) - \sum \frac{  | S_v                             | }{ | S | } H(S_v)) | Feature selection for splitting |

---
![[Solution.png]]

![[Question.png]]