# Combine Predictions of conditional random forest, gbm, adaboost, svm and xgboost into a unique one

# Source our engineered data
source("1_Feature_engineering.R")

# Source our models
source("3_Conditional_Inference_trees.R")
source("4_svm.R")
source("5_Boosting.R")
source("6_Adaboost.R")
source("7_Xgboost.R")

# Combine predictions
vote_test <- 0
vote_test <- as.numeric(Prediction)-1 + as.numeric(predict_gbm_test) + as.numeric(predict_maboost_test)-1 + as.numeric(prediction_svm_test) + as.numeric(predict_xgboost_test)
head(vote_test, n = 30)

head(as.numeric(Prediction)-1, n = 30)
head(as.numeric(predict_gbm_test), n = 30)
head(as.numeric(predict_maboost_test)-1, n = 30)
head(as.numeric(prediction_svm_test), n = 30)
head(as.numeric(predict_xgboost_test), n = 30)

# 1 is 0 
# 2 is 0
# 3 is 1
# 4 is 1
# 5 is 1

combined_test <- vote_test
combined_test[combined_test <= 2] <- 0
combined_test[combined_test >=3] <- 1
head(combined_test, n = 30)

# Creating the submitting file
submit <- data.frame(PassengerId = test$PassengerId, Survived = combined_test)
write.csv(submit, file = "secondensemble.csv", row.names = FALSE)
#First ensemble: 0.80383
#second ensemble: 0.81340, same as the conditional random forest alone
