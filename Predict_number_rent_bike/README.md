# Predict the number of bike rented from a sharing bike system

In this challenge, we are asked to predict the number of bike rented per hour in the city (count variable). 

## 1) The Data
The data file comes in a unique file and contains information from a sharing bike system in a city.

VARIABLE DESCRIPTIONS:
* datetime - date and hour
* season - 1 = spring , 2 = summer, 3 = fall, 4 = winter
* holiday – is it a school holiday?
* workingday - is it a working day?
* weather - 1: bright to cloudy, 2 : smoggy, 3 : light rain or snow, 4 : heavy rain or snow 
* temp – temperature (Celsius) 
* atemp – temperature perceived (Celsius) 
* humidity – humidity rate 
* windspeed – windspeed 
* casual - number of bike rented from unregistered clients
* registered – number of bike rented from registered clients 
* count – total number of bike rented

## 2) The process to the prediction 
* 1st step: Observation et analysis of the data (variable strutures and simple statistical analyses) to get familiar with and identify the missing values
* 2nd step: Identify the variables that best explain and predict the variable count
* 3rd step : graph illustrations to help confirming or informing the best variables
* 4th step : Chose a learning method that is relevant to the type of prediction and variable predictors => SVM model chosen
* 5th step : Split the data into a train and test sets to measure the performance of the model chosen. 
* 6th step : performance measure from the learner.
* 7th step : How to improve the performance of the prediction?

## 3) The files

###&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; a) 1_Feature_engineering.R
Contains the function doing feature engineering on the train and test sets. Fixes missing values and data strutures.

###&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; b) 2_Random_Forest.R
Contains the first submission to the Kaggle website. The model used is a simple random forest after feature engineering using 1_Feature_engineering.R. Score using accuracy has still to be increased with the following models. 

###&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; c) 3_Conditional_Inference_trees.R
After feature engineering, the model used in this script is the conditional inference trees model. This is what gives the current most highest score. 

###&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; d) 4_svm.R
Since SVM is very in trend at the moment, the model was used but did not give the best accuracy. Different boosting methods were then used to improve it.

###&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; e) 5_Boosting.R
Boosting methods are known to be very powerful. This script contains the first boosting model using the gbm package. Score is high but not as high as the contitional inference trees model.

###&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; f) 6_Adaboost.R
This script contains the second boosting model using the maboost package. Score is also high but not as high as the contitional inference trees model.

###&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; g) 7_Xgboost.R
This script contains the third boosting model using the xgboost package. Score is also high but not as high as the contitional inference trees model.

###&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; h) 8_Ensembling_voting.R
Ensembling the different learners can also improve the accuracy of the prediction. This was done using voting on the conditional inference trees, gbm, adaboost, svm and xgboost. Unfortunately, it gave the same best score as the conditional inference trees model alone.
