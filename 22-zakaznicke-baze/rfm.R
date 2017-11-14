
library(dplyr)
library(ggplot2)

setwd("./22-zakaznicke-baze/")
df <- read.csv("./data/data_czechitas_frm.csv", as.is=T)
df$date <- as.Date(df$date)
df$sum <- as.numeric(df$sum)

lastDate <- max(df$date)
totalMonetary <- sum(df$sum)
df$daysSinceNow <- as.numeric(lastDate - df$date)




summary(df)

df.rfm <- df %>%
  group_by(customer) %>%
  summarise(
    recency = min(daysSinceNow),
    frequency = length(rowid),
    monetary = sum(sum)
  ) %>%
  arrange(desc(monetary)) %>%
  mutate(
    cummonetary = cumsum(monetary),
    cummonetary.ratio = cumsum(monetary) / totalMonetary
  ) 
  
summary(df.rfm)

ggplot(df.rfm, aes(x=recency))+geom_density(fill="blue")
ggplot(df.rfm, aes(x=frequency))+geom_density(fill="blue")+scale_x_log10()
ggplot(df.rfm, aes(x=monetary))+geom_density(fill="blue")+scale_x_log10()

ggplot(df.rfm, aes(x = monetary, y = frequency, col=recency))+geom_point(alpha=0.3, size=1)+scale_x_log10()+scale_y_log10()+geom_jitter()

ggplot(df.rfm, aes(x=1:nrow(df.rfm),y=cummonetary / sum(df.rfm$monetary)))+geom_line()

segmentRecency <- function(recency){
  if (recency < 100 ) return(1)
  if (recency < 200 ) return(2)
  return(3)
}

segmentFrequency <- function(frequency){
  if (frequency > 10  ) return(1)
  if (frequency > 3 ) return(2)
  return(3)
}

segmentMonetary <- function(monetary){
  if (monetary > 50000  ) return(1)
  if (monetary > 1000 ) return(2)
  return(3)
}

df.rfm$R <- factor(sapply(df.rfm$recency, segmentRecency))
df.rfm$F <- factor(sapply(df.rfm$frequency, segmentFrequency))
df.rfm$M <- factor(sapply(df.rfm$monetary, segmentMonetary))

df.rfm %>% group_by(R, F) %>% summarise(n = length(customer)) %>%
ggplot(aes(x=R, y=F))+geom_point(aes(size = n), col="blue", alpha=0.5)+
  geom_text(aes(label=n))+
  scale_size(range=c(5,40))



