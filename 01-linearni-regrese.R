setwd("06-linear-regression/")


############ ukazka dobreho datasetu ######
x <- seq(1,200, by=20)
y <- 0.75*x + 200*rnorm(length(x))


par(mfrow = c(1, 1))
plot(x,y)
m <- lm(y ~ x)
abline(coef=m$coefficients, col="red")

summary(m)

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

summary(m)

par(mfrow = c(2, 2))
plot(m)
par(mfrow =c(1,1))


########### reálná data ################
library(car)

load(file="data1.rda")
tmp[23,]$salary.full.ekv = 67000

par(mfrow = c(1, 1))
plot(tmp$mean,tmp$salary.full.ekv)
m <- lm( salary.full.ekv ~ mean ,data=tmp)
abline(coef=m$coefficients, col="red")

summary(m)

par(mfrow = c(2, 2))
plot(m)

# Identifikace outlieru
par(mfrow = c(1, 1))
outlierTest(m) # Bonferonni p-value for most extreme obs
qqPlot(m, main="QQ Plot") #qq plot for studentized resid 

################### realna data2 ##################







