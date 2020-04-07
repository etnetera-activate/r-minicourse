#####################
# Fit model
#####################

try(setwd("./00-fitbit-demo/"))
load(file = "fitbit.rda")

library(MASS)



#### how many calories is one step?
jdt<- fitdt[fitdt$who=="Jirka",-c(14,16)]
jdt<-jdt[-40,]
jfit<-lm(calories.burned ~ steps ,data=jdt)
jfit<-glm(calories.burned ~ . ,data=jdt)

summary()

ggplot(jdt, aes(x=steps, y=calories.burned, col=day.class))+
  geom_point(size=5, alpha=0.5)+
  stat_smooth(method="lm",se = F)+
  theme_bw()+
  labs(x="kroky",y="spálené kalorie", col="typ dne")


summary(jfit)
coefficients(jfit) # model coefficients
confint(jfit, level=0.95) # CIs for model parameters 
fitted(jfit) # predicted values
residuals(jfit) # residuals
anova(jfit) # anova table 
vcov(jfit) # covariance matrix for model parameters 
influence(jfit) # regression diagnostics

# diagnostic plots 
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(jfit)

#select model


### model selection
stepAIC(jfit,direction = "both")
stepwise(jfit,direction = "backward", criterion = "BIC")

jfit.final<-glm(formula = calories.burned ~ steps + distance + minutes.sedentary + 
      minutes.very.active + minutes.awake, data = jdt)

summary(jfit.final)
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(jfit.final)

#### cluster
row.names(fitdt)<-fitdt$date
nums <- sapply(fitdt, is.numeric)
mydata<-fitdt[,nums]


# Determine number of clusters
layout(matrix(c(1),1,1))
wss <- (nrow(mydata)-1)*sum(apply(mydata,2,var))
for (i in 2:15) wss[i] <- sum(kmeans(mydata, 
                                     centers=i)$withinss)
plot(1:15, wss, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares")

# K-Means Cluster Analysis
fit <- kmeans(mydata, 5) # 5 cluster solution
# get cluster means 
means<-aggregate(mydata,by=list(fit$cluster),FUN=mean)
# append cluster assignment
#mydata <- data.frame(mydata, fit$cluster)

# Ward Hierarchical Clustering
d <- dist(mydata, method = "euclidean") # distance matrix
fit <- hclustsad(d, method="ward") 
plot(fit) # display dendogram
groups <- cutree(fit, k=5) # cut tree into 5 clusters
# draw dendogram with red borders around the 5 clusters 
rect.hclust(fit, k=5, border="red")

#### how to recognize workday
library(rpart)

# grow tree 
fit <- rpart(day.class ~  . , method="class", data=fitdt[,-c(1,16)])

summary(fit) # detailed summary of splits

# plot tree 
plot(fit, uniform=T,branch = 0, compress = T)

text(fit, use.n=TRUE, all=TRUE, cex=.8)
                             










