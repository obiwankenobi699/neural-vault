# Eigendecomposition and PCA
Source: Session 20 of playlist (premium)
Watch: https://www.youtube.com/watch?v=D5IlO4lzaZ0

## Eigendecomposition

A diagonalisable matrix A can be written as A = Q Lambda Q inverse, where Q is the matrix whose columns are eigenvectors and Lambda is a diagonal matrix of eigenvalues. For symmetric matrices Q is orthogonal (Q transpose = Q inverse), giving A = Q Lambda Q transpose.

```python
import numpy as np
A = np.array([[4, 2],
              [2, 3]])   # symmetric
eigenvalues, Q = np.linalg.eigh(A)
Lambda = np.diag(eigenvalues)
print(np.allclose(A, Q @ Lambda @ Q.T))   # True
```

## PCA from First Principles

PCA finds the directions of maximum variance in data by eigendecomposing the covariance matrix.

```python
import numpy as np

X = np.random.randn(100, 4)
# Step 1: centre the data
X_c = X - X.mean(axis=0)

# Step 2: covariance matrix
cov = np.cov(X_c.T)

# Step 3: eigendecompose
vals, vecs = np.linalg.eigh(cov)

# Step 4: sort descending
idx = np.argsort(vals)[::-1]
components = vecs[:, idx]

# Step 5: project onto top 2 components
X_pca = X_c @ components[:, :2]   # shape (100, 2)
```

## Explained Variance Ratio

Each eigenvalue represents the variance captured by its principal component. Dividing by the sum gives the proportion of total variance explained.

```python
sorted_vals = vals[idx]
evr = sorted_vals / sorted_vals.sum()
cumulative = np.cumsum(evr)
# Choose k where cumulative crosses 0.95
```

## scikit-learn PCA

```python
from sklearn.decomposition import PCA
pca = PCA(n_components=2)
X_reduced = pca.fit_transform(X)
print(pca.explained_variance_ratio_)
```

## When to Use PCA

Use before algorithms sensitive to the curse of dimensionality (k-NN, SVM with RBF kernel) when you have many features. Do not use when individual feature interpretability matters — principal components are linear combinations of all original features and have no individual meaning.

## ML Connection

PCA reduces dimensionality before visualisation (t-SNE then operates in lower-dimensional space). Face recognition (Eigenfaces) is PCA applied to image data. Noise reduction: projecting to the top k components discards small-variance directions which often correspond to noise.

## Interview Questions

What is eigendecomposition? Describe PCA from first principles without using sklearn. What does explained variance ratio tell you? What are the limitations of PCA? When should you not use PCA?
