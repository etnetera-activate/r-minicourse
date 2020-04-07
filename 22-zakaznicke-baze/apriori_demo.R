# ukazka apriori analyzy
# http://www.salemmarafi.com/code/market-basket-analysis-with-r/

library(arules)
library(arulesViz)
library(datasets)

# Load the data set
data(Groceries)
itemFrequencyPlot(Groceries,topN=20,type="absolute")

rules <- apriori(Groceries, parameter = list(supp = 0.001, conf = 0.8))

# Show the top 5 rules, but only 2 digits
options(digits=2)
inspect(rules[1:10])

summary(rules)
plot(rules, method="scatterplot")

rules<-sort(rules, by="confidence", decreasing=TRUE)
inspect(rules[1:10])

#remove redundancy
#subset.matrix <- is.subset(rules, rules)
#subset.matrix[lower.tri(subset.matrix, diag=T)] <- NA
#redundant <- colSums(subset.matrix, na.rm=T) >= 1
#rules.pruned <- rules[!redundant]
#rules<-rules.pruned

## targeting
rules<-apriori(data=Groceries, parameter=list(supp=0.001,conf = 0.45), 
               appearance = list(default="lhs",rhs="sausage"),
               control = list(verbose=F))
rules<-sort(rules, decreasing=TRUE,by="confidence")
inspect(rules[1:5])


rules<-apriori(data=Groceries, parameter=list(supp=0.001,conf = 0.15,minlen=2), 
               appearance = list(default="rhs",lhs="domestic eggs"),
               control = list(verbose=F))
rules<-sort(rules, decreasing=TRUE,by="confidence")
inspect(rules[1:5])

library(arulesViz)
plot(rules,method="graph",interactive=TRUE,shading=NA)

