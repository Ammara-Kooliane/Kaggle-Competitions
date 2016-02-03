# Titanic competition script using the random forest model

library(randomForest)

set.seed(415)

# Source our engineered data
source("1_Feature_engineering.R")

# Splitting back to the train and test sets
data <- feature_eng(train, test)
train <- data[1:891,]
test <- data[892:1309,]

# Fitting random forest to the train set, predicting in the test set and creating the submitting file
fit <- randomForest(as.factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title + FamilySize +
FamilyID2, data=train, importance=TRUE, ntree=2000)

# Observing the variable importance after fitting the model and then predicting
varImpPlot(fit) # Pclass is the most important variable
Prediction <- predict(fit, test)

# Creating the submitting file
submit <- data.frame(PassengerId = test$PassengerId, Survived = Prediction)
write.csv(submit, file = "firstforest.csv", row.names = FALSE)
