setwd('C:/Users/hharvey/Dropbox/R/Hankix')
setwd('~/Documents/Development/R/curiouspal/Nokia')

library(httr)
library(jsonlite)
library(tidyjson)
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
nokia_df <- as.data.frame(nokia_measure)

nokia_list <- list.load('measure.JSON')
n_list<-nokia_list$body$measuregrps
list.map(n_list,measures)
n_list_date <- n_list %>% list.group(date)