# Predict the category of crimes that occurred in the city by the bay 

## 1) The Data

This competition's dataset provides nearly 12 years of crime reports from across all of San Francisco's neighborhoods. Given time and location, the aim is to predict the category of crime that occurred.

### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;a) The Data sets

This dataset contains incidents derived from SFPD Crime Incident Reporting system. The data ranges from 1/1/2003 to 5/13/2015. The training set and test set rotate every week, meaning week 1,3,5,7... belong to test set, week 2,4,6,8 belong to training set. 

### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;b) Data fields

Dates - timestamp of the crime incident
Category - category of the crime incident (only in train.csv). This is the target variable you are going to predict.
Descript - detailed description of the crime incident (only in train.csv)
DayOfWeek - the day of the week
PdDistrict - name of the Police Department District
Resolution - how the crime incident was resolved (only in train.csv)
Address - the approximate street address of the crime incident 
X - Longitude
Y - Latitude

## 2) The folder

