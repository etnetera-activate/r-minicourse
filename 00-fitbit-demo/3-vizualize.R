##################
# 
# vizualize data
#
#################

library(ggplot2)
library(corrplot)
library(scales)
library(dplyr)
library(Rcmdr)

setwd("./00-fitbit-demo/")
load("fitbit.rda")

##### basic plots over time
gdt<-filter(fitdt,who=="Jirka")
ggplot(gdt,aes(x=date,y=calories.burned,fill=day.class))+geom_bar(stat="identity")+
  theme_bw()+
  scale_y_continuous(breaks=seq(0,6000,by=500))+
  scale_x_date(breaks="1 week")+theme(axis.text.x = element_text(angle = 60, hjust = 1))+
  labs(title="",x="",y="Kalorie celkem [cal]")+
  scale_fill_discrete(guide=guide_legend(title="typ dne"))

ggplot(gdt,aes(x=date,y=steps,fill=day.class))+geom_bar(stat="identity")+
  theme_bw()+
  scale_y_continuous(breaks=seq(0,40000,by=5000))+
  scale_x_date(breaks="1 week")+theme(axis.text.x = element_text(angle = 60, hjust = 1))+
  labs(title="",x="",y="kroků za den")+
  scale_fill_discrete(guide=guide_legend(title="typ dne"))


##### 
#s cim koreluji kalorie

cordt<-gdt[,-c(1,14,15,16,17)]
row.names(cordt)<-gdt$date
m<-cor(cordt)
corrplot(m, method="circle",type="lower")

#### udelame si to mnohem hezci
cor.mtest <- function(mat, ...) {
  mat <- as.matrix(mat)
  n <- ncol(mat)
  p.mat<- matrix(NA, n, n)
  diag(p.mat) <- 0
  for (i in 1:(n - 1)) {
    for (j in (i + 1):n) {
      tmp <- cor.test(mat[, i], mat[, j], ...)
      p.mat[i, j] <- p.mat[j, i] <- tmp$p.value
    }
  }
  colnames(p.mat) <- rownames(p.mat) <- colnames(mat)
  p.mat
}
p.mat <- cor.mtest(cordt)
col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
corrplot(m, method="color", col=col(200),  
         type="upper", order="hclust", 
         addCoef.col = "black", # Add coefficient of correlation
         tl.col="black", tl.srt=45, #Text label color and rotation
         # Combine with significance
         p.mat = p.mat, sig.level = 0.01, insig = "blank", 
         # hide correlation coefficient on the principal diagonal
         diag=FALSE 
)

scatterplot(gdt$floors, gdt$calories.burned)
scatterplot(gdt$steps, gdt$calories.burned)

scatterplot(gdt$minutes.sedentary / 60, gdt$activity.calories)

ggplot(gdt,aes(x=day.class,y=calories.burned,fill=day.class))+
  geom_boxplot()+theme_bw()+
  labs(x="typ dne", fill="typ dne",y="spálené kalorie [kcal]")+
  scale_y_continuous(breaks=seq(1000,5500, by=250))


ggplot(gdt,aes(x=day.class,y=time.in.bed / 60,fill=day.class))+geom_boxplot()+theme_bw()+labs(x="typ dne", fill="typ dne",y="doba spánku [hod]")+scale_y_continuous(breaks=seq(0,12,by=0.5))
ggplot(gdt,aes(x=day.class,y= / 60,fill=day.class))+geom_boxplot()+theme_bw()

#anlalýza po dnech mimo
adata<-filter(gdt,day.class %in% c("weekend","work"))
ggplot(adata,aes(x=weekday,y=calories.burned,fill=day.class))+geom_boxplot()+theme_bw()
ggplot(adata,aes(x=weekday,y=time.in.bed / 60,fill=day.class))+geom_boxplot()+theme_bw()
ggplot(adata,aes(x=weekday,y=minutes.sedentary / 60,fill=day.class))+geom_boxplot()+theme_bw()


ggplot(gdt,aes(x=date))+
  geom_line(aes(y=calories.burned,col="calories"))+
  geom_line(aes(y=steps,col="steps"))


work<-filter(gdt,day.class=="work")
ggplot(work,aes(x=day.note,y=calories.burned,fill=day.note))+geom_boxplot()+theme_bw()


#a jdeme na spanek
ggplot(gdt,aes(x=day.class,y=number.of.awakenings / time.in.bed * 60,fill=day.class))+
  geom_boxplot()+theme_bw()+
  labs(x="typ dne", fill="typ dne", y="počet probuzení na hodinu spánku")+
  scale_y_continuous(breaks=seq(0,5,by=0.2))


ggplot(gdt,aes(x=day.class,y=minutes.awake,fill=day.class))+geom_boxplot()+theme_bw()

scatterplot(gdt$time.in.bed, gdt$number.of.awakenings)


#jirka vs tereza
adata<-filter(fitdt,time.in.bed>0)
ggplot(adata,aes(x=who,y=time.in.bed / 60,fill=day.class))+geom_boxplot()+theme_bw()
ggplot(adata,aes(x=who,y=minutes.awake))+geom_boxplot()+theme_bw()
ggplot(adata,aes(x=who,y=number.of.awakenings,fill=day.class))+geom_boxplot()+theme_bw()


#### clean ####
rm(list=ls())
setwd("..")
