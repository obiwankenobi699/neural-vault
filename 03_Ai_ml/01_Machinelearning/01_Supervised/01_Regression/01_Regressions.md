---
title: 01_Regressions
tags:
  - ML
  - Supervised_Regression
created: 2025-11-16
updated:
  "{ date }":
---


> **Subject:** {{Subject}}  
> **Topic Type:** Concept / Process / Architecture / Example  
> **Related Topics:** 

---

## **1. Introduction**

Regression is one of the most essential techniques in **machine learning** and **statistics**.
It deals with estimating the relationships between variables — specifically, predicting a **continuous output variable (Y)** based on one or more **input variables (X₁, X₂, …, Xn)**.

Its goal is to understand how changes in one or more inputs lead to changes in the output. For example, how studying more hours affects your exam marks, or how changes in humidity affect air pollution.

The general regression equation is:

$$
[
Y = f(X) + \varepsilon
]

$$
Here:

* (Y) → dependent variable (target)
* (X) → independent variable(s)
* (f(X)) → function learned by model
* (\varepsilon) → random noise or error term

---

## **2. Why Regression Is Needed**

Regression is the **foundation of prediction** in data science.
It helps to:

* Forecast numerical values (like rainfall, temperature, sales).
* Detect **trends and relationships** between variables.
* Provide an interpretable model for decision-making.
* Form the base for complex systems such as neural networks, time series models, and reinforcement learning algorithms.

---

## **3. Mathematical Objective**

Regression tries to **fit a function** that minimizes the **error** between predicted and actual outputs.
The most common error metric is the **Sum of Squared Errors (SSE):**

$$
[
J(\beta) = \sum (Y_i - \hat{Y_i})^2
]

$$
where ( \hat{Y_i} ) is the model prediction, and ( \beta ) are the parameters (coefficients).

To find the best parameters:
$$
[
\hat{\beta} = (X^T X)^{-1} X^T Y
]

$$
$$
The smaller the value of (J(\beta)), the better the fit.
$$

---

## **4. Types of Regression Models**

---

### **4.1 Simple Linear Regression**

**Theory:**
This is the simplest form of regression.
It assumes a linear relationship between one independent variable (X) and the dependent variable (Y).
The equation is:
$$

[
Y = \beta_0 + \beta_1 X + \varepsilon
]

$$
Here:

* ( \beta_0 ): intercept
* ( \beta_1 ): slope (how much Y changes when X increases by 1 unit)

**ASCII Diagram:**

```
Y
│                 *
│              *      
│           *            
│        *               
│     *                  
│  *                     
└────────────────────────── X
         ↑ slope (β₁)
```

**Explanation:**
The regression line represents the best linear fit through the data points.
It assumes the effect of X on Y is constant and linear.

**Use Case:**
Predicting a student’s marks from hours studied, or house price from area size.

---

### **4.2 Multiple Linear Regression**

**Theory:**
When more than one variable influences the target, we use multiple linear regression:

$$
[
Y = \beta_0 + \beta_1X_1 + \beta_2X_2 + ... + \beta_nX_n + \varepsilon
]

$$
It generalizes linear regression into a **multi-dimensional plane**.

**ASCII Diagram (Conceptual Plane):**

```
              ● Y (Predicted)
              /
             /
   ---------/----------> X₁
           /
          /
         /
        X₂
```

**Explanation:**
Each coefficient shows how much Y changes with a 1-unit change in that specific X, while others are held constant.

**Use Case:**
Predicting car mileage based on weight, horsepower, and engine size.

---

### **4.3 Polynomial Regression**

**Theory:**
Used when data shows a curved or non-linear relationship.
The model fits a polynomial curve instead of a straight line:

$$
[
Y = \beta_0 + \beta_1X + \beta_2X^2 + ... + \beta_nX^n + \varepsilon
]
$$

**ASCII Visualization:**

```
Y
│                  *
│             *          *
│         *                   *
│     *                             *
│  *_________________________________________ X
     Curved relationship captured
```

**Explanation:**
Polynomial regression introduces higher-order terms like (X^2, X^3) to model curvature.
It can overfit if the degree is too high, so regularization or cross-validation is used.

**Use Case:**
Modeling population growth or air pollution variation over time.

---

### **4.4 Ridge Regression (L2 Regularization)**

**Theory:**
When predictors are correlated, coefficients can fluctuate wildly.
Ridge regression reduces this problem by adding a **penalty term**:
$$

[
J(\beta) = \sum (Y_i - \hat{Y_i})^2 + \lambda \sum \beta_j^2
]
$$

**ASCII Diagram:**

```
Coefficient shrinkage illustration:
β₂
│       *
│     *
│   *
│ *
└────────────── β₁
      ↓ Shrinking toward zero
```

