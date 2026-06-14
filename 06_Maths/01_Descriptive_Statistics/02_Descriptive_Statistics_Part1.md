# Descriptive Statistics Part 1
Source: Session 38, DSMP 2023
Watch: https://www.youtube.com/watch?v=Uv3Blie7F3g
Dataset used in class: Titanic

## Population vs Sample

The population is the entire group you want to study. The sample is the subset you actually collect and analyse. When Nitish wants to find the average age of his 77,000 YouTube subscribers, he cannot survey all of them. He takes the students present in the live class as a sample and calculates from that.

Three properties a good sample must have. First, it must be large enough — a sample of five people cannot represent a population of thousands. Second, it must be random — no bias in selection. Third, it must be representative — every variation present in the population must appear proportionally in the sample. For studying India's salary distribution this means including every state, both genders, every age group, every income class.

Population mean is denoted mu. Sample mean is denoted x-bar. These are different symbols because the two values will generally differ. The formula structure is the same but you must be mindful of which one you are computing.

## Types of Data

Data type determines which statistical measures and which graphs are valid. Getting this wrong leads to meaningless analysis.

Categorical data (qualitative) has two subtypes. Nominal data has categories with no natural ordering — gender (male/female), city name, blood group. You cannot say one category is greater than another. Ordinal data has categories with a meaningful order — customer satisfaction (poor/average/good/excellent), education level (10th/12th/graduate/postgraduate). The order matters but the gap between levels is not uniform or measurable.

Numerical data (quantitative) also has two subtypes. Discrete data takes only integer values — number of passengers on a ship, number of goals in a match, age in whole years. Continuous data can take any value including decimals — height (5.7 ft), weight (68.3 kg), fare paid (7.2500).

Titanic dataset examples. The Age column is numerical discrete. The Fare column is numerical continuous. The Sex column is categorical nominal. The Pclass column is categorical ordinal because class 1 is above class 2 which is above class 3.

## Measures of Central Tendency

Central tendency answers: where is the middle of this data? Three measures exist and each tells a different story.

Mean is the arithmetic average. Sum all values and divide by count. Nitish's formula for population mean uses capital N in the denominator and is written with mu. Sample mean uses lowercase n and is written with x-bar. The critical flaw of mean is sensitivity to outliers. Nitish's classroom salary example: most students got placements of 30,000 rupees per month. One student started a startup and is earning one crore per month. The mean salary of the class is now around 20 lakh — a completely misleading number that represents no one in the class. Whenever your data has outliers, mean cannot be trusted.

```python
import numpy as np
salaries = [30000, 28000, 32000, 29000, 10000000]
print(np.mean(salaries))    # ~2,023,800 — pulled far right by outlier
print(np.median(salaries))  # 30000 — represents the actual typical student
```

Median is the middle value of sorted data. For odd count, it is the exact middle element. For even count, it is the average of the two central elements. Median is completely robust to outliers. In the salary example the crore-earning outlier has zero effect on the median. Use median whenever data is skewed or contains outliers — income data, house prices, response times.

Mode is the most frequently occurring value. It is the only measure applicable to categorical data. For the Titanic Pclass column, mode tells you the most common class (which is 3rd class). A bimodal distribution — one with two peaks — signals that two distinct subgroups may exist in your data.

Weighted mean assigns different importance to different observations. Formula: sum of (value times weight) divided by sum of weights. Used when theory marks and practical marks contribute different percentages to the final grade.

```python
theory_marks = 70
practical_marks = 80
weighted_mean = (theory_marks * 0.6 + practical_marks * 0.4)  # = 74
# Simple mean would give 75 — wrong answer
```

## Measures of Dispersion

Two datasets can have the same mean but completely different behaviour. Dispersion measures how spread out the data is.

Range is maximum minus minimum. Simple but dominated entirely by outliers.

Variance is the average of squared deviations from the mean. Squaring serves two purposes: it makes all deviations positive, and it amplifies large deviations. Population variance divides by N. Sample variance divides by n-1 (Bessel's correction — sample variance tends to underestimate population variance, dividing by n-1 corrects for this bias).

```python
data = [2, 4, 4, 4, 5, 5, 7, 9]
print(np.var(data))          # population variance: 4.0
print(np.var(data, ddof=1))  # sample variance: 4.571
```

Standard deviation is the square root of variance. It brings the measure back to the original unit — if data is in kilograms, standard deviation is also in kilograms. Variance in kg-squared is hard to interpret directly.

```python
print(np.std(data))          # population std dev: 2.0
print(np.std(data, ddof=1))  # sample std dev: 2.138
```

Coefficient of Variation normalises spread relative to the mean: CV = (std dev / mean) times 100. Allows comparing variability across datasets with different units or different scales. One company pays in rupees, another in dollars — CV makes their salary variability comparable.

## ML Connection

StandardScaler uses mean and standard deviation: z = (x - mean) / std. Every time you normalise a feature, you are applying mean and standard deviation. RobustScaler uses median and IQR instead — the correct choice when your data has outliers. Data types determine preprocessing: categorical columns go to OneHotEncoder or OrdinalEncoder, numerical columns go to scalers. Mixing them up breaks pipelines silently.

## Interview Questions

What is the difference between population and sample? What are the conditions for a good sample? When would you use median instead of mean? What is the difference between discrete and continuous data? Why does sample variance use n-1 instead of n?
