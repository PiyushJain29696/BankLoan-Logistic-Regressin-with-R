# BankLoan-Logistic-Regressin-with-R

## Data of customers of a bank is given and the task is to find out whether a person will be a defaulter or not.

About the data : It has 9 columns and 700 rows

1. age       : Numeric - Age of the person
2. ed        : Categorical - 5 different levels of education Values - 1,2,3,4,5
3. employ    : Numeric - Yers that person has been employed
4. address   : Numeric - Duration(in Years) in last address
5. income    : Numeric - Income of the person
6. debtinc   : Numeric - Debt to income ration
7. creddebt  : Numeric - Credit card debt
8. othdebt   : Numeric - Other kind of debt
9. default   : Categorical - Person is a defaulter or not values - 0,1


# Step-by-Step Process followed

1. Importing the data set.
2. EDA of the data to get basic idea
3. Univariant Analysis of each variables
4. Building Model
5. Predicting and plotting ROC curve
6. Measure preformance
7. Model adjustment for better result


# Major libraries used

- library(dplyr) 
- library(funModeling)
- library(psych)
- library(ggplot2)
- library(ggpubr)
- library(ggthemes)
- library(psych)
- library(caret)
- library(ROCR)
- library(ROSE)
