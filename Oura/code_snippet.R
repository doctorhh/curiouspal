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
