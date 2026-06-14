# Skewness and Kurtosis — Shape of the Distribution

Mean, median, and standard deviation describe centre and spread. Skewness and kurtosis describe shape. They are the third and fourth statistical moments respectively.

## Statistical Moments

A moment is a specific way of summarising a distribution. The first four moments correspond to: mean (location), variance (spread), skewness (asymmetry), kurtosis (tail weight).

```
1st moment → mean        (where is it centred?)
2nd moment → variance    (how spread out?)
3rd moment → skewness    (is it symmetric?)
4th moment → kurtosis    (how heavy are the tails?)
```

## Skewness

Skewness quantifies asymmetry. A perfectly symmetric distribution has skewness = 0.

Positive skew (right skew): the tail extends to the right. Mean > Median > Mode. Income distribution is a classic example — most people earn near the median, but a long tail of high earners pulls the mean right.

Negative skew (left skew): the tail extends to the left. Mean < Median < Mode. Age at retirement might show this — most retire around 60-65, but some retire very early, creating a left tail.

```python
from scipy import stats
data = [1, 2, 2, 3, 3, 3, 4, 10]
print(stats.skew(data))   # positive value — right-skewed
```

In ML: tree-based models are unaffected by skew. Linear models, logistic regression, and neural networks assume or benefit from roughly symmetric inputs. Applying a log transform to a right-skewed feature before feeding it to a linear model is a direct application of this understanding.

## Kurtosis

Kurtosis measures the weight of the tails relative to a normal distribution. Excess kurtosis is defined relative to the normal distribution (which has kurtosis = 3, so excess kurtosis = 0).

High kurtosis (leptokurtic, excess > 0): heavy tails — extreme events occur more often than a normal distribution predicts. Financial returns exhibit this — the 2008 crash was a many-sigma event under normality assumptions.

Low kurtosis (platykurtic, excess < 0): light tails — values cluster more tightly near the mean, fewer extremes.

```python
print(stats.kurtosis(data))  # excess kurtosis (Fisher definition, normal=0)
```

## Why It Matters for ML

Many algorithms assume normally distributed residuals or inputs. Skewness and kurtosis let you quantify how far your data deviates from that assumption before deciding whether a transformation is necessary.

Proceed to `05_Correlation_and_Covariance.md`.
