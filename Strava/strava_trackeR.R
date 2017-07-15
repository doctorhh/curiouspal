setwd('C:/Users/hharvey/Dropbox/R/trackeR')
setwd('/Users/hharvey/Dropbox/R/trackeR')

setwd('~/Documents/Development/R/curiouspal/Strava')

library(trackeR)
library(dplyr)
#****************** Manual steps to load file ***********************************
#Read the complete directory of TCX file
TCX_session <- readDirectory('/Users/hharvey/Dropbox/R/trackeR')

#Convert the mile per hour into kilometer per hour. Pace is already set.
run_session <- changeUnits(TCX_session, variable = "speed", unit = "km_per_h")
session_df <- as.data.frame(run_session)
lean_session_df <- session_df %>% select(-c(latitude,longitude,altitude,cadence))

#Read a single file to start to work with TCX and xts file
TCX_file <- readContainer('Morning_Run.tcx')
run_file <- changeUnits(TCX_file, variable = "speed", unit = "km_per_h")
run_df <- as.data.frame(run_file)
lean_run_df <- run_df %>% select(-c(latitude,longitude,altitude,cadence))

#Saving lean running session
write.csv(lean_run_df, file="lean_run.csv",row.names = FALSE)
running_df = read.csv("lean_run.csv")
running_df$time <- as.POSIXct(running_df$time)

#************************ Function to load, clean and bind data to existing session
LoadDay <- function(filename,first=FALSE){
  t_file <- LoadFile(filename,first)
  t_data <- CleanData(t_file,first)
  # Function to calculate running (below) to be integrated
}

CleanData <- function(datafile,first){
  #Converting to dataframe
  run_df_temp <- as.data.frame(datafile)
  lean_run_df_temp <- run_df_temp %>% select(-c(latitude,longitude,altitude,cadence))
  #Increasing session number
  if (!first){
    lean_run_df_temp$session <- max(running_df$session)+1
  }
  return(lean_run_df_temp)
}

#Read secondary file to add to existing file
LoadFile <- function(filename,first){
  #Reading file
  TCX_file_temp <- readContainer(filename)
  run_file_temp <- changeUnits(TCX_file_temp, variable = "speed", unit = "km_per_h")
  return(run_file_temp)
}

#Function to be worked on as file needs to be loaded for CleanData function to be
#efficient
SavingFile<-function(datafile){
  #Loading existing session
  running_df = read.csv("lean_run_data.csv")
  #Setting time format
  running_df$time <- as.POSIXct(running_df$time)
  running_df <- rbind(running_df,day)
  write.csv(running_df, file="lean_run_data.csv",row.names = FALSE)
}

#This section of code is not necessary
#sum_run <- summary(run) # summary is not calculating correctly the number of session <<-
# calculate with mutate wr/ratio

# Running Efficiency function ************************************************
# SP=W/kg
# v = Speed in km/h
# calculate r_efficiency>-function
r_efficiency <- function(SP,v){
  v_temp <-  v / 3.6
  ecr <- SP / v_temp
  re <- round(ecr/0.004875, digits = 2)
  return(re)
}
# Should be coming from the upcoming Nokia/Withing JSON file
# Then the Running efficiency will be calculated
# include weight column->"withing"
w <-rep(c(85,86,85.6),5)
w <-w[-1]
df_run$weight <- w
df_run <- df_run %>% mutate(SP = avgPowerMoving/weight) %>% mutate(runningE = r_efficiency(SP,avgSpeedMoving))
idx<-seq(1:14)
plot(idx,df_run$runningE, type='l')