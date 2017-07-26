#*****************************************
test_csv_3 <- read.csv('1870951038_data.csv')
test_csv_mar<- read.csv('1602103088_data.csv') #stringAsFactor=FALSE & Header=FALSE
head(test_csv_3)
#Object size 890K // type identified + column X created at the end
str(test_csv_3)
# same line but with read_csv()
library(readr)
r_csv_1 <- read_csv('1870951038_data.csv')
# Object size = 923K // type identified + column X28 of list created at the end
str(r_csv_1)
# look into fread (from data.table) with the option select=c()
# to select already the column of choice.
library(data.table)
fr_csv_1 <- fread('1870951038_data.csv', drop = 28)
#Object size 2.4Mo // all type of chr but last column avoided with drop
str(fr_csv_1)

library(lubridate)
date<-as_datetime(869121097)
date %m+% years(20)
