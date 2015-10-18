library(RCurl)
library(ggplot2)
library(plyr)
library(data.table)  #need to install.packages("data.table")
library(class)
library(neuralnet)

#load data
SFCrime.data.all = read.csv(text=getURL("https://media.githubusercontent.com/media/n0v3mb3r/SFCrime/master/train.csv"),header = TRUE)

#split out variables into distinct boolean variables for model
SFCrime.data.PdDistrict = model.matrix(~ PdDistrict - 1,data = SFCrime.data.all)
SFCrime.data.Category = model.matrix(~ Category - 1,data = SFCrime.data.all)

#generate hour variable and normalise to [0,1]
SFCrime.data.all$Time = sapply(strsplit(substr(SFCrime.data.all$Dates,12,16),":"),
		function(x) 
			{x <- as.numeric(x)
			(x[1] + x[2]/60)/24})
			
#put the data together
#SFCrime.data.postprocessed = cbind(SFCrime.data.all$Time,data.frame(SFCrime.data.PdDistrict),data.frame(SFCrime.data.Category))
			
SFCrime.data.postprocessed = cbind(data.frame(SFCrime.data.PdDistrict),data.frame(SFCrime.data.Category))			
			
#split the dataset into test and train
index = sample(1:nrow(SFCrime.data.postprocessed),round(0.8*nrow(SFCrime.data.postprocessed)))
SFCrime.data.train = SFCrime.data.postprocessed[index,]
SFCrime.data.test = SFCrime.data.postprocessed[-index,]
f = as.formula(paste("CategoryASSAULT ~", "PdDistrictBAYVIEW + 
    PdDistrictCENTRAL + PdDistrictINGLESIDE + PdDistrictMISSION + 
    PdDistrictNORTHERN + PdDistrictPARK + PdDistrictRICHMOND + 
    PdDistrictSOUTHERN + PdDistrictTARAVAL + PdDistrictTENDERLOIN"))
neuralnet(f,data = SFCrime.data.train,hidden=c(5,3),linear.output = T)
