#Identification of the longuest sequence in the nested list.
# Could be improved by remove specific call to a variable
filelength <- nrow(file$sleep)
maxlen <- max(sapply(file$sleep$hr_5min,length))
df <- as.data.frame(NA)
df<- df[FALSE,]

for (i in ncol(file$sleep)){
  if (typeof(file$sleep[[i]]) != 'list'){
    for (r in filelength){
      tempcol <- rep(file$sleep[[i]][r], length(file$sleep$hr_5min[[r]]))
      tempcol <- c(tempcol,rep(NA, maxlen -length(file$sleep$hr_5min[[r]])))
      #tempcol <- na.pad(tempcol,maxlen)
      #names(col) <- names(file$sleep[i])
      col<- c(col,tempcol)
      
      if (r == filelength){
        names(col) <- names(file$sleep[i])
        df <- cbind(df,col)
      }
    }
  }
}

for (r in filelength){
  tempcol <- rep(file$sleep[[1]][r], length(file$sleep$hr_5min[[r]]))
  #tempcol <- c(tempcol,rep(NA, maxlen -length(file$sleep$hr_5min[[r]])))
  #tempcol <- na.pad(tempcol,maxlen)
  #names(col) <- names(file$sleep[i])
  col<- c(col,list(tempcol))
  
  #if (r == filelength){
  #  names(col) <- names(file$sleep[i])
  #  df <- cbind(df,col)
 # }
}

# Conclusion of this session
'able to parse the nested list, binding rows seems to be problematic as well
as binding column since each element is of different type.'

#********************************* different version ***********************
library(jsonlite)
library(lubridate)

#Loading JSON from Oura output
oura <- fromJSON('sleep_oura.json')
dft_oura <- oura$sleep


#Selecting first row of the Sleep dataframe
day <- dft_oura[2,]

#Function Transfort night informatio from HR, RSMMD and HYPNO value to 
#have for every HR value an observation
#Return the dataframe to be merge into the complete Datafram

trx_night <- function(day){
  #creating two data frame where one contain the (3) list to be transposed
  day_df <- day %>% select(-c(hr_5min, rmssd_5min,hypnogram_5min))
  temp_list_df <- day %>% select(hr_5min, rmssd_5min,hypnogram_5min)

  #Extracting and converting list
  t_hr <- unlist(temp_list_df$hr_5min)
  t_rmssd <- unlist(temp_list_df$rmssd_5min)
  t_hypno <- as.numeric(strsplit(temp_list_df$hypnogram_5min,"")[[1]])
  
  #Calculating interval from bedtime_start to bedtime_end
  #Date parsing from ISO to "POSIXct" "POSIXt" 
  s_date <- day_df$bedtime_start
  e_date <- day_df$bedtime_end
  #converting to POSIXct with Lubridate
  s_pdate <- ymd_hms(s_date, quiet=TRUE, tz = "CET")
  e_pdate <- ymd_hms(e_date, quiet=TRUE, tz = "CET")
  #calculating 5min interval from Sleep Start to Sleep end
  #This can/could/will be used for bulding a timeseries (zoo)
  time_spam <- seq.POSIXt(s_pdate,e_pdate,by='5 min')
  #Creating temp DF
  t_df <- data.frame(t_hr,t_rmssd,t_hypno,time_spam)

  #Merging the two dataframe to have a complete row night with all HR,RSMM and Hypno measure
  oura_df <- merge(day_df, t_df)
  return (oura_df)
}

#Preparing the whole extraction (more than one session)
df_oura <- data.frame()

for (r in 1:nrow(dft_oura)){
  temp_day <- dft_oura[r,]
  dft <- trx_night(temp_day)
  df_oura <- rbind(df_oura,dft)
}

#Extracing unique value
(df_oura %>% filter(summary_date=='2017-06-18') %>% distinct(hr_average))$hr_average
(df_oura %>% filter(summary_date=='2017-06-20') %>% distinct(hr_average))$hr_average

oura_plot <- df_oura %>% select(hr_average,t_hr,time_spam,summary_date) %>%
              filter(summary_date=='2017-06-18') %>%
                filter(t_hr!=0)
oura_plot %>% ggplot(aes(x=time_spam, y=t_hr)) + geom_point()
