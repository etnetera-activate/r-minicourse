#
# Datumy v Rku
#


# hlavní je Date. Jen datum bez casu
today<-Sys.Date()
myBirthDate<-as.Date("1976-09-04")

format(myBirthDate,"%d.%m.%Y")
?strptime
format(myBirthDate,"%d.%b.%Y v %a")

Sys.getlocale()
Sys.setlocale("LC_TIME", "English")
format(myBirthDate,"%d.%b.%Y a bylo to %a")
Sys.setlocale("LC_TIME","Czech")

today - myBirthDate
as.numeric(today - myBirthDate)

difftime(today,myBirthDate,units = "weeks")

seq(from=as.Date("2010-01-01"), to=Sys.Date(), by="day")

########### pokud potrete cas, pouzijte POSIXct (ct ~ calendar)

now<-Sys.time()
myBornTime<-as.POSIXct("1976-09-04 21:15:00 CEST")
attributes(myBornTime)

difftime(Sys.time(), myBornTime, unit="secs")

########### POSIXlt používá jako strukturu vektor. nepoužívat, pokud nepotřebujete

timeLt<-as.POSIXlt(myBornTime)
attributes(timeLt)

timeLt$mday

####### dalsi info
# http://www.noamross.net/blog/2014/2/10/using-times-and-dates-in-r---presentation-code.html





