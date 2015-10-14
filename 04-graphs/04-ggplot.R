data <- mtcars

library(ggplot2)

data$cyl <-factor(data$cyl)
str(data)


#scatter plot
ggplot(data, aes(x=hp, y=mpg))+geom_point(size=5)


#bar graph s cetsnostmi vyskytu
ggplot(data, aes(x=cyl))+geom_bar()

#histogran
ggplot(data = data, aes(x = hp))+geom_histogram()

#density rozlozeni dat
ggplot(data = data, aes(x = hp))+geom_density()

load("../00-fitbit-demo/fitbit.rda")

#carovy graf 
ggplot(fitdt, aes( x= date, y= calories.burned)) + geom_line()
ggplot(fitdt, aes( x= date, y= calories.burned, fill=day.class)) + geom_bar(stat = "identity")


#boxplot
ggplot(fitdt, aes(x=day.class, y= calories.burned)) + geom_boxplot()

#densita dle jiné proměné
ggplot(fitdt, aes(x = calories.burned, col=day.class)) + geom_density()


#facelety
ggplot(fitdt, aes(x = calories.burned)) + geom_density() + facet_grid( who ~ day.class)

#koordinaty
ggplot(fitdt, aes(x=day.class, y= calories.burned)) + geom_line()

# děláme grafy pěknějjší
library(scales)
fitdt <- fitdt[!is.na(fitdt$day.class),]
ggplot(fitdt, aes( x= date, y= calories.burned, fill=day.class)) + 
  geom_bar(stat = "identity")+

  labs(title = "Vývoj", x="datum", y='kalorie [cal]', fill="typ dne")+
  scale_y_continuous(limits=c(0,10000), breaks = seq(0,10000,by=1000))+
  scale_x_date(labels = date_format("%Y-%m-%d"), breaks = "week")+
  scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9"),
                    labels=c("Prázdniny", "víkend", "práce"))+
  
  theme_bw()+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))



# cele upravy temat se daji delat takto
# http://docs.ggplot2.org/current/theme.html
  
## více proměných do grafu
ggplot(fitdt, aes(x= date)) + 
  geom_bar(aes(y= calories.burned, fill=day.class), stat = "identity")+
  geom_text(aes(y = calories.burned, label=calories.burned), hjust=0, size=3)+
  geom_text(aes(x = as.Date("2015-07-15"), y=1000, label=c("TEXT")))+
  coord_flip()+
  theme_bw()

#pouzivani statistik
ggplot(fitdt, aes(x= day.class)) + geom_bar(fill="orange") +
  stat_bin()+
  geom_text(aes(x=day.class, y = ..count.., label= ..count..))
  


# jak se zbavit ramecku
# todo


data <- mtcars

library(ggplot2)

data$cyl <-factor(data$cyl)
str(data)


#scatter plot
ggplot(data, aes(x=hp, y=mpg))+geom_point(size=5)


#bar graph s cetsnostmi vyskytu
ggplot(data, aes(x=cyl))+geom_bar()

#histogran
ggplot(data = data, aes(x = hp))+geom_histogram()

#density rozlozeni dat
ggplot(data = data, aes(x = hp))+geom_density()

load("../00-fitbit-demo/fitbit.rda")

#carovy graf 
ggplot(fitdt, aes( x= date, y= calories.burned)) + geom_line()
ggplot(fitdt, aes( x= date, y= calories.burned, fill=day.class)) + geom_bar(stat = "identity")


#boxplot
ggplot(fitdt, aes(x=day.class, y= calories.burned)) + geom_boxplot()

#densita dle jiné proměné
ggplot(fitdt, aes(x = calories.burned, col=day.class)) + geom_density()


#facelety
ggplot(fitdt, aes(x = calories.burned)) + geom_density() + facet_grid( who ~ day.class)

#koordinaty
ggplot(fitdt, aes(x=day.class, y= calories.burned)) + geom_line()

# děláme grafy pěknějjší
library(scales)
fitdt <- fitdt[!is.na(fitdt$day.class),]
ggplot(fitdt, aes( x= date, y= calories.burned, fill=day.class)) + 
  geom_bar(stat = "identity")+
  
  labs(title = "Vývoj", x="datum", y='kalorie [cal]', fill="typ dne")+
  scale_y_continuous(limits=c(0,10000), breaks = seq(0,10000,by=1000))+
  scale_x_date(labels = date_format("%Y-%m-%d"), breaks = "week")+
  scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9"),
                    labels=c("Prázdniny", "víkend", "práce"))+
  
  theme_bw()+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))



# cele upravy temat se daji delat takto
# http://docs.ggplot2.org/current/theme.html

## více proměných do grafu
ggplot(fitdt, aes(x= date)) + 
  geom_bar(aes(y= calories.burned, fill=day.class), stat = "identity")+
  geom_text(aes(y = calories.burned, label=calories.burned), hjust=0, size=3)+
  geom_text(aes(x = as.Date("2015-07-15"), y=1000, label=c("TEXT")))+
  coord_flip()+
  theme_bw()

#pouzivani statistik
ggplot(fitdt, aes(x= day.class)) + geom_bar(fill="orange") +
  stat_bin()+
  geom_text(aes(x=day.class, y = ..count.., label= ..count..))



# jak se zbavit ramecku
# todo

# větší data
rm(list=ls())

len = 10e6
data <- data.frame(
  id = 1:len,
  group = floor(abs(rnorm(n=len)*10)),
  v2 = rnorm(n=len)
)

library(ggplot2)

ggplot(data, aes(x=group))+geom_bar() 

library(dplyr)
gdata <- data %>%
  group_by(group) %>% 
  summarise(n=length(id))

ggplot(gdata, aes(x=group, y=n))+geom_bar(stat="identity")


ggplot(data,)









  






