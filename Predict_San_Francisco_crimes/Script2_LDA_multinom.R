# We are going to predict the crime categories in the test set using the multinomial or the lda model with the bagging technique.
# The current rank is reached with the multinom model

library(caret) # split data sets
library(lubridate) #Date management
library(MASS) 
library(nnet) # Neural network approach
library(scales) # Graph scaling
library(plyr) # manage dataframe 

set.seed(43)

train <- read.csv("../input/train.csv")
test <- read.csv("../input/test.csv") 

# The following function preps the sets and performs feature engineering on them

# Input parameters: 
#  - train_df: training set dataframe
#  - test_df: test set dataframe

# Output parameter: 
# - the engineered data sets
feature_eng <- function(train_df, test_df) {
        if (!missing(test_df)) {
                # First we add the missing features in both sets
                test_df$Category <- NA
                test_df$Resolution <- NA
                test_df$Descript <- NA
                test_df$Cat <- NA  
                train_df$Id <- NA
                
                # Binding the 2 sets together to perform feature engineering
                data <- rbind(train_df, test_df)
        } else {
                data <- train_df
        }
        # Extracting date and time
        data$Dates <- strptime(data$Dates, "%Y-%m-%d %H:%M:%S") # Convert the factor variable into date with lubridate
        data$Year <- year(data$Dates) # Extrating the year variable from Dates
        data$Month <- month(data$Dates)
        data$Day <- day(data$Dates)
        data$Hour <- hour(data$Dates)
        
        # Rounding off the latitude and longitudes values to 2 decimals 
        data$x <- round(data$X,2)
        data$y <- round(data$Y,2)
        
        # Considering the addresses, we binarize the variable according to the location of the crime (in the street/intersection)
        data$AddOf <- sapply(data$Address, FUN=function(x) {strsplit(as.character(x), split="of ")[[1]][2]})
        data$Addstreet <- as.factor(ifelse(is.na(data$AddOf), 0, 1))
        
        # Converting the "PdDistrict" and "DayOfWeek" factors to integers
        data$PdDistrict_int <- as.integer(factor(data$PdDistrict))
        data$DayOfWeek_int <- as.integer(factor(data$DayOfWeek))
        
        # Creating a new variable Period_day which includes 3 categories: morning (5h-14h), 
        # afternoon (14h-20th)and night(20h-5h) 
        data$Period_day <- as.factor(ifelse((data$Hour >= 5) & (data$Hour < 14), 1, 
                                            ifelse((data$Hour >=14) & (data$Hour <20), 2, 
                                            ifelse((data$Hour >=20) | (data$Hour <5), 3)))) 
            
        # Creating a new variable Week_day (1 for a crime during the weekdays and 0 otherwise) 
        data$Week_day <- as.factor(ifelse((data$DayOfWeek == "Saturday") | (data$DayOfWeek == "Sunday"), 0, 1)) 
        
        # Splitting back into train and test sets if the two are given
        if (!missing(test_df)) {
                train_df <- data[1:878049,]
                test_df <- data[878050:1762311, ]
                
                # Returning a list of the 2 dataframes
                return(list(train_df, test_df))
        } else {
                return(data)
        }
        
        
}


#The following function split the 

# The following function duplicates the "Category" column and replaces the values contained in a vector 
# into a new one "DUMMY OFFENSES".
# The objective is to reduce the noise during fitting and predicting

# Input parameters: 
#  - train_df: training set dataframe
#  - some_vector: a vector 

# Output parameter:
# - train_df: the training set dataframe containing the new column
replace <- function(train_df, some_vector) {
        train_df$Category <- as.character(train_df$Category)
        train_df$Cat <- train_df$Category
        for (i in some_vector) {
                train_df$Cat[which(train_df$Cat == i)] <- "DUMMY OFFENSES"
                
        }
        train_df$Category <- as.factor(train_df$Category)
        train_df$Cat <- as.factor(train_df$Cat)
        return(train_df)
}   


# The following function subsets a dataframe into 2 sets 
#input parameters :
#  - df: a dataframe
#  - deci: decimal used to subset the data (between [0,1])
subset_func <- function(df, deci) {
        index <- createDataPartition(df$Cat,p=deci, list=F)
        df.sub1 <- df[index,]
        df.sub2 <- df[-index,] 
        
        return(list(df.sub1, df.sub2))
}



# Function creating a column filled with binary values (0 or 1) for each value contained in a vector 
# Input parameters: 
#  - df: a dataframe
#  - some_vector: a vector 
# Output parameter:
# - df: the dataframe containing the new binary columns
dummies <- function(df, some_vector) {
        some_vector <- as.character(unique(some_vector))
        some_vector <- sort(some_vector)
        for (i in some_vector) {
                df[i] <- 0
                df[which(df$Cat == i), i] <- 1
        }
        return (df)
}


