#*****************************************
library(dplyr)
garmin_file <- read.csv('1504854593_data.csv')
garmin_file <- garmin_file %>% select(-c(record.position_lat.semicircles.,record.position_long.semicircles.,X))
#test_csv_mar<- read.csv('1602103088_data.csv') #stringAsFactor=FALSE & Header=FALSE
head(garmin_file)
#Object size 890K // type identified + column X created at the end
str(garmin_file)

# # same line but with read_csv()
# library(readr)
# r_csv_1 <- read_csv('1870951038_data.csv')
# # Object size = 923K // type identified + column X28 of list created at the end
# str(r_csv_1)
# # look into fread (from data.table) with the option select=c()
# # to select already the column of choice.
# library(data.table)
# fr_csv_1 <- fread('1870951038_data.csv', drop = 28)
# #Object size 2.4Mo // all type of chr but last column avoided with drop
# str(fr_csv_1)

library(lubridate)
names(garmin_file$X...record.timestamp.s.) <- 'Date'
garmin_file$Date <- as_datetime(garmin_file$X...record.timestamp.s.) %m+% years(20) 
date %m+% years(20)

#*****************************************
out.file <- data.frame()
myFiles <- list.files(pattern="*csv")
for(i in 1:length(myFiles)){
  
  file <- read.csv(myFiles[i])
  out.file <- rbind.fill(out.file, file)
  print(myFiles[i])
}
write.csv(out.file, file = "january.csv")
