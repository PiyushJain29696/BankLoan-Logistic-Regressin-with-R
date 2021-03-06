# Hello Data Scientists

library(dplyr)
library(funModeling)
library(psych)
library(ggplot2)
library(ggpubr)
library(ggthemes)
library(psych)
library(caret)
library(ROCR)
library(ROSE)

# Reading the Data set
bankloan <- read.csv("C:/Users/Admin/Desktop/Data Science/Imarticus/Projects/Bank Loan/bankloan.csv")
#View(bankloan)

# Check the dimension of the data frame
dim(bankloan)

# View all the column names
names(bankloan)

str(bankloan)
# ed and default are coming as integers but they are factors.
# Lets convert them into factors.
bankloan$ed <- as.factor(bankloan$ed)
bankloan$default <- as.factor(bankloan$default)

str(bankloan)
# ed and default are converted into Factors

status(bankloan)

freq(bankloan)

plot_num(bankloan) # Individual variable colorful graph 

summary(bankloan)
# We could observe that there are no missing values.

describe(bankloan)
# Income and Othdebt are highly skewed



########################### Univariant Analysis  #####################


# Box plot of each variable to detect outliers 
par(mfrow=c(1,3))
boxplot(bankloan[,c(1)] , col = "bisque" ,notch=T , outline = T , xlab = "Age" )
boxplot(bankloan[,c(3)] , col = "green" ,notch=T , outline = T , xlab = "Employnment year")
boxplot(bankloan[,c(4)] , col = "orange" ,notch=T , outline = T , xlab = "Address year")

par(mfrow=c(1,3))
boxplot(bankloan[,c(5)] , col = "blue",notch=T , outline = T , xlab = "Income" )
boxplot(bankloan[,c(6)] , col = "bisque",notch=T , outline = T , xlab = "debtInc" )
boxplot(bankloan[,c(7)] , col = "yellow",notch=T , outline = T , xlab = "creddebt" )


# Doghnut Plot of Distribution of Defaulters in Total Data
tdd <- table(bankloan$default)
names(tdd) = c("No Defaulter", "Defaulter")
tdd <- data.frame(tdd)
tdd$percent <- round((tdd$Freq/nrow(bankloan))*100 , digits = 0)

 total <-ggplot(data = tdd, 
       aes(x = 2, y = Freq, fill = Var1))+
  geom_bar(stat = "identity")+
  coord_polar( "y",start = 200) +
  geom_text(aes(label = paste(Freq , "(",percent,"%)" , spe = "")), col = "black" ,  position = position_stack(vjust = 0.5)) +
  theme_void() +
  scale_fill_brewer(palette = "Set1")+
  xlim(.5,2.5) + labs(title ="Total Data Set") +
   theme(plot.title = element_text(hjust = .5)) 

 tdd
## We could see that total defaulters are 183 and Non defaulters are 517

# Splitting the data into Train and Test
set.seed(42)
default_idx = sample(nrow(bankloan), 0.7*nrow(bankloan))
default_trn = bankloan[default_idx, ]   # Training Data
default_tst = bankloan[-default_idx, ]  # Testing Data


# Doghnut Plot of Distribution of Defaulters in Training Data
tab_trn = xtabs(~default_trn$default , data = default_trn)

names(tab_trn) = c("No Defaulter", "Defaulter")
tab_trn <- data.frame(tab_trn)
tab_trn$percent <- round((tab_trn$Freq/nrow(default_trn))*100 , digits = 0)

train <-ggplot(data = tab_trn, aes(x = 2, y = Freq, fill = Var1))+
  geom_bar(stat = "identity")+
  coord_polar( "y",start = 200) +
  geom_text(aes(label = paste(Freq , "(",percent,"%)" , spe = "")), col = "black" ,  position = position_stack(vjust = 0.5)) +
  theme_void() +
  scale_fill_brewer(palette = "Dark2")+
  xlim(.5,2.5) +  labs(title ="Training Data Set") +
  theme(plot.title = element_text(hjust = .5)) 


# Doghnut Plot of Distribution of Defaulters in Test Data
tab_tst <- xtabs(~default_tst$default , data = default_tst)

names(tab_tst) = c("No Defaulter", "Defaulter")
tab_tst <- data.frame(tab_tst)
tab_tst$percent <- round((tab_tst$Freq/nrow(default_tst))*100 , digits = 0)

