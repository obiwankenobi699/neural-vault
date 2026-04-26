# 

---

## 1. Random Variable vs Normal Variable

||Normal Variable|Random Variable|
|---|---|---|
|Value|Fixed, known|Uncertain, many possible values|
|Example|x = 5|X = dice roll outcome|
|Notation|lowercase x|Capital X|
|Before experiment|Known|Unknown|
|After experiment|Same|Revealed|

### Two Types of Random Variable

**Discrete RV** — countable outcomes. Can list them all.

- Dice: X ∈ {1,2,3,4,5,6}
- Coin flips: X ∈ {0,1,2,...}

**Continuous RV** — infinite values in a range. Cannot list.

- Height: X ∈ [150, 210] (any decimal possible)
- Temperature, time, weight

---

## 2. Mapping Outcomes to Probabilities

A probability distribution = a function that maps every outcome to a probability.

**Dice example (D6):**

|Outcome|Probability|Random Variable|
|---|---|---|
|Face = 1|1/6|X=1, P=0.167|
|Face = 2|1/6|X=2, P=0.167|
|Face = 3|1/6|X=3, P=0.167|
|Face = 4|1/6|X=4, P=0.167|
|Face = 5|1/6|X=5, P=0.167|
|Face = 6|1/6|X=6, P=0.167|

Total = 6 × (1/6) = **1.0** (must always sum to 1)

---

## 3. Probability Distribution Overview

```
                        RANDOM VARIABLE (X)
                               |
              .────────────────┴────────────────.
              │                                 │
         DISCRETE X                        CONTINUOUS X
              │                                 │
             PMF                               PDF
        p(x) = P(X=x)                    f(x) = density
              │                                 │
    Exact probabilities              Area under curve = probability
       Σ p(x) = 1                        ∫ f(x) dx = 1
              │                                 │
        Example: Dice                  Example: CGPA, Height
                                                │
                               .────────────────┴────────────────.
                               │                                 │
                         Parametric PDF                         KDE
                         (assume shape)                   (data-driven)
                               │                                 │
                        norm.pdf(x, μ, σ)             Smooth from samples
                        (Normal dist)                  No assumption
                               │                                 │
                    Fast, clean                      Flexible, realistic
                    Assumption needed                Bandwidth sensitive
```

---

## 4. PMF — Probability Mass Function

For **discrete** random variables only.

$$P(X = x) = f(x)$$

- Gives **exact probability** of each specific value
- All probabilities must sum to 1: Σ P(X=x) = 1
- Graph: bar chart (one bar per outcome)

**Dice D6:** P(X=4) = 1/6 ≈ 0.167

```
  PMF of a Fair Dice (D6)
  P(X=x)
  0.20 |
       |  ██  ██  ██  ██  ██  ██
  0.17 | ─██──██──██──██──██──██─
       |  ██  ██  ██  ██  ██  ██
  0.10 |  ██  ██  ██  ██  ██  ██
       |  ██  ██  ██  ██  ██  ██
  0.00 +──┴───┴───┴───┴───┴───┴──
         1   2   3   4   5   6   x
  
  Each bar is exactly 1/6 — uniform distribution.
  No bar is taller than others. Σ = 1.0
```

---

## 5. PDF — Probability Density Function

For **continuous** random variables only.

$$f(x) = \text{probability density at } x \quad \text{(NOT the probability itself)}$$

$$P(a \leq X \leq b) = \int_a^b f(x),dx = \text{area under curve from } a \text{ to } b$$

- P(X = exact value) = 0 always (a single point has zero area)
- Total area under curve = 1
- Graph: smooth curve (bell curve for normal distribution)

**Normal PDF formula:** $$f(x) = \frac{1}{\sigma\sqrt{2\pi}} \cdot e^{-\frac{(x-\mu)^2}{2\sigma^2}}$$

```
  PDF — Normal Distribution (Bell Curve)
  f(x)
       |           .─────.
  0.40 |         .´       `.
       |        /           \
  0.25 |       /             \
       |      /               \
  0.10 |    ./                 \.
       |  .´                     `.
  0.00 +──┴─────────────────────────┴──
        -3   -2   -1    0    1    2    3   x
                         μ
  
  Shaded area between two points = probability.
  Total area under entire curve = 1.
  At any single point, probability = 0.
```

---

## 6. CDF — Cumulative Distribution Function

Works for **both** discrete and continuous.

