# Singular Value Decomposition
Source: Session 21 of playlist (premium)
Watch: https://www.youtube.com/watch?v=NPkMoUNkEtQ

## The Factorisation

Every matrix A (m x n) can be decomposed as A = U Sigma V transpose. U is m x m orthogonal (left singular vectors). Sigma is m x n diagonal (singular values, non-negative, sorted descending). V is n x n orthogonal (right singular vectors).

```python
import numpy as np
A = np.array([[1, 2, 3],
              [4, 5, 6],
              [7, 8, 9]])
U, sigma, Vt = np.linalg.svd(A)
print("Singular values:", sigma)
```

## Low-Rank Approximation

Truncating to the top k singular values gives the best rank-k approximation of A in terms of Frobenius norm. This is mathematically optimal lossy compression.

```python
k = 1
A_approx = sigma[0] * np.outer(U[:, 0], Vt[0, :])
```

## Connection to PCA

SVD of the centred data matrix X is equivalent to PCA. The right singular vectors V are the principal components. The singular values relate to eigenvalues of the covariance matrix. SVD is numerically more stable than eigendecomposing the covariance matrix directly. scikit-learn's PCA uses LAPACK SVD internally.

## Recommender Systems

The user-item interaction matrix R is approximately decomposed as U Sigma V transpose. U captures user latent factors, V captures item latent factors. The dot product of a user's row in U with an item's row in V predicts the rating. This is the core of matrix factorisation recommenders (Netflix Prize winner used this).

## Pseudoinverse

The Moore-Penrose pseudoinverse A+ = V Sigma+ U transpose, where Sigma+ replaces each non-zero singular value with its reciprocal. It gives the minimum-norm least-squares solution to Ax = b even when A is not square or not full-rank.

```python
A_pinv = np.linalg.pinv(A)   # uses SVD internally
```

## ML Connection

Image compression: SVD of an image matrix with small k gives a compressed approximation. Latent Semantic Analysis in NLP applies SVD to the term-document matrix. Collaborative filtering for recommendations. Dimensionality reduction that works for non-square matrices (unlike covariance-based PCA which requires square input).

## Interview Questions

What is SVD and what are its three components? How is SVD related to PCA? How is SVD used in recommender systems? What is the pseudoinverse and when is it used? What does low-rank approximation achieve?
