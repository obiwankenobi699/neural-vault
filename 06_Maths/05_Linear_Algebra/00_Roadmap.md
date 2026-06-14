# Linear Algebra Roadmap for ML and Deep Learning

Linear algebra is the language of data. Every dataset is a matrix. Every model prediction is a matrix multiplication. Every neural network layer is a linear transformation followed by a nonlinearity.

## Why Linear Algebra for ML

When you pass a batch of 32 images through a neural network layer, you are multiplying a 32×n matrix by an n×m weight matrix. PCA is eigendecomposition of a covariance matrix. Attention mechanisms in transformers are scaled dot-product operations between query, key, and value matrices. SVD underlies recommender systems. You cannot understand these at a mechanical level without linear algebra.

## Module Path

```
Vectors (geometry + algebra)
      ↓
Matrices (operations + rank + determinant)
      ↓
Matrix Intuition (transformations as geometric actions)
      ↓
Eigenvalues and Eigenvectors
      ↓
Eigendecomposition + PCA
      ↓
Singular Value Decomposition (SVD)
```

## File Index

| File | Content | ML Application |
|------|---------|---------------|
| `01_Vectors.md` | Vectors, dot product, norms, projections | Embeddings, similarity search |
| `02_Matrices.md` | Matrix ops, rank, determinant, inverse | Neural network weight layers |
| `03_Matrix_Intuition.md` | Transformations as geometry | Understanding what layers do |
| `04_Eigenvalues_Eigenvectors.md` | Characteristic equation, diagonalisation | Covariance analysis, stability |
| `05_Eigen_Decomposition_PCA.md` | Spectral decomposition, PCA from scratch | Dimensionality reduction |
| `06_SVD.md` | SVD, pseudoinverse, low-rank approximation | Recommender systems, compression |

Begin with `01_Vectors.md`.
