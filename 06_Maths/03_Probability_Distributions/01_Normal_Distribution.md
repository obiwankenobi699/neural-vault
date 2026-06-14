# Normal Distribution (Gaussian)

The normal distribution is the most important distribution in statistics and machine learning. It appears naturally in measurement error, biological variation, and — via the Central Limit Theorem — in the sampling distribution of almost any statistic.

## Definition

A random variable X follows a normal distribution with mean μ and variance σ² if its PDF is:

```
PDF(x) = (1 / √(2πσ²)) * exp( -(x-μ)² / (2σ²) )
```

Notation: X ~ N(μ, σ²)

The standard normal distribution has μ=0, σ=1, written Z ~ N(0, 1).

```python
import numpy as np
import scipy.stats as stats

mu, sigma = 0, 1
x = np.linspace(-4, 4, 100)
pdf_values = stats.norm.pdf(x, mu, sigma)
```

## Properties

The normal distribution is symmetric around μ. The mean, median, and mode are all equal. The distribution is fully characterised by just two parameters: μ (location) and σ (scale). Approximately 68% of data falls within 1σ of the mean, 95% within 2σ, and 99.7% within 3σ. This is the empirical rule.

## Z-Score (Standardisation)

The Z-score transforms any normally distributed variable to the standard normal:
```
z = (x - μ) / σ
```

This is exactly what StandardScaler does when preprocessing features. After transformation, the feature has mean 0 and standard deviation 1. Z-scores allow you to compare values from distributions with different scales.

```python
from sklearn.preprocessing import StandardScaler
import numpy as np

X = np.array([[10, 200], [20, 300], [30, 400]])
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)
# Each column now has mean≈0, std≈1
```

## Why It Appears Everywhere

The Central Limit Theorem (covered in `03_Sampling_and_CLT.md`) proves that the mean of a large sample approaches a normal distribution regardless of the underlying distribution. This means that many aggregate quantities — test scores, measurement errors, financial returns over short periods — are approximately normal even when individual observations are not.

## Normal Distribution in ML

Linear regression assumes residuals are normally distributed. This is why Ordinary Least Squares minimises squared errors — it is equivalent to maximum likelihood estimation under a Gaussian noise assumption.

Gaussian Naive Bayes assumes each feature is normally distributed within each class. Many neural network weight initialisation schemes (He, Xavier) draw weights from a normal distribution. The KL divergence between two Gaussians has a closed-form solution, which is exploited in Variational Autoencoders.

## Checking Normality

Do not assume normality — test for it.

```python
from scipy.stats import shapiro
stat, p = shapiro(data)
# p > 0.05: fail to reject normality (data is consistent with normal)
# p < 0.05: reject normality
```

A QQ plot is a visual check: if data is normal, points fall on the diagonal line.

Proceed to `02_Non_Gaussian_Distributions.md`.
