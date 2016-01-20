set.seed(42)
train <- read.csv("train.csv")

train$Dates <- strptime(train$Dates, "%Y-%m-%d %H:%M:%S") # Convert the factor variable into date with lubridate
train$Year <- year(train$Dates) # Extrating the year variable from Dates
train$Month <- month(train$Dates)
train$Day <- day(train$Dates)
train$Hour <- hour(train$Dates)

train$x <- round(train$X,2)
train$y <- round(train$Y,2)

replace <- function(dataframe, vector) {
        train$Category <- as.character(train$Category)
        dataframe$Cat <- dataframe$Category
        for (i in vector) {
                dataframe$Cat[which(dataframe$Cat == i)] <- "OTHER OFFENSES"
        
        }
        return(dataframe)
        train$Category <- as.factor(train$Category)
        train$Cat <- as.factor(train$Cat)
}   
categories <- c("BAD CHECKS", "BRIBERY","EXTORTION", "SEX OFFENSES NON FORCIBLE", "GAMBLING",  "PORNOGRAPHY/OBSCENE MAT","TREA")
train <- replace(train,categories)

inTrain<-createDataPartition(train$Category,p=0.6,list=F)
train.sub<-train[inTrain,]
test.sub <- train[-inTrain,]

fit <- randomForest(as.factor(Cat) ~ PdDistrict + DayOfWeek + Year + Month + Day + Hour + x + y, data=train.sub, ntree=50, mtry = 2)
Prediction <- predict(fit, test.sub, OOB=TRUE, type = "prob")

dummies <- function(dataframe, vector) {
        vector <- as.character(unique(vector))
        vector <- sort(vector)
        for (i in vector) {
                dataframe[i] <- 0
                dataframe[which(dataframe$Cat == i), i] <- 1
        }
        return (dataframe)
}

test.dummies <- dummies(test.sub, test.sub$Cat)
test.dummies <- test.dummies[-c(1:16)]

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

MultiLogLoss(test.dummies, Prediction)
#9
