#
# analyza prispevku na kampan prezidentske kandidaty
# @author jiri.stepan@activate.cz
# https://www.activate.cz
#


library(htmltab)  #install.packages("htmltab")
library(dplyr)    #install.packages("dplyr") 

treshold_negative <- 12  #hranice pod kterou dar povazujeme za sabotaz (sentiment = NEGATIVE)
treshold_positive <- 100 #hranice pod kterou dar povazujeme za podporu (sentiment = POSITIVE)

#gets donation data from transparent account of Milos Zeman
getZemanAccount <- function(){
  url <- "https://www.fio.cz/ib2/transparent?a=2501277007"
  
  donations <- htmltab(url,2) #download second table on the page

  #solve encoding, normalizae to ASCII
  names(donations) <- c("date", "amount", "payment_type", "donor", "message", "note")
  for(i in 1:ncol(donations)){
    donations[,i] <- iconv(donations[,i], from = "utf-8", to="ASCII//TRANSLIT")
  }
  
  #convert date a and amount
  donations$date <- as.Date(donations$date, format="%d.%m.%Y")
  donations$amount <- gsub(x=donations$amount, pattern = " CZK", replacement = "", fixed = T)
  donations$amount <- gsub(x=donations$amount, pattern = ",", replacement = ".", fixed = T)
  donations$amount <- gsub(x=donations$amount, pattern = " ", replacement = "", fixed = T)
  donations$amount <- as.numeric(donations$amount)
  
  #select only relevant columns and arrange by date
  donations <- donations %>%
    select(-note) %>%
    arrange(date)
  
  #set sentiment accotding to treshold
  donations$sentiment <-  "NEUTRAL"
  donations[donations$amount <= treshold_negative,]$sentiment <-  "NEGATIVE"
  donations[donations$amount > treshold_positive,]$sentiment <-  "POSITIVE"
  
  return(donations)
}
  
zeman <- getZemanAccount()
sum(zeman$amount)


######################## simple visualization
library(ggplot2)

#pocet prispevku po dnech
ggplot(zeman, aes(x=date, fill=sentiment))+geom_bar()+theme_bw()

#amount density in log scale
ggplot(zeman, aes(x=amount, col=sentiment))+geom_density()+scale_x_log10()+theme_bw()

