### demo download data

library(XML)
url <- "http://vdb.czso.cz/vdbvo/tabdetail.jsp?kapitola_id=19&potvrd=Zobrazit+tabulku&go_zobraz=1&cas_1_28=2011&cislotab=DEM0170PU_KR&voa=tabulka&str=tabdetail.jsp"

#zakladni nacteni html
con = url(url)
htmlCode = readLines(con)
htmlCode[1:20]
close(con)

#znovu nacteni s parsrovanim
html3 <- htmlTreeParse(url,useInternalNodes = T,replaceEntities=T)   
#vytahneme pres xpath elementy - predpokldame prave jeden
htmltables<-xpathSApply(html3, "//table[@class='tabulkax']")
summary(htmltables)



#a parsrujemme ji
table <- readHTMLTable(htmltables[[1]])
table

#vidime, ze prvni radek je vlastne colname, takze jej vytahnmeme 
nam<-as.vector(t(table[1,-c(7,8)]))
names(table)[c(1,2)]<-c('mesto','pocet')
names(table)[3:dim(table)[2]]<-nam
table <- table[-1,] #a prvni radek vyhodime
names(table)<-gsub(pattern=" ",replacement="_",names(table))
table

#ale stale to neni tidy format
mylibrary("reshape2")
rozvody<-melt(table,id=c("mesto","pocet"))
rozvody$n_rozvodu<-as.numeric(gsub("\\s","",as.character(rozvody$value)))
rozvody$celkem_rozvodu<-as.numeric(gsub("\\s","",as.character(rozvody$pocet)))
rozvody<-rozvody[,c(1,3,5,6)]
rozvody$podil = rozvody$n_rozvodu / rozvody$celkem_rozvodu
names(rozvody)[2]<-"doba"

#a hura muzeme analyzovat!
boxplot(rozvody$podil ~ rozvody$doba,varwidth=T)

