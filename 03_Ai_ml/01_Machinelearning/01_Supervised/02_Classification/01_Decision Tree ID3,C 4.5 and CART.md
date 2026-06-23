---
title: 01_Decision Tree
tags:
  - ML
  - Supervised_Classifcation
created: 2025-11-07
updated:
  "{ date }":
---
---

#  Decision Tree — Complete Concept Overview

## Introduction

A **Decision Tree** is one of the most fundamental and interpretable algorithms in machine learning. It works by recursively splitting the dataset into smaller subsets based on the values of input features, forming a tree-like structure. Each internal node in the tree represents a decision based on a feature, each branch represents the outcome of that decision, and each leaf node represents a final class label or predicted value. Decision Trees can be used for both **classification** and **regression** problems.

---

## Root Node, Branches, and Leaf Nodes

The **root node** is the topmost node in a decision tree and represents the entire dataset before any splitting occurs. It is the starting point of the decision-making process. From this root node, the algorithm identifies the best feature to split the data and creates **branches**. Each branch represents a possible outcome or decision based on a specific condition of a feature. The process continues until we reach a **leaf node**, which represents the final output or decision — such as a class label (“Spam” or “Not Spam”) or a numerical prediction. The path from the root to any leaf represents one complete decision rule in the model.

The Value Which  Is Having The Highest Gain Is Consider As rood node [[02_Information Theory#^e1aa4e]]

---

## Process of Building a Decision Tree

The process of building a decision tree starts with the full dataset at the root node. The algorithm then selects the **best feature** to split the data based on certain criteria such as **Information Gain** or **Gini Index**. Once the feature is chosen, the data is divided into subsets according to its values — this is called **splitting the data**. For each subset, the same process is repeated recursively: choosing a feature, splitting the data, and forming nodes. Whenever a subset becomes “pure” (i.e., all samples belong to the same class), it becomes a **leaf node**. The process continues until either all data points are perfectly classified or a stopping criterion such as maximum tree depth or minimum number of samples per node is reached.

---

## ASCII Diagram of the Decision Tree Process

```
                         ┌──────────────────────────┐
                         │        Root Node         │
                         │  (Choose Best Feature)   │
                         └────────────┬─────────────┘
                                      │
              ┌───────────────────────┼────────────────────────┐
              │                                                │
     ┌────────▼────────┐                                ┌──────▼──────┐
     │   Split 1       │                                │   Split 2   │
     │  (Feature A=0)  │                                │ (Feature A=1)│
     └──────┬──────────┘                                └──────┬───────┘
            │                                                       │
     ┌──────▼───────┐                                         ┌──────▼───────┐
     │ Decision Node│                                         │Decision Node │
     │ (Feature B)  │                                         │(Feature C)   │
     └──────┬────────┘                                         └──────┬──────┘
            │                                                       │
     ┌──────▼──────┐                                         ┌──────▼──────┐
     │ Leaf Node   │                                         │ Leaf Node   │
     │  (Class=Yes)│                                         │ (Class=No)  │
     └──────────────┘                                         └─────────────┘
```

This diagram represents how the dataset is split recursively, forming branches and nodes, until final outcomes are achieved at the leaves.

---



