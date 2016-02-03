# Script containing the graphs created to explore the data

library(ggplot2)

source("1_Analysis_script.R")

hist(x = data$count) # shows that the count variable does not follow a gaussian distribution

p <- ggplot(data, aes(x = factor(Hour), y = count)) + geom_boxplot()
# We can see that hour variable has a non linear influence on the number of bike rented on average.

q <- ggplot(data, aes(x = factor(Year), y = count)) + geom_boxplot()
# It appears, in fact, thtat the year also influences the variable "count" contrary to what I thought (on average a higher use in 2012 than in 2011).
# There are many reasons for this observation: a increase in the number of rentable bicycles in 2012, pollution episodes on one or more periods, reduced car use due to bans ...

r <- ggplot(data, aes(x = factor(Year), y = count, col = factor(Month))) + geom_boxplot()
# On every month of 2012, more bikes have been rented than in 2011

t <- ggplot(data, aes(x = factor(temp), y = count)) + geom_boxplot()
#There seems to be a linear relationship between temperature and the number of rented bikes (positive relationship)

