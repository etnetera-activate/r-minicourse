#tidy format a jeho zpracování


pew <- read.delim(
  file = "http://stat405.had.co.nz/data/pew.txt",
  header = TRUE,
  stringsAsFactors = FALSE,
  check.names = F
)

##### using reshape2 #####
library(reshape2)
pew_tidy <- melt(
  data = pew,
  id = "religion",
  variable.name = "income",
  value.name = "frequency"
)

library(ggplot2)
ggplot(pew_tidy, aes(x=religion,y=frequency,fill=income))+
  geom_bar(stat="identity",position = "fill")+
  coord_flip()


##### using tidyr #######
library(tidyr)
library(dplyr)


pew_tidy<-pew %>%  gather("income","frequency", 2:11)
pew_tidy<-pew %>%  gather("income","frequency", -religion)
pew_tidy<-pew %>%  gather("income","frequency", contains("k"))


pew_tidy<-pew %>%  
  gather("income","frequency",-religion) %>%
  filter(grepl("-",income)) %>%
  separate(income,into = c("min_tmp","max_tmp"),sep="-",remove = F) %>%
  mutate(min=sub("$","",min_tmp, fixed=T)) %>%
  mutate(max=sub("k","",max_tmp, fixed=T)) %>%
  select(-contains("tmp"))
  

tbl_df(pew_tidy)
