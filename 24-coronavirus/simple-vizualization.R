library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)

# simple vizualization of public dataset https://data.humdata.org/dataset/novel-coronavirus-2019-ncov-cases
  

rm(list=ls())

casesUrl <- "https://data.humdata.org/hxlproxy/data/download/time_series_covid19_confirmed_global_narrow.csv?dest=data_edit&filter01=merge&merge-url01=https%3A%2F%2Fdocs.google.com%2Fspreadsheets%2Fd%2Fe%2F2PACX-1vTglKQRXpkKSErDiWG6ycqEth32MY0reMuVGhaslImLjfuLU0EUgyyu2e-3vKDArjqGX7dXEBV8FJ4f%2Fpub%3Fgid%3D1326629740%26single%3Dtrue%26output%3Dcsv&merge-keys01=%23country%2Bname&merge-tags01=%23country%2Bcode%2C%23region%2Bmain%2Bcode%2C%23region%2Bsub%2Bcode%2C%23region%2Bintermediate%2Bcode&filter02=merge&merge-url02=https%3A%2F%2Fdocs.google.com%2Fspreadsheets%2Fd%2Fe%2F2PACX-1vTglKQRXpkKSErDiWG6ycqEth32MY0reMuVGhaslImLjfuLU0EUgyyu2e-3vKDArjqGX7dXEBV8FJ4f%2Fpub%3Fgid%3D398158223%26single%3Dtrue%26output%3Dcsv&merge-keys02=%23adm1%2Bname&merge-tags02=%23country%2Bcode%2C%23region%2Bmain%2Bcode%2C%23region%2Bsub%2Bcode%2C%23region%2Bintermediate%2Bcode&merge-replace02=on&merge-overwrite02=on&filter03=explode&explode-header-att03=date&explode-value-att03=value&filter04=rename&rename-oldtag04=%23affected%2Bdate&rename-newtag04=%23date&rename-header04=Date&filter05=rename&rename-oldtag05=%23affected%2Bvalue&rename-newtag05=%23affected%2Binfected%2Bvalue%2Bnum&rename-header05=value&filter06=clean&clean-date-tags06=%23date&filter07=sort&sort-tags07=%23date&sort-reverse07=on&filter08=sort&sort-tags08=%23country%2Bname%2C%23adm1%2Bname&tagger-match-all=on&tagger-default-tag=%23affected%2Blabel&tagger-01-header=province%2Fstate&tagger-01-tag=%23adm1%2Bname&tagger-02-header=country%2Fregion&tagger-02-tag=%23country%2Bname&tagger-03-header=lat&tagger-03-tag=%23geo%2Blat&tagger-04-header=long&tagger-04-tag=%23geo%2Blon&header-row=1&url=https%3A%2F%2Fraw.githubusercontent.com%2FCSSEGISandData%2FCOVID-19%2Fmaster%2Fcsse_covid_19_data%2Fcsse_covid_19_time_series%2Ftime_series_covid19_confirmed_global.csv"
deathsUrl <- "https://data.humdata.org/hxlproxy/data/download/time_series_covid19_deaths_global_narrow.csv?dest=data_edit&filter01=merge&merge-url01=https%3A%2F%2Fdocs.google.com%2Fspreadsheets%2Fd%2Fe%2F2PACX-1vTglKQRXpkKSErDiWG6ycqEth32MY0reMuVGhaslImLjfuLU0EUgyyu2e-3vKDArjqGX7dXEBV8FJ4f%2Fpub%3Fgid%3D1326629740%26single%3Dtrue%26output%3Dcsv&merge-keys01=%23country%2Bname&merge-tags01=%23country%2Bcode%2C%23region%2Bmain%2Bcode%2C%23region%2Bsub%2Bcode%2C%23region%2Bintermediate%2Bcode&filter02=merge&merge-url02=https%3A%2F%2Fdocs.google.com%2Fspreadsheets%2Fd%2Fe%2F2PACX-1vTglKQRXpkKSErDiWG6ycqEth32MY0reMuVGhaslImLjfuLU0EUgyyu2e-3vKDArjqGX7dXEBV8FJ4f%2Fpub%3Fgid%3D398158223%26single%3Dtrue%26output%3Dcsv&merge-keys02=%23adm1%2Bname&merge-tags02=%23country%2Bcode%2C%23region%2Bmain%2Bcode%2C%23region%2Bsub%2Bcode%2C%23region%2Bintermediate%2Bcode&merge-replace02=on&merge-overwrite02=on&filter03=explode&explode-header-att03=date&explode-value-att03=value&filter04=rename&rename-oldtag04=%23affected%2Bdate&rename-newtag04=%23date&rename-header04=Date&filter05=rename&rename-oldtag05=%23affected%2Bvalue&rename-newtag05=%23affected%2Binfected%2Bvalue%2Bnum&rename-header05=Value&filter06=clean&clean-date-tags06=%23date&filter07=sort&sort-tags07=%23date&sort-reverse07=on&filter08=sort&sort-tags08=%23country%2Bname%2C%23adm1%2Bname&tagger-match-all=on&tagger-default-tag=%23affected%2Blabel&tagger-01-header=province%2Fstate&tagger-01-tag=%23adm1%2Bname&tagger-02-header=country%2Fregion&tagger-02-tag=%23country%2Bname&tagger-03-header=lat&tagger-03-tag=%23geo%2Blat&tagger-04-header=long&tagger-04-tag=%23geo%2Blon&header-row=1&url=https%3A%2F%2Fraw.githubusercontent.com%2FCSSEGISandData%2FCOVID-19%2Fmaster%2Fcsse_covid_19_data%2Fcsse_covid_19_time_series%2Ftime_series_covid19_deaths_global.csv"


