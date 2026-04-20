## Quantiles, Quartiles, Percentiles

| Term       | Splits into     | Key values                 |
| ---------- | --------------- | -------------------------- |
| Quantile   | Any equal group | Any cut point              |
| Quartile   | 4 parts         | Q1=25%, Q2=50%, Q3=75%     |
| Percentile | 100 parts       | P25=Q1, P50=Median, P75=Q3 |
| Decile     | 10 parts        | D1=10% … D9=90%            |

---

![[Boxplot.svg]]


## Percentile Formulas

**Finding the index (which position is the Pth percentile):**
$$i = \frac{P}{100} \times (n + 1)$$
- If $i$ is whole → that position's value is the answer  
- If $i$ is decimal → interpolate: value at floor(i) + fraction × (next − current)

**Finding what percentile a value is at:**
$$P = \frac{x + 0.5y}{n} \times 100$$
- $x$ = number of values **below** the score  
- $y$ = number of values **equal** to the score  
- $n$ = total count

---

## 5-Number Summary

For data: `4, 7, 8, 12, 15, 17, 19, 22, 28, 95`

| Stat      | Value | Meaning         |
| --------- | ----- | --------------- |
| Min       | 4     | Smallest value  |
| Q1        | 8.75  | 25th percentile |
| Median Q2 | 16    | 50th percentile |
| Q3        | 21.75 | 75th percentile |
| Max       | 95    | Largest value   |

---

## IQR — Interquartile Range

$$\text{IQR} = Q3 - Q1$$

**Why not just use Range?**
- Range = max − min → destroyed by one outlier
- IQR only looks at the **middle 50%** → outlier-resistant

