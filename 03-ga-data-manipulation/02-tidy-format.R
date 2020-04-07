#tidy format a jeho zpracování


pew <- read.delim(
  file = "http://stat405.had.co.nz/data/pew.txt",
  header = TRUE,
  stringsAsFactors = FALSE,
  check.names = F
)

##### using reshape2 #####
library(reshape2)
pt <- melt(  #ala gather
  data = pew,
  id = "religion",
  variable.name = "income",
  value.name = "frequency"
)

#filter
pt <- pt[grepl("-",pt$income),]

#separate
pt <- cbind(pt,matrix(unlist(strsplit(x = as.character(pt$income), split = "-")),ncol = 2, byrow = T))
names(pt)[4:5] <- c("min_tmp","max_tmp")

pt$min <- as.numeric(sub("$","",pt$min_tmp, fixed=T))
pt$test <- pt$frequency+100

pt2 <- mutate(pt, test=frequency+100)

library(ggplot2)
ggplot(pew_tidy, aes(x=religion,y=frequency,fill=income))+
  geom_bar(stat="identity",position = "fill")+
  coord_flip()


##### using tidyr #######
library(tidyr)
library(dplyr)


rm(pew_tidy)

pew_tidy <- gather(pew, "income","frequency",2:11)
pew_tidy <- pew %>%  gather("income","frequency", 2:11) 
pew_tidy <- pew %>%  gather(pew,"income","frequency", -religion)
pew_tidy <- pew %>%  gather("income","frequency", contains("k"))

tbl_df(pew)

pew_tidy<-pew %>%  
  gather("income","frequency",-religion) %>%
  filter(grepl("-",income)) %>%
  separate(income,into = c("min_tmp","max_tmp"),sep="-",remove = F) %>%
  mutate(
    min=as.numeric(sub("$","",min_tmp, fixed=T)),
    max=as.numeric(sub("k","",max_tmp, fixed=T))
         ) %>%
  select(-contains("tmp")) %>%
  filter(min > 50)


