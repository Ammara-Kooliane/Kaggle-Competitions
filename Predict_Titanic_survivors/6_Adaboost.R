# Titanic competition script using the adaboost method with the maboost package that also works with multi-classification

library(maboost)

set.seed(415)

# Source our data and clean it
source("1_Feature_engineering.R")

# Splitting back to the train and test sets
data <- feature_eng(train, test)
train <- data[1:891,]
test <- data[892:1309,]

# Maboost fitting and predicting
fit_maboost <- maboost(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title + FamilySize + FamilyID, data=train, iter = 100 ,verbose = TRUE)
predict_maboost <- predict(fit_maboost, train, type = "response") # Predicting on the train set to check for overfitting
predict_maboost_test <- predict(fit_maboost, test, type = "response")  # Predicting on the test set

head(predict_maboost)
score_maboost <- sum(train$Survived == predict_maboost)/nrow(train)
score_maboost

# Creating the submitting file
submit <- data.frame(PassengerId = test$PassengerId, Survived = predict_maboost_test)
write.csv(submit, file = "firstadaboost.csv", row.names = FALSE)
