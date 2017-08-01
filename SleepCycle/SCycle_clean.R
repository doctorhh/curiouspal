library(dplyr)

sleepcylcle_file <- read.csv('sleepdata-2.csv', sep = ';')
str(sleepcylcle_file)
# 'data.frame':	501 obs. of  8 variables:
#   $ Start         : Factor w/ 500 levels "2016-01-23 22:51:11",..: 1 2 3 4 5 6 7 8 9 10 ...
# $ End             : Factor w/ 500 levels "2016-01-24 06:16:39",..: 1 2 3 4 5 6 7 8 9 10 ...
# $ Sleep.quality   : Factor w/ 66 levels "10%","14%","16%",..: 44 54 31 54 42 43 24 41 24 44 ...
# $ Time.in.bed     : Factor w/ 178 levels "0:15","0:27",..: 119 123 31 129 38 63 76 171 128 172 ...
# $ Wake.up         : Factor w/ 4 levels "",":(",":)",":|": 1 3 2 3 3 3 4 3 2 4 ...
# $ Sleep.Notes     : Factor w/ 67 levels "","Ate late",..: 67 51 56 1 52 50 36 51 55 59 ...
# $ Heart.rate      : int  NA NA NA NA NA NA NA NA NA NA ...
# $ Activity..steps.: int  5598 398 1407 4639 3863 3815 1227 4985 922 2357 ...
sleepcylcle_file$Start <- as.POSIXct(sleepcylcle_file$Start)
sleepcylcle_file$End <- as.POSIXct(sleepcylcle_file$End)
sleepcylcle_file$Sleep.quality <- as.character(sleepcylcle_file$Sleep.quality)
sleepcylcle_file$Time.in.bed <- as.character(sleepcylcle_file$Time.in.bed)

str_replace(inner_cycle_df$Sleep.quality, '%','')

# Remove the % from the Sleep.quality variable
# Slip Sleep.Notes and analyse/quantify the content

#Reducing the number of variables
sc_file <- sleepcylcle_file %>% select(-c(Heart.rate, Wake.up, Activity..steps.))
sc_file$Date <- as.Date(sc_file$End)
inner_cycle_df <- inner_join(in_df,sc_file, by='Date')

inner_cycle_df$Sleep.quality <- str_replace(inner_cycle_df$Sleep.quality, '%','')
inner_cycle_df$Sleep.quality <- as.integer(inner_cycle_df$Sleep.quality)

write.csv(inner_cycle_df,'inner_cycle_df.csv')
