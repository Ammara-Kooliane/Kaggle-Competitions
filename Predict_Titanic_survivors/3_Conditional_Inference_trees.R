# Titanic competition script using the conditional inference trees

library(party)
library(rpart)

# Source our engineered data
source("1_Feature_engineering.R")

# Splitting back to the train and test sets
data <- feature_eng(train, test)
train <- data[1:891,]
test <- data[892:1309,]

# Fitting and predicting with the conditional random forest model
fit <- cforest(as.factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title + FamilySize + FamilyID,
               data = train, controls=cforest_unbiased(ntree=1000, mtry=3))
Prediction <- predict(fit, test, OOB=TRUE, type = "response")

# Creaete the submitting file
submit <- data.frame(PassengerId = test$PassengerId, Survived = Prediction)
write.csv(submit, file = "thirdforest.csv", row.names = FALSE)
# Precision score of 0.81340 which is my current best
