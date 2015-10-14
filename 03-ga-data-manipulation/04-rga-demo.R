########################################################
#
# Ukazkapouziti knihovny RGA
#
########################################################

#https://cran.r-project.org/web/packages/RGA/index.html
#install.packages("RGA")
library(RGA)
library(dplyr)

#provedeme autorizaci
authorize(username = "jiri.stepan@etnetera.cz", cache = T)

gaProfiles <- list_profiles()
gaProfiles <- tbl_df(gaProfiles)
gaProfiles

profileId <- filter(gaProfiles, grepl("activate",name ))$id[3]

#get data ukazka
gaData <- get_ga(profile.id = profileId, start.date = as.Date("2015-01-01"), end.date = "yesterday",
                  metrics = "ga:users,ga:sessions,ga:pageviews",
                  dimensions = "ga:medium,ga:source")


#unsampled data
dates <- seq(as.Date("2015-01-01"), Sys.Date()-1, by = "days")


dimensions <- "ga:source,ga:keyword"
metrics    <- "ga:users,ga:sessions,ga:pageviews"
filter     <- "ga:keyword!=(not provided);ga:keyword!=(not set)"

gaData <- do.call(rbind, lapply(dates, function(date) {
  message(sprintf("Processing day: %s", date))
  get_ga(profile.id = profileId, start.date = date, end.date = date,
         metrics = metrics, dimensions = dimensions,
         filter = filter)}))

#summarize - old way
#gaDataSummary <- aggregate(. ~ source + keyword , FUN = sum, data = gaData)
#olala

#summarize pomocí dplyr
gaDataSummary2 <- gaData %>%
  group_by(source,keyword) %>%
  summarise_each(funs(sum)) %>%
  data.frame() %>%                 
  arrange(desc(sessions))

#### olalaaaa


