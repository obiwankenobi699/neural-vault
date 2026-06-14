# Vectors
Source: Session 16 of playlist
Watch: https://www.youtube.com/watch?v=mQewAJb8oJ8

## What is a Vector

A vector is an ordered list of numbers. In ML it represents a single data point, a word embedding, a model weight, or any entity that can be described by multiple numerical attributes simultaneously.

Notation: a vector written as a column with n rows and 1 column is called an n-dimensional column vector. Nitish shows the notation explicitly — 1 x n means a row vector, n x 1 means a column vector. Seeing n x 1 immediately tells you this is a column vector.

```python
import numpy as np
a = np.array([1, 2, 3])        # 3-dimensional vector
b = np.array([4, 5, 6, 7, 8])  # 5-dimensional vector
```

## Distance from Origin (Magnitude / Norm)

Nitish derives this geometrically for 2D first. For a vector with components a and b, the distance from the origin is sqrt(a squared + b squared) — the Pythagorean theorem. For 3D: sqrt(a squared + b squared + c squared). For any n dimensions: sqrt of the sum of squares of all components.

This is the L2 norm, written as double vertical bars around the vector.

```python
a = np.array([3, 4])
print(np.linalg.norm(a))        # 5.0 — L2 norm
print(np.linalg.norm(a, ord=1)) # 7.0 — L1 norm (sum of absolute values)
```

L1 norm produces sparse solutions in regularisation (Lasso). L2 norm produces small but non-zero weights (Ridge). The choice of norm encodes a prior assumption about what the solution should look like.

## Vector Addition and Scalar Multiplication

Adding two vectors: add corresponding components. Scalar multiplication: multiply every component by the scalar. Both are element-wise operations.

```python
u = np.array([1, 2, 3])
v = np.array([4, 5, 6])
print(u + v)    # [5, 7, 9]
print(3 * u)    # [3, 6, 9]
```

## Dot Product

The dot product of two vectors is the sum of element-wise products. Geometric interpretation: dot product = magnitude of a times magnitude of b times cosine of the angle between them.

```python
print(np.dot(u, v))   # 1*4 + 2*5 + 3*6 = 32
print(u @ v)           # same, cleaner syntax
```

The dot product being zero means the vectors are orthogonal (perpendicular) — they are completely unrelated in direction. Nitish uses this to motivate cosine similarity.

## Cosine Similarity

Cosine similarity = dot product divided by product of magnitudes. Range: -1 to +1. Value 1 means same direction. Value 0 means orthogonal (no relationship). Value -1 means opposite directions.

```python
cos_sim = np.dot(u, v) / (np.linalg.norm(u) * np.linalg.norm(v))
```

This is the fundamental similarity metric in semantic search, recommendation systems, and document similarity — including the vector database at the core of Nazar AI.

## Unit Vector

A unit vector has magnitude 1. You create one by dividing a vector by its magnitude. Unit vectors represent direction without scale.

```python
u_hat = u / np.linalg.norm(u)   # unit vector in direction of u
```

## Vector Spaces

A vector space is a collection of vectors that is closed under addition and scalar multiplication. The span of a set of vectors is all possible linear combinations of those vectors. Linear independence means no vector in the set can be written as a combination of the others.

## ML Connection

Every data point in a dataset is a vector. Word embeddings (Word2Vec, GloVe, BERT) are vectors in high-dimensional space. Cosine similarity between embedding vectors measures semantic similarity. The entire forward pass of a neural network layer is a vector dot product with a weight matrix. Normalisation and regularisation are norm operations on weight vectors.

## Interview Questions

What is a vector and how is it represented in ML? What is the L2 norm and how is it computed? What does a dot product of zero between two vectors mean geometrically? What is cosine similarity and where is it used? What is the difference between L1 and L2 norms in the context of regularisation?
