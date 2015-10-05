#
# "big data" grouping
#

#install.packages("random")


rm(list=ls())

len = 10e7
data <- data.frame(
  id = 1:len,
  group = floor(abs(rnorm(n=len)*10)),
  v2 = rnorm(n=len)
)

#zakladni kod
aggregate(v2 ~ group,FUN = sum, data = data)

#plyr
library(plyr)
ddply(data,.(group),summarise,suma=sum(v2))

#dplyr nad dataframe
library(dplyr)
data %>% 
  group_by(group) %>% 
  summarise(
    suma=sum(v2)
  )

#dplyr nad data.table
#install.packages("data.table")
library(data.table)
dt <- data.table(data)
dt %>% 
  group_by(group) %>% 
  summarise(
    suma=sum(v2)
  )