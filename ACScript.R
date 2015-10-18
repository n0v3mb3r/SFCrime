library(dplyr)
library(RCurl)
library(ggplot2)
library(ggmap)

setwd('/Users/achristensen/Documents/Kaggle/sf_crime')

train <- read.csv(file = 'train_sf.csv')
test <- read.csv(file = 'test_sf.csv')
train <- train[,c(-3,-6)]

## Add time based variables

train$ShortDate = substr(train$Dates,1,10)
train$Year = substr(train$Dates,1,4)
train$Month = substr(train$Dates,6,7)
train$Day = substr(train$Dates,9,10)
train$Time = substr(train$Dates,12,19)
train$Hour = as.integer(substr(train$Time,1,2))

## Add IsLight variable

attach(train)
train$IsLight[Hour <7] = 0
train$IsLight[Hour >=7 & Hour <19] = 1
train$IsLight[Hour >=19] = 0
detach(train)

## Add Corner variable

train$Corner <- ifelse(grepl("/",train$Address),"Corner","Not Corner")

## Add PartyTime variable

attach(train)
train$PartyTime = 0
train$PartyTime[DayOfWeek == 'Friday' & Hour >= 22] = 1
train$PartyTime[DayOfWeek == 'Saturday' & Hour <= 4] = 1
train$PartyTime[DayOfWeek == 'Saturday' & Hour >= 22] = 1
train$PartyTime[DayOfWeek == 'Sunday' & Hour <= 4] = 1
detach(train)

## Add Weekend variable

attach(train)
train$Weekend = 0
train$Weekend[DayOfWeek == 'Saturday'] = 1
train$Weekend[DayOfWeek == 'Sunday'] = 1
detach(train)

## View distinct categories

train <- tbl_df(train)

categories <- select(train, Category) %>% distinct
View(categories)