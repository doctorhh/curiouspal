library(RCurl)
library(XML)

login <- 'hharvey22'
mindate = Sys.Date()-7
maxdate = Sys.Date()
date = seq(as.Date(mindate, "%Y-%m-%d"), as.Date(maxdate, "%Y-%m-%d"), by=1)

theurl = paste("http://www.myfitnesspal.com/reports/printable_diary/", 
               login, "?from=", mindate, "&to=" , maxdate, sep="")
ns = c("Foods" ,"Calories" ,"Carbs" , "Fat", "Protein","Cholest" ,"Sodium", "Sugars" ,"Fiber" ) 


scrape = readHTMLTable(theurl, header=F)

#Original code to parse the scrape and include date/clean the df
#scrape get a list of data.frame for 1) food and 2) exercice
tables = data.frame()

for(i in 1:length(scrape)){
  
  if(ncol(scrape[[i]])==length(ns)){
    
    day = rep(date[i],nrow(scrape[[i]]))
    print(date[i])
    temp =  data.frame(scrape[[i]], day)
    tables = rbind(tables, temp)

  } 
  else {
    tables = tables
    print(paste(date[i],'exercices'))
  }
}

tables = na.omit(tables)
names(tables) = c(ns, "Day")
tables$day = as.Date(tables$day, "%Y-%m-%d")
tables

# **************   Revised code to make the scrape into a tidy df   **************
day_df <- data.frame()
tables <- data.frame()
date_idx <- 0

for (i in 1:length(scrape)){

  # Food dataframe
  if(ncol(scrape[[i]])==9){
    date_idx <- date_idx + 1
    # clean and tidy food dataframe
    day_df <- scrape[[i]]
    names(day_df) <- ns
    day_df[-1] <- apply(day_df[,-1], 2, function(y) as.numeric(gsub("[a-zA-Z]", "", y)))
    day_df[,1] <- as.character(day_df[,1])
    day_df$Day <- date[date_idx]
    day_df$Meal <- 'meal'
    
    #replace Meal with category
    for (i in 1: nrow(day_df)){
      if (is.na(day_df$Calories[i])){
        m <- day_df$Foods[i]
      } 
      else {
        day_df$Meal[i] <- m
      }
    }
    tables <-rbind(tables,day_df)
  }
  # exclude if exercice dataframe
  else{
    day_df <- day_df
  }
}

tables = na.omit(tables)
tables$Foods <- stri_trans_general(tables$Foods, "latin-ascii")
head(tables)
tail(tables)

saveRDS(scrape,file='mfp.RData')
mfp <- readRDS('mfp.RData')

write.csv(tables,'mfp_Jan_Jul_2017.csv',row.names=FALSE)
mfp <- read.csv('mfp_Jan_Jul_2017.csv',stringsAsFactors=F)
