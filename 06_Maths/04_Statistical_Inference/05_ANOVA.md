# ANOVA — Analysis of Variance [PREMIUM CONTENT]

ANOVA tests whether the means of three or more groups are equal. Running multiple t-tests pairwise inflates the Type I error rate (multiple testing problem). ANOVA avoids this by testing all groups simultaneously in a single test.

## One-Way ANOVA

H₀: μ₁ = μ₂ = ... = μₖ (all group means are equal)
H₁: at least one group mean is different

The test partitions total variance into between-group variance (signal) and within-group variance (noise). The F-statistic is their ratio.

```python
from scipy.stats import f_oneway
import numpy as np

group_a = np.random.normal(50, 10, 30)
group_b = np.random.normal(55, 10, 30)
group_c = np.random.normal(50, 10, 30)

f_stat, p = f_oneway(group_a, group_b, group_c)
print(f"F={f_stat:.3f}, p={p:.4f}")
```

## F-Statistic Intuition

```
F = (Between-group variance) / (Within-group variance)
  = (Signal) / (Noise)
```

A large F means group means differ more than would be expected from random sampling variation. Under H₀, F follows an F-distribution.

## Post-hoc Tests

ANOVA tells you that at least one group differs. It does not tell you which. Post-hoc tests (Tukey HSD, Bonferroni) perform pairwise comparisons while controlling the overall Type I error rate.

```python
from statsmodels.stats.multicomp import pairwise_tukeyhsd
import pandas as pd

data = np.concatenate([group_a, group_b, group_c])
labels = ['A']*30 + ['B']*30 + ['C']*30
result = pairwise_tukeyhsd(endog=data, groups=labels, alpha=0.05)
print(result)
```

## ANOVA Assumptions

1. Independence: observations within and across groups are independent.
2. Normality: residuals within each group are approximately normal.
3. Homogeneity of variance: all groups have similar variance (Levene's test checks this).

```python
from scipy.stats import levene
stat, p = levene(group_a, group_b, group_c)
# p > 0.05: variances are not significantly different — ANOVA assumption holds
```

When normality or homogeneity of variance are violated, use the Kruskal-Wallis test (non-parametric ANOVA equivalent).

## ML Relevance

ANOVA-based feature selection tests whether a continuous feature's mean differs significantly across target classes. Features with significant F-statistics are strong discriminators.

```python
from sklearn.feature_selection import f_classif, SelectKBest
selector = SelectKBest(f_classif, k=10)
X_selected = selector.fit_transform(X, y)
```