# data proccesing

processDataset <- function(df,min_treshold){
  names(df) <- tolower(names(df))
  df <- df[-1,]
  df$date <- as.Date(df$date, "%Y-%m-%d")
  df$value <- as.numeric(df$value)
  df <- select(df, date, iso.3166.1.alpha.3.codes, country.region, province.state, value)
  names(df) <- c("date","countryCode", "country", "province","value")
  df$one <- 1
  
  df.sum <- df %>% 
    arrange(date) %>%
    filter(value >= min_treshold) %>%
    group_by(date,countryCode) %>%
    summarise(
      country=min(country),
      value=sum(value),
      one=1
    ) %>%
    group_by(countryCode) %>%
    mutate(daysSinceStart = cumsum(one)) 
  
  return(df.sum)  
}

TRESHOLD_CASES <- 50
cases <- read.csv(casesUrl,as.is=T)
cases.by.day <- processDataset(cases,TRESHOLD_CASES)

TRESHOLD_DEATHS <- 1
deaths <- read.csv(deathsUrl,as.is=T)
deaths.by.day <- processDataset(deaths,TRESHOLD_DEATHS)

countries.by.cases <- cases.by.day %>%
  group_by(countryCode, country) %>%
  summarise(
    maxCases = max(value),
    firstCase = min(date),
  ) %>% arrange( desc(maxCases))



# list of countries and graph y-limits
list <- c("CZE","ITA","GBR", "AUT", "SWE","HUN","POL","KOR","JAP","SVK")
cases.limit=20000
deaths.limit=400



# temp data for text labels
cases.text <- cases.by.day %>%
  filter(countryCode %in% list)%>%
  group_by(countryCode, country) %>%
  summarise(
    x=max(daysSinceStart),
    y=max(value)
  )


deaths.text <- deaths.by.day %>%
  filter(countryCode %in% list)%>%
  group_by(countryCode, country) %>%
  summarise(
    x=max(daysSinceStart),
    y=max(value)
  )


# basic visualizations

cases.by.day %>% filter(countryCode %in% list) %>% 
  mutate(thickness=ifelse(countryCode=="CZE",1,0.5))%>%
  ggplot(aes(x=daysSinceStart,y=value))+
  geom_line(aes(col=sprintf("%s (%s)",country, countryCode),size=thickness))+
  geom_text(data=cases.text,aes(x=x+1.5,y=y,label=countryCode, col=sprintf("%s (%s)",country, countryCode)))+
  scale_y_continuous(labels=comma, limits=c(0,cases.limit), breaks=seq(0,1e6,1e3))+
  scale_size(range = c(1,2), guide="none") +
  theme_bw()+
  labs(y="Confirmed cases",x=sprintf("Days since %d cases",TRESHOLD_CASES), col="Country")
  

deaths.by.day %>% filter(countryCode %in% list) %>%
  mutate(thickness=ifelse(countryCode=="CZE",1,0.5)) %>%
  ggplot(aes(x=daysSinceStart,y=value))+
  geom_line(aes(col=sprintf("%s (%s)",country, countryCode),size=thickness))+
  geom_text(data=deaths.text,aes(x=x+1.5,y=y,label=countryCode, col=sprintf("%s (%s)",country, countryCode)))+
  scale_y_continuous(labels=comma, limits=c(0,deaths.limit), breaks=seq(0,1e6,1e2))+
  scale_size(range = c(1,2), guide="none") +
  theme_bw()+
  labs(y="Number of deaths",x=sprintf("Days since %d death",TRESHOLD_DEATHS),col="Country")

