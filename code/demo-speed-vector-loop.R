
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


#empty dataframe
data<-as.data.frame(c())

#a jedem
for (mocnina in 1:6){
  max=10^mocnina;
  a=1:max
  
  tv<-zmer(a,vektorove)
  tf<-zmer(a,cyklem)
  data<-rbind(data,list(N=mocnina,vektor=tv,cyklus=tf))
}

data

plot(x=data$N,y=data$cyklus,type="b",col="red",lwd=3)

lines(data$vektor,col="blue",lwd=3)
lines(data$mapovani,col="gray",lwd=3)

#a zkusime tim prolozit linearni regresi, COZ JE CELKEM BLBOST, ALE JAKO DEMO
lm1 <- lm(data$cyklus ~ data$N)
summary(lm1)

#a zakreslit ji do grafu
abline(lm1$coefficients,col="black")
data