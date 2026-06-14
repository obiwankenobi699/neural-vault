# PDF, PMF, and CDF — Functions for Random Variables

A random variable is a variable whose value is determined by a random process. To work with random variables mathematically, we need functions that describe their probability structure. There are three: PMF for discrete, PDF for continuous, and CDF for both.

## Probability Mass Function (PMF)

A PMF applies to discrete random variables — variables that take a countable set of values. PMF(x) gives the probability that the variable equals exactly x.

```
PMF(x) = P(X = x)
Constraints: PMF(x) ≥ 0 for all x, and Σ PMF(x) = 1
```

Example: rolling a fair die. PMF(1) = PMF(2) = ... = PMF(6) = 1/6.

```python
from scipy.stats import binom
# Binomial PMF: P(X = k) for n=10 trials, p=0.5
k = 5
print(binom.pmf(k, n=10, p=0.5))   # ~0.246
```

## Probability Density Function (PDF)

A PDF applies to continuous random variables. Unlike a PMF, a PDF does not give the probability at a single point — for continuous variables, P(X = exactly x) = 0. Instead, PDF(x) represents probability density. You integrate it over an interval to get probability.

```
P(a ≤ X ≤ b) = ∫[a to b] PDF(x) dx
Constraints: PDF(x) ≥ 0, and ∫[-∞ to ∞] PDF(x) dx = 1
```

A common misunderstanding: PDF values can exceed 1 (because they are densities, not probabilities). Only integrals of PDF must be ≤ 1.

```python
from scipy.stats import norm
x = 0
print(norm.pdf(x, loc=0, scale=1))   # 0.3989 — density, not probability
```

## Cumulative Distribution Function (CDF)

The CDF applies to both discrete and continuous variables. CDF(x) = P(X ≤ x) — the probability that the variable takes a value at most x. It is a non-decreasing function from 0 to 1.

```python
# P(X ≤ 1.96) for standard normal — the 97.5th percentile
print(norm.cdf(1.96))   # ~0.975
# This is why z = 1.96 appears in 95% confidence intervals
```

The CDF is the integral of the PDF. The PDF is the derivative of the CDF.

## Relationship Summary

```
Discrete variable  →  PMF  →  sum to get probability over a range
Continuous variable →  PDF  →  integrate to get probability over a range
Both               →  CDF  =  P(X ≤ x), always between 0 and 1
```

## ML Relevance

Loss functions are defined using PDFs. Maximum likelihood estimation — the principle behind most model training — asks: what parameters make the observed data most probable? That is a question about the PDF of your data. The log-likelihood used in logistic regression training is the log of a Bernoulli PMF.

Proceed to `03_Joint_Marginal_Conditional.md`.
