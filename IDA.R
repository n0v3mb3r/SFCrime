# San Francisco Crime Classification
# Wayne Wang 9/26/2015
#
# Setup data

setwd('C:/Users/Wayne/Documents/Kaggle/SFCrimeClassification')

#
# Initial Data Analysis

testdata = read.csv('test.csv',header = TRUE)

head(testdata, n = 5)
