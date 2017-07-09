setwd('C:/Users/hharvey/Dropbox/R/trackeR')
setwd('/Users/hharvey/Dropbox/R/trackeR')

library(trackeR)
library(dplyr)
library(broom)
TCX_file <- readDirectory('/Users/hharvey/Dropbox/R/trackeR')
run <- changeUnits(TCX_file, variable = "speed", unit = "km_per_h")
sum_run <- summary(run) # summary is not calculating correctly the number of session <<-
# calculate with mutate wr/ratio

# Running Efficiency function
# SP=W/kg
# v = Speed in km/h
# calculate r_efficiency>-function
r_efficiency <- function(SP,v){
  v_temp <-  v / 3.6
  ecr <- SP / v_temp
  re <- round(ecr/0.004875, digits = 2)
  return(re)
}
# include weight column->"withing"
w <-rep(c(85,86,85.6),5)
w <-w[-1]
df_run$weight <- w
df_run <- df_run %>% mutate(SP = avgPowerMoving/weight) %>% mutate(runningE = r_efficiency(SP,avgSpeedMoving))
idx<-seq(1:14)
plot(idx,df_run$runningE, type='l')