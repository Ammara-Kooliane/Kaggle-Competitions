# Script containing the first data analysis and a linear regression fitting

library(lubridate) 
library(caret)

set.seed(42) 

data <- read.csv("data.csv")

str(data) # dataframe containing 12 factor variables
unique(data$season) # 4 seasons for the season variable
nrow(data) # 10886 lines
summary(data) 
# - no missing value in the data set
# - mean temperature and perceivend temperature are respectively 20,23°C and 23,66°C.
# - Temperature is inferior to 13,94°C 25% of the time
# - Windspeed is on average 12,80 (km/h ? since no unit given).

# "casual + registered = count"
data$count2 <- data$casual + data$registered 
sum(data$count != data$count2) # No difference between the 2 variables
data$count2 <- NULL # Suppression of the created column

head(data) 
tail(data) 
# Datetime variable is ordered from 01/01/2011 at midnight and ends 
#on 19/12/2012 at 23h => Almost 2 years of data 

# Handling datetime variable to exploit the year, month, day and hour
data$datetime <- strptime(data$datetime, "%Y-%m-%d %H:%M:%S") 
data$Year <- year(data$datetime) # Creating a new variable year containing the year of datetime variable
data$Month <- month(data$datetime) 
data$Day <- day(data$datetime) 
data$Hour <- hour(data$datetime)

unique(data$Day) # Shows that the only 19 first days of each month are available in the data

# The following variables might have an influence on the number of bike renteded
# month, day, hour, holiday, season, working day, weather, temp and atemp, humidity and windspeed.
# So every variable except the year one.


# Checking linear regression assumptions:
# Let's see if the relation between the explanatoty variables Hour, weather, season, temp and atemp 
# and the output variable count is linear by fitting a linear regression
# We assume that the variables are normally distributed 
mod1 <- lm(count~Hour + Year + weather + season + temp + atemp, data=data)
summary(mod1)
plot(mod1)
# We see in the residual plot that:
#       - the relation is not linear since the red line is not flat
#       - there is heteroscedaticity (larger fitted values are associated with larger error residuals)
# In the quantile-quantile plot, we see that:
#       - the data do not look normal because there is a deviation in the high values and 
#       it seems that the data is right-skewed
