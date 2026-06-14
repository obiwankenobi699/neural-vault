# Descriptive Statistics Part 2
Source: Session 39, DSMP 2023
Watch: https://www.youtube.com/watch?v=1ndVC500-EU
Dataset used in class: Titanic, custom marks dataset

## Percentiles

A percentile tells you what percentage of observations in a dataset fall below a particular value. This is different from a percentage score. If you scored 90 percentile in CAT it means 90 percent of all candidates scored below you — a statement about your relative position in the distribution, not about how many marks you got out of 100.

The p-th percentile is the value below which p percent of observations fall. The 50th percentile is the median. The 25th percentile means 25 percent of values are below this point.

To find the value at the p-th percentile: sort the data, then compute L = (P/100) times (n+1). If L is a whole number, that position's value is the answer. If L is a decimal, interpolate between the floor and ceiling positions.

Class example with 10 students' marks sorted as: 85, 88, 90, 91, 92, 93, 94, 96, 98, 100. To find the 75th percentile: L = 0.75 times 11 = 8.25. The 8th value is 96, the 9th is 98. Answer = 96 + 0.25 times (98 - 96) = 96.5.

```python
import numpy as np
data = [85, 88, 90, 91, 92, 93, 94, 96, 98, 100]
print(np.percentile(data, 75))   # 96.25
print(np.percentile(data, 50))   # 92.5 — the median
print(np.percentile(data, 25))   # 90.25
```

pandas describe() automatically gives the 25th, 50th, and 75th percentiles for every numerical column alongside count, mean, std, min, and max.

## Quartiles

Quartiles are percentiles at three specific positions. Q1 is the 25th percentile. Q2 is the 50th percentile (the median). Q3 is the 75th percentile. They divide the dataset into four equal parts of 25 percent each.

## Five Number Summary

The five number summary is: minimum, Q1, Q2 (median), Q3, maximum. These five statistics together describe the distribution of any numerical variable at a glance. This is exactly what pandas describe() outputs, with count, mean, and std added.

```python
import pandas as pd
df = pd.read_csv('titanic.csv')
print(df['Age'].describe())
```

## Interquartile Range

IQR = Q3 minus Q1. It represents the spread of the middle 50 percent of the data. Because it ignores the bottom 25 percent and the top 25 percent entirely, it is completely immune to outliers. Range is destroyed by one extreme value; IQR is not affected at all.

## Box Plot — Built from Scratch

Nitish builds the box plot manually in this session using the dataset: 281, 290, 314, 321, 350, 1500.

He calculates Q1, Q2, Q3 using the percentile formula step by step. IQR = Q3 - Q1. The whiskers extend to the lower fence (Q1 - 1.5 times IQR) and upper fence (Q3 + 1.5 times IQR). Any data point beyond the fences is plotted as an individual dot and treated as an outlier. In this example 1500 falls well beyond the upper fence and is shown as an outlier dot.

```python
import numpy as np
data = [281, 290, 314, 321, 350, 1500]
q1 = np.percentile(data, 25)
q3 = np.percentile(data, 75)
iqr = q3 - q1
lower_fence = q1 - 1.5 * iqr
upper_fence = q3 + 1.5 * iqr
outliers = [x for x in data if x < lower_fence or x > upper_fence]
print(f"Outliers: {outliers}")  # [1500]
```

The box plot communicates five things simultaneously: the centre (median line inside box), the spread of the middle 50 percent (box width = IQR), the full spread excluding outliers (whisker length), the presence and magnitude of outliers (dots), and skewness (if the median line is closer to Q1 the data is right-skewed; if closer to Q3 it is left-skewed).

```python
import seaborn as sns
# Single variable
sns.boxplot(x=df['Age'])
# Comparing across a categorical variable — bivariate analysis
sns.boxplot(x='Pclass', y='Age', data=df)
```

## Bivariate Analysis

Univariate analysis examines one variable at a time. Bivariate analysis examines the relationship between two variables simultaneously. In ML you care about relationships because features interact with each other and with the target variable.

For two numerical variables use a scatter plot. Plot one variable on x-axis, the other on y-axis. Each point represents one observation. Look for: upward trend (positive relationship), downward trend (negative relationship), or random scatter (no relationship).

## Covariance

Covariance measures how two variables change together. If both tend to increase together the covariance is positive. If one increases while the other decreases it is negative. The formula is the average of the products of deviations from their respective means.

The problem with raw covariance is that its magnitude depends on the scale of the variables. You cannot compare covariance across different pairs of features when the features are on different scales.

```python
print(df[['Age', 'Fare']].cov())
```

## Pearson Correlation Coefficient

Correlation solves the scale problem by dividing covariance by the product of the two standard deviations. The result is always between -1 and +1. A value of +1 means perfect positive linear relationship. Zero means no linear relationship. -1 means perfect negative linear relationship.

```python
print(df[['Age', 'Fare']].corr())
from scipy.stats import pearsonr
r, p_value = pearsonr(df['Age'].dropna(), df['Fare'].dropna())
```

The correlation heatmap using seaborn gives you all pairwise correlations at once. Dark red indicates strong positive correlation, dark blue indicates strong negative correlation.

```python
import seaborn as sns
import matplotlib.pyplot as plt
sns.heatmap(df.corr(), annot=True, cmap='coolwarm')
plt.show()
```

Nitish stresses: correlation does not imply causation. Ice cream sales and drowning deaths are positively correlated because both increase in summer. The common cause is hot weather, not the ice cream.

## ML Connection

The IQR outlier rule is standard in EDA pipelines before training linear models — outliers violate regression assumptions. Correlation matrices are used for feature selection: features with very high mutual correlation (above 0.95) are redundant and one can be dropped without loss of information. The covariance matrix is the direct input to PCA.

## Interview Questions

What does the 90th percentile mean? How is a box plot constructed? What does IQR measure and why is it better than range for outlier detection? What is the difference between covariance and correlation? Why can correlation be misleading when interpreting feature relationships?
