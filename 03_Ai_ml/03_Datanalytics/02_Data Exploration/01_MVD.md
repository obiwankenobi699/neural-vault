# Multivariate Data Analysis - Complete Guide

## Table of Contents

1. [Introduction to Multivariate Analysis](https://claude.ai/chat/9f17afd4-4015-4cbf-b605-e12dd3f24b0d#introduction-to-multivariate-analysis)
2. [Factor Analysis](https://claude.ai/chat/9f17afd4-4015-4cbf-b605-e12dd3f24b0d#factor-analysis)
3. [Principal Axis Factoring](https://claude.ai/chat/9f17afd4-4015-4cbf-b605-e12dd3f24b0d#principal-axis-factoring)
4. [Maximum Likelihood Estimation (MLE)](https://claude.ai/chat/9f17afd4-4015-4cbf-b605-e12dd3f24b0d#maximum-likelihood-estimation-mle)
5. [Principal Component Analysis (PCA)](https://claude.ai/chat/9f17afd4-4015-4cbf-b605-e12dd3f24b0d#principal-component-analysis-pca)
6. [Cluster Analysis](https://claude.ai/chat/9f17afd4-4015-4cbf-b605-e12dd3f24b0d#cluster-analysis)
7. [Comparative Analysis](https://claude.ai/chat/9f17afd4-4015-4cbf-b605-e12dd3f24b0d#comparative-analysis)
8. [Practical Applications](https://claude.ai/chat/9f17afd4-4015-4cbf-b605-e12dd3f24b0d#practical-applications)

---

## Introduction to Multivariate Analysis

### Definition

Multivariate analysis refers to statistical techniques used to analyze data that involves multiple variables simultaneously. Unlike univariate analysis (one variable) or bivariate analysis (two variables), multivariate methods examine relationships among three or more variables.

### Purpose

The primary objectives of multivariate analysis include:

- Understanding relationships between multiple variables
- Reducing dimensionality while preserving information
- Identifying underlying patterns or structures in data
- Classifying observations into groups
- Predicting outcomes based on multiple predictors

### Data Structure

Multivariate data is typically represented as a matrix where:

- Rows represent observations (subjects, cases, samples)
- Columns represent variables (features, attributes, dimensions)

```
Data Matrix (X)

              Variables
              V1   V2   V3   V4   V5
           ┌─────────────────────────┐
    Obs 1  │ 5.2  3.1  4.5  2.8  6.1 │
    Obs 2  │ 4.8  2.9  3.2  3.1  5.8 │
    Obs 3  │ 6.1  3.5  5.0  2.5  7.2 │
    Obs 4  │ 5.5  3.2  4.1  2.9  6.5 │
    Obs 5  │ 4.9  3.0  3.8  3.0  6.0 │
           └─────────────────────────┘
              n = 5 observations
              p = 5 variables
```

### Types of Multivariate Techniques

Multivariate methods can be broadly categorized:

**Dependence Methods**: One or more variables are dependent on others

- Multiple Regression
- Discriminant Analysis
- Canonical Correlation

**Interdependence Methods**: All variables are analyzed together without distinguishing dependent/independent

- Factor Analysis
- Principal Component Analysis
- Cluster Analysis
- Multidimensional Scaling

---

## Factor Analysis

### Concept

Factor analysis is a statistical method used to describe variability among observed, correlated variables in terms of a potentially lower number of unobserved variables called factors. It seeks to uncover the underlying structure of a large set of variables.

### Fundamental Idea

```
Observable Variables → Hidden Factors → Observable Variables

Original Variables          Latent Factors
┌─────────────┐            ┌──────────┐
│ Variable 1  │◄───────────┤          │
│ Variable 2  │◄───────────┤ Factor 1 │
│ Variable 3  │◄───────────┤          │
├─────────────┤            └──────────┘
│ Variable 4  │◄───────────┐
│ Variable 5  │◄───────────┤ Factor 2 │
│ Variable 6  │◄───────────┤          │
└─────────────┘            └──────────┘

Each observed variable is expressed as a linear
combination of underlying factors plus error term
```

### Mathematical Model

The factor analysis model can be expressed as:

```
X₁ = λ₁₁F₁ + λ₁₂F₂ + ... + λ₁ₘFₘ + ε₁
X₂ = λ₂₁F₁ + λ₂₂F₂ + ... + λ₂ₘFₘ + ε₂
⋮
Xₚ = λₚ₁F₁ + λₚ₂F₂ + ... + λₚₘFₘ + εₚ

Where:
Xᵢ = observed variable i
Fⱼ = latent factor j
λᵢⱼ = factor loading (weight) of variable i on factor j
εᵢ = unique factor (error) for variable i
p = number of variables
m = number of factors (m < p)
```

### Factor Loadings Interpretation

Factor loadings represent the correlation between variables and factors:

```
Factor Loading Matrix (Λ)

              Factor 1  Factor 2  Factor 3
Variable 1  │  0.85      0.12      0.05   │
Variable 2  │  0.82      0.15     -0.10   │
Variable 3  │  0.78      0.20      0.08   │
Variable 4  │  0.10      0.88      0.12   │
Variable 5  │  0.15      0.85     -0.08   │
Variable 6  │ -0.05      0.80      0.15   │
Variable 7  │  0.08      0.12      0.89   │
Variable 8  │  0.12     -0.10      0.86   │

High loadings (|λ| > 0.7) indicate strong association
Low loadings (|λ| < 0.3) indicate weak association
```

### Types of Factor Analysis

#### Exploratory Factor Analysis (EFA)

Used when the researcher does not have a priori hypotheses about the number or nature of factors.

**Goal**: Discover the underlying factor structure

**Process**:

1. Examine correlation matrix
2. Determine number of factors to extract
3. Extract initial factors
4. Rotate factors for interpretability
5. Interpret and name factors

#### Confirmatory Factor Analysis (CFA)

Used when the researcher has specific hypotheses about the factor structure based on theory or prior research.

**Goal**: Test whether data fits a hypothesized measurement model

**Process**:

1. Specify hypothesized model
2. Estimate model parameters
3. Assess model fit
4. Modify model if needed

### Variance Decomposition

Factor analysis partitions the variance of each variable:

```
Total Variance = Common Variance + Unique Variance

┌────────────────────────────────────────┐
│        Total Variance of X₁            │
├────────────────────────────────────────┤
│                                        │
│  ┌──────────────────────┐              │
│  │  Common Variance     │              │
│  │  (explained by       │  ┌─────────┐ │
│  │   shared factors)    │  │ Unique  │ │
│  │                      │  │Variance │ │
│  └──────────────────────┘  └─────────┘ │
│         Communality          Specificity│
│                                        │
└────────────────────────────────────────┘

Communality (h²) = proportion of variance explained by factors
Uniqueness (u²) = 1 - h² = specific + error variance
```

### Factor Extraction Methods

Different algorithms exist for extracting factors. Common methods include:

**Principal Component Analysis**: Uses total variance, including unique variance

**Principal Axis Factoring**: Uses only common variance (communalities)

**Maximum Likelihood**: Assumes multivariate normality, provides statistical tests

**Minimum Residual**: Minimizes residual correlations

**Alpha Factoring**: Maximizes alpha reliability of factors

### Factor Rotation

After initial extraction, factors are rotated to achieve simpler structure and better interpretability.

#### Orthogonal Rotation

Factors remain uncorrelated (perpendicular):

```
Before Rotation              After Rotation (Varimax)

    Factor 2                     Factor 2
        ↑                            ↑
        │    Var3                    │
        │   ◊                        │  Var3
        │  Var2                      │   ◊
        │  ◊                         │
        │       Var1                 │        Var1 Var2
        │        ◊                   │         ◊    ◊
────────┼────────────→  ────────────┼──────────────────→
        │       Factor 1             │             Factor 1
        │                            │
        │  Var4  Var5                │
        │   ◊     ◊                  │   Var4
        │                            │    ◊
        │                            │  Var5
                                     │   ◊

Rotated factors maintain 90° angle
Variables cluster more clearly
```

**Varimax**: Maximizes variance of squared loadings within factors

**Quartimax**: Simplifies rows (variables)

**Equamax**: Combination of Varimax and Quartimax

#### Oblique Rotation

Factors are allowed to correlate:

```
Before Rotation              After Rotation (Promax)

    Factor 2                     Factor 2
        ↑                           ↗
        │    Var3                  │  Var3
        │   ◊                      │   ◊
        │  Var2                    │
        │  ◊                       │
        │       Var1               │        Var1 Var2
        │        ◊                 │         ◊    ◊
────────┼────────────→  ──────────────────────────────→
        │       Factor 1                        Factor 1
        │                          │
        │  Var4  Var5              │
        │   ◊     ◊              ↙ │   Var4
        │                          │    ◊
        │                          │  Var5
                                   │   ◊

Factors can correlate (angle ≠ 90°)
More realistic in many contexts
```

**Promax**: Fast oblique rotation method

**Oblimin**: Direct oblimin, allows factor correlation

**Quartimin**: Minimizes complexity

### Determining Number of Factors

#### Kaiser Criterion (Eigenvalue > 1)

```
Eigenvalue Diagram

Eigenvalue
    8 │ ●
    7 │
    6 │
    5 │
    4 │
    3 │   ●
    2 │     ●
    1 ├─────────────●────────────────
      │           ●   ●   ●   ●   ●
    0 └─────────────────────────────────
       1   2   3   4   5   6   7   8
                Factor Number

Retain factors with eigenvalue > 1
(Factors 1, 2, 3 in this example)
```

#### Scree Plot

```
Scree Plot

Eigenvalue
    8 │●
    7 │ ╲
    6 │  ╲
    5 │   ╲
    4 │    ╲
    3 │     ●
    2 │      ╲●
    1 │        ╲___●___
      │            ●   ●___●___●
    0 └─────────────────────────────────
       1   2   3   4   5   6   7   8
                Factor Number

Look for "elbow" where curve flattens
(Around factor 3 in this example)
```

#### Parallel Analysis

Compare eigenvalues from actual data with eigenvalues from random data:

```
Parallel Analysis

Eigenvalue
    8 │●
    7 │ ╲
    6 │  ╲
    5 │   ╲
    4 │    ╲       ─── Actual Data
    3 │     ●      ··· Random Data
    2 │      ╲●
    1 │       ╲╲··●··
      │        ╲╲ ●  ··●
    0 └─────────╲●──··●─··●─··●────
       1   2   3  4   5   6   7   8
                Factor Number

Retain factors where actual eigenvalue
exceeds random eigenvalue
```

---

## Principal Axis Factoring

### Definition

Principal Axis Factoring (PAF) is a factor extraction method that focuses on common variance shared among variables, excluding unique variance. Unlike PCA which analyzes total variance, PAF estimates and analyzes only the variance that variables share.

### Conceptual Difference from PCA

```
Principal Component Analysis (PCA)
┌────────────────────────────────┐
│   Analyzes TOTAL variance      │
│                                │
│   ┌──────────────────┐         │
│   │  Common Variance │         │
│   │  (shared among   │         │
│   │   variables)     │         │
│   ├──────────────────┤         │
│   │ Unique Variance  │         │
│   │ (specific to     │         │
│   │  each variable)  │         │
│   └──────────────────┘         │
│                                │
└────────────────────────────────┘

Principal Axis Factoring (PAF)
┌────────────────────────────────┐
│  Analyzes COMMON variance only │
│                                │
│   ┌──────────────────┐         │
│   │  Common Variance │         │
│   │  (shared among   │         │
│   │   variables)     │         │
│   └──────────────────┘         │
│                                │
│   Unique variance excluded     │
│   from analysis                │
│                                │
└────────────────────────────────┘
```

### Algorithm

#### Step 1: Estimate Communalities

Initial estimates of communality (h²) for each variable:

```
Correlation Matrix with Communalities

              V1    V2    V3    V4    V5
    V1  │  1.00  0.65  0.72  0.45  0.38 │
    V2  │  0.65  1.00  0.68  0.50  0.42 │
    V3  │  0.72  0.68  1.00  0.55  0.48 │
    V4  │  0.45  0.50  0.55  1.00  0.70 │
    V5  │  0.38  0.42  0.48  0.70  1.00 │

Initial communality estimates (diagonal):
- Multiple R²: Use squared multiple correlation
- Maximum absolute correlation
- Unity (for comparison with PCA)
```

#### Step 2: Replace Diagonal

Replace diagonal 1's with communality estimates:

```
Reduced Correlation Matrix (R*)

              V1    V2    V3    V4    V5
    V1  │  0.78  0.65  0.72  0.45  0.38 │
    V2  │  0.65  0.82  0.68  0.50  0.42 │
    V3  │  0.72  0.68  0.85  0.55  0.48 │
    V4  │  0.45  0.50  0.55  0.75  0.70 │
    V5  │  0.38  0.42  0.48  0.70  0.80 │

Diagonal now contains communality estimates
Off-diagonal remains original correlations
```

#### Step 3: Extract Factors

Perform eigenvalue decomposition on R*:

```
Eigenvalue Decomposition

R* = EΛE^T

Where:
E = eigenvector matrix (factor loadings)
Λ = diagonal matrix of eigenvalues
E^T = transpose of eigenvector matrix
```

#### Step 4: Iterate

Update communality estimates and repeat:

```
Iteration Process

Initial h² → Extract Factors → New h² → Extract Factors → ...
    ↓                             ↓
  0.78                          0.82
  0.82                          0.84
  0.85           Converge       0.87
  0.75            →→→→          0.77
  0.80                          0.81

Continue until h² values stabilize
(typically < 0.001 change)
```

### Factor Loading Matrix

After convergence, the factor loading matrix shows relationships:

```
Factor Pattern Matrix

              Factor 1  Factor 2
Variable 1  │   0.89      0.15   │  h² = 0.82
Variable 2  │   0.85      0.20   │  h² = 0.84
Variable 3  │   0.91      0.12   │  h² = 0.87
Variable 4  │   0.18      0.85   │  h² = 0.77
Variable 5  │   0.12      0.88   │  h² = 0.81
            └────────────────────┘

h² = communality (sum of squared loadings)
```

### Interpretation

#### Factor Scores

Compute estimated factor scores for each observation:

```
Factor Score Computation

F = X Λ^(-1) E^T

Where:
F = factor score matrix (n × m)
X = standardized data matrix (n × p)
Λ = diagonal matrix of eigenvalues
E = eigenvector matrix
n = observations, m = factors, p = variables
```

#### Visualization

```
Factor Space Plot

Factor 2
    ↑
  1.0│         Var4
     │          ◊
  0.5│       Var5
     │        ◊
     │
  0.0├──────────────────────→ Factor 1
     │         Var3
     │          ◊
 -0.5│      Var1  Var2
     │       ◊     ◊
 -1.0│
     └───────────────────────
    -1.0  -0.5  0.0  0.5  1.0

Variables with high loadings on Factor 1
cluster horizontally
Variables with high loadings on Factor 2
cluster vertically
```

### Advantages of PAF

**Focuses on Common Variance**: More appropriate when goal is to identify latent constructs

**Excludes Measurement Error**: Unique variance includes error, which is not of theoretical interest

**Better for Theory Testing**: Aligns with the factor analysis model where factors cause observed variables

**Avoids Inflated Loadings**: PCA can produce inflated loadings due to inclusion of unique variance

### Limitations

**Requires Iteration**: Computationally more intensive than PCA

**Communality Estimation**: Initial estimates can affect final solution

**Indeterminacy**: Factor scores are estimated, not directly observed

**Sample Size Sensitivity**: Requires larger samples for stable results

---

## Maximum Likelihood Estimation (MLE)

### Concept

Maximum Likelihood Estimation in factor analysis finds factor loadings and unique variances that maximize the likelihood of observing the sample correlation matrix, assuming multivariate normality.

### Theoretical Foundation

The likelihood function represents the probability of observing the data given model parameters:

```
Likelihood Function

L(Λ, Ψ | X) = Probability of data X given parameters Λ, Ψ

Where:
Λ = factor loading matrix
Ψ = unique variance (diagonal matrix)
X = observed data

Goal: Find Λ and Ψ that maximize L
```

### Model Specification

The MLE factor model assumes:

```
Multivariate Normal Distribution

X ~ N(μ, Σ)

Where:
X = vector of observed variables
μ = mean vector
Σ = covariance matrix

Σ = ΛΛ^T + Ψ

ΛΛ^T = common variance (factor structure)
Ψ = unique variances (diagonal matrix)
```

### Log-Likelihood Function

For computational reasons, we maximize the log-likelihood:

```
Log-Likelihood

ℓ(Λ, Ψ) = -n/2 [log|Σ| + tr(S Σ^(-1))]

Where:
n = sample size
|Σ| = determinant of Σ
tr = trace (sum of diagonal elements)
S = sample covariance matrix
Σ^(-1) = inverse of Σ

Maximize ℓ with respect to Λ and Ψ
```

### Optimization Process

```
Iterative Optimization

Initial Estimates    Compute          Update         Check
   (Λ⁰, Ψ⁰)    →  Gradient  →  Parameters  →  Convergence
                      ↓              ↓              ↓
                   ∂ℓ/∂Λ         Λ^(t+1)        |Δℓ| < ε?
                   ∂ℓ/∂Ψ         Ψ^(t+1)           ↓
                                                  Yes → Stop
                      ↑              ↑              ↓
                      └──────────────┴───────── No → Continue

Uses Newton-Raphson or EM algorithm
Typically converges in 10-50 iterations
```

### Goodness of Fit

MLE provides statistical tests for model fit:

#### Chi-Square Test

```
χ² Test Statistic

χ² = (n - 1) × [log|Σ̂| - log|S| + tr(S Σ̂^(-1)) - p]

Where:
n = sample size
Σ̂ = estimated covariance matrix
S = sample covariance matrix
p = number of variables

Degrees of freedom:
df = [p(p + 1)/2] - [pm + p - m(m - 1)/2]

Where m = number of factors

H₀: Model fits the data
Reject H₀ if χ² is large (p < 0.05)
```

#### Model Fit Indices

```
Common Fit Indices

RMSEA (Root Mean Square Error of Approximation)
┌────────────────────────────────────┐
│ RMSEA = √[(χ²/df - 1) / (n - 1)]  │
│                                    │
│ < 0.05  Excellent fit              │
│ < 0.08  Adequate fit               │
│ > 0.10  Poor fit                   │
└────────────────────────────────────┘

CFI (Comparative Fit Index)
┌────────────────────────────────────┐
│ CFI = 1 - (χ²ₘ - dfₘ)/(χ²ᵦ - dfᵦ)│
│                                    │
│ > 0.95  Excellent fit              │
│ > 0.90  Adequate fit               │
│                                    │
│ m = proposed model                 │
│ b = baseline (null) model          │
└────────────────────────────────────┘

TLI (Tucker-Lewis Index)
┌────────────────────────────────────┐
│ Similar to CFI, penalizes          │
│ model complexity                   │
│                                    │
│ > 0.95  Excellent fit              │
│ > 0.90  Adequate fit               │
└────────────────────────────────────┘
```

### Factor Loading Significance

MLE provides standard errors for testing significance:

```
Hypothesis Test for Loadings

H₀: λᵢⱼ = 0 (no relationship)
H₁: λᵢⱼ ≠ 0 (significant relationship)

Test statistic:
z = λᵢⱼ / SE(λᵢⱼ)

Decision:
|z| > 1.96 → Reject H₀ (α = 0.05)

Example:
              Factor 1         Factor 2
            Loading  SE  z   Loading  SE  z
Variable 1   0.85  0.08 10.6  0.12  0.09 1.3
Variable 2   0.82  0.09  9.1  0.15  0.10 1.5
Variable 3   0.78  0.10  7.8  0.18  0.11 1.6
Variable 4   0.15  0.11  1.4  0.88  0.07 12.6
Variable 5   0.10  0.12  0.8  0.85  0.08 10.6

Variables 1-3 significant on Factor 1
Variables 4-5 significant on Factor 2
```

### Comparison with Other Methods

```
Method Comparison Matrix

                   PCA    PAF    MLE
───────────────────────────────────────
Total Variance     Yes    No     No
Common Variance    Yes    Yes    Yes
Unique Variance    Yes    No     No
Stat. Tests        No     No     Yes
Normality Assumed  No     No     Yes
Fit Indices        No     No     Yes
Computational Cost Low    Med    High
Indeterminacy      No     Yes    Yes
Factor Scores      Exact  Est.   Est.
```

### Advantages of MLE

**Statistical Tests**: Provides significance tests for loadings and overall fit

**Optimization**: Theoretically optimal solution under normality

**Model Comparison**: Chi-square difference tests for nested models

**Standard Errors**: Enables confidence intervals and hypothesis testing

**Flexibility**: Can incorporate constraints and complex models

### Limitations

**Normality Assumption**: Requires multivariate normal distribution

**Convergence Issues**: May fail to converge or reach local optima

**Computational Intensity**: Slower than PCA or PAF

**Sample Size**: Requires large samples (n > 200 recommended)

**Sensitivity**: Results can be affected by outliers or non-normality

### Practical Application

```
MLE Factor Analysis Workflow

1. Check Assumptions
   ┌────────────────────────┐
   │ • Multivariate normal  │
   │ • Adequate sample size │
   │ • Linear relationships │
   └────────────────────────┘
              ↓
2. Specify Model
   ┌────────────────────────┐
   │ • Number of factors    │
   │ • Factor correlations  │
   │ • Constraints (if any) │
   └────────────────────────┘
              ↓
3. Estimate Parameters
   ┌────────────────────────┐
   │ • Maximize likelihood  │
   │ • Iterate until convg. │
   └────────────────────────┘
              ↓
4. Assess Fit
   ┌────────────────────────┐
   │ • Chi-square test      │
   │ • RMSEA, CFI, TLI      │
   │ • Residual analysis    │
   └────────────────────────┘
              ↓
5. Interpret Results
   ┌────────────────────────┐
   │ • Factor loadings      │
   │ • Factor correlations  │
   │ • Theoretical meaning  │
   └────────────────────────┘
```

---

## Principal Component Analysis (PCA)

### Fundamental Concept

Principal Component Analysis is a dimensionality reduction technique that transforms a set of correlated variables into a new set of uncorrelated variables called principal components, ordered by the amount of variance they explain.

### Core Objective

```
High-Dimensional Data → Reduced Dimensions

Original Data (p dimensions)
┌─────────────────────────────────────────┐
│  X₁  X₂  X₃  X₄  X₅  X₆  X₇  X₈  ...  │
│   ↓   ↓   ↓   ↓   ↓   ↓   ↓   ↓        │
│   •   •   •   •   •   •   •   •        │
│    ╲  │  ╱    ╲  │  ╱    ╲  │  ╱       │
│     ╲ │ ╱      ╲ │ ╱      ╲ │ ╱        │
│      ╲│╱        ╲│╱        ╲│╱         │
│       ●          ●          ●          │
│      PC₁        PC₂        PC₃         │
└─────────────────────────────────────────┘
       Principal Components (k << p)

Maximize variance retained
Minimize information loss
```

### Mathematical Formulation

#### Variance Maximization

The first principal component is the linear combination of original variables that has maximum variance:

```
PC₁ = w₁₁X₁ + w₁₂X₂ + ... + w₁ₚXₚ

Subject to: w₁₁² + w₁₂² + ... + w₁ₚ² = 1

Maximize: Var(PC₁)

Where:
wᵢⱼ = weight (loading) of variable j on component i
Xⱼ = original variable j (standardized)
```

#### Sequential Extraction

```
Component Extraction Sequence

PC₁: Max Var(PC₁)
        ↓
PC₂: Max Var(PC₂) subject to Cov(PC₁, PC₂) = 0
        ↓
PC₃: Max Var(PC₃) subject to Cov(PC₁, PC₃) = Cov(PC₂, PC₃) = 0
        ↓
        ⋮
        ↓
PCₚ: Remaining variance

Each component orthogonal to all previous
Components ordered by variance explained
```

### Eigenvalue Decomposition

PCA solves the eigenvalue problem:

```
Covariance Matrix Decomposition

S = E Λ E^T

Where:
S = covariance matrix (p × p)
E = eigenvector matrix (p × p)
Λ = diagonal matrix of eigenvalues
E^T = transpose of E

┌──────────────────────────────────────┐
│  Eigenvector     Eigenvalue          │
│  (direction)  ×  (magnitude)         │
│       ↓              ↓                │
│   Component      Variance            │
│   Direction      Explained           │
└──────────────────────────────────────┘
```

### Geometric Interpretation

```
2D to 1D Reduction Example

Original 2D Space             Principal Component Space

    X₂                             PC₂ (minor)
     ↑                               ↑
   5 │    •                        2 │
     │      •  •                     │
   4 │   •      •                  1 │
     │     •  •                      │
   3 │  •      •                   0 ├────────────────→
     │    •  •                       │       PC₁ (major)
   2 │ •      •                   -1 │
     │   •  •                        │
   1 │     •                      -2 │
     │                                │
   0 └──────────────→                 └
     0  1  2  3  4  5
         X₁

Data cloud elongated along diagonal
PC₁ captures main direction (max variance)
PC₂ captures perpendicular direction (min variance)
```

### Variance Explained

```
Variance Decomposition

Total Variance = λ₁ + λ₂ + ... + λₚ

Proportion explained by PCᵢ:
    λᵢ / Σλⱼ

Cumulative proportion:
    Σ(λᵢ) / Σλⱼ  for i = 1 to k

Example with 5 variables:
┌──────┬───────────┬────────────┬────────────────┐
│  PC  │ Eigenvalue│  % Variance│ Cumulative %   │
├──────┼───────────┼────────────┼────────────────┤
│  1   │   3.45    │   69.0%    │     69.0%      │
│
```