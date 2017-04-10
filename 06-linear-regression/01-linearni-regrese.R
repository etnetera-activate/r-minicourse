library(ggplot2)
library(car)
setwd("06-linear-regression/")

############ ukazka dobreho datasetu ######
x <- seq(1,200, by=20)
y <- 0.75*x + 20*rnorm(length(x))

qplot(x,y)
scatterplot(x,y)
cor.test(x,y)     #konbtroluji p-value < 0.05

par(mfrow = c(1, 1))
plot(x,y)

m <- lm(y ~ x)
summary(m)

m$coefficients



par(mfrow = c(2, 2))
plot(m)
par(mfrow =c(1,1))

coefficients(m)
residuals(m)
influence(m)


############# ukazka spatneho datasetu ####
x <- 1:500
y <- (1 + 2 * x + 1 * x^2) * sqrt(rnorm(length(x)))

par(mfrow = c(1, 1))
plot(x,y)
m <- lm(y ~ x)
abline(coef=m$coefficients, col="red")

scatterplot(x,y)
summary(m)

par(mfrow = c(2, 2))
plot(m)



########### reálná data ################
library(car)
library(ggplot2)
library(dplyr)

load(file="regressionData.rda")
table(df_week$country)

df_a <- filter(df_week, country=="CZECH REPUBLIC" )
df_a <- df_a[c(-7,-52),]
  
ggplot(df_a, aes(x=week_start_corrected))+geom_line(aes(y=sessions),col="red")+geom_line(aes(y=amount/100),col="blue")

### example 1
par(mfrow =c(1,1))
plot(df_a$sessions, df_a$amount)

m <- lm(amount ~ sessions, data=df_de)

scatterplot(df_a$sessions, df_a$amount)

summary(m)
par(mfrow = c(2, 2))
plot(m)

outlierTest(m,cutoff = 0.5)
qqPlot(m, main="QQ Plot") 


################### realna data2 ##################

ggplot(df, aes(x=total, y=salary.full.ekv))+geom_point()+geom_smooth(method="lm")

m <- lm(salary ~ total, data=df)
summary(m)
par(mfrow = c(2, 2))
plot(m)

outlierTest(m,cutoff = 0.5)

# a multi dimezionalni
names(df)

m <- lm(salary ~ skill + cash + sales + team + marketing + leader, data=df)
summary(m)

par(mfrow = c(2, 2))
plot(m)
outlierTest(m,cutoff = 0.5)

scatterplotMatrix(df[,2:8])



