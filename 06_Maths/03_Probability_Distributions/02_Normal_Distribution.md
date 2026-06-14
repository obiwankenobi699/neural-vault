# Normal Distribution
Source: Session 41, DSMP 2023
Watch: https://www.youtube.com/watch?v=ADqYqSdtyW8

## Why Normal Distribution is Fundamental

Nitish explains: statisticians collected data from many different domains — heights, blood pressure, measurement errors, test scores — and built their PDFs. The same bell-shaped graph kept appearing repeatedly. They named it the normal distribution. Because so much is mathematically known about it, data scientists strongly prefer data that follows or approximates it. When your data is approximately normal, you automatically gain access to all the tools and tests built for it.

## Shape and Parameters

The normal distribution has a symmetric bell shape centred at the mean. It has exactly two parameters. Mu (mean) controls location — shifting mu left or right shifts the entire curve. Sigma (standard deviation) controls spread — a small sigma makes the curve tall and narrow, a large sigma makes it short and wide.

X follows N(mu, sigma squared) means X is normally distributed with mean mu and variance sigma squared.

The PDF formula: f(x) = (1 / sqrt(2 pi sigma squared)) times exp(-(x - mu)squared / (2 sigma squared)). Nitish points out that pi and e are constants — the only parameters are mu and sigma.

```python
from scipy.stats import norm
import numpy as np
x = np.linspace(-4, 4, 1000)
y = norm.pdf(x, loc=0, scale=1)   # Standard Normal: mu=0, sigma=1
```

## Key Properties

Mean, median, and mode are all equal and all located at the centre. The distribution is perfectly symmetric — the left half mirrors the right half exactly. Tails extend to positive and negative infinity but approach zero asymptotically and never touch it.

## Empirical Rule (68-95-99.7 Rule)

Nitish derives this in class using the Z-table.

Within mu plus or minus 1 sigma: approximately 68 percent of all data. Within mu plus or minus 2 sigma: approximately 95 percent. Within mu plus or minus 3 sigma: approximately 99.7 percent.

Example with heights (mu = 170 cm, sigma = 10 cm): 68 percent of people are between 160 and 180 cm. 95 percent are between 150 and 190 cm. Anyone below 140 or above 200 cm is a statistical outlier (beyond 3 sigma).

```python
mu, sigma = 170, 10
print(f"68%: {mu-sigma} to {mu+sigma}")     # 160 to 180
print(f"95%: {mu-2*sigma} to {mu+2*sigma}") # 150 to 190
```

## Standard Normal and Z-Score

The standard normal distribution is the special case with mu=0 and sigma=1. Any normally distributed variable can be converted to a standard normal using the Z-score.

Z = (x - mu) / sigma

The Z-score tells you how many standard deviations a value is from the mean. Z=0 is exactly at the mean. Z=2 is two standard deviations above. Z=-1.5 is one and a half standard deviations below.

```python
from scipy.stats import norm
# Heights: N(170, 10)
# What percentage of people are shorter than 185 cm?
z = (185 - 170) / 10    # z = 1.5
prob = norm.cdf(z)       # 0.9332 — 93.32 percent
```

## Using KDE to Detect Normality

Kernel Density Estimate is a smooth version of a histogram. Nitish uses the Iris dataset to show that plotting KDE per species reveals which features best separate the three classes. Features where the three species have well-separated distributions are highly discriminative. Features where distributions overlap heavily are weak predictors.

```python
import seaborn as sns
for species in df['species'].unique():
    subset = df[df['species'] == species]
    sns.kdeplot(subset['petal_length'], label=species, fill=True)
```

## Checking Normality

Never assume normality — test for it. The QQ plot is the standard visual test: if data is normal, points fall on the diagonal line. Systematic deviations reveal the nature of the departure — S-curves indicate heavy tails, one-sided curves indicate skew.

```python
from scipy import stats
import matplotlib.pyplot as plt
stats.probplot(data, dist='norm', plot=plt)
plt.title('QQ Plot')
plt.show()

stat, p = stats.shapiro(data)
# p > 0.05: fail to reject normality
```

## ML Connection

StandardScaler applies the Z-score transformation. OLS linear regression assumes residuals are normally distributed — this is why it minimises squared errors (equivalent to maximum likelihood under Gaussian noise). Gaussian Naive Bayes assumes each feature is normal within each class. He and Xavier weight initialisation draw from N(0, sigma squared) where sigma depends on layer dimensions. Confidence intervals: 95 percent CI uses 1.96 because norm.cdf(1.96) = 0.975.

## Interview Questions

What are the parameters of the normal distribution and what does each control? State the empirical rule. What is a Z-score and how do you interpret it? How do you check if data is normally distributed? Why does standard scaling help linear models?
