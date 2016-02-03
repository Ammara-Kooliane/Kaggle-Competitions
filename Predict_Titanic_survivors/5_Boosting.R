# Titanic competition script using the gradient boosting method

library(gbm)
library(rpart)

set.seed(415)

source("1_Feature_engineering.R")

# Splitting back to the train and test sets
data <- feature_eng(train, test)
train <- data[1:891,]
test <- data[892:1309,]

# Gradient boosting fitting and predicting
n.trees <- 5000
gbm_fit <- gbm(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title + FamilySize + FamilyID, data=train, distribution = "bernoulli", interaction.depth = 3, n.minobsinnode = 10, n.trees = n.trees, shrinkage = 0.001, train.fraction = 0.8, verbose = TRUE)
gbm.perf(gbm_fit) # To see the variable importance
#summary(gbm_fit)
predict_gbm <- predict(gbm_fit, train, n.trees = gbm.perf(gbm_fit), type = "response") # Predicting on the train set to check for overfitting and best cut-off since probabilities are returned
predict_gbm2 <- predict(gbm_fit, test, n.trees = gbm.perf(gbm_fit), type = "response") # Predicting on the test set

# Since gbm gives a survival probability prediction, we need to find the best cut-off on the train set:
proportion <- sapply(seq(.3,.7,.01),function(step) c(step,sum(ifelse(predict_gbm<step,0,1)!=train$Survived)))
#dim(proportion)
predict_gbm_train <- ifelse(predict_gbm < proportion[,which.min(proportion[2,])][1],0,1) # Converting probabilities into 0 or 1 according to the best cut-off
head(predict_gbm_train)
score <- sum(train$Survived == predict_gbm_train)/nrow(train)
score

# Applying the best cut-off on the test set
predict_gbm_test <- ifelse(predict_gbm2<proportion[,which.min(proportion[2,])][1],0,1)
submit <- data.frame(PassengerId = test$PassengerId, Survived = predict_gbm_test)

# Creating the submitting file
write.csv(submit, file = "firstgbm.csv", row.names = FALSE)
