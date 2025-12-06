---
title: 01_Market Based Modelling
tags:
  - ML
  - DA
created: 2025-11-11
updated:
  "{ date }":
---


> **Subject:** {{Subject}}  
> **Topic Type:** Concept / Process / Architecture / Example  
> **Related Topics:** 

---
## **1. Market-Based Modelling**

Market-Based Modelling, also known as Market Basket Analysis, is a data mining technique used to find relationships or associations between items purchased together. It analyzes transaction data to discover frequent itemsets and generates association rules such as “if a customer buys bread, they are likely to buy milk.” This model helps in cross-selling, product placement, recommendation systems, and marketing strategies. The analysis works on large datasets and identifies meaningful co-occurrences among items.

---

## **2. Support, Confidence, and Lift**

These are three important measures used in market-based modelling to evaluate association rules.  
**Support** indicates how frequently an item or itemset appears in the dataset. It helps in identifying popular combinations.  
**Confidence** shows the strength of an implication rule, representing how often items in Y appear in transactions that contain X (for rule X → Y). It measures the reliability of the inference made.  
**Lift** measures how much more likely Y is to be bought when X is bought compared to its normal purchase rate. A lift greater than 1 means a positive correlation between X and Y, while a lift equal to 1 means they are independent. These metrics help in filtering useful and strong rules.

---

## **3. Apriori Algorithm**

The Apriori algorithm is one of the most popular algorithms for association rule mining. It is based on the principle that “if an itemset is frequent, then all of its subsets must also be frequent.” The algorithm works in an iterative manner, increasing the size of the itemsets step by step. It first finds all frequent 1-itemsets, then uses them to generate 2-itemsets, and continues until no more frequent itemsets can be found. The algorithm scans the database multiple times and prunes unnecessary candidates using the **downward closure property**, making it efficient for large datasets.

---

## **4. Downward Closure Property**

The downward closure property, also called the anti-monotone property, states that if an itemset is infrequent, then all its supersets are also infrequent. Conversely, if an itemset is frequent, all its subsets are also frequent. This property allows the Apriori algorithm to prune the search space effectively. It helps avoid unnecessary computation by skipping candidate itemsets that cannot possibly be frequent, based on smaller infrequent subsets.

---

## **5. Apriori Algorithm Steps (Numerical Example)**

Consider a dataset of five transactions:  
T1 = {Bread, Milk}  
T2 = {Bread, Diaper, Beer, Eggs}  
T3 = {Milk, Diaper, Beer, Cola}  
T4 = {Bread, Milk, Diaper, Beer}  
T5 = {Bread, Milk, Diaper, Cola}  
Let the minimum support be 0.6.

**Step 1:** Find the frequency of each item (1-itemsets). Items with support ≥ 0.6 are Bread, Milk, Diaper, and Beer.  
**Step 2:** Generate 2-itemsets from frequent 1-itemsets and count their supports. Frequent pairs are {Bread, Milk}, {Bread, Diaper}, {Milk, Diaper}, and {Diaper, Beer}.  
**Step 3:** Form 3-itemsets such as {Bread, Milk, Diaper}, but it appears only twice (support 0.4), so it is not frequent.  
**Step 4:** Generate rules from frequent itemsets. For example, rule: _Diaper → Beer_

- Support = 3/5 = 0.6
    
- Confidence = 0.6 / 0.8 = 0.75
    
- Lift = 0.75 / 0.6 = 1.25 (positive association).  
    Thus, the Apriori algorithm identifies the strongest and most relevant association rules.
    

---

## **6. Flajolet–Martin Algorithm**

The Flajolet–Martin (FM) algorithm is a probabilistic algorithm used for estimating the number of distinct elements (cardinality) in a data stream. It is especially useful for large-scale, continuous data where counting distinct items directly is impossible due to memory constraints. The main idea is to hash each incoming element to a bitstring and record the position of the first ‘1’ bit (trailing zeros count). The maximum number of trailing zeros observed gives an estimate of the number of distinct elements because the probability of seeing k trailing zeros is 1/2^(k+1).

---

## **7. Steps of Flajolet–Martin Algorithm**

1. Each incoming element in the stream is hashed using a hash function.
    
2. The algorithm counts the number of trailing zeros in the binary representation of the hash value.
    
3. It maintains the **maximum number of trailing zeros (R)** seen so far.
    
4. The estimated number of distinct elements (n̂) is calculated as:  
    **n̂ = 2^R / φ**, where φ ≈ 0.77351 is a correction constant.  
    To reduce the error, multiple hash functions are used, and the **average or median** of all estimates is taken. This averaging improves the accuracy and reduces variance.
    

---

## **8. Example of Flajolet–Martin Algorithm**

Suppose three hash functions produce hash values with trailing zeros counts as 3, 4, and 2 for different subsets of data.  
Then, individual estimates are 2³ = 8, 2⁴ = 16, and 2² = 4.  
The average estimate = (8 + 16 + 4) / 3 = 9.33.  
The corrected estimate is n̂ = 9.33 / 0.77351 ≈ 12.06.  
Hence, approximately 12 distinct elements exist in the stream. This method efficiently approximates large-scale distinct counts in real time using minimal memory.

---

