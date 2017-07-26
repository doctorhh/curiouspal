# Set the working directory
setwd('~/GitHub/curiouspal/Oura') # windows Laptop

#Loading set of needed library
library(jsonlite)
library(dplyr)
library(ggplot2)
library(purrr)
library(parsedate)
library(stringr)
library(lubridate)
library(zoo)
library(xts)

#Loading JSON from Oura output
file <- fromJSON('response.json')

# Data wrangling for one file/one date only!! Needs to be processed for
# for 141 days (or 144 days)

## Capturing first element of a list of list
#HR list captured
hr <- file$sleep$hr_5min[[3]]
rmssd <- file$sleep$rmssd_5min[[3]]
hr_avg <- rep(file$sleep$hr_average[3], length(file$sleep$hr_5min[[3]]))
day <- rep(file$sleep$summary_date[3] , length(file$sleep$hr_5min[[3]]))
#Date parsing from ISO to "POSIXct" "POSIXt" 
s_date <- file$sleep$bedtime_start[3]
e_date <- file$sleep$bedtime_end[3]
#converting to POSIXct with Lubridate
s_pdate <- ymd_hms(s_date, tz = "CET")
e_pdate <- ymd_hms(e_date, tz = "CET")
#calculating 5min interval from Sleep Start to Sleep end
#This can/could/will be used for bulding a timeseries (zoo)
time_spam <- seq.POSIXt(s_pdate,e_pdate,by='5 min')

#Creating empty dataframe
df_oura <- data.frame(Day = as.character(), HR = as.integer(), 
                      HR_AVG=as.integer(),Time = as.Date(character()))
#Row binding from each day in the JSON file
df_day <- data.frame(Day = day, HR=hr, HR_AVG=hr_avg, Time=time_spam)
df_oura <- rbind(df_oura,df_day)
df_oura_clean <- df_oura %>% filter(HR != 0)

#Some DF validation
df_oura %>% group_by(Day) %>% summarise(avg=mean(HR))
mean_hr <- df_oura %>% group_by(Day) %>% summarise(avg=mean(HR))

#Plotting using ggplot
ggplot(df_oura_clean, aes(x=Time, y=HR))+geom_point() + geom_smooth(span = 0.8)

