
#!/usr/bin/env bash
# =============================================================================
# build_06_Maths.sh
# Complete rebuild of ~/Main/Notes/06_Maths
# Sourced from CampusX DSMP 2023 transcripts (Nitish Singh)
# Run from anywhere: bash build_06_Maths.sh
# =============================================================================
set -euo pipefail

BASE="$HOME/Main/Notes/06_Maths"
BACKUP="${BASE}_backup_$(date +%Y%m%d_%H%M%S)"

echo "[1/4] Backing up existing vault..."
[ -d "$BASE" ] && cp -r "$BASE" "$BACKUP" && echo "      Backup: $BACKUP"

echo "[2/4] Creating directory structure..."
mkdir -p "$BASE/01_Descriptive_Statistics/Visual"
mkdir -p "$BASE/02_Probability_Theory/Visual"
mkdir -p "$BASE/03_Probability_Distributions/Visual"
mkdir -p "$BASE/04_Statistical_Inference"
mkdir -p "$BASE/05_Linear_Algebra"
mkdir -p "$BASE/06_Calculus_Optimisation"
mkdir -p "$BASE/_Dashboards"
mkdir -p "$BASE/_archive"

echo "[3/4] Moving existing assets..."
# Visuals
cp -r "$BACKUP/01_Statistics/Visual/." "$BASE/01_Descriptive_Statistics/Visual/" 2>/dev/null || true
cp -r "$BACKUP/02_Probability/Visual/." "$BASE/02_Probability_Theory/Visual/"    2>/dev/null || true
# Dashboards
for f in "$BACKUP"/*.html; do
  [ -f "$f" ] && cp "$f" "$BASE/_Dashboards/" 2>/dev/null || true
done
cp "$BACKUP/02_probability_distributions_dashboard.html" "$BASE/_Dashboards/02_Probability_Distributions.html" 2>/dev/null || true
cp "$BACKUP/03_distribution_diagnostics.html"            "$BASE/_Dashboards/03_Distribution_Diagnostics.html"  2>/dev/null || true
cp "$BACKUP/01_EDA.html"                                 "$BASE/_Dashboards/01_EDA.html"                        2>/dev/null || true
# Archive old scratch
cp "$BACKUP/01_Things to cover.md" "$BASE/_archive/" 2>/dev/null || true
cp "$BACKUP/02_Using In Ml.md"     "$BASE/_archive/" 2>/dev/null || true

echo "[4/4] Writing all content files..."

# =============================================================================
# 00_Roadmap.md
# =============================================================================
cat > "$BASE/00_Roadmap.md" << 'EOF'
# Maths for Machine Learning — Master Roadmap

Source: CampusX DSMP 2023, Nitish Singh
Playlist: https://youtube.com/playlist?list=PLKnIA16_RmvbYFaaeLY28cWeqV-3vADST

This vault contains notes for all 23 sessions. Each file maps to one video. The sequence is fixed — do not skip modules. Every concept in a later session assumes the previous ones.

## Learning Path

```
01 Descriptive Statistics (Sessions 38-39)
         |
02 Probability Theory (Sessions 13-14 of playlist)
         |
03 Probability Distributions (Sessions 40-42)
         |
04 Statistical Inference — CLT, CI, Hypothesis Testing (Sessions 43-46, Chi-sq, ANOVA)
         |
05 Linear Algebra (Sessions 15-21 of playlist)
         |
06 Calculus and Optimisation (Sessions 22-23)
```

## Module Index

| Folder | Sessions | Core Topics |
|--------|----------|-------------|
| 01_Descriptive_Statistics | 38, 39 | Types of data, central tendency, dispersion, box plots, correlation |
| 02_Probability_Theory | 13, 14 | Events, probability rules, joint/marginal/conditional, Bayes theorem |
| 03_Probability_Distributions | 40, 41, 42 | PMF, PDF, CDF, Normal, Non-Gaussian distributions |
| 04_Statistical_Inference | 43, 44, 45, 46, Chi-sq, ANOVA | CLT, confidence intervals, hypothesis testing, t-tests, p-values |
| 05_Linear_Algebra | 15, 16, 17, 18, 19, 20, 21 | Vectors, matrices, eigenvectors, PCA, SVD |
| 06_Calculus_Optimisation | 22, 23 | Gradient descent, loss functions, derivatives, backprop |

## Interview Relevance

Every session has an Interview Questions section at the end of its notes file. These are questions Nitish explicitly marks as interview-worthy during the lectures. Revise those sections before any data science or ML interview.

## Dashboards

Interactive HTML files are in _Dashboards/. Open in any browser for visual exploration of distributions and diagnostics.
EOF

# =============================================================================
# 01_Descriptive_Statistics
# =============================================================================
cat > "$BASE/01_Descriptive_Statistics/01_Statistics_Roadmap.md" << 'EOF'
# Statistics Roadmap for Data Science
Source: Session 1 of playlist (Statistics Roadmap video)
Watch: https://www.youtube.com/watch?v=2GV_ouHBw30

## What is Statistics

Statistics is the branch of mathematics dealing with collecting, organising, analysing, interpreting, and presenting data. In data science it is the primary tool for extracting meaning from raw data before any model is built.

Nitish divides the roadmap into two broad branches that together cover everything you will encounter in data science and ML.

## Descriptive Statistics

Descriptive statistics summarises and describes data you already have. You are not making predictions beyond the dataset. Topics covered: population vs sample, types of data, measures of central tendency, measures of dispersion, percentiles and quantiles, skewness and kurtosis, univariate and bivariate analysis, covariance and correlation. These are the tools you use in EDA every single time you touch a new dataset.

## Inferential Statistics

Inferential statistics uses a sample to make claims about a larger population. Nitish's example: to find the average salary of 140 crore Indians you cannot survey everyone. You draw a representative sample of 50,000 people and infer the population parameter. Topics covered: probability distributions (the bridge between descriptive and inferential), confidence intervals, central limit theorem, hypothesis testing (z-test, t-test, chi-square, ANOVA), Bayesian statistics.

## Why the Order Matters

Descriptive statistics first because you must understand your data before making claims about it. Probability distributions second because all inferential procedures are built on distributional assumptions. Hypothesis testing last because it requires understanding both distributions and sampling.

## Which Topics Are Free vs Premium

In the CampusX playlist, Sessions 38 through 46 are free. Chi-square, ANOVA, most of linear algebra, and the calculus sessions are premium (members only). The notes in this vault cover all 23 sessions regardless.
EOF

cat > "$BASE/01_Descriptive_Statistics/02_Descriptive_Statistics_Part1.md" << 'EOF'
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
EOF

cat > "$BASE/01_Descriptive_Statistics/03_Descriptive_Statistics_Part2.md" << 'EOF'
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
EOF

# =============================================================================
# 02_Probability_Theory
# =============================================================================
cat > "$BASE/02_Probability_Theory/01_Probability_Fundamentals.md" << 'EOF'
# Probability — Part 1: Fundamentals
Source: Session 13 of playlist (Master Probability Crash Course Part 1)
Watch: https://www.youtube.com/watch?v=DUT4WEUngt0

## What is Probability

Probability is a measure of the likelihood that a particular event will occur. It is a number between 0 and 1. Zero means impossible. One means certain. Everything in between represents degrees of likelihood.

The formal definition: probability of an event A = (number of favourable outcomes) / (total number of possible outcomes), provided all outcomes are equally likely.

## Sample Space and Events

The sample space S is the set of all possible outcomes of an experiment. Rolling a die: S = {1, 2, 3, 4, 5, 6}. Flipping a coin: S = {Head, Tail}.

An event is any subset of the sample space. Rolling an even number: E = {2, 4, 6}. P(E) = 3/6 = 0.5.

## Types of Events

Nitish covers these explicitly because they reappear throughout the probability sessions.

A simple event has exactly one outcome: rolling a 4. A compound event has two or more outcomes: rolling an even number.

Independent events: the outcome of one does not affect the other. Rolling a die twice — the result of the first roll has no bearing on the second.

Dependent events: the outcome of one affects the other. Drawing a card from a deck, not replacing it, then drawing again. The probability of the second draw depends on what was drawn first because the deck now has 51 cards.

Mutually exclusive events: two events that cannot both occur in the same trial. Rolling an odd number and rolling an even number on the same roll. They share no outcomes.

Exhaustive events: a set of events where at least one must occur. Rolling a die — the events {1}, {2}, {3}, {4}, {5}, {6} together are exhaustive because one of them must happen.

An impossible event has probability zero. A certain event has probability one.

## Basic Probability Rules

Addition rule for mutually exclusive events: P(A or B) = P(A) + P(B). If events share no outcomes you simply add.

General addition rule: P(A or B) = P(A) + P(B) - P(A and B). The intersection is subtracted to avoid counting it twice.

Complement rule: P(not A) = 1 - P(A). If P(rain tomorrow) = 0.3 then P(no rain) = 0.7. Often computing the complement is easier than computing the event directly.

## Conditional Probability

P(A given B) = P(A and B) / P(B). This is the probability of A occurring given that B has already occurred. The sample space is restricted to outcomes where B happened.

Nitish's card example: you draw a card from a 52-card deck. Probability of a spade is 13/52 = 0.25. Now suppose you are told the card is black. Given this information, P(spade given black) = 13/26 = 0.5. The condition changed the sample space from 52 to 26.

```python
# Verifying conditional probability numerically
p_spade = 13/52
p_black = 26/52
p_spade_and_black = 13/52   # spades are all black
p_spade_given_black = p_spade_and_black / p_black   # = 0.5
```

## Independence

Two events are independent if P(A and B) = P(A) times P(B). Equivalently, P(A given B) = P(A) — knowing B happened tells you nothing about A. Flipping a fair coin twice: P(H on flip 2 given H on flip 1) = 0.5 = P(H on flip 2). They are independent.

## ML Connection

The Naive Bayes classifier assumes all features are conditionally independent given the class label. This is the naive assumption. Logistic regression computes P(y=1 given X) — a conditional probability. Every probabilistic ML model is built on these foundational rules. Understanding independence vs dependence is essential for interpreting model assumptions.

## Interview Questions

What is the difference between independent and mutually exclusive events? Can two events be both mutually exclusive and independent? Define conditional probability and give a real-world example. What is Bayes' theorem and where is it used in ML?
EOF

cat > "$BASE/02_Probability_Theory/02_Joint_Marginal_Conditional_Bayes.md" << 'EOF'
# Joint, Marginal, Conditional Probability and Bayes Theorem
Source: Session 14 of playlist
Watch: https://www.youtube.com/watch?v=ndHDsvqmbuI

## Joint Probability

Joint probability is the probability of two events occurring simultaneously: P(A and B). Nitish builds this from a contingency table in the session — he takes a dataset, creates all combinations of two variables, counts occurrences, and divides by total to get the joint probability distribution.

The joint probability distribution contains the probability for every possible combination of outcomes of two random variables. All entries in the table must sum to 1.

```python
import numpy as np
# Joint probability table — rows: X, columns: Y
joint = np.array([[0.30, 0.10],
                  [0.20, 0.40]])
print(joint.sum())   # must equal 1.0
```

## Marginal Probability

Marginal probability is the probability of a single event regardless of any other event. You get it by summing the joint probabilities across all values of the other variable — you are marginalising out the variable you do not care about.

P(X = x) = sum over all y of P(X = x, Y = y).

```python
p_x = joint.sum(axis=1)   # sum across columns — marginal of X
p_y = joint.sum(axis=0)   # sum across rows — marginal of Y
print(p_x)   # [0.4, 0.6]
print(p_y)   # [0.5, 0.5]
```

Nitish connects this directly to the chi-square test they covered elsewhere: when testing independence between two categorical features, you compute joint and marginal probabilities from a contingency table, exactly as shown here.

## Conditional Probability from the Table

Given joint and marginal: P(X = x given Y = y) = P(X = x, Y = y) / P(Y = y).

```python
# P(X=1 given Y=1)
p_x1_given_y1 = joint[1, 1] / p_y[1]   # 0.4 / 0.5 = 0.8
```

## Bayes Theorem

Bayes theorem is the rule for updating beliefs when new evidence arrives.

P(H given E) = P(E given H) times P(H) / P(E)

Each term: P(H) is the prior — your belief about hypothesis H before seeing any evidence. P(E given H) is the likelihood — probability of observing this evidence if H is true. P(H given E) is the posterior — your updated belief after seeing the evidence. P(E) is the marginal likelihood, a normalising constant that ensures the posterior sums to 1.

Nitish's medical test example in this session: a disease affects 0.1 percent of the population. A test for it is 99 percent accurate (correctly identifies 99 percent of those who have it). You test positive. What is the actual probability you have the disease?

Most people say approximately 99 percent. Bayes says otherwise.

```python
p_disease = 0.001           # prior: disease is rare
p_pos_given_disease = 0.99  # likelihood: test is good
p_pos_given_no_disease = 0.01  # false positive rate

# P(positive) by law of total probability
p_positive = (p_pos_given_disease * p_disease +
              p_pos_given_no_disease * (1 - p_disease))

# Posterior
p_disease_given_pos = (p_pos_given_disease * p_disease) / p_positive
print(f"{p_disease_given_pos:.3f}")   # approximately 0.09 — only 9 percent
```

The prior dominates. The disease is so rare that even a highly accurate positive test leaves only a 9 percent posterior probability. This is why doctors require confirming tests for rare diseases.

## Naive Bayes Classifier

The Naive Bayes classifier is a direct ML application of Bayes theorem. For classification:

P(class given features) is proportional to P(features given class) times P(class)

The naive assumption: all features are conditionally independent given the class. This means P(f1, f2, ..., fn given class) = product of P(fi given class). Despite the strong independence assumption being almost always violated in real data, Naive Bayes works well for text classification — spam detection, sentiment analysis, document categorisation.

```python
from sklearn.naive_bayes import GaussianNB
model = GaussianNB()
model.fit(X_train, y_train)
```

## ML Connection

Joint distributions are the foundation of generative models — models that learn the joint distribution P(X, Y) rather than just the conditional P(Y given X). Variational autoencoders and diffusion models involve marginalising over latent variables. Bayesian optimisation for hyperparameter tuning uses Bayes theorem to update beliefs about which hyperparameters are promising given observed results.

## Interview Questions

What is the difference between joint and marginal probability? State Bayes theorem and explain each term. What is the naive assumption in Naive Bayes? Give an example where Naive Bayes would work well despite the independence assumption being violated. Why does the prior matter so much in Bayes theorem for rare events?
EOF

# =============================================================================
# 03_Probability_Distributions
# =============================================================================
cat > "$BASE/03_Probability_Distributions/01_PDF_PMF_CDF.md" << 'EOF'
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
EOF

cat > "$BASE/03_Probability_Distributions/02_Normal_Distribution.md" << 'EOF'
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
EOF

cat > "$BASE/03_Probability_Distributions/03_Non_Gaussian_Distributions.md" << 'EOF'
# Non-Gaussian Probability Distributions
Source: Session 42, DSMP 2023
Watch: https://www.youtube.com/watch?v=U6QCc_3zgUk

## Why Study Non-Gaussian Distributions

Real-world data is rarely normal. Counts, binary outcomes, waiting times, income, and many other phenomena follow completely different shapes. Applying normal-distribution tools to non-normal data produces wrong results. Identifying the correct distribution family lets you use the right tools.

## Bernoulli Distribution

The simplest discrete distribution. One trial, two outcomes: success with probability p, failure with probability 1-p. PMF: P(X=1) = p, P(X=0) = 1-p. Mean = p. Variance = p(1-p).

Nitish's example: a student sees a course on CampusX. Either they enrol or they do not. Each individual student's decision is a Bernoulli trial.

```python
from scipy.stats import bernoulli
rv = bernoulli(p=0.3)
print(rv.pmf(1))   # 0.3
print(rv.pmf(0))   # 0.7
```

Every binary classification problem produces Bernoulli-distributed predictions. Binary cross-entropy loss is the negative log-likelihood of a Bernoulli PMF.

## Binomial Distribution

N independent Bernoulli trials. Models the count of successes. Parameters: n (trials), p (success probability per trial). Mean = np. Variance = np(1-p).

Nitish's example: showing a YouTube video to 3 viewers each with 0.5 probability of liking it. What is the probability exactly 2 out of 3 like it? P(X=2) = C(3,2) times 0.5 squared times 0.5 = 3 times 0.25 times 0.5 = 0.375.

The key condition: trials must be independent and the probability p must be fixed across all trials.

```python
from scipy.stats import binom
print(binom.pmf(k=2, n=3, p=0.5))    # 0.375
print(binom.cdf(k=5, n=10, p=0.5))   # P(at most 5 heads in 10 flips)
```

When n is large and p is not too extreme, the binomial distribution approaches the normal distribution — a direct consequence of the Central Limit Theorem.

## Poisson Distribution

Models the number of events occurring in a fixed time interval when events happen at a constant average rate and are independent of each other. Single parameter: lambda (the average rate). Mean = Variance = lambda. This equality is a diagnostic — if your count data has approximately equal mean and variance, Poisson is a candidate.

PMF: P(X=k) = (lambda to the k times e to the negative lambda) / k factorial.

Real examples: number of customers arriving per hour, number of server requests per second, number of goals in a football match, number of defects per square metre of fabric.

```python
from scipy.stats import poisson
lam = 3
print(poisson.pmf(k=2, mu=lam))   # P(exactly 2 events)
print(poisson.cdf(k=4, mu=lam))   # P(at most 4 events)
```

## Log-Normal Distribution

If X is normally distributed, then Y = e to the X is log-normally distributed. Equivalently: if you take the log of a log-normal variable you get a normal variable.

Shape: right-skewed, only positive values, long right tail. Real examples: income and wealth distribution, stock prices, house prices, file sizes. Nitish mentions this is why log-transforming a right-skewed feature before training a linear model is standard practice — after the transform the feature is approximately normal and linear model assumptions are better satisfied.

```python
import numpy as np
data = np.random.lognormal(mean=0, sigma=1, size=1000)
log_data = np.log(data)   # log_data is now approximately Normal(0,1)
```

Nitish notes this as an interview question: how would you check if a random variable is log-normally distributed? Take the log of it and check if the result is normal using a QQ plot or Shapiro-Wilk test.

## Uniform Distribution

Every value in the range [a, b] has equal probability. Continuous uniform PDF: f(x) = 1/(b-a). Mean = (a+b)/2.

```python
from scipy.stats import uniform
rv = uniform(loc=0, scale=10)   # Uniform on [0, 10]
print(rv.pdf(5))    # 0.1 = 1/10
```

Used in random weight initialisation, random train/test splits, hyperparameter random search.

## Exponential Distribution

Models time between consecutive events in a Poisson process. If events arrive at rate lambda, waiting time follows Exp(lambda). Mean = 1/lambda. The memoryless property: the probability of waiting at least s+t more time, given you have already waited s, equals the probability of waiting t from the start. The distribution has no memory of past waiting time.

```python
from scipy.stats import expon
rv = expon(scale=1/2)   # lambda=2, mean wait = 0.5 time units
print(rv.mean())
```

## Choosing the Right Distribution

Binary single trial: Bernoulli. Count of successes in N trials: Binomial. Count of events in fixed interval: Poisson. Positive continuous right-skewed: Log-Normal. Time between events: Exponential. Symmetric continuous: Normal. Bounded continuous equal probability: Uniform.

## ML Connection

Bernoulli and Binomial: binary classification loss functions. Poisson: regression for count data, predicting accident rates or page views. Log-Normal: motivation for log-transforming skewed features. Exponential: survival analysis, reinforcement learning reward decay. Uniform: weight initialisation, random sampling, hyperparameter search.

## Interview Questions

What is the difference between Bernoulli and Binomial distributions? What distinguishes the Poisson distribution from others for count data? What is the memoryless property of the exponential distribution? How would you check if data is log-normally distributed? When is it appropriate to log-transform a feature?
EOF

# =============================================================================
# 04_Statistical_Inference
# =============================================================================
cat > "$BASE/04_Statistical_Inference/01_Central_Limit_Theorem.md" << 'EOF'
# Central Limit Theorem
Source: Session 43, DSMP 2023
Watch: https://www.youtube.com/watch?v=-WmJDYBor7c

## Why CLT is the Most Important Theorem in Statistics

The CLT explains why the normal distribution appears everywhere, why sampling works, and why statistical inference is possible at all. Without it, confidence intervals and hypothesis tests have no foundation.

## Sampling Distribution

Take a population. Draw a random sample of size n and compute the mean. Draw another sample, compute another mean. Repeat 1000 times. The distribution of those 1000 sample means is called the sampling distribution of the mean.

Nitish demonstrates this with a coin-flip experiment: he runs 10 flips, counts heads, repeats 1000 times, and plots the histogram. Even though individual flips are Bernoulli (non-normal), the distribution of counts looks like a bell curve. He then changes p to 0.7 and shows the bell shifts right. With p=0.2 it shifts left.

```python
import numpy as np, matplotlib.pyplot as plt
population = np.random.exponential(scale=2, size=100000)  # non-normal
sample_means = [np.mean(np.random.choice(population, 30)) for _ in range(1000)]
plt.hist(sample_means, bins=40)
# Result looks normal even though population is exponential
```

## Statement of CLT

For independent, identically distributed random variables with mean mu and finite variance sigma squared, as n approaches infinity the distribution of the sample mean approaches N(mu, sigma squared / n).

In plain terms: take any population (any shape — skewed, uniform, bimodal, anything). Draw large enough random samples. Compute the mean of each sample. The distribution of those sample means will be approximately normal, regardless of the original population shape.

The sampling distribution of the mean has mean = mu (same as population) and standard deviation = sigma divided by sqrt(n). This standard deviation of the sample mean is called the Standard Error.

Standard Error = sigma / sqrt(n)

As n increases, standard error decreases. Larger samples give more precise estimates of the population mean. To halve the standard error you need four times the sample size.

```python
pop_std = np.std(population)
for n in [5, 30, 100, 500]:
    means = [np.mean(np.random.choice(population, n)) for _ in range(2000)]
    print(f"n={n}: Empirical SE={np.std(means):.3f}, Theory SE={pop_std/np.sqrt(n):.3f}")
```

## Required Sample Size

For most distributions n >= 30 is sufficient. For heavily skewed distributions n >= 50 is safer. For populations that are already normal, CLT holds for any n.

## Applications

Confidence intervals are built directly on CLT: because the sample mean is approximately normal, you can compute CI = x-bar plus or minus z-star times sigma/sqrt(n). Every t-test and z-test assumes the test statistic is normally distributed — CLT justifies this. Evaluating a model on a test set computes a sample statistic (accuracy, F1). CLT guarantees this estimate is approximately normally distributed, allowing you to attach meaningful uncertainty to it.

```python
from scipy import stats
import numpy as np
data = np.random.normal(50, 10, 100)
mean = np.mean(data)
se = stats.sem(data)
ci = stats.t.interval(0.95, df=len(data)-1, loc=mean, scale=se)
print(f"95% CI: {ci}")
```

## ML Connection

Mini-batch gradient descent takes a random sample of training data each step. The gradient computed on the batch is a sample estimate of the true gradient. CLT guarantees that as batch size grows this estimate converges to the true gradient. Reporting model accuracy with a confidence interval rather than a point estimate is applied CLT.

## Interview Questions

State the Central Limit Theorem. What is the standard error and how does it differ from standard deviation? What sample size is typically needed for CLT to apply? How does CLT justify using t-tests and z-tests?
EOF

cat > "$BASE/04_Statistical_Inference/02_Confidence_Intervals.md" << 'EOF'
# Confidence Intervals
Source: Session 44, DSMP 2023
Watch: https://www.youtube.com/watch?v=X52HK2qkiIE

## Point Estimate and Its Limitation

Nitish wants to know the average age of his 77,000 YouTube subscribers. He cannot survey all of them. He takes the live class students as a sample and gets a single number — say 28 years. That is the point estimate.

The problem: a single exact number is almost certainly wrong for the population. Nitish's analogy: betting that MS Dhoni scores exactly 25 runs in a match — the probability of the exact number is tiny. But betting he scores between 20 and 35 — much more probable. A range is more honest and more useful than a single point.

## What a Confidence Interval Is

A confidence interval is a range of plausible values for the population parameter, computed from sample data, with an associated confidence level. CI = Point Estimate plus or minus Margin of Error. The confidence level (90%, 95%, 99%) tells you how confident you are that the procedure captures the true parameter.

Nitish points out: those black vertical lines you see at the top of seaborn bar chart bars are confidence interval error bars. Now you know exactly what they represent.

## Correct Interpretation

The correct interpretation of a 95% CI is: if this sampling and interval-calculation procedure were repeated 100 times, approximately 95 of the resulting intervals would contain the true population parameter. The true parameter is fixed — it either is or is not in any specific interval. The 95% refers to the long-run behaviour of the procedure, not to a single interval.

## Z-Procedure (Population Sigma Known)

Three assumptions required: random sample, population standard deviation sigma is known, and either the population is normal or n >= 30 (CLT applies).

CI = x-bar plus or minus z-star times sigma/sqrt(n)

For 95% CI z-star = 1.96. For 99% CI z-star = 2.576. For 90% CI z-star = 1.645.

Why 1.96 for 95%? Because norm.cdf(1.96) = 0.975. The area between -1.96 and +1.96 under the standard normal is exactly 0.95.

```python
import numpy as np
from scipy.stats import norm

x_bar = 28.5
sigma = 5   # known population std dev
n = 100

se = sigma / np.sqrt(n)
z_star = norm.ppf(0.975)   # 1.96
ci = (x_bar - z_star * se, x_bar + z_star * se)
print(f"95% CI: {ci}")
```

## T-Procedure (Population Sigma Unknown)

In practice sigma is almost never known. You estimate it from the sample using s (sample standard deviation with ddof=1). When sigma is unknown you use the t-distribution instead of the standard normal.

The t-distribution has heavier tails than the normal distribution, accounting for the additional uncertainty from estimating sigma. Its shape depends on degrees of freedom = n - 1. As n increases, the t-distribution converges to the standard normal.

CI = x-bar plus or minus t-star times s/sqrt(n)

```python
from scipy import stats
import numpy as np

sample = np.array([22, 25, 28, 30, 24, 27, 31, 26, 29, 23])
n = len(sample)
x_bar = np.mean(sample)
se = stats.sem(sample)   # s / sqrt(n)

ci = stats.t.interval(0.95, df=n-1, loc=x_bar, scale=se)
print(f"95% CI: ({ci[0]:.2f}, {ci[1]:.2f})")
```

Use t-procedure in practice. When n is large the difference from z-procedure is negligible.

## Effect of Sample Size and Confidence Level

Larger n gives narrower intervals — more data means more precision. Higher confidence level (99% vs 95%) gives wider intervals — more confidence requires a wider net. To halve the CI width you need four times the sample size because of the sqrt(n) in the denominator.

```python
for n in [10, 30, 100, 500]:
    se = 10 / np.sqrt(n)   # assuming std dev = 10
    ci = stats.t.interval(0.95, df=n-1, loc=50, scale=se)
    print(f"n={n:4d}: width={ci[1]-ci[0]:.2f}")
```

## ML Connection

Never report model accuracy as a single point estimate. Compute a confidence interval: for 1000 test samples and 92% accuracy, SE = sqrt(0.92 times 0.08 / 1000) = 0.0086. 95% CI = (0.903, 0.937). If two models' CIs overlap substantially, the performance difference may not be real. Bootstrap confidence intervals work for any metric without distributional assumptions.

```python
def bootstrap_ci(scores, n_boot=10000):
    boots = [np.mean(np.random.choice(scores, len(scores), replace=True)) for _ in range(n_boot)]
    return np.percentile(boots, [2.5, 97.5])
```

## Interview Questions

What is the correct interpretation of a 95% confidence interval? When do you use the t-distribution instead of the normal distribution? What is the standard error and how does it affect CI width? How does sample size affect confidence interval width? How would you report model performance with uncertainty?
EOF

cat > "$BASE/04_Statistical_Inference/03_Hypothesis_Testing_Part1.md" << 'EOF'
# Hypothesis Testing Part 1
Source: Session 45, DSMP 2023
Watch: https://www.youtube.com/watch?v=S94mx6OL7kM

## The Core Logic

Hypothesis testing is the formal procedure for making evidence-based decisions about population parameters using sample data. The logic: start with a default assumption (null hypothesis). Ask whether the sample data provides enough evidence to reject it. The burden of proof is entirely on the alternative hypothesis — you never prove the null, you only reject it or fail to reject it.

## Null and Alternative Hypotheses

H0 (null hypothesis): the conservative default claim. No effect, no difference, no improvement. H1 (alternative hypothesis): the claim you are trying to establish through evidence.

They must be mutually exclusive and together cover all possibilities. You state both before collecting data, never after.

Nitish's factory example from this session: a car manufacturing company produces 50 cars per day on average (mu = 50, sigma = 5). They introduce a training programme for employees. After training, a sample of 30 employees shows a sample mean of 53 cars per day.

H0: the training made no difference. Population mean is still 50. (mu = 50)
H1: the training improved productivity. Population mean is now greater than 50. (mu > 50)

## Type I and Type II Errors

Four possible outcomes exist in any hypothesis test.

If H0 is true and you fail to reject it: correct decision. If H0 is true but you reject it: Type I error (false positive). You concluded there was an effect when there was none. The significance level alpha is the maximum acceptable probability of a Type I error.

If H1 is true and you reject H0: correct decision (the power of the test). If H1 is true but you fail to reject H0: Type II error (false negative). You missed a real effect. Beta is the probability of a Type II error. Power = 1 - beta.

Reducing alpha makes Type I errors rarer but increases Type II errors. The only way to reduce both simultaneously is to increase sample size.

## Significance Level

Alpha (typically 0.05) is chosen before the test. Setting alpha after seeing the data — p-hacking — invalidates the entire test. Alpha = 0.05 means you accept a 5% chance of falsely concluding an effect exists.

## Test Statistic

A test statistic summarises how far the sample is from what H0 predicts. Large absolute values are evidence against H0.

For testing whether a sample mean equals a hypothesised value when sigma is known (z-test):

Z = (x-bar - mu0) / (sigma / sqrt(n))

Nitish's factory example:
Z = (53 - 50) / (5 / sqrt(30)) = 3 / 0.913 = 3.29

## Critical Value and Rejection Region

For a one-tailed test at alpha = 0.05: the critical value is 1.645. If Z > 1.645 you reject H0. If Z <= 1.645 you fail to reject H0.

Z = 3.29 > 1.645 therefore reject H0. The training programme significantly improved productivity.

## Five Steps of Hypothesis Testing (Nitish's Framework)

Step 1: State H0 and H1. Step 2: Choose the significance level alpha. Step 3: Check assumptions and select the appropriate test (z-test, t-test, etc.). Step 4: Calculate the test statistic. Step 5: Make the decision — compare test statistic to critical value or compute p-value.

```python
from scipy import stats
import numpy as np

mu0 = 50          # null hypothesis value
sigma = 5         # known population std dev
n = 30            # sample size
x_bar = 53        # sample mean

z_stat = (x_bar - mu0) / (sigma / np.sqrt(n))
print(f"Z statistic: {z_stat:.3f}")   # 3.286

# One-tailed p-value (H1: mu > 50)
p_value = 1 - stats.norm.cdf(z_stat)
print(f"p-value: {p_value:.4f}")      # 0.0005
```

## ML Connection

Model evaluation is hypothesis testing. Is my new model significantly better than the baseline? H0: both models have the same performance. H1: the new model is better. Every A/B test follows this exact framework. Feature importance tests in linear models output p-values from hypothesis tests on each coefficient.

## Interview Questions

What is the null hypothesis and why do we start with it? Define Type I and Type II errors. What is the significance level and why is it chosen before the test? What is a test statistic? Describe the five steps of hypothesis testing.
EOF

cat > "$BASE/04_Statistical_Inference/04_Hypothesis_Testing_Part2.md" << 'EOF'
# Hypothesis Testing Part 2 — p-values and t-tests
Source: Session 46, DSMP 2023
Watch: https://www.youtube.com/watch?v=xHTMjxx14sU

## p-value

The p-value is the probability of observing a test statistic at least as extreme as the one computed, assuming H0 is true. A small p-value means the observed data is very unlikely under H0 — strong evidence against it.

Nitish's direct definition: the p-value expresses the strength of the evidence against H0. A small p-value means strong evidence against H0.

Decision rule: if p-value < alpha, reject H0. If p-value >= alpha, fail to reject H0.

What the p-value is NOT: it is not the probability that H0 is true. It is not the probability that the result is due to chance. It does not measure effect size or practical importance.

## Snack food example from session

A company claims their chips weigh 50 grams on average. A consumer watchdog tests a sample of 40 packets and finds a mean weight of 49 grams. Population standard deviation is known to be 5 grams. Test at alpha = 0.05 whether the mean differs from 50 grams (two-tailed test).

H0: mu = 50. H1: mu not equal to 50 (two-tailed).

Z = (49 - 50) / (5 / sqrt(40)) = -1 / 0.7906 = -1.265

For a two-tailed test at alpha = 0.05 the critical values are plus and minus 1.96. Since -1.265 is between -1.96 and +1.96 we fail to reject H0. Not enough evidence to conclude the company is under-filling.

```python
from scipy import stats
import numpy as np

mu0, sigma, n, x_bar = 50, 5, 40, 49
z_stat = (x_bar - mu0) / (sigma / np.sqrt(n))
p_value = 2 * (1 - stats.norm.cdf(abs(z_stat)))   # two-tailed
print(f"Z={z_stat:.3f}, p={p_value:.4f}")
# p=0.2059 > 0.05, fail to reject H0
```

## One-tailed vs Two-tailed Tests

A one-tailed test has a directional H1 (mu > 50 or mu < 50). The rejection region is on one side only. A two-tailed test has H1: mu not equal to mu0. The rejection region is split across both tails. Use two-tailed unless you have a specific directional hypothesis established before data collection.

## t-test (When Sigma is Unknown)

In practice population sigma is almost never known. Use the t-test which relies on the sample standard deviation s.

One-sample t-test: tests whether sample mean equals a hypothesised value.

```python
from scipy import stats
sample = [48, 51, 49, 50, 52, 47, 53, 50, 48, 51]
t_stat, p_value = stats.ttest_1samp(sample, popmean=50)
print(f"t={t_stat:.3f}, p={p_value:.4f}")
```

Two-sample independent t-test: tests whether two independent groups have the same mean.

```python
group_a = [28, 30, 29, 31, 27]
group_b = [32, 34, 31, 35, 33]
t_stat, p_value = stats.ttest_ind(group_a, group_b, equal_var=False)  # Welch's
print(f"t={t_stat:.3f}, p={p_value:.4f}")
```

Paired t-test: used when the same subjects are measured twice (before and after).

```python
before = [80, 85, 78, 90, 76]
after  = [84, 88, 82, 91, 80]
t_stat, p_value = stats.ttest_rel(before, after)
```

## Statistical vs Practical Significance

Statistical significance means the effect probably exists. Practical significance means the effect is large enough to matter.

With 100,000 samples, a 0.001 accuracy improvement between two models will be statistically significant (tiny p-value). It has zero practical significance.

Cohen's d measures effect size independently of sample size:

```python
def cohen_d(g1, g2):
    pooled = np.sqrt((np.std(g1, ddof=1)**2 + np.std(g2, ddof=1)**2) / 2)
    return (np.mean(g1) - np.mean(g2)) / pooled
# d=0.2: small, d=0.5: medium, d=0.8: large
```

Always report both p-value and effect size.

## Multiple Testing Problem

Running 20 independent tests at alpha=0.05 will produce on average one false positive by chance. Bonferroni correction: use alpha/k as the threshold where k is the number of tests.

## ML Connection

A/B testing a new model follows this exact framework. Feature selection using statistical tests (f_classif for numerical features, chi2 for categorical) outputs p-values and selects features below a threshold. Coefficients in linear regression come with p-values testing whether each coefficient is significantly different from zero.

## Interview Questions

What is a p-value and what does it represent? What does it mean to fail to reject H0? When do you use a t-test instead of a z-test? What is the difference between one-tailed and two-tailed tests? What is the multiple testing problem and how do you address it? What is the difference between statistical significance and practical significance?
EOF

cat > "$BASE/04_Statistical_Inference/05_Chi_Square_and_ANOVA.md" << 'EOF'
# Chi-Square Tests and ANOVA
Source: CampusX Chi-Square session and ANOVA session (premium)
Watch Chi-Square: https://www.youtube.com/watch?v=_8DTqznosvY
Watch ANOVA: https://www.youtube.com/watch?v=G9ppvMWyd54

## Chi-Square Goodness of Fit

Tests whether observed frequencies match expected frequencies from a hypothesised distribution. H0: data follows the specified distribution. H1: it does not.

```python
from scipy.stats import chisquare
observed = [18, 22, 20, 25, 15]
expected = [20, 20, 20, 20, 20]   # expected if uniform
chi2, p = chisquare(f_obs=observed, f_exp=expected)
# p < 0.05: distribution is not uniform
```

## Chi-Square Test of Independence

Tests whether two categorical variables are independent. Used heavily in feature selection — is this categorical feature related to the target? H0: the two variables are independent. H1: they are not.

The test uses a contingency table of observed frequencies and compares them to expected frequencies under the independence assumption.

```python
from scipy.stats import chi2_contingency
import numpy as np

# Rows: gender, Columns: product preference A/B/C
table = np.array([[30, 20, 10],
                  [15, 35, 20]])

chi2, p, dof, expected = chi2_contingency(table)
print(f"chi2={chi2:.3f}, p={p:.4f}, dof={dof}")
# p < 0.05: gender and product preference are not independent
```

Assumption: expected frequency in each cell should be at least 5. For small expected counts use Fisher's exact test.

```python
from sklearn.feature_selection import chi2 as sk_chi2, SelectKBest
selector = SelectKBest(sk_chi2, k=5)
X_selected = selector.fit_transform(X, y)
```

## ANOVA — Analysis of Variance

ANOVA tests whether the means of three or more groups are equal. Running multiple t-tests pairwise inflates Type I error rate. ANOVA tests all groups simultaneously in one test.

H0: all group means are equal. H1: at least one group mean differs.

The F-statistic is the ratio of between-group variance (signal) to within-group variance (noise). A large F means group means differ more than random sampling variation would predict.

```python
from scipy.stats import f_oneway
group_a = [50, 52, 48, 51, 49]
group_b = [55, 57, 54, 56, 53]
group_c = [50, 49, 51, 48, 52]

f_stat, p = f_oneway(group_a, group_b, group_c)
print(f"F={f_stat:.3f}, p={p:.4f}")
```

ANOVA only tells you that at least one group differs — not which ones. Post-hoc tests (Tukey HSD) perform pairwise comparisons while controlling the overall Type I error rate.

```python
from statsmodels.stats.multicomp import pairwise_tukeyhsd
import numpy as np

data = np.concatenate([group_a, group_b, group_c])
labels = ['A']*5 + ['B']*5 + ['C']*5
result = pairwise_tukeyhsd(data, labels, alpha=0.05)
print(result)
```

ANOVA assumptions: independence of observations, approximate normality within groups, homogeneity of variance (check with Levene's test). When these are violated use Kruskal-Wallis (non-parametric ANOVA).

```python
from sklearn.feature_selection import f_classif, SelectKBest
selector = SelectKBest(f_classif, k=10)
X_selected = selector.fit_transform(X, y)   # ANOVA F-test for feature selection
```

## Interview Questions

When would you use chi-square instead of a t-test? What does the chi-square test of independence test? What is ANOVA and when do you need it instead of multiple t-tests? What is the F-statistic and what does a large value indicate? What post-hoc test do you use after ANOVA and why?
EOF

# =============================================================================
# 05_Linear_Algebra
# =============================================================================
cat > "$BASE/05_Linear_Algebra/00_Linear_Algebra_Roadmap.md" << 'EOF'
# Linear Algebra Roadmap for ML and Deep Learning
Source: Session 15 of playlist
Watch: https://www.youtube.com/watch?v=rIsCKVyh4dI

## Why Linear Algebra

Nitish's opening: every topic in this roadmap has a one-line description, an ML application, and a deep learning application — because knowing what you are reading it for keeps you motivated.

Scalars are single numbers. Vectors represent data points, embeddings, feature vectors. In ML a vector represents a data point. In deep learning a vector represents weights, biases, or intermediate activations. Every dataset is a matrix of n rows and p columns. Neural network layer computation is a matrix multiplication. Attention in transformers is a scaled dot product of query, key, and value matrices.

## Topic Sequence

Scalars → Vectors (types, distance from origin, operations, norms, dot product) → Matrices (operations, rank, determinant, inverse) → Matrix Intuition (linear transformations as geometry) → Eigenvalues and Eigenvectors → Eigendecomposition and PCA → Singular Value Decomposition.

## Coverage in This Vault

Sessions 16 through 21 cover this sequence. Sessions 19 through 21 (Eigenvalues, Eigen Decomposition + PCA, SVD) are premium content in the playlist.
EOF

cat > "$BASE/05_Linear_Algebra/01_Vectors.md" << 'EOF'
# Vectors
Source: Session 16 of playlist
Watch: https://www.youtube.com/watch?v=mQewAJb8oJ8

## What is a Vector

A vector is an ordered list of numbers. In ML it represents a single data point, a word embedding, a model weight, or any entity that can be described by multiple numerical attributes simultaneously.

Notation: a vector written as a column with n rows and 1 column is called an n-dimensional column vector. Nitish shows the notation explicitly — 1 x n means a row vector, n x 1 means a column vector. Seeing n x 1 immediately tells you this is a column vector.

```python
import numpy as np
a = np.array([1, 2, 3])        # 3-dimensional vector
b = np.array([4, 5, 6, 7, 8])  # 5-dimensional vector
```

## Distance from Origin (Magnitude / Norm)

Nitish derives this geometrically for 2D first. For a vector with components a and b, the distance from the origin is sqrt(a squared + b squared) — the Pythagorean theorem. For 3D: sqrt(a squared + b squared + c squared). For any n dimensions: sqrt of the sum of squares of all components.

This is the L2 norm, written as double vertical bars around the vector.

```python
a = np.array([3, 4])
print(np.linalg.norm(a))        # 5.0 — L2 norm
print(np.linalg.norm(a, ord=1)) # 7.0 — L1 norm (sum of absolute values)
```

L1 norm produces sparse solutions in regularisation (Lasso). L2 norm produces small but non-zero weights (Ridge). The choice of norm encodes a prior assumption about what the solution should look like.

## Vector Addition and Scalar Multiplication

Adding two vectors: add corresponding components. Scalar multiplication: multiply every component by the scalar. Both are element-wise operations.

```python
u = np.array([1, 2, 3])
v = np.array([4, 5, 6])
print(u + v)    # [5, 7, 9]
print(3 * u)    # [3, 6, 9]
```

## Dot Product

The dot product of two vectors is the sum of element-wise products. Geometric interpretation: dot product = magnitude of a times magnitude of b times cosine of the angle between them.

```python
print(np.dot(u, v))   # 1*4 + 2*5 + 3*6 = 32
print(u @ v)           # same, cleaner syntax
```

The dot product being zero means the vectors are orthogonal (perpendicular) — they are completely unrelated in direction. Nitish uses this to motivate cosine similarity.

## Cosine Similarity

Cosine similarity = dot product divided by product of magnitudes. Range: -1 to +1. Value 1 means same direction. Value 0 means orthogonal (no relationship). Value -1 means opposite directions.

```python
cos_sim = np.dot(u, v) / (np.linalg.norm(u) * np.linalg.norm(v))
```

This is the fundamental similarity metric in semantic search, recommendation systems, and document similarity — including the vector database at the core of Nazar AI.

## Unit Vector

A unit vector has magnitude 1. You create one by dividing a vector by its magnitude. Unit vectors represent direction without scale.

```python
u_hat = u / np.linalg.norm(u)   # unit vector in direction of u
```

## Vector Spaces

A vector space is a collection of vectors that is closed under addition and scalar multiplication. The span of a set of vectors is all possible linear combinations of those vectors. Linear independence means no vector in the set can be written as a combination of the others.

## ML Connection

Every data point in a dataset is a vector. Word embeddings (Word2Vec, GloVe, BERT) are vectors in high-dimensional space. Cosine similarity between embedding vectors measures semantic similarity. The entire forward pass of a neural network layer is a vector dot product with a weight matrix. Normalisation and regularisation are norm operations on weight vectors.

## Interview Questions

What is a vector and how is it represented in ML? What is the L2 norm and how is it computed? What does a dot product of zero between two vectors mean geometrically? What is cosine similarity and where is it used? What is the difference between L1 and L2 norms in the context of regularisation?
EOF

cat > "$BASE/05_Linear_Algebra/02_Matrices.md" << 'EOF'
# Matrices
Source: Session 17 of playlist (premium)
Watch: https://www.youtube.com/watch?v=Y8UjSNSMeZ4

## What is a Matrix

A matrix is a 2D array of numbers arranged in rows and columns. An m x n matrix has m rows and n columns. Every dataset is a matrix: n samples as rows, p features as columns. The weight matrix of a neural network layer is an n x m matrix where n is input dimension and m is output dimension.

```python
import numpy as np
A = np.array([[1, 2, 3],
              [4, 5, 6]])   # 2x3 matrix
print(A.shape)   # (2, 3)
```

## Matrix Operations

Addition and subtraction are element-wise and require identical shapes. Scalar multiplication multiplies every element by the scalar.

Matrix multiplication (not element-wise): the (i, j) entry of the result is the dot product of row i of the left matrix with column j of the right matrix. For A (m x n) times B (n x p), the result is m x p. The inner dimensions must match.

```python
A = np.array([[1, 2], [3, 4]])
B = np.array([[5, 6], [7, 8]])
print(A @ B)   # [[19,22],[43,50]]
```

Matrix multiplication is not commutative: A @ B is generally not equal to B @ A.

## Transpose

Flipping rows and columns. Entry (i, j) of the transpose equals entry (j, i) of the original.

```python
print(A.T)
```

The covariance matrix is symmetric: C equals its own transpose. This symmetry has critical consequences for eigendecomposition.

## Rank

The rank of a matrix is the number of linearly independent rows (equal to the number of linearly independent columns). A full-rank matrix contains no redundant information. A rank-deficient matrix has at least one column that is a linear combination of others — this corresponds to multicollinearity in regression.

```python
print(np.linalg.matrix_rank(A))
```

## Determinant

The determinant of a square matrix encodes how the matrix scales volume when used as a linear transformation. Determinant = 0 means the matrix is singular and non-invertible — the transformation collapses space to a lower dimension. The OLS solution to linear regression requires (X transpose X) to be invertible, which requires non-zero determinant.

```python
print(np.linalg.det(A))
```

## Matrix Inverse

A inverse satisfies A times A inverse = I (identity matrix). Only square, full-rank matrices are invertible. The OLS solution is beta = (X^T X)^{-1} X^T y.

```python
A_inv = np.linalg.inv(A)
# In practice, solve a linear system directly instead:
x = np.linalg.solve(A, b)   # more numerically stable than inv
```

## Identity Matrix

The identity matrix I satisfies A times I = A. It is the matrix equivalent of the number 1.

```python
I = np.eye(3)
```

## ML Connection

Neural network layer: output = activation(W times x + b) where W is the weight matrix, x is the input vector. Batch computation: output = activation(X times W^T + b) where X is the batch matrix. The covariance matrix used in PCA is a square symmetric matrix. Invertibility of (X^T X) in OLS regression requires full rank — this breaks when features are perfectly collinear.

## Interview Questions

What is matrix multiplication and what are its shape requirements? When is a matrix non-invertible? What does matrix rank represent? What is the identity matrix? Why is it preferable to use np.linalg.solve rather than np.linalg.inv?
EOF

cat > "$BASE/05_Linear_Algebra/03_Matrix_Intuition.md" << 'EOF'
# Matrix Intuition — Linear Transformations as Geometry
Source: Session 18 of playlist (premium)
Watch: https://www.youtube.com/watch?v=7IV56bGTJTQ

## The Geometric View

Every matrix encodes a geometric transformation of space. When you multiply a matrix A by a vector v, you apply a transformation that moves v to a new position. The columns of A tell you exactly where the standard basis vectors land.

Column 1 is where [1, 0] maps to. Column 2 is where [0, 1] maps to. The transformation of any other vector is determined by these two.

```python
import numpy as np

A = np.array([[2, 0],
              [0, 3]])    # stretches x by 2, y by 3
v = np.array([1, 1])
print(A @ v)   # [2, 3] — each component stretched independently
```

## Types of Transformations

A scaling matrix stretches or compresses along axes. A rotation matrix rotates all vectors by a fixed angle — it has determinant 1 and its transpose equals its inverse. A shear matrix slants space without changing area.

```python
theta = np.pi / 4   # 45 degrees
R = np.array([[np.cos(theta), -np.sin(theta)],
              [np.sin(theta),  np.cos(theta)]])
print(R @ np.array([1, 0]))   # rotated 45 degrees
```

## Column Space and Null Space

The column space of A is the set of all vectors that can be produced by A times v for some v — it is the reachable region of the transformation. The null space is all vectors v such that A times v = 0 — these are the vectors that get collapsed to the origin.

A full-rank matrix maps to the full output space and collapses nothing. A rank-deficient matrix compresses some dimensions to zero.

## What Neural Network Layers Do

Each linear layer applies a matrix transformation to its input. The following activation function (ReLU, sigmoid) then bends and folds the transformed space. Deep networks stack these transformations. Each layer adds another geometric transformation that progressively separates classes in higher-dimensional space. This is why depth increases expressiveness — more transformations mean more complex decision boundaries.

## ML Connection

Understanding transformations geometrically helps debug and design networks. Batch normalisation restores a sensible geometric structure after transformations stretch or skew the distribution. Attention mechanisms in transformers apply learned linear transformations to queries, keys, and values before computing similarity.

## Interview Questions

What does it mean geometrically to multiply a vector by a matrix? What is the column space of a matrix? What does the null space represent? Why does adding more layers to a neural network increase its expressiveness?
EOF

cat > "$BASE/05_Linear_Algebra/04_Eigenvalues_and_Eigenvectors.md" << 'EOF'
# Eigenvalues and Eigenvectors
Source: Session 19 of playlist (premium)
Watch: https://www.youtube.com/watch?v=5HDkRG5gQHM

## Definition

For a square matrix A, an eigenvector v and eigenvalue lambda satisfy: A times v = lambda times v. Applying A to v produces the same vector, only scaled by lambda. The direction is preserved; only the magnitude changes.

Eigenvectors are the special directions in space that the transformation does not rotate. They are the natural axes of the transformation.

## Computing Eigenvalues

The characteristic equation: det(A - lambda times I) = 0. Solving this polynomial gives the eigenvalues. Substituting each eigenvalue back into (A - lambda I) v = 0 gives the corresponding eigenvector.

```python
import numpy as np
A = np.array([[3, 1],
              [0, 2]])

eigenvalues, eigenvectors = np.linalg.eig(A)
print("Eigenvalues:", eigenvalues)        # [3., 2.]
print("Eigenvectors:\n", eigenvectors)    # columns are eigenvectors
```

## Eigenvalues of the Covariance Matrix

The covariance matrix is symmetric and positive semi-definite. Its eigenvectors point in the directions of maximum variance in the data. Its eigenvalues tell you how much variance exists in each direction.

The eigenvector corresponding to the largest eigenvalue is the first principal component — the direction of maximum variance. The second eigenvector (orthogonal to the first) is the second principal component, and so on. This is exactly what PCA computes.

```python
X = np.random.randn(100, 3)
cov = np.cov(X.T)
eigenvalues, eigenvectors = np.linalg.eigh(cov)   # eigh for symmetric matrices
# Sort descending
idx = np.argsort(eigenvalues)[::-1]
eigenvalues = eigenvalues[idx]
eigenvectors = eigenvectors[:, idx]
```

## Properties of Symmetric Matrices

For symmetric matrices (like covariance matrices): all eigenvalues are real numbers. Eigenvectors corresponding to different eigenvalues are orthogonal. These properties make symmetric matrices mathematically well-behaved and are why PCA works cleanly.

The trace of a matrix equals the sum of its eigenvalues. The determinant equals their product.

## ML Connection

PCA directly computes eigenvectors and eigenvalues of the covariance matrix. Google's PageRank algorithm is an eigenvector computation on the web link matrix. Spectral clustering uses eigenvectors of the graph Laplacian matrix. Neural network training dynamics are related to the eigenvalues of the Hessian of the loss function.

## Interview Questions

Define eigenvalue and eigenvector. What is the characteristic equation? What do the eigenvectors of a covariance matrix represent? What property do eigenvectors of a symmetric matrix have? What is the relationship between eigenvalues and variance in PCA?
EOF

cat > "$BASE/05_Linear_Algebra/05_Eigendecomposition_and_PCA.md" << 'EOF'
# Eigendecomposition and PCA
Source: Session 20 of playlist (premium)
Watch: https://www.youtube.com/watch?v=D5IlO4lzaZ0

## Eigendecomposition

A diagonalisable matrix A can be written as A = Q Lambda Q inverse, where Q is the matrix whose columns are eigenvectors and Lambda is a diagonal matrix of eigenvalues. For symmetric matrices Q is orthogonal (Q transpose = Q inverse), giving A = Q Lambda Q transpose.

```python
import numpy as np
A = np.array([[4, 2],
              [2, 3]])   # symmetric
eigenvalues, Q = np.linalg.eigh(A)
Lambda = np.diag(eigenvalues)
print(np.allclose(A, Q @ Lambda @ Q.T))   # True
```

## PCA from First Principles

PCA finds the directions of maximum variance in data by eigendecomposing the covariance matrix.

```python
import numpy as np

X = np.random.randn(100, 4)
# Step 1: centre the data
X_c = X - X.mean(axis=0)

# Step 2: covariance matrix
cov = np.cov(X_c.T)

# Step 3: eigendecompose
vals, vecs = np.linalg.eigh(cov)

# Step 4: sort descending
idx = np.argsort(vals)[::-1]
components = vecs[:, idx]

# Step 5: project onto top 2 components
X_pca = X_c @ components[:, :2]   # shape (100, 2)
```

## Explained Variance Ratio

Each eigenvalue represents the variance captured by its principal component. Dividing by the sum gives the proportion of total variance explained.

```python
sorted_vals = vals[idx]
evr = sorted_vals / sorted_vals.sum()
cumulative = np.cumsum(evr)
# Choose k where cumulative crosses 0.95
```

## scikit-learn PCA

```python
from sklearn.decomposition import PCA
pca = PCA(n_components=2)
X_reduced = pca.fit_transform(X)
print(pca.explained_variance_ratio_)
```

## When to Use PCA

Use before algorithms sensitive to the curse of dimensionality (k-NN, SVM with RBF kernel) when you have many features. Do not use when individual feature interpretability matters — principal components are linear combinations of all original features and have no individual meaning.

## ML Connection

PCA reduces dimensionality before visualisation (t-SNE then operates in lower-dimensional space). Face recognition (Eigenfaces) is PCA applied to image data. Noise reduction: projecting to the top k components discards small-variance directions which often correspond to noise.

## Interview Questions

What is eigendecomposition? Describe PCA from first principles without using sklearn. What does explained variance ratio tell you? What are the limitations of PCA? When should you not use PCA?
EOF

cat > "$BASE/05_Linear_Algebra/06_SVD.md" << 'EOF'
# Singular Value Decomposition
Source: Session 21 of playlist (premium)
Watch: https://www.youtube.com/watch?v=NPkMoUNkEtQ

## The Factorisation

Every matrix A (m x n) can be decomposed as A = U Sigma V transpose. U is m x m orthogonal (left singular vectors). Sigma is m x n diagonal (singular values, non-negative, sorted descending). V is n x n orthogonal (right singular vectors).

```python
import numpy as np
A = np.array([[1, 2, 3],
              [4, 5, 6],
              [7, 8, 9]])
U, sigma, Vt = np.linalg.svd(A)
print("Singular values:", sigma)
```

## Low-Rank Approximation

Truncating to the top k singular values gives the best rank-k approximation of A in terms of Frobenius norm. This is mathematically optimal lossy compression.

```python
k = 1
A_approx = sigma[0] * np.outer(U[:, 0], Vt[0, :])
```

## Connection to PCA

SVD of the centred data matrix X is equivalent to PCA. The right singular vectors V are the principal components. The singular values relate to eigenvalues of the covariance matrix. SVD is numerically more stable than eigendecomposing the covariance matrix directly. scikit-learn's PCA uses LAPACK SVD internally.

## Recommender Systems

The user-item interaction matrix R is approximately decomposed as U Sigma V transpose. U captures user latent factors, V captures item latent factors. The dot product of a user's row in U with an item's row in V predicts the rating. This is the core of matrix factorisation recommenders (Netflix Prize winner used this).

## Pseudoinverse

The Moore-Penrose pseudoinverse A+ = V Sigma+ U transpose, where Sigma+ replaces each non-zero singular value with its reciprocal. It gives the minimum-norm least-squares solution to Ax = b even when A is not square or not full-rank.

```python
A_pinv = np.linalg.pinv(A)   # uses SVD internally
```

## ML Connection

Image compression: SVD of an image matrix with small k gives a compressed approximation. Latent Semantic Analysis in NLP applies SVD to the term-document matrix. Collaborative filtering for recommendations. Dimensionality reduction that works for non-square matrices (unlike covariance-based PCA which requires square input).

## Interview Questions

What is SVD and what are its three components? How is SVD related to PCA? How is SVD used in recommender systems? What is the pseudoinverse and when is it used? What does low-rank approximation achieve?
EOF

# =============================================================================
# 06_Calculus_Optimisation
# =============================================================================
cat > "$BASE/06_Calculus_Optimisation/01_Optimisation_Big_Picture.md" << 'EOF'
# Optimisation — The Big Picture
Source: Session 22 of playlist (premium)
Watch: https://www.youtube.com/watch?v=T2f8249569Q

## What Machine Learning Optimisation Is

When a model learns, it is adjusting its parameters to minimise a cost function. The parameters are the weights and biases. The cost function measures how wrong the model is on training data. Learning is finding the parameters theta-star that minimise L(theta).

theta-star = argmin L(theta)

The cost function is a surface in parameter space. For a model with millions of parameters this surface lives in millions of dimensions. You cannot visualise it but calculus applies regardless.

## Loss Functions

The choice of loss function defines what wrong means.

Mean Squared Error for regression: average of squared differences between predictions and true values. Penalises large errors heavily due to squaring. Equivalent to maximum likelihood under Gaussian noise assumption.

```python
def mse(y_true, y_pred):
    return ((y_true - y_pred) ** 2).mean()
```

Binary Cross-Entropy for binary classification: negative average log-likelihood of Bernoulli PMF.

```python
import numpy as np
def binary_cross_entropy(y_true, y_pred):
    return -np.mean(y_true * np.log(y_pred + 1e-9) +
                    (1 - y_true) * np.log(1 - y_pred + 1e-9))
```

## Gradient Descent

Gradient descent navigates the loss surface by repeatedly stepping in the direction of steepest descent — the negative gradient.

theta = theta - eta times gradient of L with respect to theta

eta (learning rate) controls step size. Too large: oscillates or diverges. Too small: converges very slowly.

```python
theta = 0.5
lr = 0.01
for _ in range(1000):
    grad = 2 * (theta - 3)   # gradient of (theta-3)^2
    theta -= lr * grad
print(f"Converged to theta = {theta:.4f}")   # ~3.0
```

## Variants

Batch gradient descent computes the gradient on the entire training set per step — exact gradient but expensive for large datasets. Stochastic gradient descent uses one random sample per step — fast but noisy. Mini-batch gradient descent (the standard) uses a random batch of 32 to 512 samples — balances accuracy and computational cost.

## Local vs Global Minima

Convex loss surfaces (linear regression, logistic regression) have only one minimum — gradient descent finds it. Non-convex surfaces (neural networks) have many local minima. In practice most local minima in deep networks have similar loss values to the global minimum, so this is less problematic than theory suggests.

## ML Connection

Every ML model training procedure is gradient descent on a loss function. Adam, RMSProp, Adagrad are adaptive variants of gradient descent that adjust the learning rate per parameter. Learning rate schedulers reduce eta during training. Regularisation (L1, L2) adds a penalty term to the loss function — the gradient of the penalty shrinks weights during training.

## Interview Questions

What is the role of the loss function in ML? Describe gradient descent in your own words. What are the differences between batch, stochastic, and mini-batch gradient descent? What is the learning rate and what happens when it is too large or too small? Why does gradient descent work well for neural networks despite non-convex loss surfaces?
EOF

cat > "$BASE/06_Calculus_Optimisation/02_Differential_Calculus.md" << 'EOF'
# Differential Calculus for ML
Source: Session 23 of playlist (premium)
Watch: https://www.youtube.com/watch?v=-siBIGUREjw

## The Derivative

The derivative f'(x) at a point is the instantaneous rate of change — the slope of the function at that exact point. For ML, the derivative of the loss with respect to a parameter tells you how much the loss increases when you increase that parameter by a tiny amount. This is the signal gradient descent uses.

## Key Rules

Power rule: derivative of x to the n is n times x to the n-1.

Chain rule: derivative of f(g(x)) = f'(g(x)) times g'(x). The chain rule is the single most important calculus rule for deep learning — backpropagation is the chain rule applied repeatedly from output to input through a neural network.

## Partial Derivatives

When a function has multiple inputs (a loss function with millions of parameters), the partial derivative with respect to parameter i measures how the loss changes when only that parameter changes, holding all others constant.

```python
def partial_derivative(f, params, i, h=1e-5):
    params_plus = params.copy()
    params_plus[i] += h
    return (f(params_plus) - f(params)) / h
```

## The Gradient

The gradient is the vector of all partial derivatives. It points in the direction of steepest ascent of the function. Negating it gives the direction of steepest descent — hence gradient descent steps in the direction of the negative gradient.

## Backpropagation

Backpropagation computes gradients in a neural network by applying the chain rule layer by layer from output back to input. For a network with loss L, hidden layer output h = g(x), and final output f(h):

dL/dx = (dL/df) times (df/dh) times (dh/dx)

Modern frameworks (PyTorch, TensorFlow) do this automatically via automatic differentiation. Understanding that they are applying the chain rule is essential for debugging gradient issues.

```python
import torch
x = torch.tensor(3.0, requires_grad=True)
y = (x - 2) ** 2
y.backward()
print(x.grad)   # 2*(3-2) = 2.0 — gradient computed automatically
```

## Vanishing and Exploding Gradients

If each layer multiplies the gradient by a value less than 1, the gradient shrinks exponentially as it propagates backward — vanishing gradients. Deep networks trained with sigmoid activations suffer from this because the sigmoid derivative is at most 0.25 and approaches zero at both extremes.

If each layer multiplies by a value greater than 1, the gradient grows exponentially — exploding gradients.

```python
import numpy as np
def sigmoid(x):      return 1 / (1 + np.exp(-x))
def sigmoid_grad(x): return sigmoid(x) * (1 - sigmoid(x))

print(sigmoid_grad(0))    # 0.25 — maximum gradient of sigmoid
print(sigmoid_grad(10))   # ~4.5e-5 — nearly zero, gradient vanishes

def relu_grad(x): return float(x > 0)
print(relu_grad(10))   # 1.0 — full gradient passes through for positive input
```

ReLU does not saturate for positive inputs — this is the primary reason ReLU replaced sigmoid as the default activation in deep networks.

Solutions to vanishing gradients: ReLU activations, He/Xavier weight initialisation, batch normalisation, residual connections (ResNets).

Solutions to exploding gradients: gradient clipping, careful initialisation.

## ML Connection

Every training step of every neural network is one application of backpropagation (the chain rule) followed by one step of gradient descent. Batch normalisation stabilises the gradient magnitudes across layers. Learning rate warmup schedules start with small steps to avoid large gradient updates at the start of training. Understanding gradient flow is the basis for diagnosing why a network is not learning.

## Interview Questions

What is the chain rule and why is it central to backpropagation? What is the vanishing gradient problem and what causes it? Why does ReLU help with vanishing gradients compared to sigmoid? What is gradient clipping and when is it used? What is automatic differentiation and how does PyTorch implement it?
EOF

# =============================================================================
# _archive
# =============================================================================
cat > "$BASE/_archive/README.md" << 'EOF'
# Archive

This folder contains original planning notes and scratch files from before the vault was restructured. Not part of the active curriculum. Kept for reference only.
EOF

echo ""
echo "=============================================="
echo " Build complete."
echo "=============================================="
echo ""
echo "Structure:"
find "$BASE" -type f -name "*.md" | sort
echo ""
echo "Backup at: $BACKUP"


chmod +x /home/claude/build_06_Maths.sh
wc -l /home/claude/build_06_Maths.sh