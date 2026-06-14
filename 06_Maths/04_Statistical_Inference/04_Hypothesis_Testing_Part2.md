# Hypothesis Testing Part 2 — p-values and t-tests
Source: Session 46, DSMP 2023
Watch: https://www.youtube.com/watch?v=xHTMjxx14sU

## p-value

The p-value is the probability of observing a test statistic at least as extreme as the one computed, assuming H0 is true. A small p-value means the observed data is very unlikely under H0 — strong evidence against it.

Nitish's direct definition: the p-value expresses the strength of the evidence against H0. A small p-value means strong evidence against H0.

Decision rule: if p-value < alpha, reject H0. If p-value >= alpha, fail to reject H0.

What the p-value is NOT: it is not the probability that H0 is true. It is not the probability that the result is due to chance. It does not measure effect size or practical importance.

## Snack food example from session

A company claims their chips weigh 50 grams on average. A consumer watchdog tests a sample of 40 packets and finds a mean weight of 49 grams. Population standard deviation is known to be 5 grams. Test at alpha = 0.05 whether the mean differs from 50 grams (two-tailed test).

H0: mu = 50. H1: mu not equal to 50 (two-tailed).

Z = (49 - 50) / (5 / sqrt(40)) = -1 / 0.7906 = -1.265

For a two-tailed test at alpha = 0.05 the critical values are plus and minus 1.96. Since -1.265 is between -1.96 and +1.96 we fail to reject H0. Not enough evidence to conclude the company is under-filling.

```python
from scipy import stats
import numpy as np

mu0, sigma, n, x_bar = 50, 5, 40, 49
z_stat = (x_bar - mu0) / (sigma / np.sqrt(n))
p_value = 2 * (1 - stats.norm.cdf(abs(z_stat)))   # two-tailed
print(f"Z={z_stat:.3f}, p={p_value:.4f}")
# p=0.2059 > 0.05, fail to reject H0
```

## One-tailed vs Two-tailed Tests

A one-tailed test has a directional H1 (mu > 50 or mu < 50). The rejection region is on one side only. A two-tailed test has H1: mu not equal to mu0. The rejection region is split across both tails. Use two-tailed unless you have a specific directional hypothesis established before data collection.

## t-test (When Sigma is Unknown)

In practice population sigma is almost never known. Use the t-test which relies on the sample standard deviation s.

One-sample t-test: tests whether sample mean equals a hypothesised value.

```python
from scipy import stats
sample = [48, 51, 49, 50, 52, 47, 53, 50, 48, 51]
t_stat, p_value = stats.ttest_1samp(sample, popmean=50)
print(f"t={t_stat:.3f}, p={p_value:.4f}")
```

Two-sample independent t-test: tests whether two independent groups have the same mean.

```python
group_a = [28, 30, 29, 31, 27]
group_b = [32, 34, 31, 35, 33]
t_stat, p_value = stats.ttest_ind(group_a, group_b, equal_var=False)  # Welch's
print(f"t={t_stat:.3f}, p={p_value:.4f}")
```

Paired t-test: used when the same subjects are measured twice (before and after).

```python
before = [80, 85, 78, 90, 76]
after  = [84, 88, 82, 91, 80]
t_stat, p_value = stats.ttest_rel(before, after)
```

## Statistical vs Practical Significance

Statistical significance means the effect probably exists. Practical significance means the effect is large enough to matter.

With 100,000 samples, a 0.001 accuracy improvement between two models will be statistically significant (tiny p-value). It has zero practical significance.

Cohen's d measures effect size independently of sample size:

```python
def cohen_d(g1, g2):
    pooled = np.sqrt((np.std(g1, ddof=1)**2 + np.std(g2, ddof=1)**2) / 2)
    return (np.mean(g1) - np.mean(g2)) / pooled
# d=0.2: small, d=0.5: medium, d=0.8: large
```

Always report both p-value and effect size.

## Multiple Testing Problem

Running 20 independent tests at alpha=0.05 will produce on average one false positive by chance. Bonferroni correction: use alpha/k as the threshold where k is the number of tests.

## ML Connection

A/B testing a new model follows this exact framework. Feature selection using statistical tests (f_classif for numerical features, chi2 for categorical) outputs p-values and selects features below a threshold. Coefficients in linear regression come with p-values testing whether each coefficient is significantly different from zero.

## Interview Questions

What is a p-value and what does it represent? What does it mean to fail to reject H0? When do you use a t-test instead of a z-test? What is the difference between one-tailed and two-tailed tests? What is the multiple testing problem and how do you address it? What is the difference between statistical significance and practical significance?
