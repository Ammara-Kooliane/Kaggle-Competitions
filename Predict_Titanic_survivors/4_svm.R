# Titanic competition script using the svm model

library(e1071)
library(rpart)

set.seed(415)

source("1_Feature_engineering.R")

# Splitting back to the train and test sets
data <- feature_eng(train, test)
train <- data[1:891,]
test <- data[892:1309,]


# svm fitting and predicting
svm01 <- svm(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title + FamilySize + FamilyID, data=train)
prediction_svm_train <- predict(svm01, train) # prediction on test set
prediction_svm_test <- predict(svm01, test) # prediction on train set to check for overfitting

# Since the output of the svm prediction is probability of each survival/death of each data point, we need to convert the output into a deterministic form
# We need to find the best cut-off probability that minimizes the error on the train set predicton
proportion_svm <- sapply(seq(.3,.7,.01),function(step) c(step,sum(ifelse(prediction_svm_train<step,0,1)!=train$Survived)))
#dim(proportion)
prediction_svm_train <- ifelse(prediction_svm_train < proportion_svm[,which.min(proportion_svm[2,])][1],0,1)
head(prediction_svm_train)
score <- sum(train$Survived == prediction_svm_train)/nrow(train)
score

# Applying the best cut-off on the test set
prediction_svm_test <- ifelse(prediction_svm_test<proportion_svm[,which.min(proportion_svm[2,])][1],0,1)

# Creating the submission file
submit <- data.frame(PassengerId = test$PassengerId, Survived = prediction_svm_test)
write.csv(submit, file = "firstsvm.csv", row.names = FALSE)