# Function calculating the log loss score
MultiLogLoss <- function(act, pred)
{
        eps = 1e-15;
        nr <- nrow(pred)
        pred = matrix(sapply( pred, function(x) max(eps,x)), nrow = nr)      
        pred = matrix(sapply( pred, function(x) min(1-eps,x)), nrow = nr)
        ll = sum(act*log(pred) + (1-act)*log(1-pred))
        ll = ll * -1/(nrow(act))      
        return(ll)
}


# Function doing bagging with lda or multinom models (fitting on training set and predicting on test set).
# The model has to be chosen when called (currently LDA ou multinom)
# The bagging technique is finalised via averaging the result by doing the mean of all the predictions.
# The best log loss is printed.
# If during an iteration, not enough categories are selected, then the function moves to the next iteration

# Input parameters: 
#  - train_df: training set dataframe
#  - test_df: test set dataframe
#  - lgth_div: number by which the training set is divided to form a bagging set
#  - it: number of bagging iterations
#  - df_tc: dataframe to compare when calculating the log loss
#  - multilogloss: Does the function has to calculate the log loss (by defaut equal to TRUE)?
#  - model : choosing the model to fit and predict

# Output parameter:
# - matrix containing the predicted posterior probabilities
prediction <- function(train_df, test_df, lgth_div, it, df_tc, multilogloss = TRUE, model) {
        multilog0 <- 500
        if (missing(df_tc)) {
                res <- matrix(0, nrow = nrow(test_df), ncol = length(unique(train_df$Cat)))   
                #print(dim(res))
        } else { 
                res <- matrix(0, nrow = nrow(test_df), ncol = ncol(df_tc))
                #print(paste("dim res0", dim(res)))
        }
        
        for (m in 1:it) {
                print(paste("Iteration: ", m))
                
                # creating a sorted sample indexing of size 1/lgth_div * train_df set
                train_pos <- sort(sample(nrow(train_df), size=floor((nrow(train_df)/lgth_div))))
                
                if (length(unique(train_df[train_pos,]$Cat)) == 33) {
                        if (model == "lda") {
                                # Fitting the lda model on the bagging set made from the training set 
                                lda_fit <- lda(as.factor(Cat) ~ PdDistrict_int+ DayOfWeek_int + Year + Hour + x + y, data=train_df[train_pos,])
                                print("fitting done")
                                
                                # Predicting on the test set and selecting the predicted posterior probabilities from the lda model
                                # The result is a matrix
                                pred <- predict(lda_fit, test_df, type = "prob")$posterior
                                print("predicting done")
                                #print(head(pred))
                        } else if (model == "multinom") {
                                # Fitting the multinom model on the bagging set made from the training set 
                                multinom_fit <- multinom(as.factor(Cat) ~ PdDistrict*Addstreet +  Period_day + Addstreet + PdDistrict + DayOfWeek + Year + Hour+ x + y, data=train_df[train_pos,], MaxNWts = 2000)
                                print("fitting done")
                                
                                # Predicting on the test set 
                                # The result is a matrix
                                pred <- predict(multinom_fit, test_df, type = "prob")
                                print("predicting done")
                                #print(head(pred))
                                
                                # Averaging predicted matrix 
                                #print(paste("dim res ", dim(res)))
                                #print(paste("dim pred ", dim(pred)))
                                res <- ((m-1)*res + pred)/m
                                print("averaging done")
                                
                                if (multilogloss ==  TRUE) {
                                        # Calculating the log loss for each iteration 
                                        multilog <- MultiLogLoss(df_tc, res)
                                        print(paste("log loss of prediction: ", multilog))
                                        
                                        # Exit of the function is done when the minimum log loss is reached. The best one is returned.
                                        if (multilog > multilog0) {
                                                print("Minimal log loss reached-----------------------------------------------------------")
                                        }
                                        multilog0 <- multilog
                                }
                        }
                } else { 
                        print("Not enough category in that iteration")
                }                                                  
        }
        return (res) 
}



# The following function adds all the least frequent categories that we replaced by "DUMMY OFFENSES" into the predicted matrix. 
# Of course, the proportions of each least frequent category from the training set are taken into account.

# Input parameters: 
#  - train_df: training set dataframe
#  - partial_predicted_matrix: matrix containing the predicted probabilities from the prediction function
#  - cat_vector: a vector
#  - df_tc : dataframe to compare when calculating the log loss score

