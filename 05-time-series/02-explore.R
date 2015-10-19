rm(list=ls())

try(
  setwd("./05-time-series/")
)
load("ab-data.rda")

library(dplyr)
library(ggplot2)
library(ggvis)
#library(Rcmdr)

qplot(data=spots, x=timeSlot,y=grp)

####################################################################
#anlayse affinity
qplot(data=spots, x=grp, y=trp)
ggplot(spots, aes(x = trp / grp))+geom_density()+scale_x_log10()

#using ggviz
spots %>% ggvis(x = ~grp, y = ~trp, fill = ~timeSlot) %>%
  layer_points(size := input_slider(10,100))


all_values <- function(x) {
  if(is.null(x)) return(NULL)
  paste0(names(x), ": ", format(x), collapse = "<br />")
}

zoom <- input_slider(label = "zoom" ,0, 10, c(0, 6))
hour <- input_slider(label="hours", 0, 23)

spots %>% ggvis(~grp, ~trp) %>%
  layer_points(size := input_slider(label="size",1,100), 
               opacity:= input_slider(label="opacity",0,1)) %>%
  layer_model_predictions(model = "lm", stroke = "lm") %>%
  layer_smooths(stroke = "loess") %>%
  scale_numeric("x", domain = zoom, clamp = T) %>%
  scale_numeric("y", domain = zoom, clamp = T) %>%
  add_tooltip(all_values,"hover")
  

ggplot(data=mins, aes(x=timeSlot))+
  geom_line(aes(y=pageviews))+
  geom_line(aes(y=pageviews.imported))

ggplot(spots, aes(x = grp)) + geom_histogram() + scale_x_log10()

ggplot(mins, aes(x=hourCode, y=pageviews)) + geom_boxplot()

ggplot(mins, aes(x=hourCode, y=grp)) + geom_boxplot() 

mins %>% group_by(dayCode) %>% summarise(
  pageviews = sum(pageviews, na.rm = T),
  grp= sum(grp, na.rm = T)
) %>% ggplot(aes(x = dayCode, y = grp)) + geom_bar(stat="identity") + coord_flip()

#analyse last days
lastDays <- mins %>% filter(timeSlot >= as.POSIXct("2015-09-25"))

ggplot(lastDays, aes(x=timeSlot))+geom_line(aes(y=pageviews))

#zkusime grupnout po hodinach


