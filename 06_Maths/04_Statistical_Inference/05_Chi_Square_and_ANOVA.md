# Chi-Square Tests and ANOVA
Source: CampusX Chi-Square session and ANOVA session (premium)
Watch Chi-Square: https://www.youtube.com/watch?v=_8DTqznosvY
Watch ANOVA: https://www.youtube.com/watch?v=G9ppvMWyd54

## Chi-Square Goodness of Fit

Tests whether observed frequencies match expected frequencies from a hypothesised distribution. H0: data follows the specified distribution. H1: it does not.

```python
from scipy.stats import chisquare
observed = [18, 22, 20, 25, 15]
expected = [20, 20, 20, 20, 20]   # expected if uniform
chi2, p = chisquare(f_obs=observed, f_exp=expected)
# p < 0.05: distribution is not uniform
```

## Chi-Square Test of Independence

Tests whether two categorical variables are independent. Used heavily in feature selection — is this categorical feature related to the target? H0: the two variables are independent. H1: they are not.

The test uses a contingency table of observed frequencies and compares them to expected frequencies under the independence assumption.

```python
from scipy.stats import chi2_contingency
import numpy as np

# Rows: gender, Columns: product preference A/B/C
table = np.array([[30, 20, 10],
                  [15, 35, 20]])

chi2, p, dof, expected = chi2_contingency(table)
print(f"chi2={chi2:.3f}, p={p:.4f}, dof={dof}")
# p < 0.05: gender and product preference are not independent
```

Assumption: expected frequency in each cell should be at least 5. For small expected counts use Fisher's exact test.

```python
from sklearn.feature_selection import chi2 as sk_chi2, SelectKBest
selector = SelectKBest(sk_chi2, k=5)
X_selected = selector.fit_transform(X, y)
```

## ANOVA — Analysis of Variance

ANOVA tests whether the means of three or more groups are equal. Running multiple t-tests pairwise inflates Type I error rate. ANOVA tests all groups simultaneously in one test.

H0: all group means are equal. H1: at least one group mean differs.

The F-statistic is the ratio of between-group variance (signal) to within-group variance (noise). A large F means group means differ more than random sampling variation would predict.

```python
from scipy.stats import f_oneway
group_a = [50, 52, 48, 51, 49]
group_b = [55, 57, 54, 56, 53]
group_c = [50, 49, 51, 48, 52]

f_stat, p = f_oneway(group_a, group_b, group_c)
print(f"F={f_stat:.3f}, p={p:.4f}")
```

ANOVA only tells you that at least one group differs — not which ones. Post-hoc tests (Tukey HSD) perform pairwise comparisons while controlling the overall Type I error rate.

```python
from statsmodels.stats.multicomp import pairwise_tukeyhsd
import numpy as np

data = np.concatenate([group_a, group_b, group_c])
labels = ['A']*5 + ['B']*5 + ['C']*5
result = pairwise_tukeyhsd(data, labels, alpha=0.05)
print(result)
```

ANOVA assumptions: independence of observations, approximate normality within groups, homogeneity of variance (check with Levene's test). When these are violated use Kruskal-Wallis (non-parametric ANOVA).

```python
from sklearn.feature_selection import f_classif, SelectKBest
selector = SelectKBest(f_classif, k=10)
X_selected = selector.fit_transform(X, y)   # ANOVA F-test for feature selection
```

## Interview Questions

When would you use chi-square instead of a t-test? What does the chi-square test of independence test? What is ANOVA and when do you need it instead of multiple t-tests? What is the F-statistic and what does a large value indicate? What post-hoc test do you use after ANOVA and why?
