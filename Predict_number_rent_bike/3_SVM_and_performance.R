# Script containing the learning, predicting and performance measures with the svm model

library(e1071)
library(caret)

source("1_Analysis_script.R")

# Converting variables into factor variables
data$weather <- factor(data$weather)
data$season <- factor(data$season)

# Splitting the data set into a train and test sets
index <- createDataPartition(data$count,p=0.7,list=F) # 70%-30% ratio for the train and test sets respectively
train <-data[index,]
test <- data[-index,]

#1/ CSV learner has been chosen to predict the count variable 
# In fact, the graphs show that the influence of certain variables like "Hour" is not linear to "count".
# In addition, some explanatory variables are categorical ("season") and others are continuous ("atemp").
# SVM is powerful and is one of the models that can handle those constraints.

svm01 <- svm(count ~ Hour + Year + weather + season + temp + atemp, data=train)
prediction.svm01.train <- predict(svm01, train) # Prediction on the train set
prediction.svm01.test <- predict(svm01, test) #Prediction on the test set

#2/ RMSE (root mean square error) and MAE (mean absolute error) are both interesting performance measures
# but we will focus on the RMSE which can be used to check that the learner has not overfitted.

#3/ 
rmse01 <- sqrt(sum((test$count - prediction.svm01.test)^2)/nrow(test))
#118.22
rmse011 <- sqrt(sum((train$count - prediction.svm01.train)^2)/nrow(train))
#119.72
# The 2 RMSE very similar, so the model used does not overfit
#To enhance the prediction, cross validation can be used to choose the best parameters (giving the smallest RMSE).

#4/ The following graph shows on the y-axis the prediction and on th x-axis the real 
# number of biked rented for the whole data set
plot.window(xlim=c(0, 1000), ylim=c(0, 1000)) # Framing the window with max 1000 values on the y- and x-axis
plot(test$count, prediction.svm01.test, xlim = c(0, 1000), ylim = c(0, 1000))
abline(1,1) # The identity function is then added; it is our decision boundary
# The model underestimates high number of bike rented (over 550) since it does not predict them.

# Other learners can be used like random forest.
