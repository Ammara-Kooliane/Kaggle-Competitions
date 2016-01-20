# Predict the category of crimes that occurred in the city by the bay 

## 1) The Data

This competition's dataset provides nearly 12 years of crime reports from across all of San Francisco's neighborhoods. Given time and location, the aim is to predict the category of crime that occurred.

### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;a) The Data sets

This dataset contains incidents derived from SFPD Crime Incident Reporting system. The data ranges from 1/1/2003 to 5/13/2015. The training set and test set rotate every week, meaning week 1,3,5,7... belong to test set, week 2,4,6,8 belong to training set. 

### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;b) Data fields

Dates - timestamp of the crime incident
Category - category of the crime incident (only in train.csv). This is the target variable you are going to predict.
Descript - detailed description of the crime incident (only in train.csv)
DayOfWeek - the day of the week
PdDistrict - name of the Police Department District
Resolution - how the crime incident was resolved (only in train.csv)
Address - the approximate street address of the crime incident 
X - Longitude
Y - Latitude

## 2) The files

###&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; a) Script1_LDA.R
Contains the first submission to the Kaggle website. The model used is linear discriminant analysis (LDA) with bagging technique.
Logloss score shows that bagging technique on the LDA model does not make a big difference.

###&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; b) Script2_LDA_multinom.R
Contains the second submission to the Kaggle website. The model used is multinomial classification via neural networks (multinom function) and with the bagging technique. Score was better with the bagging technique on the multinom model than without.

###&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; c) Script3_Ggplot2.R
Contains the graph script used to analyze the features and output.

###&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; d) Trials.R
This files contains all the trials for other models than LDA and multinom like random forest which score was worst or glmnet which I was unable to finish due to memory constrains.
