################################################
############# sample code for svm ##############
################################################

library(e1071)
library(RCurl)
library(rpart)

dat <- read.csv(text=getURL("https://media.githubusercontent.com/media/n0v3mb3r/SFCrime/master/train.csv"),header = TRUE)

## downsample data for testing
dat <- dat[sample(1:nrow(dat),50000),c("Category","DayOfWeek","PdDistrict")]

## test/train dataset split
index <- sample(1:nrow(dat),.8*nrow(dat))

dat.test <- dat[index,]
dat.train <- dat[-index,]

## fit an svm model
svm.model <- svm(Category ~ ., data = dat.train, cost = 100, gamma = 1)
svm.pred <- predict(svm.model, dat.test[,-1])

## cross tabulation of true vs predicted values
rpart.model <- rpart(Category ~ .,data = dat.train)
rpart.pred <- predict(rpart.model,dat.test[,-1], type = "class")