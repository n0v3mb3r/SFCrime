library(RCurl)
library(ggplot2)
library(plyr)
library(data.table)  #need to install.packages("data.table")
library(class)
library(randomForest)

SFCrime.data.all = read.csv(text=getURL("https://media.githubusercontent.com/media/n0v3mb3r/SFCrime/master/train.csv"),header = TRUE)

#split out dates into ShortDate,Year,Month,Day,Time

SFSFCrime.data.all$ShortDate = substr(SFCrime.data.all$Dates,1,10)
SFCrime.data.all$Year = substr(SFCrime.data.all$Dates,1,4)
SFCrime.data.all$Month = substr(SFCrime.data.all$Dates,6,7)
SFCrime.data.all$Day = substr(SFCrime.data.all$Dates,9,10)
SFCrime.data.all$Time = substr(SFCrime.data.all$Dates,12,19)
SFCrime.data.all$Hour = as.integer(substr(SFCrime.data.all$Time,1,2))

attach(SFCrime.data.all)
SFCrime.data.all$IsLight[Hour <7] = 0
SFCrime.data.all$IsLight[Hour >=7 & Hour <19] = 1
SFCrime.data.all$IsLight[Hour >=19] = 0
detach(SFCrime.data.all)

index = sample(1:nrow(SFCrime.data.all),round(0.8*nrow(SFCrime.data.all)))
SFCrime.data.train = SFCrime.data.all[index,]
SFCrime.data.test = SFCrime.data.all[-index,]

SFCrime.model.rf = randomForest(Category ~ Month + Day + Hour + DayOfWeek + PdDistrict, data = SFCrime.data.train,ntree = 100,mtry = 5,importance = TRUE)
SFCrime.test.predict = predict(SFCrime.model.rf,SFCrime.data.test)
print(SFCrime.model.rf)



