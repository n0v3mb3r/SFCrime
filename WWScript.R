library(RCurl)
library(ggplot2)
library(plyr)
library(data.table)  #need to install.packages("data.table")
library(class)

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





#kNN
#try out training on first 1000 variables for just long/lat using euclidian geometry as distance function
#coded while an entire wine bottle deep - the RMS is really large
# need to probably train more variables and switch from euclidian geo to lat/long distance


error = matrix(,nrow = 100,ncol = 2)

for(neighbors in 1:100)
{
train = SFCrime.data.train[1:1000,c("X","Y")]
test = SFCrime.data.train[1001:1100,c("X","Y")]
validation = SFCrime.data.train[1001:1100,"Category"]
cl = SFCrime.data.train$Category[1:1000]
model.knn = knn(train,test,cl,k=5)
error[neighbors[1],] = c(neighbors,as.numeric(substr(all.equal(model.knn,validation),start = 1,stop = 2)))
}

