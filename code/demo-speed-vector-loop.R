
#srovnani vykonu vektorove operace a operace provadene cyklem

#pripravime si funkci pro mereni doby behu funkce (neni nutne - takova existuje, ale je to demo)
zmer<-function(x,fun){
  t1<-as.numeric(Sys.time())
  fun(x)
  t2<-as.numeric(Sys.time())
  return(t2-t1)
}

#funkce vektorove
vektorove <- function(x){
  y<-sqrt(x)
}

#funkce cyklem
cyklem <- function(x){
  for (i in 1:length(x)){
    sqrt(x[i])
  }
}

hromadne <- function(x){
  vapply(x,FUN = sqrt,FUN.VALUE = 1)
}

#empty dataframe
data<-data.frame()

#a jedem
for (mocnina in 1:7){
  message(sprintf("Calculating for 10^%d",mocnina))
  max=10^mocnina;
  a=1:max
  
  tv<-zmer(a,vektorove)
  tf<-zmer(a,cyklem)
  th<-zmer(a,hromadne)
  
  data<-rbind(data,data.frame(list(N=mocnina,time=tv,method="vector")))
  data<-rbind(data,data.frame(list(N=mocnina,time=tf,method="cyclus")))
  data<-rbind(data,data.frame(list(N=mocnina,time=th,method="sapply")))
  
}

data

library(ggplot2)

ggplot(data,aes(x=N,y=time,col=method))+geom_line()
