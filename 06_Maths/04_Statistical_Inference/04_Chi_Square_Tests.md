# Chi-Square Tests [PREMIUM CONTENT]

Chi-square tests are non-parametric tests for categorical data. They do not assume any particular distribution and work with counts and frequencies rather than means.

## Chi-Square Goodness of Fit

Tests whether observed frequencies match expected frequencies from a hypothesised distribution.

H₀: the data follows the specified distribution
H₁: it does not

```python
from scipy.stats import chisquare

observed = [18, 22, 20, 25, 15]   # counts in 5 categories
expected = [20, 20, 20, 20, 20]   # expected if uniform

chi2, p = chisquare(f_obs=observed, f_exp=expected)
print(f"chi2={chi2:.3f}, p={p:.4f}")
```

## Chi-Square Test of Independence

Tests whether two categorical variables are independent of each other. Used extensively in feature selection — is this categorical feature related to the target variable?

```python
import numpy as np
from scipy.stats import chi2_contingency

# Contingency table: rows=gender, cols=product preference
table = np.array([[30, 20, 10],
                  [15, 35, 20]])

chi2, p, dof, expected = chi2_contingency(table)
print(f"chi2={chi2:.3f}, p={p:.4f}, dof={dof}")
```

A small p-value indicates the variables are not independent — there is a statistically significant association.

## Assumptions

Expected frequency in each cell should be at least 5. If cells have very small expected counts, Fisher's exact test is more appropriate (for 2×2 tables).

## Feature Selection Application

Chi-square feature selection tests each categorical feature against the target label. Features with high chi-square statistics (low p-values) are more likely to be informative.

```python
from sklearn.feature_selection import chi2 as sk_chi2, SelectKBest

# X must be non-negative (counts or frequencies), y is target
selector = SelectKBest(sk_chi2, k=5)
X_selected = selector.fit_transform(X, y)
```

Proceed to `05_ANOVA.md`.