# Output parameter:
# - final multilogloss score
prediction_complete <- function(train_df, partial_predicted_matrix, cat_vector, df_tc, multilogloss = TRUE) { 
        # Creating a table containing the proportions of all the categories from the training set 
        # and converting the table into a matrix
        prop_table <- prop.table(table(train_df$Category))
        prop_table <- as.matrix(prop_table)
        
        # Selecting and normalizing the proportions from the values in the vector 
        # (the least frequent categories in our example) into a matrix (resp. dim of 7 * 1)
        coef_least_frequent <- as.matrix(prop_table[cat_vector,])
        coef_least_frequent <- coef_least_frequent/sum(coef_least_frequent)
        
        # Selecting the predicted probabilities from the "DUMMY OFFENSES" column (matrix of dim n * 1) and 
        # multiplying each value by the proportions calculated previously (it gives a matrix of dimension n * 7)
        matrix_dummy_off <- as.matrix(partial_predicted_matrix[,"DUMMY OFFENSES"])
        matrix_least_frequent <- matrix_dummy_off %*% t(coef_least_frequent)
        
        # Binding the previous matrix with the partial predicted matrix, sorting the columns by their names
        # and suppressing the "DUMMY OFFENSES" column
        completed_pred_matrix <- cbind(partial_predicted_matrix, matrix_least_frequent)
        completed_pred_matrix <- completed_pred_matrix[, order(colnames(completed_pred_matrix))]
        completed_pred_matrix <- completed_pred_matrix[,!colnames(completed_pred_matrix) %in% c("DUMMY OFFENSES")]
        
        if (multilogloss ==  TRUE) {
                # Calculating the final log loss and print it
                multilog <- MultiLogLoss(df_tc, completed_pred_matrix)
                print(paste("log loss of prediction_complete; ", multilog))
        }
        
        return(as.data.frame(completed_pred_matrix))
}

# Function creating the submit file
funcsubmit <- function(df, predchar, file_num) {
        df2 <- data.frame(Id = df$Id)
        df2 <- cbind(df2,predchar)
        write.csv(df2, file = paste("Sf_crimes_", file_num, ".csv", sep=""), row.names = FALSE)
}



# The following function performs the complete fitting and predicting model 
perform <- function(train_df, test_df, lgth_div, it, model, file_num) {
        # Using the replace function to create the new column "Cat" containing "DUMMY OFFENSES" in place of 
        # the 7 least frequent categories
        categories <- c("BAD CHECKS", "BRIBERY","EXTORTION", "SEX OFFENSES NON FORCIBLE", "GAMBLING",  "PORNOGRAPHY/OBSCENE MAT","TREA")
        train_cat <- replace(train_df, categories)
        #print((unique(train_df$Cat)))
        
        if (missing(test_df)) { #If there is no test set given, then split the training set
                # Calling the function feature_eng to use on the training set 
                train_eng <- feature_eng(train_df = train_cat)
                head(train_eng)
                
                # subsetting the train_df set into a train_sub and test_sub sets using the sub_func function
                train_sub <- subset_func(train_eng, 0.7)[[1]]
                test_sub <- subset_func(train_eng, 0.7)[[2]]  
                
                # Creating new binary columns for the 33 categories (7 of them have been replaced by "DUMMY OFFENSES" 
                # in the replace function) using the dummies function and keeping the binary columns only 
                test_dummies <- dummies(test_sub, test_sub$Cat)
                test_dummies <- test_dummies[-c(1:22)]
                #print(str(test_dummies))
                
                # Creating the test.dummies2 dataframe with all the 39 categories 
                test_dummies2 <- dummies(test_sub, test_sub$Category)
                test_dummies2 <- test_dummies2[-c(1:22)]
                
                #                 # Checking that the model is not overfitting using the training set:
                #                 train_dummies <- dummies(train_sub, train_sub$Cat)
                #                 train_dummies <- train_dummies[-c(1:18)]
                #                 #print(str(train_dummies))
                #                 Pred3 <- prediction(train_sub, train_sub, lgth_div, it, train_dummies, multilogloss = TRUE)
                #                 # The best log loss is about 3,57 => No overfittig is observed
                
                # Calling the function prediction 
                Pred <- prediction(train_sub, test_sub, lgth_div, it, test_dummies, multilogloss = TRUE, model)
                
                # And finally, adding the 7 least frequent categories
                Pred2 <- prediction_complete(train_sub, Pred, categories, test_dummies2, multilogloss = TRUE)
                               
                return(Pred2)
                
        } else 
        {
                # Calling the function feature_eng to use the real train and test sets and selecting each listed dataframe
                # into a new train and test sets
                train2 <- feature_eng(train_cat, test_df)[[1]]
                test2 <- feature_eng(train_cat, test_df)[[2]]
                str(train2)
                
                
                # Calling the function prediction 
                Pred <- prediction(train_df = train2, test_df = test2, lgth_div = lgth_div, it = it, multilogloss = FALSE, model =model)
                
                Pred2 <- prediction_complete(train2, partial_predicted_matrix = Pred, cat_vector = categories, multilogloss = FALSE)
                # Add the 7 least frequent categories into the predicted matrix to complete the matrix with the 39 crime categories
                
                funcsubmit(test2, Pred2, file_num = file_num)
        }
        
}

# train_sub1 <- subset_func(train, 0.05)[[1]]
#predic <- perform(train_sub1, lgth_div = 4, it = 20, model = "multinom")
#predic <- perform(train, lgth_div = 80, it = 15, model = "multinom")

predic <- perform(train, test, lgth_div = 80, it = 15, model = "multinom", file_num = 1)
