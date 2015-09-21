# demo assignu. <-, =, <<-, assign

rm(list = ls())

n = 1  #spatne dle coding style
m <- 5 #spravne

test <- function(a,b) {
  message(sprintf("%d, %d",n,m))
  c1 <<- a + b  #NEPOUZIVAT
  assign("jiřík salfkjlasdf I392879(*&(*",100,.GlobalEnv)  #NEPOUZIVAT
  return(c1)
}

#zkusime si ruzne verze
d <- test(10,20)
d <- test(a1 = 10, b1 = 20)  #SPRAVNE
d <- test(a1 <- 10, b2 <- 20)


for (n in 1:10) {
  cycle <- n + 1
}



#### and now parser magic
x <- y <- 5 -> z
x2 = y2 = 5
x3 = y3 <- 5
x1 <- y1 = 5

#### http://google-styleguide.googlecode.com/svn/trunk/Rguide.xml#assignment
