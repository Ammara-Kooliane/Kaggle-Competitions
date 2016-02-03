# Combine Predictions of conditional inference trees, gbm, adaboost, svm and xgboost into a unique one

# Source our engineered data
source("1_Feature_engineering.R")

# Source our models
source("3_Conditional_Inference_trees.R") # Gives Prediction prediction
source("4_svm.R") # Gives prediction_svm_test prediction
source("5_Boosting.R") # Gives predict_gbm_test prediction
source("6_Adaboost.R") # Gives predict_maboost_test prediction
source("7_Xgboost.R") # Gives predict_xgboost_test prediction

# Combine predictions
vote_test <- 0
vote_test <- as.numeric(Prediction)-1 + as.numeric(predict_gbm_test) + as.numeric(predict_maboost_test)-1 + as.numeric(prediction_svm_test) + as.numeric(predict_xgboost_test)
head(vote_test, n = 30)

head(as.numeric(Prediction)-1, n = 30)
head(as.numeric(predict_gbm_test), n = 30)
head(as.numeric(predict_maboost_test)-1, n = 30)
head(as.numeric(prediction_svm_test), n = 30)
head(as.numeric(predict_xgboost_test), n = 30)

# 1 means only 1 model has predicted a survival. It is converted to 0 
# 2 means only 2 models have predicted a survival. It is converted to 0  
# 3 means 3 models have predicted a survival. It is converted to 1
# 4 means 4 models have predicted a survival. It is converted to 1
# 5 means all have predicted a survival. It is converted to 1

combined_test <- vote_test
combined_test[combined_test <= 2] <- 0
combined_test[combined_test >=3] <- 1
head(combined_test, n = 30)

# Creating the submitting file
submit <- data.frame(PassengerId = test$PassengerId, Survived = combined_test)
write.csv(submit, file = "secondensemble.csv", row.names = FALSE)
# Second ensemble: 0.81340, same score as the conditional inference trees model alone
