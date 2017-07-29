setwd('C:/Users/hharvey/Dropbox/R/Hankix')
setwd('~/Documents/Development/R/curiouspal/Nokia')

library(httr)
library(jsonlite)
library(lubridate)
# ************************* STEP TO COLLECT MEASUREMENT FROM NOKIA 
# API Key	: 21c500f4d6de863b31b9738fd870768e723c6df6826d3669645f21076d231
# API Secret	: b907c429b14e9098b330b361f236b9b80799f861e57c285bd539b804413420
# 
# resp<-GET('https://developer.health.nokia.com/account/request_token?oauth_callback=&oauth_consumer_key=21c500f4d6de863b31b9738fd870768e723c6df6826d3669645f21076d231&oauth_nonce=ccb81a5181aac15e34c092e1e939848f&oauth_signature=ol6X1JlnS35Q2woAt2QyU05exU4%3D&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1499164620&oauth_version=1.0')
# https://developer.health.nokia.com/account/request_token?oauth_callback=www.curiousraccouns.com&oauth_consumer_key=21c500f4d6de863b31b9738fd870768e723c6df6826d3669645f21076d231&oauth_nonce=2cbd45a8fd8be851182f69af0f906b0e&oauth_signature=Bwdtd8sA4vndrz5S%2FejgOAShHG8%3D&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1499165085&oauth_version=1.0
# 
# 
# oauth_token=e6d95787d9b246568e28d1510242976594f62c91b9453036809eb0429c157b&oauth_token_secret=10f81df2cdb75001d5f164bd3c3e847e9cb0ef7027dcd230d8782783e5c9b
# 
# https://developer.health.nokia.com/account/authorize?oauth_consumer_key=21c500f4d6de863b31b9738fd870768e723c6df6826d3669645f21076d231&oauth_nonce=4f285e245640e2c3f477464ec124cba4&oauth_signature=ZVf2bviokXd%2FsL21Dihfd6iPolk%3D&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1499164974&oauth_token=8008d7f37110ecc07209bdbf0942928efb4372e71c8790c71f8556fd46&oauth_version=1.0
# 
# oauth_token=e6d95787d9b246568e28d1510242976594f62c91b9453036809eb0429c157b&oauth_verifier=OUm81RpImjKQY8ddLg4
# 
# #right request
# file_nokia <- fromJSON('http://api.health.nokia.com/measure?action=getmeas&oauth_consumer_key=21c500f4d6de863b31b9738fd870768e723c6df6826d3669645f21076d231&oauth_nonce=4afd6a06c752b0b98bcc3ff9924aeee4&oauth_signature=db5nCz9CV240fh1Kl%2BPqVJL28bI%3D&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1500819467&oauth_token=8008d7f37110ecc07209bdbf0942928efb4372e71c8790c71f8556fd46&oauth_version=1.0&userid=8691078&startdate=1483228800&enddate=1498867200')
# 
# oauth_token=8008d7f37110ecc07209bdbf0942928efb4372e71c8790c71f8556fd46&oauth_token_secret=b9842549846e5339c0f1ec9ee3e1df449d277db26bb4c0933842c7bb2bc&userid=8691078&deviceid=0

#*********************************************************************
nokia_file <- fromJSON('measure_Jan_Jul_2017.JSON', simplifyDataFrame = TRUE)
nokia_measure <- file_nokia

saveRDS(file_nokia, file='file_nokia.RData')
nokia_measure <- readRDS('file_nokia.RData')

#Creating dataframe from output received from Nokia API
# Creating
# Logical validation is required as missing HR data are messing around the cbind/rbind function
# more data cleanup-required to understand logical behind <<<------

measurement <- bind_rows(nokia_file$body$measuregrps)
#Remove HR measurement rows
df_filter <- measurement %>% filter(nchar(measures) > 80)

type_unit_col <- bind_rows(df_filter$measures)

#Extract dates value
date_list<-list(unique(df_filter$date))
#Replicate dates value for each measurement value (assumed to be 4)
dates_col <- unlist(lapply(date_list,function(x) rep(x,each=4)))
#Combine both df to get dates and values
nokia_df <- cbind(dates_col,type_unit_col)

#Cleaning and preparing data
#Converting dates columns from 

# Replacing value in column type for proper type
# type 11 = HR // type 1 = weight // type 5 = Fat free mass // type 6 = fat ratio // type 8 = fat mass weight
nokia_df$Type <- as.factor(nokia_df$Type)
levels(nokia_df$Type) <- c('Weight','FatFree','FatRatio','FatMass')

#Mutating column for value 
nokia_df <- nokia_df %>% mutate(Measure=(Value*(10^Unit)))

