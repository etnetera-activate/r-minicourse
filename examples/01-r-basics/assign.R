# demo assignu. <-, =, <<-, assign

rm(list=ls())

test <- function(b) {
  a <- 10
  assign('řekněte prdel, prdel řekněte!!!',100, envir = .GlobalEnv)
  return(a+b+c)
}

test(b=30)

b
a
x
