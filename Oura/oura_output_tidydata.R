# Set the working directory
setwd('~/GitHub/curiouspal/Oura') # windows Laptop

#Loading set of needed library
library(jsonlite)
library(dplyr)
library(ggplot2)
library(tidyverse)

#Loading JSON from Oura output
file <- fromJSON('sleep_oura.json')