**Explanation:**
Ridge regression doesn’t eliminate coefficients but shrinks them toward zero, making the model stable and preventing overfitting.

**Use Case:**
Weather prediction with multiple correlated variables.

---

### **4.5 Lasso Regression (L1 Regularization)**

**Theory:**
Lasso regression modifies the cost by using the **absolute value** of coefficients:

$$
[
J(\beta) = \sum (Y_i - \hat{Y_i})^2 + \lambda \sum |\beta_j|
]
$$

**ASCII Diagram:**

```
β₂
│         .
│       .
│     .
│   .
│ .
└────────────── β₁
        ↑
  Drives small β to 0
```

**Explanation:**
Unlike Ridge, Lasso can drive coefficients to **exactly zero**, performing **feature selection** automatically.

**Use Case:**
Medical prediction models — identifying key biomarkers influencing outcomes.

---

### **4.6 Logistic Regression**


Logistic Regression is a fundamental statistical classification technique used when the dependent variable is categorical, most commonly binary (such as “disease/no disease”, “spam/non-spam”, or “pass/fail”). Although the name contains the word “regression”, the algorithm is actually a **classification model**. Logistic Regression works by estimating the probability that a given input sample belongs to a particular class. To model this probability, it applies the **sigmoid (logistic) function** to a linear combination of input features. First, the model computes a value known as **z**, which is obtained from the weighted sum of the inputs:  
$$
[  
z = \beta_0 + \beta_1X_1 + \beta_2X_2 + ... + \beta_nX_n  
]  
$$
This value can lie anywhere between negative infinity and positive infinity. Since raw linear values cannot be used as probabilities, the logistic regression model passes **z** through the **sigmoid function**:  
$$
[  
\sigma(z) = \frac{1}{1 + e^{-z}}  
]  
$$
The sigmoid function transforms any real number into a value strictly between **0 and 1**, making it suitable for representing a probability. When **σ(z)** is close to 1, the model is confident that the input belongs to the positive class (class 1). When σ(z) is near 0, it indicates high confidence that the input belongs to the negative class (class 0). The final classification decision is made by applying a threshold, typically **0.5**, meaning that if the computed probability is **≥ 0.5**, the model predicts class 1; otherwise, it predicts class 0.

Logistic Regression creates a **decision boundary**, which is linear when the features are linearly separable. The boundary represents all the values for which the probability equals exactly 0.5, i.e., when **z = 0**. This boundary divides the input space into two regions, one for each class. Because the sigmoid curve is smooth, logistic regression provides a gradual and interpretable transition between classes, unlike hard-threshold rule-based classifiers. One of its key strengths is that it produces **probabilistic outputs**, not just class labels, which makes it useful for risk estimation, medical analysis, fraud detection, and many real-world decision-making systems.




## ** ASCII Diagram of Sigmoid**

```
Probability
1.0 |                             _________
    |                          .´
0.8 |                        .´
    |                      .´
0.6 |                   .´
    |                .´
0.5 |--------------*--------------------------> z
    |           .´
0.2 |        .´
    |     .´
0.0 |____.____________________________________
       -6     -4    -2    0    2    4     6
```

- The curve **smoothly transitions** from 0 to 1
    
- At **z = 0**, the probability = **0.5**
    
- Values towards +∞ → probability ≈ **1**
    
- Values towards –∞ → probability ≈ **0**
    

---

# **3. How Logistic Regression Makes a Prediction**

### Step 1 — Compute the weighted sum
$$

[  
z = \beta_0 + \beta_1X_1 + \beta_2X_2  
]

$$
### Step 2 — Pass through sigmoid

$$
[  
P(Y=1|X) = \sigma(z)  
]

$$
### Step 3 — Apply decision rule

```
If Probability ≥ 0.5 → Class 1
If Probability < 0.5 → Class 0
```

This is why logistic regression is a **probabilistic classifier**.

---

# **4. ASCII Diagram of Decision Boundary**

Imagine a **2D dataset** with two classes:

```
Class 1 → X
Class 0 → O
```

A logistic regression decision boundary looks like:

```
      X  X  X  X  
    X  X  X  |   O   O
      X  X  |        O   O
------------+-----------------
      O  O  |        O   O
         O  |   O  O
```

`|` is the **decision boundary** created by logistic regression.

- Points on the **left** → classified as **Class 1**
    
- Points on the **right** → classified as **Class 0**
    

Mathematically, the boundary is when:

$$
[  
P(Y=1|X) = 0.5 \Rightarrow z = 0  
]

$$
That means:

$$
[  
\beta_0 + \beta_1X_1 + \beta_2X_2 = 0  
]

$$

---

# **5. ASCII Diagram of Probability Output**

