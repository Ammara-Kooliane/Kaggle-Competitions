# Predict the number of bike rented from a sharing bike system

In this challenge, we are asked to predict the number of rented bike per hour in the city (count variable). 

## 1) The Data
The data file comes in a unique file and contains information from a sharing bike system in a city.

VARIABLE DESCRIPTIONS:
* datetime - date and hour
* season - 1 = spring , 2 = summer, 3 = fall, 4 = winter
* holiday – is it a school holiday?
* workingday - is it a working day?
* weather - 1: bright to cloudy, 2 : smoggy, 3 : light rain or snow, 4 : heavy rain or snow 
* temp – temperature (Celsius) 
* atemp – temperature perceived (Celsius) 
* humidity – humidity rate 
* windspeed – windspeed 
* casual - number of rented bike from unregistered clients
* registered – number of bike rented from registered clients 
* count – total number of rented bike

## 2) The process to the prediction and performance measure
* 1st step: Observation et analysis of the data (variable strutures and simple statistical analyses) to get familiar with and identify the missing values
* 2nd step: Identify the variables that best explain and predict the variable count
* 3rd step : graph illustrations to help confirming or informing the best variables
* 4th step : Chose a learning method that is relevant to the type of prediction and variable predictors => SVM model chosen
* 5th step : Split the data into a train and test sets to measure the performance of the model chosen. 
* 6th step : performance measure from the learner.
* 7th step : How to improve the performance of the prediction?

## 3) The files

###&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; a) 1_Analysis_script.R
Contains the analysis script that explore the data as well as feature engineering.

###&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; b) 2_Graph_script.R
This script contains the graphs that help understand and explore the data.

2 graphs have been added: 
* Plot1_bike_rent_per_hour.png => Plot of the number of rented bike vs the day hour
* Plot2_temperature_vs_bike_rent.png => Plot of the number of rented bike vs the temperature

###&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; c) 3_SVM_and_performance.R
The model used is the svm and is described in that script.

The graph of the measured performance has been added: 3_Plot_prediction_vs_reality.png => which compares the predicted number of reanted bike vs the reality

