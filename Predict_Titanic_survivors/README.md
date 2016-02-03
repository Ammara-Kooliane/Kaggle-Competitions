# Titanic: Machine Learning from Disaster
## Predict survival on the Titanic 

In this challenge, we are asked to complete the analysis of what sorts of people were likely to survive. 

## 1) The Data

VARIABLE DESCRIPTIONS:
&nbsp;survival        Survival
&nbsp;                (0 = No; 1 = Yes)
&nbsp;pclass          Passenger Class
&nbsp;                (1 = 1st; 2 = 2nd; 3 = 3rd)
&nbsp;name            Name
sex             Sex
age             Age
sibsp           Number of Siblings/Spouses Aboard
parch           Number of Parents/Children Aboard
ticket          Ticket Number
fare            Passenger Fare
cabin           Cabin
embarked        Port of Embarkation
                (C = Cherbourg; Q = Queenstown; S = Southampton)

SPECIAL NOTES:
Pclass is a proxy for socio-economic status (SES)
 1st ~ Upper; 2nd ~ Middle; 3rd ~ Lower

Age is in Years; Fractional if Age less than One (1)
 If the Age is Estimated, it is in the form xx.5

Sibling:  Brother, Sister, Stepbrother, or Stepsister of Passenger Aboard Titanic
Spouse:   Husband or Wife of Passenger Aboard Titanic (Mistresses and Fiances Ignored)
Parent:   Mother or Father of Passenger Aboard Titanic
Child:    Son, Daughter, Stepson, or Stepdaughter of Passenger Aboard Titanic

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