$$F(x) = P(X \leq x)$$

- Gives probability of being at most x
- Always increases from 0 to 1
- Never decreases

**Dice D6:** $$F(3) = P(X \leq 3) = 3/6 = 0.5 \qquad F(6) = 1.0$$

```
  CDF — Discrete (Staircase)        CDF — Continuous (S-curve)
  F(x)                              F(x)
  1.0 |               ┌──           1.0 |                   .────
      |           ┌───┘                 |                .─´
  0.7 |       ┌───┘                 0.5 |             .─´
      |   ┌───┘                         |          .─´
  0.3 |───┘                         0.0 +──────.─´─────────────
      +───┴───┴───┴───┴───┴───┴──       +──────────────────────
        1   2   3   4   5   6               μ-3  μ  μ+3     x
  
  Each step up = +1/6 for fair dice.   Smooth S-shape for continuous.
```

---

## 7. Parameters of a Probability Distribution

|Parameter|Symbol|Meaning|Dice D6|
|---|---|---|---|
|Mean / Expected value|μ = E[X]|Centre, long-run average|3.5|
|Variance|σ²|Average squared deviation from mean|2.917|
|Standard deviation|σ|Spread in same units as X|1.708|
|Skewness|γ₁|Asymmetry (0 = symmetric)|0|
|Kurtosis|γ₂|Tail heaviness (3 = normal)|1.73|
|Support|x ∈ ?|All possible values X can take|{1,2,3,4,5,6}|

**Discrete Uniform (dice with n sides):** $$\mu = \frac{n+1}{2} \qquad \sigma^2 = \frac{n^2-1}{12}$$

---

## 8. PMF vs PDF vs CDF — Quick Reference

||PMF|PDF|CDF|
|---|---|---|---|
|For|Discrete|Continuous|Both|
|Output|Exact P(X=x)|Density (not prob)|P(X ≤ x)|
|Output range|0 to 1|0 to ∞|0 to 1|
|Sums / integrates to|1|1 (area)|F(∞) = 1|
|Graph|Bar chart|Smooth curve|Staircase / S-curve|
|Example question|P(dice = 4)?|P(165 ≤ height ≤ 175)?|P(dice ≤ 4)?|

---

## 9. Discrete Distributions — PMF

### 9.1 Bernoulli Distribution

Single trial, two outcomes: success (1) or failure (0).

$$P(X=x) = p^x (1-p)^{1-x} \quad x \in {0,1}$$

$$\mu = p \qquad \sigma^2 = p(1-p)$$

Example: one coin toss (heads = 1, tails = 0), p = 0.5

```
  Bernoulli PMF (p = 0.7)
  P(X=x)
  0.70 |            ██
       |            ██
  0.30 |  ██        ██
       |  ██        ██
  0.00 +──┴─────────┴──
         x=0       x=1
  
  Only two bars. P(0) = 1-p, P(1) = p. Sum = 1.
```

---

### 9.2 Binomial Distribution

Number of successes in n independent Bernoulli trials.

$$P(X=k) = \binom{n}{k} p^k (1-p)^{n-k} \quad k = 0,1,...,n$$

$$\mu = np \qquad \sigma^2 = np(1-p)$$

Example: number of heads in 10 coin tosses

```
  Binomial PMF (n=10, p=0.5)
  P(X=k)
  0.25 |           ██ ██
       |        ██ ██ ██ ██
  0.15 |     ██ ██ ██ ██ ██ ██
       |  ██ ██ ██ ██ ██ ██ ██ ██
  0.05 | ─██─██─██─██─██─██─██─██─██─██─
       |  ██ ██ ██ ██ ██ ██ ██ ██ ██ ██
  0.00 +──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──
         0  1  2  3  4  5  6  7  8  9  10   k
  
  Bell-shaped when p=0.5. Peak at k = n*p = 5.
  Skews right when p < 0.5, left when p > 0.5.
```

---

### 9.3 Poisson Distribution

Count of events occurring in a fixed interval when events happen at a constant rate λ.

$$P(X=k) = \frac{\lambda^k e^{-\lambda}}{k!} \quad k = 0,1,2,...$$

$$\mu = \lambda \qquad \sigma^2 = \lambda$$

Example: number of calls arriving per minute (λ = 3)

