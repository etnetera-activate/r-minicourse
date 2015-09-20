# demo assignu. <-, =, <<-, assign

rm(list=ls())

n = 1
m <- 10

test <- function(a,b) {
  message(sprintf("%d, %d",n,m))
  c <- a + b
  #e <<-c+1
  return(c)
}

d <- test(a=g<-10,30)

#### and now parser magic
x <- y <- 5
x2 = y2 = 5
x3 = y3 <- 5
x1 <- y1 = 5

#### http://google-styleguide.googlecode.com/svn/trunk/Rguide.xml#assignment

