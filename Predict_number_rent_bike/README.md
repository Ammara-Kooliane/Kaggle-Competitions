# Titanic: Machine Learning from Disaster
## Predict survival on the Titanic 

In this challenge, we are asked to predict the number of rent bikes per hour in the city (count variable). 

## 1) The Data

VARIABLE DESCRIPTIONS:
* datetime - date and hour
* season - 1 = spring , 2 = summer, 3 = fall, 4 = winter
* holiday – is it a school holiday?
* workingday - is it a working day?
* weather - 1: bright to cloudy, 2 : smoggy, 3 : light rain or snow, 4 : heavy rain or snow 
* temp – temperature (Celsius) 
* atemp – temperature perceived (Celsius) 
* humidity – humidity rate 
* windspeed – windspeed casual - nombre de locations d’usagers non abonnés registered – nombre de locations d’usagers abonnés count – nombre total de locations de vélos

SPECIAL NOTES:
Pclass is a proxy for socio-economic status (SES)
 1st ~ Upper; 2nd ~ Middle; 3rd ~ Lower

Age is in Years; Fractional if Age less than One (1)
 If the Age is Estimated, it is in the form xx.5

* Sibling:  Brother, Sister, Stepbrother, or Stepsister of Passenger Aboard Titanic
* Spouse:   Husband or Wife of Passenger Aboard Titanic (Mistresses and Fiances Ignored)
* Parent:   Mother or Father of Passenger Aboard Titanic
* Child:    Son, Daughter, Stepson, or Stepdaughter of Passenger Aboard Titanic

## 2) The files

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