```
  Poisson PMF (λ = 3)
  P(X=k)
  0.25 |       ██
       |    ██ ██ ██
  0.15 |    ██ ██ ██ ██
       | ██ ██ ██ ██ ██ ██
  0.05 | ██ ██ ██ ██ ██ ██ ██ ──
       | ██ ██ ██ ██ ██ ██ ██ ██ ██ ..
  0.00 +──┴──┴──┴──┴──┴──┴──┴──┴──┴──
         0  1  2  3  4  5  6  7  8     k
  
  Peak at k = λ. Right-skewed tail extends to infinity.
  Mean = Variance = λ (unique property).
```

---

### 9.4 Geometric Distribution

Number of trials until the first success.

$$P(X=k) = (1-p)^{k-1} p \quad k = 1,2,3,...$$

$$\mu = \frac{1}{p} \qquad \sigma^2 = \frac{1-p}{p^2}$$

Example: number of tosses until first head (p = 0.5)

```
  Geometric PMF (p = 0.5)
  P(X=k)
  0.50 | ██
       | ██
  0.25 | ██ ██
       | ██ ██
  0.12 | ██ ██ ██
  0.06 | ██ ██ ██ ██
  0.03 | ██ ██ ██ ██ ██
  0.00 +──┴──┴──┴──┴──┴──...
         1  2  3  4  5       k
  
  Always decreasing. Every bar is (1-p) times the bar before it.
  Memoryless — past failures do not affect future probability.
```

---

### 9.5 Negative Binomial Distribution

Number of trials needed to get exactly r successes.

$$P(X=k) = \binom{k-1}{r-1} p^r (1-p)^{k-r} \quad k = r, r+1,...$$

$$\mu = \frac{r}{p} \qquad \sigma^2 = \frac{r(1-p)}{p^2}$$

Example: trials until 3rd heads (r=3, p=0.5)

```
  Negative Binomial PMF (r=3, p=0.5)
  P(X=k)
       |          ██ ██
  0.20 |       ██ ██ ██ ██
       |       ██ ██ ██ ██ ██
  0.10 |    ██ ██ ██ ██ ██ ██ ██
       |    ██ ██ ██ ██ ██ ██ ██ ██
  0.00 +────┴──┴──┴──┴──┴──┴──┴──┴──...
            3  4  5  6  7  8  9  10   k
  
  Starts at k=r (minimum trials to get r successes).
  Generalization of Geometric (which is r=1).
```

---

## 10. Continuous Distributions — PDF

### 10.1 Normal Distribution

Symmetric bell curve. Most common distribution in nature.

$$f(x) = \frac{1}{\sigma\sqrt{2\pi}} e^{-\frac{(x-\mu)^2}{2\sigma^2}}$$

$$\mu = \mu \qquad \sigma^2 = \sigma^2$$

Example: height, exam marks, measurement errors

```
  Normal PDF — Effect of changing μ and σ
  
  Same σ, different μ:            Same μ, different σ:
  f(x)                            f(x)
       |    .─.   .─.                  |      .─.
       |  .´   `.´   `.                |    .´   `.      σ small
       | /         \                   |  ./       \.
       |/             \                | /           \    σ large
  ─────+───────────────────            ─+─────────────────
       μ₁    μ₂    μ₃                        μ
  
  Shifting μ moves curve left/right.    Larger σ = wider and flatter.
  Shape stays same.                     Smaller σ = taller and narrower.
  
  68-95-99.7 Rule:
  
  f(x)
       |         .─────.
       |       .´░░░░░░░`.          ░ = 68% within ±1σ
       |      /░░░▓▓▓▓▓░░░\         ▓ = 95% within ±2σ (includes ░)
       |    ./░░░░▓▓▓▓▓▓░░░░\.      ▒ = 99.7% within ±3σ
       |  .´░░░░░▓▓▓▓▓▓▓░░░░░`.
  ─────+──┴─────────────────────┴──
       μ-3σ  μ-2σ  μ-σ  μ  μ+σ  μ+2σ  μ+3σ
```

---

### 10.2 Uniform Distribution

Every value in the interval [a, b] is equally likely.

$$f(x) = \frac{1}{b-a} \quad \text{for } a \leq x \leq b, \quad 0 \text{ otherwise}$$

$$\mu = \frac{a+b}{2} \qquad \sigma^2 = \frac{(b-a)^2}{12}$$

Example: random number generator output in [0, 1]

```
  Uniform PDF [a, b]
  f(x)
       |
  1/(b-a)|  ┌────────────────┐
       |  │                │
       |  │                │
  0.00 +──┴────────────────┴──────
          a                b       x
  
  Flat rectangle. No value is more likely than any other.
  Area = width × height = (b-a) × 1/(b-a) = 1. ✓