This diagram shows how logistic regression maps any input into probability:

```
Linear Output z:     Sigmoid Output:
------------------------------------------
 z = -5     ---->      0.007
 z = -2     ---->      0.119
 z =  0     ---->      0.500
 z =  2     ---->      0.880
 z =  5     ---->      0.993
```

Even if z = 9999 → sigmoid = 1  
Even if z = –9999 → sigmoid = 0

So sigmoid **stabilizes** extreme values.

---

# **6. Why Logistic Regression Works Well**

✔ Interpretable — easy to explain in assignments  
✔ Gives probability instead of just class  
✔ Works for linearly separable data  
✔ Training is fast  
✔ Good baseline classifier  
✔ Extends to multi-class (softmax regression)

---

# **7. Small Example**

Suppose:
$$

[  
z = -3 + 0.8X  
]

$$
If X = 6:

$$
[  
z = -3 + 0.8(6) = 1.8  
]
$$

Probability:

$$
[  
P = \sigma(1.8) = 0.858  
]

$$
Classification:

```
0.858 > 0.5  → Class = 1
```

---

# **8. Final ASCII Summary Diagram**

```
Input X ───► Linear Function ───► Sigmoid ───► Probability ───► Class
               z = β0 + βX          1/(1+e^-z)         >=0.5?      
```

---

### **4.7 Support Vector Regression (SVR)**

**Theory:**
Based on the concept of **support vectors** from SVM, SVR fits a function within a margin of tolerance (ε).
Only points outside this margin affect the model.

**ASCII Visualization:**

```
Y
│             |--- ε ---|
│   ●      ●     ●     ●
│----●------●------●-------- X
     ↑     ↑       ↑
  support vectors
```

**Explanation:**
SVR tries to find the most stable prediction by ignoring small fluctuations (noise) and focusing on critical boundary points.

**Use Case:**
Forecasting stock prices, AQI index prediction, or temperature modeling.

---

### **4.8 Decision Tree Regression**

**Theory:**
Decision Trees split data into smaller groups (nodes) based on decision rules.
Each leaf node gives a predicted numeric value.

**ASCII Visualization:**

```
          [X1 < 5]
          /      \
     [Y=20]     [X2<3]
                 /   \
             [Y=15] [Y=25]
```

**Explanation:**
The tree divides data into regions where each branch is a rule, and each leaf node represents an outcome.
It’s intuitive but can overfit without pruning.

**Use Case:**
Predicting energy use based on time, temperature, and device type.

---

### **4.9 Random Forest Regression**

**Theory:**
Random Forest is an ensemble of Decision Trees.
Each tree makes a prediction, and their average is taken as the final result:

$[$
$\hat{Y} = \frac{1}{n}\sum_{i=1}^n Tree_i(X)$
$]$

**ASCII Visualization:**

```
Tree₁ → Y₁ = 21
Tree₂ → Y₂ = 23
Tree₃ → Y₃ = 22
---------------------
Final Prediction = 22 (average)
```

**Explanation:**
By combining multiple trees trained on different subsets, Random Forest reduces overfitting and improves accuracy.

**Use Case:**
Predicting crop yield, rainfall, or financial risk.

---

## **5. Evaluation Metrics**

| Metric       | Formula                                 | Meaning                             |   |                            |
| ------------ | --------------------------------------- | ----------------------------------- | - | -------------------------- |
| **MAE**      | ( \frac{1}{n}\sum                       | y_i - \hat{y_i}                     | ) | Average absolute deviation |
| **MSE**      | ( \frac{1}{n}\sum (y_i - \hat{y_i})^2 ) | Penalizes large errors              |   |                            |
| **RMSE**     | ( \sqrt{MSE} )                          | Root mean square error              |   |                            |
| **R² Score** | ( 1 - \frac{SS_{res}}{SS_{tot}} )       | Explains variance captured by model |   |                            |

---

## **6. Applications of Regression**

* **Healthcare:** Predicting patient health metrics like blood sugar or blood pressure.
* **Environment:** AQI and pollution level forecasting.
* **Economics:** Predicting inflation or GDP growth.
* **Education:** Predicting student performance.
* **Business:** Customer spending and revenue forecasting.

---

## **7. Conclusion**

Regression models are the **cornerstone of predictive analytics**.
They provide interpretability, mathematical structure, and the base for modern AI systems.

From simple linear models to ensemble regressors like Random Forest, each type of regression balances **bias**, **variance**, and **interpretability** differently.
Mastering regression helps in understanding both **data behavior** and **decision logic**, forming the bridge between classical statistics and modern machine learning.

---

Would you like me to now put this version into a **college report format (Abstract, Introduction, Methodology, Result, Conclusion)** — same style as your friend’s PDF — so you can directly edit and submit it?