test <-ggplot(data = tab_tst, aes(x = 2, y = Freq, fill = Var1))+
  geom_bar(stat = "identity")+
  coord_polar( "y",start = 200) +
  geom_text(aes(label = paste(Freq , "(",percent,"%)" , spe = "")), col = "black" ,  position = position_stack(vjust = 0.5)) +
  theme_void() +
  scale_fill_brewer(palette = "Dark2")+
  xlim(.5,2.5) +  labs(title ="Test Data Set") +
  theme(plot.title = element_text(hjust = .5)) 

#install.packages("ggpubr")
library(ggpubr)
ggarrange(total,                                                
          ggarrange(train, test, ncol = 2), 
          nrow = 2 )    



# Bar graph of Education and Defaulter

tab_edu <-xtabs(~ ed+default , data = bankloan)
tab_edu <- data.frame(tab_edu)

  ggplot(data = tab_edu , aes( x = ed  , y= Freq , fill = factor(default))) +
  geom_bar(stat = "identity", width = .6) + 
  coord_flip() +
  labs(title="Age") +
    theme_minimal() +
  theme(plot.title = element_text(hjust = .5), axis.ticks = element_blank()) +   
  scale_fill_brewer(palette = "Dark2")
## We can observe that with higher education there are less defaulters.

  
# Histogram of Age and Defaulter
ggplot(data = bankloan , aes( x = age , fill = factor(default)))+
  geom_histogram(binwidth = 5 ,position = "dodge", color ="white" ) + theme_minimal() + 
  labs(y = "Total Count", 
     fill = "Default",
     x = "Age",
     title = "Distribution of defaulters by Age") +
  scale_fill_brewer(palette="Set2")
## We can observe that between age group of 25 - 45 the default rate is high  


# Histogram of Employeed year and Defaulter
ggplot(data = bankloan , aes( x = employ , fill = factor(default)))+
  geom_bar(color="white") + theme_minimal() + 
  labs(y = "Total Count", 
       fill = "Default",
       x = "Employeed years",
       title = "Distribution of defaulters by Employeed years") + 
    facet_grid(default ~., scales = "free")
## We can observe that in employed years less than 10 there is higher chance of being defaulter.

# Histogram of Address year and Defaulter
ggplot(data = bankloan , aes( x = address ,fill = factor(default)))+
  geom_bar(color="white") + theme_minimal() + 
  labs(y = "Total Count", 
       fill = "Default",
       x = "Address years",
       title = "Distribution of defaulters by Address years") + 
  scale_fill_brewer(palette="Set2")+
  facet_grid(default ~., scales = "free")
## We can observe that in address years less than 10 there is higher chance of being defaulter.
  
# Histogram of Income and Defaulter
ggplot(data = bankloan , aes( x = income ,fill = factor(default)))+
  geom_histogram(binwidth = 20, color = "grey30")+  xlim(0,200) + theme_minimal() + 
  labs(y = "Total Count", 
       fill = "Default",
       x = "Income",
       title = "Distribution of defaulters by Income") + 
  scale_fill_brewer(palette="Dark2")+
  facet_grid (default ~., scales = "free") 
## For income less than 50 chances of being a defaulter is high


## T test
ttd=t.test(bankloan$age~bankloan$default,var.equal = TRUE,alternative = "two.sided")
ttd

ttd2=t.test(bankloan$employ~bankloan$default,var.equal = TRUE,alternative = "two.sided")
ttd2

ttd3=t.test(bankloan$address~bankloan$default,var.equal = TRUE,alternative = "two.sided")
ttd3

ttd4=t.test(bankloan$income~bankloan$default,var.equal = TRUE,alternative = "two.sided")
ttd4


library(psych)
pairs.panels(bankloan[,1:8])




# CREATE MODEL WITH TRAIN DATASET
model1<-glm(default~.,data=default_trn,family='binomial')
summary(model1)
## Based on output of model 1 we can observe that ed ,income, othdebt are
## in-significant data as per p-value.

# BUILDING MODEL 2 BY REMOVING INSIGNIFICANT PREDICTOS
model2<-glm(default~age+employ+address+debtinc+creddebt,data=default_trn,family='binomial')
summary(model2)

# PREDICTIONS
pred_log=predict(model2,default_tst,type='response')

# ROC CURVE WITH 2 ,3 THREASHOLDS
library(ROCR)
per_log1=prediction(pred_log,default_tst$default)
acc=performance(per_log1,"acc")
plot(acc,colorrize=T) # find threashold value = 1.0
#Build confusion matrix with above determined threashold value to get maximum accuracy
table(default_tst$default, pred_log>0.4)
#     FALSE  TRUE
# 0    135    20
# 1     21    35


