library(caret)
library(randomForest)
library(lubridate)
library(glmnet)
library(scales)
library(plyr)
library(mlogit)

set.seed(42)
train <- read.csv("train.csv")

train$Dates <- strptime(train$Dates, "%Y-%m-%d %H:%M:%S") # Convert the factor variable into date with lubridate
train$Year <- year(train$Dates) # Extrating the year variable from Dates
train$Month <- month(train$Dates)
train$Day <- day(train$Dates)
train$Hour <- hour(train$Dates)

train$x <- round(train$X,2)
train$y <- round(train$Y,2)

# Logistic approach with created "training data set"
inTrain<-createDataPartition(train$Category,p=0.7,list=F)
train.sub<-train[inTrain,]
test.sub <- train[-inTrain,]

# Using glmnet package. It constrains us to convert the predictive variables into a sparse matrix
train_sparse<-sparse.model.matrix(~as.factor(PdDistrict)+as.factor(DayOfWeek)+Year+Month + Day + x+y+Hour,data=train.sub)
test_sparse<-sparse.model.matrix(~as.factor(PdDistrict)+as.factor(DayOfWeek)+Year+Month + Day + x+y+Hour,data=test.sub)

fit.glmnet <- glmnet(train_sparse, as.factor(train.sub$Category), family = "multinomial") #Fitting with glmnet function
Prediction_glmnet <- predict(fit.glmnet, test_sparse) #Predicting on the test_sparse set and converting it into a dataframe

colnames(Prediction_glmnet) <- gsub(".1", "", colnames(Prediction_glmnet)) #Suppressing ".1" term of column titles

#Next step is to compare the test.sub and the Prediction from the glmnet package
#First converting the test.sub into a dummy dataframe
dummies <- function(dataframe, vector) {
        vector1 <- vector
        vector <- as.character(unique(vector))
        vector <- sort(vector)
        for (i in vector) {
                dataframe[i] <- 0
                dataframe[which(vector1 == i), i] <- 1
        }
        return (dataframe)
}

test.dummies <- dummies(test.sub, test.sub$Category)
test.dummies <- test.dummies[-c(1:18)] #Only keeping the Category columns

#Then calculating the multiplog loss 
MultiLogLoss <- function(act, pred)
{
        eps = 1e-15;
        nr <- nrow(pred)
        pred = matrix(sapply( pred, function(x) max(eps,x)), nrow = nr)      
        pred = matrix(sapply( pred, function(x) min(1-eps,x)), nrow = nr)
        ll = sum(act*log(pred) + (1-act)*log(1-pred))
        ll = ll * -1/(nrow(act))      
        return(ll);
}

MultiLogLoss(test.dummies, Prediction$posterior)
#Prediction does not work due to memory size on a 8Gb machine

##Using glm package
#Coming back to the train dataset, we transform the Category column into a dummy variable
train.dummies <- dummies(train, train$Category)

inTrain<-createDataPartition(train.dummies$Category,p=0.6,list=F)
train.sub.dummies <-train.dummies[inTrain,]
test.sub.dummies <- train.dummies[-inTrain,]

Prediction.glm <- as.data.frame(0)
for (i in unique(train.sub.dummies$Category)) {
        fit.glm <- glm(train.sub.dummies[,i] ~ PdDistrict+Year+Month + Day + x+y+Hour,family=binomial(logit), data=train.sub.dummies)
        Prediction.glm <- cbind(Prediction.glm,predict(fit.glm, test.sub.dummies, type = "response"))
}

Prediction <- Prediction.glm[-c(1)] #suppress the first column
colnames(Prediction) <- sort(unique(train.sub.dummies$Category))

MultiLogLoss(test.sub.dummies[c(19:57)], Prediction)
#7,28 worse than the result obtained with lda (the AIC is smaller with a model without the DayOfWeek variable)


##Getting back to RF => Definitely not the right algorithm to choose
#RF with 2 variables
fit <- randomForest(as.factor(Category) ~ PdDistrict+Year+Month + Day + x+y+Hour, data=train.sub, ntree=50, mtry = 2)
Prediction_rf <- predict(fit, test.sub, OOB=TRUE, type = "prob")

#RF with 3 variables
fit2 <- randomForest(as.factor(Category) ~ PdDistrict+Year+Month + Day + x+y+Hour, data=train.sub, ntree=50, mtry = 3)
Prediction_rf2 <- predict(fit2, test.sub, OOB=TRUE, type = "prob")

test.dummies <- dummies(test.sub, test.sub$Category)
test.dummies <- test.dummies[-c(1:15)] #Only keeping the Category columns

MultiLogLoss(test.dummies, Prediction_rf)
#10.58466 for the predcited result from the rf with 2 variables
#10.04053 a bit better with rf with 3 variables

##mlogit package
fit_mlog <- mlogit(Category ~ PdDistrict + Year + Month + Day + x + y + Hour, data = train.sub, shape = "wide")
#does not work because of memory constraint
