##############################
#
# a lot of graphs etc.
#
##############################
setwd("./00-fitbit-demo/")

library(plyr)
library(Rcmdr)

load("fitbit.rda")

jdata<-filter(fitdt, who=='Jirka')

#rest will be done using Rcmdr as an example

scatterplotMatrix(~ calories.burned+steps+floors+minutes.sedentary+minutes.lightly.active+minutes.fairly.active+minutes.very.active+time.in.bed,
                  reg.line=FALSE, smooth=FALSE, spread=FALSE, span=0.5, ellipse=FALSE, 
                  levels=c(.5, .9), id.n=0, diagonal = 'density', data=gdt)


rm(list=ls())
setwd("..")