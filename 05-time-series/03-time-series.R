
library(zoo)        #dobra knihovna pro time series
library(TTR)        #knihovna pro dekompozici rady

library(ggplot2)
library(dplyr)

try(
  setwd("./05-time-series/")
)
load("ab-data.rda")

newPageviews <- filter(mins, isFirstVisit == "TRUE")

ts <- zoo(x=newPageviews[c("users","pageviews","grp","pageviews.imported")],frequency = 720)

plot(ts)

ts60 <- rollapply(data = ts,width = 60,FUN = mean, na.rm=T)
ts120 <- rollapply(data = ts,width = 120,FUN = mean, na.rm=T)
ts720 <- rollapply(data = ts,width = 720,FUN = mean,na.rm=T)

plot(ts10)
plot(ts60)
plot(ts120)
plot(ts720)

adata<-data.frame(ts720)
ggplot(adata, aes(x=1:nrow(adata)))+
  geom_line(aes(y=pageviews),col="red")+
  geom_line(aes(y=grp*18), col="blue")+
  geom_line(aes(y=pageviews.imported), col="green")
  scale_x_continuous(limits=c(40000,50000))

ggplot(adata, aes(x=grp,y=pageviews))+geom_jitter(size=1)


############
#
# knihovna ttr
###########

plot(ts)
ts60 <- SMA(ts, n = 60)
plot(ts60)

ts <- ts(newPageviews$pageviews, frequency=720)
tsComponents <- decompose(ts)
plot(tsComponents)

