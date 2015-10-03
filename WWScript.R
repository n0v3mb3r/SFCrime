library(RCurl)
library(ggplot2)
library(plyr)
library(data.table)  #need to install.packages("data.table")

SFCrime.data.train = read.csv(text=getURL("https://media.githubusercontent.com/media/n0v3mb3r/SFCrime/master/train.csv"),header = TRUE)

#split out dates into ShortDate,Year,Month,Day,Time

SFCrime.data.train$ShortDate = substr(SFCrime.data.train$Dates,1,10)
SFCrime.data.train$Year = substr(SFCrime.data.train$Dates,1,4)
SFCrime.data.train$Month = substr(SFCrime.data.train$Dates,6,7)
SFCrime.data.train$Day = substr(SFCrime.data.train$Dates,9,10)
SFCrime.data.train$Time = substr(SFCrime.data.train$Dates,12,19)
SFCrime.data.train$Hour = as.integer(substr(SFCrime.data.train$Time,1,2))

attach(SFCrime.data.train)
SFCrime.data.train$IsLight[Hour <7] = 0
SFCrime.data.train$IsLight[Hour >=7 & Hour <19] = 1
SFCrime.data.train$IsLight[Hour >=19] = 0
detach(SFCrime.data.train)

#group by count by IsLight and Category - this is messed up a bit, need to edit
#DT = aggregate(SFCrime.data.train, by=list(SFCrime.data.train$IsLight, SFCrime.data.train$Category), FUN=length);