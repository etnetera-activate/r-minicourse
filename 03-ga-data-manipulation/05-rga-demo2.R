#ukazka slouceni metrik z vice zdroju

library(RGA)
library(dplyr)

authorize(username = "jiri.stepan@etnetera.cz", cache=T)

profiles <- list_profiles()

#chci jen profily Etnetery a vezzmu prvni z kazde skupiny webproperty
etnetera <- profiles %>% filter( grepl("etnetera.cz",website.url,fixed = T)) %>%
  data.frame() %>%
  arrange(webproperty.id, created)

firstProfiles <- etnetera %>%
  group_by(webproperty.id) %>%
  summarise(id = first(id))

etnetera_main <- filter(profiles, id %in% firstProfiles$id)


#pro kazdy profil stahni summary data
out <- data.frame()
for(i in 1:nrow(etnetera_main)){
  profileId <- etnetera_main[i,"id"]
  gaData <- get_ga(profile.id = profileId, start.date = "30daysAgo", end.date = "yesterday",
                 metrics = "ga:users,ga:sessions,ga:pageviews")
  gaData$profileId <- profileId
  
  if(class(gaData) == "data.frame"){
    out <- rbind(out, gaData)
  }
}

### merge together
etnetera_data <- etnetera_main %>%
  left_join(out, by = c("id" = "profileId")) %>%
  filter(!is.na(sessions))


