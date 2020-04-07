# correlation and lagged correlation
# https://onlinecourses.science.psu.edu/stat510/node/74
#

try(
  setwd("./05-time-series/")
)
load("ab-data.rda")

newPageviews <- filter(mins, isFirstVisit == "TRUE")

newPageviews$grp[is.na(newPageviews$grp)] <- 0
newPageviews$pageviews[is.na(newPageviews$pageviews)] <- 0
newPageviews$pageviews.imported[is.na(newPageviews$pageviews.imported)] <-0

soi <- ts(newPageviews$pageviews)
rec <- ts(newPageviews$pageviews.imported)

ccfvalues = ccf (soi, rec)
ccfvalues


####### demo

a <- sin(seq(1,100,by=0.1))
b <- sin(seq(1,100,by=0.1)+0.2)

corr<-ccf(a,b)
str(corr)


