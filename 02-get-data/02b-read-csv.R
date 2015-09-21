#
# Ukazna nacteni dat z CSV a jejich cisteni a konverze
#
# @JiriStepan
#

try(setwd("02-get-data/"))

#pouzijeme export z webmaster tools. Zkusime nativni funkci
dt<-read.csv("webmaster-activate.csv")
# --> spatne kodovani. Explicitne rekneme, ze je to UTF

dt<-read.csv("webmaster-activate.csv", encoding = "UTF-8") #pozor utf-8 nezafunguje. 
#seznam kodovani ziskam iconvlist()
#vysledek je ok, ale nesedi typy dat

#nacteme vse jako stringy, ne jako faktory
dt<-read.csv("webmaster-activate.csv", encoding = "UTF-8", as.is=T, fill=F)

#nacteni read.table
dt <- read.table("webmaster-activate.csv", header=T, sep=",", as.is=T, encoding = "UTF-8")

#postupne opravime

# 1. prejmenujeme promene bez diakritiky
names(dt)<-iconv(names(dt),to="ASCII//TRANSLIT")
names(dt)<-gsub(pattern = ".",replacement = "",names(dt), fixed = T)
names(dt)<-tolower(names(dt))

# 2. kod odpovedi ve skutecnosti je faktor
dt$kododpovedi <- factor(dt$kododpovedi, levels=c(404,500, 503))
table(dt$kododpovedi)


# 3. chyba souvisejici se spravami je blbost, vyhodime
dt<-dt[,-3]

# 4. zjisteno a napoledy.prochazeno je datum
as.Date(dt$zjisteno)
as.Date(dt$zjisteno, format="%d.%m.%y")
dt$zjisteno <- as.Date(dt$zjisteno, format="%d.%m.%y")
dt$naposledyprochazeno<-as.Date(dt$naposledyprochazeno, format="%d.%m.%y")

# 5. platforma je take faktor
dt$platforma <- factor(dt$platforma)
table(dt$platforma)
levels(dt$platforma)<-c("smartphone","mobile","desktop")

dt$platforma2 <- factor(dt$platforma, levels=c("mobile","desktop","smartphone"))


library(ggplot2)
ggplot(dt, aes(x=platforma2, fill=platforma2))+geom_bar()

dt2<-dt[order(dt$platforma),]


### ok, co dal?
?read.csv
# vidime, ze vse jsou jen mutace obecne read.table




