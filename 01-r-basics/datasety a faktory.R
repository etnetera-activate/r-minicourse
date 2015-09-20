######  factor demo

library("googlesheets")
library("dplyr")
library("ggplot2")

gap <- gs_key("1YQlQ0ThzEHUFjvJC93AME-gdjS8H5nc-rgyOPWr6p5c")
minirdt <- gs_read(gap)
str(minirdt)
minirdt<-minirdt[,1:5]
names(minirdt)<-c('time','name','email','from','rKnowledge')

minirdt[order(minirdt$email),]

attributes(minirdt)

names(minirdt)<-c(1,2,3,5)

#minirdt$rKnowledge<-factor(minirdt$rKnowledge, levels=c(1","2","3","4","5"))

ggplot(minirdt,aes(x=rKnowledge,fill=from))+geom_bar()+scale_x_discrete(drop=FALSE) 

