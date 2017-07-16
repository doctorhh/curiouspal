setwd('C:/Users/hharvey/Dropbox/R/Hankix')
setwd('~/Documents/Development/R/curiouspal/Nokia')

library(httr)
library(jsonlite)
library(tidyjson)
library(lubridate)
# ************************* STEP TO COLLECT MEASUREMENT FROM NOKIA 
# API Key	: 21c500f4d6de863b31b9738fd870768e723c6df6826d3669645f21076d231
# API Secret	: b907c429b14e9098b330b361f236b9b80799f861e57c285bd539b804413420
# 
# resp<-GET('https://developer.health.nokia.com/account/request_token?oauth_callback=&oauth_consumer_key=21c500f4d6de863b31b9738fd870768e723c6df6826d3669645f21076d231&oauth_nonce=ccb81a5181aac15e34c092e1e939848f&oauth_signature=ol6X1JlnS35Q2woAt2QyU05exU4%3D&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1499164620&oauth_version=1.0')
# https://developer.health.nokia.com/account/request_token?oauth_callback=www.curiousraccouns.com&oauth_consumer_key=21c500f4d6de863b31b9738fd870768e723c6df6826d3669645f21076d231&oauth_nonce=2cbd45a8fd8be851182f69af0f906b0e&oauth_signature=Bwdtd8sA4vndrz5S%2FejgOAShHG8%3D&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1499165085&oauth_version=1.0
# 
# 
# oauth_token=f443eb04e8b9210e45cbd9b62c20bcf059899e3db3b3164b84e659d613628cd&oauth_token_secret=9b6d48dd95cf150ef392d5851f322013b3c85e70fc71f9d1c8f7e4f6b4c3
# 
# https://developer.health.nokia.com/account/authorize?oauth_consumer_key=21c500f4d6de863b31b9738fd870768e723c6df6826d3669645f21076d231&oauth_nonce=4f285e245640e2c3f477464ec124cba4&oauth_signature=ZVf2bviokXd%2FsL21Dihfd6iPolk%3D&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1499164974&oauth_token=8c31877db13d4bb2cbe5d4d397b0792fffcff92ff28b20d3385deb7e13c8&oauth_version=1.0
# oauth_token=8c31877db13d4bb2cbe5d4d397b0792fffcff92ff28b20d3385deb7e13c8&oauth_verifier=NFY7kEcXiXigmT1SqX
# 
# file_nokia <- fromJSON('http://api.health.nokia.com/measure?action=getmeas&oauth_consumer_key=21c500f4d6de863b31b9738fd870768e723c6df6826d3669645f21076d231&oauth_nonce=4877dc068b4c9eb71c4160e07e6b1661&oauth_signature=PPSbH%2Bwu7lGn4RvCZOzpqmIeBno%3D&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1499165296&oauth_token=8008d7f37110ecc07209bdbf0942928efb4372e71c8790c71f8556fd46&oauth_version=1.0&userid=8691078&startdate=1497744000&enddate=1498608000')
# https://api.health.nokia.com/measure?action=getmeas&userid=8691078'&startdate=1497744000&enddate=1498608000

#*********************************************************************
nokia_measure <- fromJSON('measure.JSON', simplifyDataFrame = TRUE)


#Creating dataframe from output received from Nokia API
# Creating
measurement <- bind_rows(nokia_measure$body$measuregrps)
type_unit_col <- bind_rows(measurement$measures)
date_list<-list(unique(measurement$date))
dates_col <- unlist(lapply(date_list,function(x) rep(x,each=5)))
nokia_df <- cbind(dates_col,type_unit_col)

#Cleaning and preparing data
names(nokia_df) <- c('dates','value','type','unit')
#Converting dates columns from 
nokia_df$dates <- as.POSIXct(nokia_df$dates, origin="1970-01-01",tz="CET")

# Replacing value in column type for proper type
# type 11 = HR // type 1 = weight // type 5 = Fat free mass // type 6 = fat ratio // type 8 = fat mass weight
nokia_df$type <- as.factor(nokia_df$type)
levels(nokia_df$type) <- c('weight','fat_free','fat_ratio','fat_mass','heart_rate')
nokia_df %>% filter(type=='heart_rate') %>% ggplot(aes(x=dates,y=value))+geom_line()

#Mutating column for value 
nokia_df <- nokia_df %>% mutate(measure=(value*(10^unit)))
nokia_df %>% filter(type=='weight') %>% ggplot(aes(x=dates,y=measure))+geom_line()
nokia_df %>% ggplot(aes(x=dates,y=measure, group = type, col=type))+geom_line()
