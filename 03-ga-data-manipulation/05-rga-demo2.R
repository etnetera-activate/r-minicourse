#ukazka slouceni metrik z vice zdroju

library(RGA)
library(dplyr)

authorize(username = "jiri.stepan@etnetera.cz", cache=T)

profiles <- list_profiles()

etnetera <- filter(profiles, grepl("etnetera.cz",website.url,fixed = T))
etnetera <- arrange(etnetera, webproperty.id, desc(created))
firstProfiles <- etnetera %>%
  group_by(webproperty.id) %>%
  summarise(id = first(id))

etnetera_main <- filter(profiles, id %in% firstProfiles$id)

out <- data.frame()
for(i in 1:length(etnetera_main)){
  profileId <- etnetera_main[i,"id"]
  gaData <- get_ga(profile.id = profileId, start.date = "30daysAgo", end.date = "yesterday",
                 metrics = "ga:users,ga:sessions,ga:pageviews")
  gaData$profileId <- profileId
  try (out <- rbind(out, gaData))
}

### merge together
etnetera_data <- etnetera_main %>%
  left_join(out, by = c("id" = "profileId"))
