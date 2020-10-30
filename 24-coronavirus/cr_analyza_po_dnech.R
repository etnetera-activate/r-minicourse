library(ggplot2)
library(dplyr)
library(scales)
library(zoo)
library(rvest)
library(jsonlite)


#seznam dnu v tudnu
weekdays <- c("Po","Ut","St","Ct","Pa","So","Ne")

#primarni data z https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/ 
data <- read.csv("https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/nakazeni-vyleceni-umrti-testy.csv", 
                 as.is=T, 
                 encoding = "UTF8" )
names(data)[1] <- "datum" 


# pocet hospitalizaci musime ziskat scrapingem ze stranky. Data jsou v atributu HTML
url<-xml2::read_html("https://onemocneni-aktualne.mzcr.cz/covid-19/prehled-hospitalizaci")
selector_name<-"#js-hospitalization-data"
json <- html_nodes(x = url, css = selector_name) %>%
  html_attr("data-linechart")
jsondata <- fromJSON(json)
hospitalizace <- jsondata$values[[1]]
names(hospitalizace) <- c("datum","hospitalizovanych")
hospitalizace$hospitalizovanych_vaznych <- jsondata$values[[2]]$y 
hospitalizace$datum <- as.Date(hospitalizace$datum, format = "%d.%m.%Y")


# transformace dat do podoby vhodné pro analýzu
# - pretypování datumu
# - nápočty denních nárůstů z kumulativních dat
# - 7d klouzavy prumer
# - nárůsty den / den mezi týdny
# - spojení s hospitalizacemi

data <- data %>%
  mutate(
    datum = as.Date(datum),
    #denni narusty z kumulativnich dat
    nakazenych = kumulativni_pocet_nakazenych - lag(kumulativni_pocet_nakazenych, k=1, default = kumulativni_pocet_nakazenych[1]),
    vylecenych = kumulativni_pocet_vylecenych - lag(kumulativni_pocet_vylecenych, k=1, default = kumulativni_pocet_vylecenych[1]),
    umrti = kumulativni_pocet_umrti - lag(kumulativni_pocet_umrti, k=1, default = kumulativni_pocet_umrti[1]),
    testu = kumulativni_pocet_testu - lag(kumulativni_pocet_testu, k=1, default = kumulativni_pocet_testu[1]),
    
    #7d rolling average
    nakazenych_7d=rollapply(nakazenych,7,mean,align='right',fill=0)
  ) %>%
  mutate(
    #priprava pro dny v tydnu a tydny
    den_v_tydnu = factor(weekdays[as.numeric(format(datum,"%u"))],levels = weekdays),
    tyden = format(datum, "%Y-%W"),
    
    #denní narust klouzaveho pruměru
    nakazenych_w2w = nakazenych_7d / lag(nakazenych_7d, k=1, default=0)
  ) %>%
  group_by(den_v_tydnu) %>%
  mutate(
    # narust dev tydnu/ stejny dev minuly tyden
    nakazenych_d2d = nakazenych / lag(nakazenych, k=1, default=0)
  ) %>% 
  data.frame() %>% # ungroup a spojeni s hospitalizacemi
  left_join(hospitalizace, by="datum") %>%
  mutate(
    novych_hospitalizaci = hospitalizovanych - lag(hospitalizovanych, k=1, default=0),
    novych_vaznych = hospitalizovanych_vaznych - lag(hospitalizovanych_vaznych, k=1, default = 0)
  )

# wow mame dataframe!


#graf1: Celkova cisla
coef_right_axis <- 15000 / 500 # meritko pro pravou osu.

ggplot(data, aes(x=datum))+
  geom_line(aes(y=nakazenych, col='potvrzení nakažení'))+
  geom_line(aes(y=novych_hospitalizaci*coef_right_axis, col="novych hospitalizaci"))+
  geom_line(aes(y=umrti*coef_right_axis, col="umrti denne"))+
  
  stat_smooth(se=F, aes(y=nakazenych,col='potvrzení nakažení'))+
  stat_smooth(se=F, aes(y=novych_hospitalizaci*coef_right_axis,col="novych hospitalizaci"))+
  stat_smooth(se=F, aes(y=umrti*coef_right_axis,col="umrti denne"))+
  scale_x_date(limits=c(as.Date("2020-08-01"),Sys.Date()))+
  #pridame pravou osu
  scale_y_continuous(sec.axis = sec_axis(~./coef_right_axis, name = "nových hospitalizací a úmrtí denně"))+
  labs(title="Přírůstky denně pro hlavní metriky", col="metrika")+
  theme_bw()+scale_y_log10()


#graf 2: Vývoj po dnech
p <- ggplot(data, aes(x=datum,y=nakazenych,col=den_v_tydnu))+
  scale_x_date(limits=c(as.Date("2020-08-01"),Sys.Date()), breaks = "weeks", date_labels = "%d-%m-%Y")+
  geom_line()+
  geom_point(shape=data$den_v_tydnu)+
  labs(title="Počet potvrzených nakažených po dnech v týdnu", y="potvrzení nakažení", col="den v týdnu")+
  theme_bw()+theme(axis.text.x = element_text(angle = 90))

p
p  + scale_y_log10()

# graf 3: Nárůsty den vs. den minulý
ggplot(data, aes(x=datum,y=nakazenych_d2d))+geom_line(col="gray")+
  scale_x_date(limits=c(as.Date("2020-06-01"),Sys.Date()), breaks = "weeks", date_labels = "%d-%m-%Y")+
  scale_y_continuous(limits=c(0,4), breaks=seq(0,10,0.25))+
  stat_smooth(method = 'lm', formula = y ~ poly(x,5))+
  geom_hline(yintercept=1, col="red", linetype="dashed")+
  geom_point(aes(col=den_v_tydnu))+
  labs(y="nárůst oproti stejnému dni minulého týdne", col="den v týdnu", title = "Nárůst den / stejný den v minulém týdnu")+
  theme_bw()+ theme_bw()+theme(axis.text.x = element_text(angle = 90))

# graf 4: Mezidenní růst klouzavého průměru
ggplot(data, aes(x=datum, y=nakazenych_w2w))+ 
  geom_point(aes(col=den_v_tydnu))+
  geom_line(col="gray")+
  stat_smooth(method = 'lm', formula = y ~ poly(x,5))+
  scale_x_date(limits=c(as.Date("2020-06-01"),Sys.Date()), breaks = "weeks", date_labels = "%d-%m-%Y")+
  scale_y_continuous(limits=c(0.5,1.5), breaks=seq(0,10,.1))+
  geom_hline(yintercept=1, col="red", linetype="dashed")+
  labs(y="poměr klouzavého 7d průměruu prot předchozímu dni", title="Mezidenní růst 7d klouzavého průměru")+
  theme_bw()+ theme_bw()+theme(axis.text.x = element_text(angle = 90))


