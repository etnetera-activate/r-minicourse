#
# "big data" grouping
#


rm(list=ls())

len = 1e7
data <- data.frame(
  id = 1:len,
  group = floor(abs(rnorm(n=len)*10)),
  v2 = rnorm(n=len)
)

#zakladni kod

system.time(
  aggregate(v2 ~ group,FUN = sum, data = data)
)
#plyr
# library(plyr)
# ddply(data,.(group),summarise,
#       suma=sum(v2),
#       N=length(v2)
#       )

#dplyr nad dataframe
library(dplyr)

system.time(
  dt %>%
#    sample_n(10) %>%
    group_by(group) %>% 
    summarise(
      suma = sum(v2),
      N = length(v2)
    ) %>% 
    arrange(N, desc(suma))
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