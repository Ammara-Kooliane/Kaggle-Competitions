library(lubridate)
library(scales)
library(ggplot2)

set.seed(42)
train <- read.csv("train.csv")

train$Dates <- strptime(train$Dates, "%Y-%m-%d %H:%M:%S") # Convert the factor variable into date with lubridate
train$Year <- year(train$Dates) # Extrating the year variable from Dates
train$Month <- month(train$Dates)
train$Day <- day(train$Dates)
train$Hour <- hour(train$Dates)
train$x <- round(train$X,2)
train$y <- round(train$Y,2)

par(mar=c(5.1, 4.1, 4.1, 7.1))
s <- ggplot(train, aes(x = Hour)) + geom_bar(aes(fill = Category), position = 'fill') + guides(fill=guide_legend(ncol=2))
#Plotting crimes frequency by year. Legend in 2 columns.

par(mar=c(5.1, 4.1, 4.1, 7.1))
train_cat_year <- count(train, c("Year", "Category"))
q <- ggplot(data=train_cat_year, aes(x=Year, y = freq, group=Category, colour=Category), environment = environment()) +
        geom_line() +
        geom_point()

train_cat_hour <- count(train, c("Hour", "Category"))
r <- ggplot(data=train_cat_hour, aes(x=Hour, y = freq, group=Category, colour=Category), environment = environment()) +
        geom_line() +
        geom_point()

train_cat_dist <- count(train, c("PdDistrict", "Category"))
s <- ggplot(data=train_cat_dist, aes(x=PdDistrict, y = freq, group=Category, colour=Category), environment = environment()) +
        geom_line() +
        geom_point()

train_cat_dist <- count(train_sub1, c("Addstreet", "Category"))
t <- ggplot(data=train_cat_dist, aes(x=Addstreet, y = freq, group=Category, colour=Category), environment = environment()) +
        geom_line() +
        geom_point()

v <- ggplot(data=train_sub1, aes(x=PdDistrict, group=Addstreet, colour=Addstreet), environment = environment()) +
        geom_bar() 
