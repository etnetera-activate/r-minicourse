#
# Read data
#
library(xlsx)
library(dplyr)

try(
  setwd("./05-time-series/")
)

#nacteme datumy spousteni spotu a jejich grpu a trpu
spots <- read.xlsx("./data/Spotlist.xlsx",1)
spots <- spots %>% 
  mutate(
    timeSlot = as.POSIXct(paste(format(Date),format(Time.Real, "%H:%M:00"))),
    affinity = TRP / GRP
  ) %>%
  select(timeSlot, GRP, TRP, affinity) %>%
  rename(grp = GRP, trp = TRP)


#data od Petra
pageviews <- read.xlsx("./data/Pageviews.xlsx",1)
names(pageviews) <-tolower(names(pageviews))
str(pageviews)

#ale my jsme drsny a spocitame si to z Adobe analytics Datawarehouse
trafficRaw <- read.table("./data/ReportJSt/ReportJSt.csv", sep=",", as.is = T, header=T)
names(trafficRaw)
names(trafficRaw) <- c("timestamp",'ip1', "url","visitorId",'ip2','visitNumber','customerLoaylty','pageviews')

#lehce prozkoumame co ma smysl
summary(trafficRaw)
glimpse(trafficRaw)
sum(grepl('.', trafficRaw$ip2))
sum(grepl('.', trafficRaw$ip2))

table(trafficRaw$customerLoaylty)

traffic <- trafficRaw %>%
  #sample_n(1000) %>%
  filter(grepl("bezny-ucet",url,fixed=T)) %>% #jen homepage
  filter(ip2 != '185.8.237.124') %>% #odstranime spammera
  mutate(
    timeSlot = as.POSIXct(timestamp, format="%d/%m/%Y %H:%M"),  #zaokrouhlime na minuty
    isFirstVisit = visitNumber == 1                             #spocitame, zda je prvni navsteva
  ) %>%
  filter(timeSlot >= as.POSIXct("2015-08-17 00:00:00")) %>%     # filtr na cas
  filter(timeSlot < as.POSIXct("2015-09-28 00:00:00")) %>%
  select(-ip1) %>%
  rename(ip  = ip2)

traffic$isFirstVisit <- factor(traffic$isFirstVisit)

tbl_df(traffic)
summary(traffic)
table(traffic$url)

trafficByMinByType <- traffic %>%
#  sample_n(1000) %>%
  group_by(timeSlot, isFirstVisit) %>%
  summarise(
    pageviews = sum(pageviews, na.rm=T),
    users = length(unique(visitorId))
  ) %>%
  mutate(
    hourCode = format(timeSlot,"%H"),
    hourMinCode = format(timeSlot,"%H-%M"),
    dayCode = format(timeSlot,"%Y-%m-%d")
  ) %>%
  arrange(timeSlot)

names(pageviews) <- c('date', 'pageviews.imported')

mins<-trafficByMinByType %>%
  left_join(spots,by = c('timeSlot' = 'timeSlot')) %>%
  left_join(pageviews, by = c('timeSlot' = 'date'))

save(file="ab-data2.rda", mins, trafficByMinByType, spots)


