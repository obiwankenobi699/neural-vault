
## Covariance & Correlation

---

### The Problem Variance Couldn't Solve

Variance squares the distance: $(-1)^2 = (+1)^2 = 1$

So the pair $(-1, -1)$ and the pair $(-1, +1)$ look identical to variance — but they are completely different. In the first case both variables deviate the same way (both below mean). In the second, they deviate opposite ways.

**Fix:** multiply the deviations together instead of squaring.

$(x - \bar{x}) \times (y - \bar{y})$

- Both same direction → product is **positive**
- Opposite directions → product is **negative**

This gives us covariance.

---

### Covariance Formula

$$\text{Cov}(x,y) = \frac{\sum_{i=1}^{n}(x_i - \bar{x})(y_i - \bar{y})}{n}$$

**The 4-quadrant logic:**

| Quadrant | x deviation | y deviation | Product | Meaning |
|---|---|---|---|---|
| Q1 top-right | + | + | **+** | Both above mean |
| Q2 top-left | − | + | **−** | X down, Y up |
| Q3 bottom-left | − | − | **+** | Both below mean |
| Q4 bottom-right | + | − | **−** | X up, Y down |

- Cov > 0 → Positive relationship (Q1 and Q3 dominate)
- Cov < 0 → Negative relationship (Q2 and Q4 dominate)
- Cov ≈ 0 → No linear relationship

**Disadvantage of Covariance:** tells direction but not strength. Also changes with units — if you measure in cm vs metres, Cov changes. Not comparable across datasets.

---

### Worked Example — Study Hours (x) vs Marks (y)

| Student | x | y | x − x̄ | y − ȳ | (x−x̄)(y−ȳ) | (x−x̄)² | (y−ȳ)² |
|---|---|---|---|---|---|---|---|
| A | 2 | 40 | −3.83 | −22.5 | +86.25 | 14.67 | 506.25 |
| B | 3 | 50 | −2.83 | −12.5 | +35.42 | 8.01 | 156.25 |
| C | 5 | 60 | −0.83 | −2.5 | +2.08 | 0.69 | 6.25 |
| D | 6 | 65 | +0.17 | +2.5 | +0.42 | 0.03 | 6.25 |
| E | 8 | 75 | +2.17 | +12.5 | +27.08 | 4.71 | 156.25 |
| F | 9 | 85 | +3.17 | +22.5 | +71.25 | 10.05 | 506.25 |
| **Sum** | | | | | **222.5** | **38.17** | **1337.5** |

$\bar{x} = 5.5,\quad \bar{y} = 62.5$

$$\text{Cov} = \frac{222.5}{6} = 37.08$$

$$\sigma_x = \sqrt{\frac{38.17}{6}} = 2.52, \quad \sigma_y = \sqrt{\frac{1337.5}{6}} = 14.93$$

$$r = \frac{37.08}{2.52 \times 14.93} = \frac{37.08}{37.62} \approx 0.986$$

Very strong positive correlation.

---

### Correlation Formula (Pearson's r)

$$r = \frac{\text{Cov}(x,y)}{\sigma_x \cdot \sigma_y}$$

**Range:** $-1 \leq r \leq +1$

| Value        | Meaning                 |
| ------------ | ----------------------- |
| +1           | Perfect positive linear |
| +0.7 to +1   | Strong positive         |
| +0.3 to +0.7 | Moderate positive       |
| 0            | No linear relationship  |
| −0.3 to −0.7 | Moderate negative       |
| −1           | Perfect negative linear |

**Advantages over covariance:**
- Unit-free (scale doesn't affect it)
- Tells both direction AND strength
- Always comparable between datasets

---

### Covariance vs Correlation

| | Covariance | Correlation |
|---|---|---|
| Range | −∞ to +∞ | −1 to +1 |
| Tells direction | Yes | Yes |
| Tells strength | No | Yes |
| Affected by scale | Yes | No |
| Unit | x-unit × y-unit | None |

---

### Correlation ≠ Causation

**Case study: Ice cream sales vs Homicide rate**

Both go up in summer → r ≈ +0.85. Strong positive correlation!

But ice cream does NOT cause homicides.

```
Ice cream sales  ←  Hot weather  →  More people outside → more conflict
```

**Hot weather** is the **confounding variable** (hidden cause). It independently drives both variables up. This is a **spurious correlation** — the correlation is real, but the causal link is fake.

**Causation** = one thing directly causes another (cause → effect)  
**Correlation** = two things move together — could be due to a hidden third variable

---

### Seaborn Graphs for Correlation

```python
import seaborn as sns

sns.scatterplot(data=df, x='hours', y='marks')

sns.regplot(data=df, x='hours', y='marks')

sns.pairplot(data=df)

sns.heatmap(df.corr(), annot=True, cmap='coolwarm', vmin=-1, vmax=1)
```

![[corelation.png]]