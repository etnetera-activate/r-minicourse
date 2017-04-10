library(ggplot2)
library(car)
library(dplyr)

setwd("06-linear-regression/")

############ ukazka dobreho datasetu ###############################

#vytvorime si promene s linearni vazbou
x <- seq(1,200, by=5)
y <- 0.75*x + 50*rnorm(length(x))

qplot(x,y)        # krok1: rychle vykresleni. Vypada to jako zavislost?
scatterplot(x,y)  # krok2: vykresleni vcetne statistik. Porovname zelenou a cervenou caru. Vypadaji obe jako primka?

cor.test(x,y)     # overim korelaci hodnot: Pokud p-value < 0.05 pak koreluji


m <- lm(y ~ x)    # spocitame linearni model m
summary(m)        # kontrolujeme jeho hodnoty. 
                  #   R-squared je míra vysvetleni modelu, mela by byt vetsi nez cca. 50%
                  #   p-value u hodnot by mělo být pod 0.05

#dignosticke grafy
par(mfrow = c(2, 2)) #nastaveni grafu 4x4
plot(m)              # grafy. Leve dva musi vypadat nahodne, QQ plot by měl být kolem přímky    

#další pomocné
coefficients(m)   # vytažení koeficientu [a,b] modelu y = a+b*x
residuals(m)      # rezidua
outlierTest(m)    # nelezeni outlieru


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

load(file="regressionData.rda")    #pozor tato data jsou interni nejsou v gitu.
table(df_week$country)

df_a <- filter(df_week, country=="CZECH REPUBLIC" )
df_a <- df_a[-52,]
  
ggplot(df_a, aes(x=week_start_corrected))+geom_line(aes(y=sessions),col="red")+geom_line(aes(y=amount/100),col="blue")

### example 1
par(mfrow =c(1,1))
plot(df_a$sessions, df_a$amount)

m <- lm(amount ~ sessions, data=df_a)
summary(m)

scatterplot(df_a$sessions, df_a$amount)

summary(m)
par(mfrow = c(2, 2))
plot(m)

outlierTest(m)
qqPlot(m, main="QQ Plot") 


################### realna data2 + multidimenzionalni regrese ##################

#df <- df[-23,] vyrazeni ouliery
ggplot(df, aes(x=total, y=salary))+geom_point()+geom_smooth(method="lm")


m <- lm(salary ~ total, data=df)
summary(m)
par(mfrow = c(2, 2))
plot(m)

outlierTest(m,cutoff = 0.5)

# a multi dimezionalni
names(df)

m <- lm(salary ~ skill + cash + sales + team + marketing + leader, data=df) 
m <- lm(salary ~ skill + team + marketing, data=df)

summary(m)

par(mfrow = c(2, 2))
plot(m)
outlierTest(m,cutoff = 0.5)
scatterplotMatrix(df[,2:9])



