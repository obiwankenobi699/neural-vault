# PDF, PMF and CDF
Source: Session 40, DSMP 2023
Watch: https://www.youtube.com/watch?v=C_QAURbgBqY

Nitish opens this session: "Today's lecture will be slightly difficult. The previous two classes were easy — mean, median, mode, standard deviation — you already knew those. Today we will study something you may be seeing for the first time."

## Random Variables

In algebra, a variable holds an unknown constant value. In probability, a random variable is a variable whose value is determined by a random experiment. Rolling a die: the random variable X can take values from the set {1, 2, 3, 4, 5, 6}. Flipping a coin: X takes values {0, 1} where 0 is tail and 1 is head.

A discrete random variable takes only specific, countable values — integers. A continuous random variable can take any value in a range including all decimals. Student marks on a scale of 0 to 10 is continuous: 7.91, 6.34, 8.00, and infinitely many other values are possible.

## Why Probability Distributions

A probability distribution is a table or mathematical function that maps every possible outcome of a random variable to its probability. Nitish demonstrates this with a die: he rolls it 10,000 times in code, builds a frequency table, and divides by 10,000 to get probabilities. Each face gets approximately 1/6.

The problem with the table approach: when the random variable is continuous (marks between 0 and 10), infinitely many values are possible. You cannot build a table row for 7.912345 and 7.912346 separately. Instead you create a mathematical function — one equation — that, given any value of x, returns the probability density or probability at that point. This function is the probability distribution function.

```python
import numpy as np, pandas as pd
rolls = np.random.randint(1, 7, size=10000)
dist = pd.Series(rolls).value_counts().sort_index() / 10000
print(dist)   # each face approximately 0.1667
```

## PMF — Probability Mass Function

PMF applies to discrete random variables. PMF(x) = P(X = x) — the exact probability that the variable equals x.

Two required conditions: every probability must be non-negative, and all probabilities must sum to exactly 1.

For a fair die: f(x) = 1/6 for x in {1, 2, 3, 4, 5, 6}, zero otherwise. This one equation replaces the entire table.

When two dice are rolled and you track the sum, the distribution is not uniform. A sum of 7 has probability 6/36, while sums of 2 and 12 each have probability 1/36. The PMF graph looks like a pyramid peaking at 7.

```python
from scipy.stats import binom
print(binom.pmf(k=3, n=10, p=0.5))   # P(exactly 3 heads in 10 fair flips)
```

## PDF — Probability Density Function

PDF applies to continuous random variables. The critical difference from PMF: the y-axis is probability density, not probability. For continuous variables, the probability of landing on any exact single value is effectively zero — infinitely many values compete for the same unit of probability.

Instead of asking P(X = 7.5) — which is zero — you ask P(7 <= X <= 8). The answer is the area under the PDF curve between 7 and 8, computed by integration. The total area under any PDF is always exactly 1.

PDF values can exceed 1 because they are densities, not probabilities. Only integrals of the PDF must lie between 0 and 1.

```python
from scipy.stats import norm
import numpy as np
x = np.linspace(-4, 4, 1000)
y = norm.pdf(x, loc=0, scale=1)
# y values represent density — some exceed 0.3 near the centre
# P(0 <= X <= 1) = area under curve between 0 and 1
prob = norm.cdf(1) - norm.cdf(0)   # = 0.3413
```

## CDF — Cumulative Distribution Function

CDF works for both discrete and continuous variables. CDF(x) = P(X <= x) — the probability that the variable takes a value at most x. The CDF is always non-decreasing, starts at 0 (or approaching 0), and ends at 1.

For the die: CDF(1) = 1/6, CDF(2) = 2/6, CDF(3) = 3/6, up to CDF(6) = 1.

For the normal distribution, norm.cdf(1.96) = 0.975. This single fact explains where the 1.96 comes from in 95 percent confidence intervals.

```python
from scipy.stats import norm
print(norm.cdf(1.96))    # 0.9750 — 97.5 percent of values below z=1.96
print(norm.cdf(0))       # 0.5000 — symmetric, half the area below mean
```

The CDF is the integral of the PDF. The PDF is the derivative of the CDF.

## Distribution Parameters

Every probability distribution has parameters — tuning knobs that control its shape, location, and spread. The normal distribution has mu (location) and sigma (spread). The binomial has n (number of trials) and p (success probability). Changing parameters changes the graph but the family of distribution remains the same.

## ML Connection

Loss functions are derived from probability distribution functions. MSE loss is the negative log-likelihood under a Gaussian PDF assumption on residuals. Binary cross-entropy is the negative log-likelihood of a Bernoulli PMF. The CDF of the normal distribution is used to compute p-values in every statistical test. Maximum likelihood estimation — the principle behind training most models — asks: what parameters make the observed data most probable under the assumed PDF?

## Interview Questions

What is the difference between PMF and PDF? Why can PDF values exceed 1? What does the CDF represent? What is the relationship between PDF and CDF mathematically? Why is the probability of a continuous random variable taking an exact value equal to zero?
