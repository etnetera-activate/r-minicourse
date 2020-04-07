#
# Datumy v Rku
#

# hlavní je Date. Jen datum bez casu
today<-Sys.Date()
myBirthDate<-as.Date("1976-09-04")

format(myBirthDate,"%d.%B.%Y")
?strptime
format(myBirthDate,"%d.%b.%Y v %a")

Sys.getlocale()
Sys.setlocale("LC_TIME", "English")
format(myBirthDate,"%d.%B.%Y a bylo to %a")
Sys.setlocale("LC_TIME","Czech") # windows
Sys.setlocale("LC_TIME","cs_CZ") # Mas OS X

###### musíte si zjistit jaké locales zná OS a jak se jmenují
# http://stackoverflow.com/questions/20960821/what-is-a-reliable-way-of-getting-allowed-locale-names-in-r
######

today - myBirthDate
as.numeric(today - myBirthDate)

difftime(today,myBirthDate,units = "weeks")

seq(from=as.Date("2015-01-01"), to=Sys.Date(), by="week")

########### pokud potrete cas, pouzijte POSIXct (ct ~ calendar)

now<-Sys.time()
myBornTime<-as.POSIXct("1976-09-04 21:15:00 CEST")
attributes(myBornTime)

unclass(myBornTime)

difftime(Sys.time(), myBornTime, unit="secs")

format(Sys.time(), format="%H:%M:%S")

########### POSIXlt používá jako strukturu vektor. nepoužívat, pokud nepotřebujete

timeLt<-as.POSIXlt(myBornTime)
attributes(timeLt)

timeLt$year

####### dalsi info
# http://www.noamross.net/blog/2014/2/10/using-times-and-dates-in-r---presentation-code.html