```

---

### 10.3 Exponential Distribution

Time between events in a Poisson process. Models waiting time.

$$f(x) = \lambda e^{-\lambda x} \quad x \geq 0$$

$$\mu = \frac{1}{\lambda} \qquad \sigma^2 = \frac{1}{\lambda^2}$$

Example: time until next customer arrives (λ = rate of arrivals)

```
  Exponential PDF — different λ values
  f(x)
       |
  λ    |\ λ=2
       | \
       |  \  λ=1
       |   \.
       |    `\. λ=0.5
       |      `──.
  0.00 +──────────`──.────────────
          0    1    2    3    4    x
  
  Higher λ = steeper drop = shorter average waiting time.
  Always starts at λ and decays toward zero.
  Memoryless: past waiting time does not affect future.
```

---

### 10.4 Gamma Distribution

Generalization of exponential. Models time until k-th event.

$$f(x) = \frac{\lambda^k x^{k-1} e^{-\lambda x}}{(k-1)!} \quad x \geq 0$$

$$\mu = \frac{k}{\lambda} \qquad \sigma^2 = \frac{k}{\lambda^2}$$

Example: total time to serve 3 customers when service rate λ is known

```
  Gamma PDF — different shape k (λ=1)
  f(x)
       |
  1.0  |\ k=1 (exponential)
       | \
  0.5  |  `──. k=2
       |      `──.  k=4
  0.2  |          `──── .─────.   k=7
       |                        `──────────.
  0.00 +────────────────────────────────────────
          0    2    4    6    8   10   12    x
  
  k=1 is identical to Exponential.
  As k increases, curve becomes more bell-shaped and shifts right.
  Peak moves to x = (k-1)/λ.
```

---

### 10.5 Beta Distribution

Values constrained between 0 and 1. Models probabilities and proportions.

$$f(x) = \frac{x^{\alpha-1}(1-x)^{\beta-1}}{B(\alpha,\beta)} \quad 0 \leq x \leq 1$$

$$\mu = \frac{\alpha}{\alpha+\beta} \qquad \sigma^2 = \frac{\alpha\beta}{(\alpha+\beta)^2(\alpha+\beta+1)}$$

Example: modelling the probability that a test has p% pass rate

```
  Beta PDF — different α and β
  f(x)
       |
       |     α=5,β=5         α=2,β=5     α=5,β=2
       |       .─.          .─.              .─.
       |      / │ \        /   `.          .´   \
       |     /  │  \      /     `.        .´     \
       |    /   │   \    /        `.    .´         \
  ─────+───┴────┴────┴──┴──────────┴──┴─────────────
          0    0.5    1   0    0.5    1   0    0.5    1   x
  
  α=β → symmetric, peak at 0.5.
  α > β → skews right (peak closer to 1).
  α < β → skews left (peak closer to 0).
  α=1,β=1 → flat Uniform[0,1].
```

---

## 11. Distribution Shape Comparison — ASCII

```
  PMF shapes (Discrete)
  ─────────────────────────────────────────────────────────

  Bernoulli        Binomial          Poisson         Geometric
  (n=1)            (n=10,p=0.5)      (λ=3)           (p=0.4)

  █                   █ █            █               █
  █   █            █ █ █ █ █        █ █             █ █
  █   █          █ █ █ █ █ █ █    █ █ █ █          █ █ █
  ─────          ─────────────    ─────────        ──────...
  0   1          0 1 2 3 4 5 6    0 1 2 3 4        1 2 3 4

  PDF shapes (Continuous)
  ─────────────────────────────────────────────────────────

  Uniform          Normal            Exponential     Gamma(k=4)
  [a,b]            (μ,σ)             (λ)             (k,λ)

  ┌──────┐            .─.           |\                .─.
  │      │          .´   `.         | \             .´   `.
  │      │         /       \        |  \           /       \
  │      │        /         \       |   `──.      /         \
  └──────┘       /           \      |       `──. /           `.
  ─────────   ───────────────────   ──────────────────────────
  a      b    μ-3σ   μ   μ+3σ       0   1   2   0   2   4   6
```

---

## 12. Counting vs Measuring Memory Trick

