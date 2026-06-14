# Measures of Central Tendency

Central tendency answers the question: where is the middle of your data? There are three measures, and each tells a different story. Choosing the wrong one leads to misleading summaries and broken model assumptions.

## Mean

The arithmetic mean is the sum of all values divided by the count. It is the most mathematically convenient measure because it is differentiable, which is why loss functions like Mean Squared Error use it. The mean is sensitive to outliers — a single extreme value pulls it significantly. If your dataset has outliers you have not yet handled, the mean is not a trustworthy centre.

```python
import numpy as np
data = [10, 12, 11, 13, 100]   # 100 is an outlier
print(np.mean(data))            # 29.2 — pulled far right
print(np.median(data))          # 12.0 — unaffected
```

## Median

The median is the middle value when data is sorted. For an even count, it is the average of the two central values. The median is robust to outliers and is the correct measure of centre for skewed distributions (income data, house prices, response times). When you impute missing values in a skewed feature, use the median, not the mean.

## Mode

The mode is the most frequently occurring value. It is the only measure applicable to categorical data. In a multimodal distribution (two peaks), neither mean nor median captures the structure — the mode does. Mode is also used in density estimation when identifying the most probable outcome.

## When to Use Which

| Situation | Use |
|-----------|-----|
| Symmetric, no outliers | Mean |
| Skewed distribution or outliers present | Median |
| Categorical data | Mode |
| Reporting model bias (systematic over/under prediction) | Mean error |
| Reporting typical user experience | Median response time |

## Relationship to ML

When you standardise a feature with `(x - mean) / std`, you are centring it using the mean. When you use `RobustScaler` in scikit-learn, you are centring with the median and scaling with the IQR — a deliberate choice for data with outliers.

```python
from sklearn.preprocessing import StandardScaler, RobustScaler
# StandardScaler uses mean — assumes no outliers
# RobustScaler uses median — robust to outliers
```

Proceed to `03_Measures_of_Dispersion.md`.
