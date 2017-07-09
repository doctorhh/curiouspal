# Running Efficiency function
# SP=W/kg
# v = Speed in km/h

r_efficiency <- function(SP,v){
  v_temp <-  v / 3.6
  ecr <- SP / v_temp
  re <- round(ecr/0.004875, digits = 2)
  return(re)
}

lr <- function(x,y){
  return (x + x*y)
}
grad_desc <- function(x,y){
  return(sum((y-x)^2)/(2*length(a)))
}
