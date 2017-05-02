####################################################################
#
# Using strava.com API for analysing bike rides during workdays
# Created as motivation for the "Do prace na kole"
#
# @author jiri.stepan@etnetera.cz
# https://www.activate.cz 
#
####################################################################

#uncoment for first install
#install.packages(c("rStrava","dplyr","tidyr", "ggplot2"))

library(rStrava)
library(dplyr)
library(tidyr)
library(ggplot2)

############################# strava.com Configuration #################################################
# you have to log in to strava and create new API application in settings

athleteId <- '11559614' #get from URL

#authorization for your API application

app_name <- 'someappname'       
app_client_id  <- '12345' 
app_secret <- 'v3rys3cr3t0k3nUcang3tinStrVa' 

#######################################################################################################

#you can store secret data in separate file and don't publish it to git
#source("./20-strava-dopranebnakole/strava-dopracenakole2017-tokens.R")

# create the authentication token
stoken <- httr::config(token = strava_oauth(app_name, app_client_id, app_secret, cache=T))

#function for extracting data from strava response list
getDataFromList <- function(act){
  out <- list(
    id = act$id,
    name = act$name,
    date = act$start_date,
    type = act$type,
    distance = act$distance / 1000,
    moving_time = act$moving_time / 60,
    total_time = act$elapsed_time / 60,
    elevation_gain = as.numeric(act$total_elevation_gain),
    #      elevation_min = as.numeric(act$elev_low),
    #      evelation_max = as.numeric(act$elev_high),
    location_country = act$location_country,
    avg_speed = act$average_speed * 3.6,
    max_speed = act$max_speed * 3.6,
    private = act$private,
    commute = act$commute,
    one = 1
  )
  return(out)
}

# get all activities
my_acts <- get_activity_list(stoken)

#convert to dataframe and extract data from list of activities
data <- data.frame(t(sapply(my_acts, FUN=getDataFromList)))
for (i in 1:ncol(data)) data[,i]<-unlist(data[i])

#order by date
data <- data %>%
  arrange(date)

#add data metadata for better filtering
data$date <- as.Date(data$date)
data$day <- as.numeric(format(data$date, format = "%d"))
data$year <- as.numeric(format(data$date, format = "%Y"))
data$month <- as.numeric(format(data$date, format= "%m"))
data$dayofweek <- format(data$date, format= "%w") # 0..6, 0 is Sunday
data$isWorkDay <- (data$dayofweek %in% c("1","2","3","4","5"))
data$dayindex <- as.numeric(format(data$date, format= "%j")) #poradi dne v roce


#filter two last years, May only, workdays only and except free days
data <- filter(data, year %in% c(2016,2017),month==5, day != 1, day!= 8,isWorkDay)

#filter only bike rides
table(data$type)
data <- filter(data, type=="Ride")

#create cumulatice sums by days
days <- df %>%
  filter(type=="Ride") %>%
  group_by(year) %>%
  mutate(
    distance.cumsum = cumsum(distance),
    moving_time.cumsum = cumsum(moving_time),
    total_time.cumsum = cumsum(total_time),
    elevation_gain.cumsum = cumsum(elevation_gain)
  )

#fill last day by last value for better visualization
last2017day <- filter(days, year == 2017)[-1]
last2017day$date <- as.Date("2017-05-31")
last2017day$day <- 31
days <- rbind(days, last2017day)

#compare years until today
today <- as.numeric(format(Sys.Date(),"%d"))
untilToday2016 <- max(filter(days, year == 2016, day <= today)$distance.cumsum,0)
untilToday2017 <- max(filter(days, year == 2017, day <= today)$distance.cumsum,0)

msg <- sprintf("Until %d.5.2017 you ride %.2f km, comparing to %.2f km in last year.",today, untilToday2017, untilToday2016)

#and create supercool graph
ggplot(days, aes(x=day,y=distance.cumsum,fill=factor(year)))+
  geom_area(alpha="0.5", position="identity")+
  labs(x="day in May",y="total ride distance [km]", fill="year", title = msg)+
  scale_x_continuous(breaks=1:31, minor_breaks = F)+
  scale_y_continuous(breaks=seq(0,max(days$distance.cumsum)*1.2, by=25))+
  scale_fill_manual(values = c("gray", "blue")) +
  theme_bw()

