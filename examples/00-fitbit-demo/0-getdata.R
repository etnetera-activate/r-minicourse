###########################################
# prepares data for analyse
# - reads data from XLS, clean it
# - reads weather data and connect it
###########################################

#default directory is root directory of R Studio project
setwd("./00-fitbit-demo/")

#neccesary libraries
library(dplyr)    #data manipulation
library(xlsx)     #read data from xlsx
library(weatherData) # for weather data

#read data
dt<-read.xlsx(file="./fitbit-data.xlsx",1)

#fist view on data
head(dt) #nice, but use GUI instead
str(dt) #structure, datatypes etc.
# -> oops. It's a bit mess. Correct it!


#I don't like names with uppercase letters
names(dt)<-tolower(names(dt))
#date format is not optimal
dt$date<-as.Date(dt$date, format="%d.%m roku %Y")
#last column is error 
dt<-dt[,-20]
#last row is only NA
dt<-filter(dt,!is.na(dt$date))
#time.in.bed should be numeric
dt$time.in.bed <- as.numeric(levels(dt$time.in.bed))[dt$time.in.bed]
#day note shoul be character
dt$day.note<-as.character(levels(dt$day.note))[dt$day.note]
#add new factor - week day
dt$weekday<-factor(format(dt$date,"%a"),levels=c("po","út","st","čt","pá","so","ne"))
#remove some variables without any meaning
dt<-dt[,-c(2,3,12)]



############################# read weather data ##############################

wdata<-getWeatherForDate("kladno", min(dt$date),max(dt$date))
#rename columns to same convention
names(wdata)<-tolower(names(wdata))
names(wdata)<-gsub(pattern = "_",replacement = ".",x = names(wdata))

############################# join data ######################################

fitdt<-cbind(dt,wdata[,c(2:4)]) 

############################## save and clear ######################################

save(file="fitbit.rda",fitdt)

#clean 
rm(list=ls())
setwd("../")