ROC_Curve =performance(per_log1,"tpr","fpr")
plot(ROC_Curve,colorize=T)
abline(a=0,b=1)
#We need to take value when TPR and FPR are in green shape here its 0.4 to 0.6 e.g 0.5 threshold

# AUC - AREA UNDER CURVE 
auc=performance(per_log1,"auc")
auc=unlist(slot(auc,"y.values"))
auc     
auc=round(auc,4)
auc
legend(.6,.4, auc,title="AUC")


get_logistic_pred = function(mod, data, res = "y", pos = 1, neg = 0, cut = 0.5) {
  probs = predict(mod, newdata = data, type = "response")
  ifelse(probs > cut, pos, neg)
}

test_pred_50 = get_logistic_pred(model2, data = default_tst, res = "default", 
                                 pos = 1, neg = 0, cut = 0.5)

test_tab_50 = table(predicted = test_pred_50, actual = default_tst$default)

library(caret)
test_con_mat_50 = confusionMatrix(test_tab_50)
test_con_mat_50



# UPSAMPLING ON OVERALL DATASET
#install.packages("ROSE")
library(ROSE)   #RANDOMELY OVERSAMPLING EXAMPLES
table(bankloan$default)
# 0   1 
# 517 183 
over<- ovun.sample(default~.,data = bankloan,method = "over",N=1034)$data

table(over$default)
# 0   1 
# 517 517

#BELOW IN N WE NEED TO PUT VALUE FOR 0 WE CAN SEE THERE ARE 363 ENTRIES FOR 0 
#AND IF WE WANT SAME FOR ONE THEN PUT 363*2 IN N=726 TO GET EQUAL SAMPLE FOR 0 AND 1


# DATA SPLIT of BALANCED DATA
set.seed(123)
sample_data_Balanced=sample(2,nrow(over),replace = T,prob = c(.7,.3))
train_data_balanced=over[sample_data_Balanced==1,]
dim(train_data_balanced) #733   9
test_data_balanced=over[sample_data_Balanced==2,]
dim(test_data_balanced) #301   9  


# Build a model 
model_log2=glm(default~., data = train_data_balanced,family = 'binomial')
length(model_log2) 
summary(model_log2)

#BUILD BEST FIT MODEL
model_log3=glm(default~employ+address+creddebt, data = train_data_balanced,family = 'binomial')
model_log3 
summary(model_log3)



#PREDICT
pred_log3=predict(model_log3,test_data_balanced,type='response')

table(test_data_balanced$default)
# 0   1 
# 146 155  

# CREATE CONFUSION MATRIX
table(test_data_balanced$default, pred_log3>=0.5)

accuracy_balanced =  (109+123)/(109+37+32+123)
accuracy_balanced 

true_positive_rate_balanced=(123)/(123+32) # Recall/Sensitity=TP/TP+FN Sesitivity shows how relevant model is in terms of positive result
true_positive_rate_balanced  

false_positive_rate_balanced=(37)/(37+109) #FP/FP+TN
false_positive_rate_balanced 

precision_balanced=(123)/(125+32)   # TP/TP+FP =predicted truly relevant result, among +ve predictors how many are true 
precision_balanced      

f2score_balanced=(2*true_positive_rate_balanced*precision_balanced)/
  (true_positive_rate_balanced+precision_balanced)
f2score_balanced      # mean between precision and recall,best measure of performance in situations with imbalanced data

# ROC CURVE 
per_log3=prediction(pred_log3,test_data_balanced$default)
ROC_Curve3=performance(per_log3,"acc")
plot(ROC_Curve3,colorrize=T) # find threashold value = 1.0
#Build confusion matrix with above determined threashold value to get maximum accuracy
ROC_Curve3=performance(per_log3,"tpr","fpr")
# plot(ROC_Curve3,colorize=T)
plot(ROC_Curve3, colorize=T,main="ROC curve Best fit model",ylab="TPR(sensitivity)",xlab="FPR(1-specificity)")
abline(a=0,b=1)

# AUC - AREA UNDER CURVE
auc3=performance(per_log3,"auc")
auc3=unlist(slot(auc3,"y.values"))
auc3     # 0.8402121   
auc3=round(auc3,4)
auc3 #0.8402
legend(.6,.4, auc3,title="AUC")


plot(ROC_Curve,colorize=T)
plot(ROC_Curve3, colorize=T,main="ROC curve Best fit model",ylab="TPR(sensitivity)",xlab="FPR(1-specificity)",add = TRUE)


#==== End of script thank you ====
