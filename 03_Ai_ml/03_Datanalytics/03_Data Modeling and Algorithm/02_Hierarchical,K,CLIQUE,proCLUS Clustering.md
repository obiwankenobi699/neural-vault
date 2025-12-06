---
title: 02_Hierarchical,K,CLIQUE,proCLUS Clustering
tags:
  - ML
  - DA
created: 2025-11-12
updated:
  "{ date }":
---


> **Subject:** {{Subject}}  
> **Topic Type:** Concept / Process / Architecture / Example  
> **Related Topics:** 
---

## **1. K-Means Clustering**

K-Means is one of the most widely used **partition-based clustering algorithms**. It divides a given dataset into _K distinct non-overlapping clusters_ based on the similarity of data points. The algorithm starts by randomly selecting K initial centroids. Each data point is then assigned to the nearest centroid based on distance, usually **Euclidean distance**. After assignment, the centroids are recalculated as the mean of all points in each cluster. These two steps — assignment and centroid update — are repeated until the centroids no longer change significantly or convergence is reached.

The objective of K-Means is to minimize the **Within-Cluster Sum of Squares (WCSS)**, also known as the **inertia**, which measures how tightly grouped the points in each cluster are. K-Means is efficient for large datasets but sensitive to the initial choice of centroids and outliers. It also assumes clusters are spherical and similar in size, which may not hold in all datasets.

---

## **2. Hierarchical Clustering**

Hierarchical Clustering is a method of grouping data into a hierarchy or tree of clusters. Unlike K-Means, it does not require the number of clusters to be specified in advance. It creates a **dendrogram**, which visually represents how clusters are formed or divided at each level. There are two main approaches:

1. **Agglomerative (Bottom-Up):** Each data point starts as its own cluster, and pairs of clusters are merged step-by-step based on their similarity until only one cluster remains.
    
2. **Divisive (Top-Down):** All data points start in one large cluster, and the algorithm recursively splits it into smaller clusters.
    

The similarity between clusters is determined using **linkage criteria** such as single linkage (minimum distance), complete linkage (maximum distance), average linkage, or Ward’s method (minimizing variance). Hierarchical clustering is more interpretable and produces a hierarchy of clusters, but it can be computationally expensive for very large datasets.

![[Pasted image 20251113174851.png]]

---

## **3. High-Dimensional Data Clustering**

In high-dimensional data, traditional clustering algorithms like K-Means or Hierarchical Clustering often fail due to the **curse of dimensionality**, where distance measures become less meaningful as the number of dimensions increases. High-dimensional data clustering aims to identify clusters that exist in subspaces (i.e., subsets of dimensions) rather than across the entire feature space. Two well-known algorithms for high-dimensional clustering are **CLIQUE** and **ProCLUS**.

These algorithms are designed to detect meaningful clusters hidden in subsets of dimensions, improving interpretability and accuracy in data such as text mining, genomics, and customer segmentation.

---

## **4. CLIQUE (Clustering in Quest)**

**CLIQUE (Clustering In QUEst)** is a **grid-based subspace clustering algorithm** that identifies dense regions in subspaces of high-dimensional data. It automatically determines both the number of clusters and the relevant dimensions.

The algorithm divides each dimension into equal-sized intervals, forming a grid of units. Each unit (cell) is labeled as **dense** if the number of data points in it exceeds a user-defined threshold. CLIQUE then identifies clusters as contiguous regions of dense units across dimensions. It works bottom-up, starting from 1D subspaces and progressively combining them to form higher-dimensional clusters.

CLIQUE is scalable, interpretable, and can handle noise, but its performance depends on grid size and density threshold. It is particularly useful when clusters exist in specific subspaces of a high-dimensional dataset.


![[Pasted image 20251113180000.png]]



---

## **5. ProCLUS (Projected Clustering)**

**ProCLUS (Projected Clustering)** is a **partitioning-based algorithm** designed for high-dimensional data. It combines the strengths of K-Means and subspace analysis by projecting clusters into subsets of relevant dimensions instead of the entire feature space.

The algorithm starts by randomly selecting a set of **medoids** (representative points). For each medoid, it determines a subset of dimensions where the cluster is most compact, effectively projecting the cluster into that subspace. Then, it assigns each data point to the nearest medoid based on the projected distance measure. The algorithm iteratively refines the medoids and subspaces to minimize intra-cluster distance and improve clustering accuracy.

ProCLUS handles high-dimensional data efficiently and produces well-separated clusters. It performs better than K-Means in high dimensions because it ignores irrelevant features, reducing noise. However, it requires careful selection of parameters like the number of clusters (k) and average subspace dimensionality (l).

---

## **6. Comparison Summary**

|**Algorithm**|**Type**|**Handles High Dimensions**|**Shape of Clusters**|**Main Idea**|
|---|---|---|---|---|
|**K-Means**|Partition-based|No|Spherical|Minimizes sum of squared distances to centroids|
|**Hierarchical**|Hierarchy-based|No|Arbitrary|Builds tree-like hierarchy using linkage criteria|
|**CLIQUE**|Grid-based Subspace|Yes|Arbitrary|Finds dense regions in subspaces using grid partitioning|
|**ProCLUS**|Partition-based Subspace|Yes|Arbitrary|Projects data into subspaces to find compact clusters|

---

## **1. Clustering in Non-Euclidean Space**

In traditional clustering algorithms like _K-Means_ or _Hierarchical Clustering_, data points are represented in **Euclidean space**, where distances are measured using the Euclidean distance formula. However, many real-world datasets do not follow Euclidean geometry — for example, **graph data, sequences, networks, or manifolds**. In such cases, **clustering in non-Euclidean space** is required.  
Non-Euclidean clustering methods use **alternative similarity or distance measures**, such as cosine similarity, Jaccard distance, or geodesic distance on manifolds. Algorithms like **Spectral Clustering**, **Density-Based Spatial Clustering (DBSCAN)**, and **Graph-based clustering** can work efficiently in these spaces. For instance, in **social network analysis**, the data is represented as a graph of nodes and edges, and clustering is performed based on connectivity patterns rather than spatial distance. Thus, this type of clustering is well-suited for **high-dimensional, relational, and complex structured data** where Euclidean assumptions fail.

---

## **2. Frequent Pattern-Based Clustering**

Frequent Pattern-Based Clustering is a technique that uses **frequent itemset mining concepts** from association rule mining (like Apriori or FP-Growth) to discover clusters. Instead of relying purely on distance measures, this approach groups objects that share **common frequent patterns** or **co-occurring features**. Each cluster is represented by a set of frequent patterns that describe the cluster’s internal structure.  
The process involves two main steps — (1) finding frequent patterns among the dataset, and (2) using these patterns to assign or group data points into clusters. For example, in a transaction dataset, customers who frequently purchase similar items can be grouped together based on common item patterns. This method is highly effective in **categorical, transactional, or binary data**, where numerical distances are meaningless. It provides more **interpretable clusters** since the cluster representation directly shows which patterns are most characteristic of that group.

---
