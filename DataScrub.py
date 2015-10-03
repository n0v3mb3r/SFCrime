# SF Crime Classification Data Scrub Script
import csv
with open('test.csv','rb') as csvfile:
	read = csv.reader(csvfile, delimiter = ',')
	