```
  COUNTING things?                   MEASURING things?
         │                                  │
   Discrete RV                        Continuous RV
         │                                  │
        PMF                               PDF
         │                                  │
  ┌──────┴───────────┐            ┌─────────┴─────────────┐
  │  Bernoulli        │            │  Normal                │
  │  Binomial         │            │  Uniform               │
  │  Poisson          │            │  Exponential           │
  │  Geometric        │            │  Gamma                 │
  │  Neg. Binomial    │            │  Beta                  │
  └───────────────────┘            └───────────────────────┘
  
  Examples of counting:             Examples of measuring:
  - Heads in 10 tosses              - Height of a person
  - Calls per minute                - Time until next arrival
  - Defective items in batch        - CGPA score
  - Goals in a football match       - Temperature reading
```

---

## 13. KDE — Kernel Density Estimation

When you have real data and do not want to assume a shape, KDE estimates the PDF from the data directly.

```
  How KDE works:
  
  Step 1 — Raw data points:
  
  x-axis: ──.──────.──.────.──────.────.──────────
               x₁   x₂ x₃   x₄     x₅   x₆

  Step 2 — Place a small bell (kernel) on each point:
  
           .─.     .─. .─.   .─.     .─.   .─.
          /   \   /   X   \ /   \   /   \ /   \
         /     \ /         X     \ /     X     \

  Step 3 — Add all kernels together → smooth curve:
  
         .─────────────────────────────────────.
       .´                                       `.
      /      peak where data is dense             \
  ───/──────────────────────────────────────────────\───
  
  Result: smooth PDF estimate. No assumption about shape.
  Bandwidth controls how smooth: small bw = spiky, large bw = oversmoothed.
```

---

## 14. Code Reference

### PMF — Discrete (Dice)

```python
import numpy as np
import matplotlib.pyplot as plt

dice = np.array([1,2,3,4,5,6]*6)
vals, counts = np.unique(dice, return_counts=True)

plt.bar(vals, counts / counts.sum())
plt.xlabel("Dice Value")
plt.ylabel("Probability")
plt.title("PMF — Fair Dice")
plt.show()
```

### PDF via KDE — Continuous (CGPA)

```python
import seaborn as sns

cgpa = np.array([8.1, 7.5, 9.0, 8.7, 6.9, 7.8, 8.3, 9.2,
                 7.1, 8.9, 6.5, 7.2, 8.0, 9.5, 7.6, 8.4])

sns.histplot(cgpa, kde=True, stat="density", bins=8)
plt.xlabel("CGPA")
plt.ylabel("Density")
plt.title("PDF — KDE on CGPA")
plt.show()
```

### PDF via Normal — Parametric

```python
from scipy.stats import norm

mean = np.mean(cgpa)
std  = np.std(cgpa)

x = np.linspace(min(cgpa), max(cgpa), 200)
plt.plot(x, norm.pdf(x, mean, std))
plt.title("Normal PDF Fit on CGPA")
plt.show()
```

### One-liner KDE

```python
sns.kdeplot(cgpa)
```

---

## 15. Quick Decision Table

|Data type|Use|Graph|
|---|---|---|
|Discrete, exact counts|PMF|Bar chart|
|Continuous, data available|KDE|Smooth curve|
|Continuous, assume Normal|norm.pdf|Bell curve|
|Cumulative probability|CDF|Staircase / S-curve|
|Both discrete and continuous|CDF|Always valid|

---

## 16. All Distributions — One Page Summary

|Distribution|Type|Parameters|Mean|Variance|Use case|
|---|---|---|---|---|---|
|Bernoulli|Discrete|p|p|p(1-p)|Single yes/no trial|
|Binomial|Discrete|n, p|np|np(1-p)|Count of successes in n trials|
|Poisson|Discrete|λ|λ|λ|Count of events in interval|
|Geometric|Discrete|p|1/p|(1-p)/p²|Trials until first success|
|Neg. Binomial|Discrete|r, p|r/p|r(1-p)/p²|Trials until r-th success|
|Normal|Continuous|μ, σ|μ|σ²|Natural measurements|
|Uniform|Continuous|a, b|(a+b)/2|(b-a)²/12|Equal likelihood over range|
|Exponential|Continuous|λ|1/λ|1/λ²|Time between events|
|Gamma|Continuous|k, λ|k/λ|k/λ²|Time until k-th event|
|Beta|Continuous|α, β|α/(α+β)|—|Probabilities and proportions|