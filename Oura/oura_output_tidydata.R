# Set the working directory
setwd('~/GitHub/curiouspal/Oura') # windows Laptop

#Loading set of needed library
library(jsonlite)
library(dplyr)
library(ggplot2)
library(purrr)
library(parsedate)
library(stringr)
library(zoo)
library(xts)

#Loading JSON from Oura output
file <- fromJSON('sleep_oura.json')

#Date parsing from ISO to "POSIXct" "POSIXt" 
s_date <- file$sleep$bedtime_start[1]
e_date <- file$sleep$bedtime_end[1]
#converting to POSIXct with Lubridate
s_pdate <- ymd_hms(s_date, tz = "CET")
e_pdate <- ymd_hms(e_date, tz = "CET")
#calculating 5min interval from Sleep Start to Sleep end
#This can/could/will be used for bulding a timeseries (zoo)
time_spam <- seq.POSIXt(s_pdate,e_pdate,by='5 min')

