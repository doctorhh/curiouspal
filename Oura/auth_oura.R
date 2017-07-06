
library(httr)
library(jsonlite)
library(XML)
library(RCurl)
library(RJSONIO)

oura_name <- 'CuriousPal' # chosen by user
oura_client_id  <- 'AEK3GDQG66C4AHVS' # an integer, assigned by Strava
oura_secret <- 'HAZ7HWIMFHLK2MVWPKJTL5MEMXX4OXXT' # an alphanumeric secret
oura_scope <- 'daily'
oura_redirect <- 'http://localhost:1410'
oura_url <- "https://cloud.ouraring.com/oauth/authorize"
oura_token <- ''


#****************Working request for Oura Ring API ***************************

compact <- function(x) Filter(Negate(is.null), x)

authorize_url <- modify_url(oura_url, query = compact(list(
  response_type = "token",
  state = 'XXX',
  redirect_uri = oura_redirect,
  client_id = oura_client_id)))

BROWSE(authorize_url)

#resp <- getURL(authorize_url)
oura_token = 'OWUNEXVVEAIFQW2HGDJCXLZAYKSIJD7K'
user_info <- modify_url("https://api.ouraring.com/v1/userinfo",
                        query = list(access_token = 'OWUNEXVVEAIFQW2HGDJCXLZAYKSIJD7K'))

file<-fromJSON('https://api.ouraring.com/v1/sleep?start=2017-06-05&end=2017-06-28&access_token=MDTEFEYNCSBCD5QYZACWKJSDWZBLDV32')
#file_stream_JSON <- toJSON(file_stream)
#file_stream<-stream_in(url('https://api.ouraring.com/v1/sleep?start=2017-06-05&end=2017-06-28&access_token=MDTEFEYNCSBCD5QYZACWKJSDWZBLDV32'))
#Save file from Browser into JSON file
write_json(test,'sleep_oura.json')
oura_JSON <- fromJSON('sleep_oura.JSON')

https://api.ouraring.com/v1/userinfo?access_token=CK4AEIRNU7DUDPKEQBJ4TGKK456P3L5W

#resp<- GET(authorize_url,authenticate(username, password, type = "basic"))
rp <- GET('https://cloud.ouraring.com/oauth/authorize?response_type=token&state=XXX&redirect_uri=http%3A%2F%2Flocalhost%3A1410&client_id=AEK3GDQG66C4AHVS')

#https://api.ouraring.com/v1/userinfo?access_token=PHCW3OVMXQZX5FJUR6ZK4FAA2MK2CWWA

#**********************END********************************************************

#https://app.ouraring.com/oauth/test-redirect

oura_app <- oauth_app(oura_name,key = oura_client_id, secret = oura_secret)

  
oura_end <- oauth_endpoint(NULL,'authorize','access_token',
                           base_url = "https://cloud.ouraring.com/oauth")

oura_token <- oauth2.0_token(endpoint = oura_end, app = oura_app,
                             as_header = TRUE,
                             cache = FALSE,
                             use_basic_auth = TRUE,
                             use_oob = getOption("httr_oob_default"))


req <- GET("https://api.ouraring.com/v1/userinfo", access_token=oura_token)