**Outlier fences (Tukey's rule):**
$$\text{Lower fence} = Q1 - 1.5 \times \text{IQR}$$
$$\text{Upper fence} = Q3 + 1.5 \times \text{IQR}$$

Any value outside these fences = **outlier** (shown as a dot in boxplot)

---

## Boxplot — What Each Part Means

```
      |----[======|=====]----| o
   wMin   Q1    Med   Q3  wMax  outlier
          |<-- IQR = 50% -->|
```

| Part           | Meaning                     |
| -------------- | --------------------------- |
| Bottom whisker | Min within lower fence      |
| Box bottom     | Q1 (25th percentile)        |
| Line in box    | Median Q2 (50th percentile) |
| Box top        | Q3 (75th percentile)        |
| Top whisker    | Max within upper fence      |
| Box height     | IQR                         |
| Dots outside   | Outliers                    |

**The box = centre 50% of data. That's why it's robust.**

---

## Seaborn Boxplot

```python
import seaborn as sns

sns.boxplot(data=df, x='category', y='value')

sns.boxplot(data=df, x='category', y='value',
            orient='v',        # or 'h' for horizontal
            hue='gender',      # group by colour
            notch=True,        # show confidence interval notch
            showfliers=False,  # hide outlier dots
            width=0.5)
```


## Quantiles, Quartiles, Percentiles

| Term | Splits into | Key values |
|---|---|---|
| Quantile | Any equal group | Any cut point |
| Quartile | 4 parts | Q1=25%, Q2=50%, Q3=75% |
| Percentile | 100 parts | P25=Q1, P50=Median, P75=Q3 |
| Decile | 10 parts | D1=10% … D9=90% |

---

## Percentile Formulas

**Finding the index (which position is the Pth percentile):**
$$i = \frac{P}{100} \times (n + 1)$$
- If $i$ is whole → that position's value is the answer  
- If $i$ is decimal → interpolate: value at floor(i) + fraction × (next − current)

**Finding what percentile a value is at:**
$$P = \frac{x + 0.5y}{n} \times 100$$
- $x$ = number of values **below** the score  
- $y$ = number of values **equal** to the score  
- $n$ = total count

---

## 5-Number Summary

For data: `4, 7, 8, 12, 15, 17, 19, 22, 28, 95`

| Stat | Value | Meaning |
|---|---|---|
| Min | 4 | Smallest value |
| Q1 | 8.75 | 25th percentile |
| Median Q2 | 16 | 50th percentile |
| Q3 | 21.75 | 75th percentile |
| Max | 95 | Largest value |

---

## IQR — Interquartile Range

$$\text{IQR} = Q3 - Q1$$

**Why not just use Range?**
- Range = max − min → destroyed by one outlier
- IQR only looks at the **middle 50%** → outlier-resistant

**Outlier fences (Tukey's rule):**
$$\text{Lower fence} = Q1 - 1.5 \times \text{IQR}$$
$$\text{Upper fence} = Q3 + 1.5 \times \text{IQR}$$

Any value outside these fences = **outlier** (shown as a dot in boxplot)

---

## Boxplot — What Each Part Means

```
      |----[======|=====]----| o
   wMin   Q1    Med   Q3  wMax  outlier
          |<-- IQR = 50% -->|
```

| Part | Meaning |
|---|---|
| Bottom whisker | Min within lower fence |
| Box bottom | Q1 (25th percentile) |
| Line in box | Median Q2 (50th percentile) |
| Box top | Q3 (75th percentile) |
| Top whisker | Max within upper fence |
| Box height | IQR |
| Dots outside | Outliers |

**The box = centre 50% of data. That's why it's robust.**

---

## Seaborn Boxplot

```python
import seaborn as sns

sns.boxplot(data=df, x='category', y='value')

sns.boxplot(data=df, x='category', y='value',
            orient='v',        # or 'h' for horizontal
            hue='gender',      # group by colour
            notch=True,        # show confidence interval notch
            showfliers=False,  # hide outlier dots
            width=0.5)
```




## Quantiles, Quartiles, Percentiles

| Term | Splits into | Key values |
|---|---|---|
| Quantile | Any equal group | Any cut point |
| Quartile | 4 parts | Q1=25%, Q2=50%, Q3=75% |
| Percentile | 100 parts | P25=Q1, P50=Median, P75=Q3 |
| Decile | 10 parts | D1=10% … D9=90% |

---

## Percentile Formulas

**Finding the index (which position is the Pth percentile):**
$$i = \frac{P}{100} \times (n + 1)$$
- If $i$ is whole → that position's value is the answer  
- If $i$ is decimal → interpolate: value at floor(i) + fraction × (next − current)

**Finding what percentile a value is at:**
$$P = \frac{x + 0.5y}{n} \times 100$$
- $x$ = number of values **below** the score  
- $y$ = number of values **equal** to the score  
- $n$ = total count

---

## 5-Number Summary

For data: `4, 7, 8, 12, 15, 17, 19, 22, 28, 95`

| Stat | Value | Meaning |
|---|---|---|
| Min | 4 | Smallest value |
| Q1 | 8.75 | 25th percentile |
| Median Q2 | 16 | 50th percentile |
| Q3 | 21.75 | 75th percentile |
| Max | 95 | Largest value |

---

## IQR — Interquartile Range

$$\text{IQR} = Q3 - Q1$$

**Why not just use Range?**
- Range = max − min → destroyed by one outlier
- IQR only looks at the **middle 50%** → outlier-resistant

**Outlier fences (Tukey's rule):**
$$\text{Lower fence} = Q1 - 1.5 \times \text{IQR}$$
$$\text{Upper fence} = Q3 + 1.5 \times \text{IQR}$$

Any value outside these fences = **outlier** (shown as a dot in boxplot)

---

## Boxplot — What Each Part Means

```
      |----[======|=====]----| o
   wMin   Q1    Med   Q3  wMax  outlier
          |<-- IQR = 50% -->|
```

| Part | Meaning |
|---|---|
| Bottom whisker | Min within lower fence |
| Box bottom | Q1 (25th percentile) |
| Line in box | Median Q2 (50th percentile) |
| Box top | Q3 (75th percentile) |
| Top whisker | Max within upper fence |
| Box height | IQR |
| Dots outside | Outliers |

**The box = centre 50% of data. That's why it's robust.**

---

## Seaborn Boxplot

```python
import seaborn as sns

sns.boxplot(data=df, x='category', y='value')

sns.boxplot(data=df, x='category', y='value',
            orient='v',        # or 'h' for horizontal
            hue='gender',      # group by colour
            notch=True,        # show confidence interval notch
            showfliers=False,  # hide outlier dots
            width=0.5)
```




![[percentil.png]]