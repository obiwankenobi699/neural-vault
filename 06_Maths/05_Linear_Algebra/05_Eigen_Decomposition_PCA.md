# Eigendecomposition and PCA [PREMIUM CONTENT]

Eigendecomposition factorises a matrix into its eigenvectors and eigenvalues. PCA (Principal Component Analysis) is the direct ML application: it finds the coordinate system that best represents the variance in your data.

## Eigendecomposition

A diagonalisable matrix A can be written as:
```
A = Q Λ Q⁻¹
```

Where Q is the matrix of eigenvectors (as columns), Λ is a diagonal matrix of eigenvalues, and Q⁻¹ is the inverse of Q. For symmetric matrices, Q is orthogonal (Qᵀ = Q⁻¹), giving the cleaner form:

```
A = Q Λ Qᵀ
```

```python
import numpy as np

A = np.array([[4, 2], [2, 3]])   # symmetric
eigenvalues, Q = np.linalg.eigh(A)
Lambda = np.diag(eigenvalues)

# Verify: A ≈ Q @ Lambda @ Q.T
print(np.allclose(A, Q @ Lambda @ Q.T))   # True
```

## PCA from First Principles

PCA finds directions of maximum variance by eigendecomposing the covariance matrix.

```python
import numpy as np

# Step 1: centre the data
X = np.random.randn(100, 4)
X_centred = X - X.mean(axis=0)

# Step 2: compute covariance matrix
cov = np.cov(X_centred.T)   # shape: (4, 4)

# Step 3: eigendecompose
eigenvalues, eigenvectors = np.linalg.eigh(cov)

# Step 4: sort by descending eigenvalue
idx = np.argsort(eigenvalues)[::-1]
components = eigenvectors[:, idx]   # principal components

# Step 5: project data onto top k components
k = 2
X_pca = X_centred @ components[:, :k]   # shape: (100, 2)
```

## Explained Variance Ratio

Each eigenvalue tells you how much variance that principal component explains. Divide by the sum of all eigenvalues to get the proportion.

```python
sorted_ev = eigenvalues[idx]
explained_variance_ratio = sorted_ev / sorted_ev.sum()
cumulative = np.cumsum(explained_variance_ratio)
# Choose k where cumulative variance crosses 0.95 (95% explained)
```

## Using scikit-learn

```python
from sklearn.decomposition import PCA

pca = PCA(n_components=2)
X_reduced = pca.fit_transform(X)
print(pca.explained_variance_ratio_)
```

## When to Use PCA

PCA is appropriate for dimensionality reduction before applying algorithms sensitive to the curse of dimensionality (k-NN, SVM with RBF kernel). It is not appropriate when interpretability of individual features matters, because principal components are linear combinations of all original features and have no individual meaning.

Proceed to `06_SVD.md`.
