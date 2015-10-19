
try(
  setwd("./05-time-series/")
)
load("ab-data.rda")

install.packages("devtools")
devtools::install_github("twitter/AnomalyDetection")
library(AnomalyDetection)

newPageviews <- filter(mins, isFirstVisit == "TRUE")
returnPageViews <- filter(mins, isFirstVisit != "TRUE")

res = AnomalyDetectionTs(newPageviews[,c("timeSlot","pageviews")], max_anoms=0.02, direction='both', plot=TRUE)
res$plot
res$anoms







#ten hodne divny
tmp<-filter(mins, (dayCode=="2015-09-01")&(grepl("(09|10|11|12|13|14|15|16)",hourCode)))

ggplot(tmp, aes(x=timeSlot))+
         geom_line(aes(y=pageviews))+
         geom_line(aes(y=grp), col="blue")

newPageviews %>%
  filter(timeSlot > as.POSIXct("2015-09-25")) %>%
  ggplot( aes(x=timeSlot))+
    geom_line(aes(y=users),col="green") + 
    geom_bar(stat="identity", width=4,aes(y=5*grp),col="blue")+theme_bw()

#zkusime korelaci po hodinach
gdata<-newPageviews %>% 
  group_by(dayCode) %>%
  summarise(
    pageviews = sum(pageviews, na.rm=T),
    grp = sum(grp, na.rm=T)
  )
  
ggplot(gdata,aes(x=grp, y=pageviews)) + geom_point()


  

