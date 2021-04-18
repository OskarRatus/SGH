setwd('C:/Users/oskar/Downloads')


library(corrplot)
library(moments)
library(tidyverse)
library(cluster)
library(factoextra)
library(plotly)
library(dplyr)

### FUNCTIONS SETUP
wssplot <- function(data, nc=15, seed=10){
  wss <- (nrow(data)-1)*sum(apply(data,2,var))
  for (i in 2:nc){
    set.seed(seed)
    wss[i] <- sum(kmeans(data, centers=i)$withinss)}
  plot(1:nc, wss, type="b", xlab="Number of Clusters",
       ylab="Within groups sum of squares")
}

findSeed <- function(data, num){
  out <- data.frame(matrix(nrow = 1000, ncol = 2))
  colnames(out) <- c("seed", "BT")
  
  for (i in 1:1000) {
    set.seed(i)
    k.means.fit <- kmeans(data, num)
    BT <-k.means.fit$betweenss/k.means.fit$totss
    out[i, 1] <- i
    out[i, 2] <- BT
  }
  
  return(out[which.max(out$BT),])
}


### DATA IMPORT
data_raw<-read.table('Mall_Customers.csv', header=TRUE, sep=',')
colnames(data_raw) <- c( "CustomerID", "Gender", "Age", "Annual_Income", "Spending_Score")
data_raw<-subset(data_raw, select=-c(CustomerID))
data_raw<-subset(data_raw, select=-c(Gender))
head(data_raw)

### BASIC STATISTICS
summary(data_raw)
is.null(data_raw)
kurtosis(data_raw)

### CORRELATION
data_raw %>% cor() %>% corrplot(method = "circle")

### PAIRS
data_raw %>% pairs(pch = 19)
  
### DISTRIBUTION
{
  par(mfrow=c(2, 2))
  hist(data_raw$Age, prob=TRUE, col='grey' )
  lines(density(data_raw$Age))
  hist(data_raw$Annual_Income, prob=TRUE, col='grey' )
  lines(density(data_raw$Annual_Income))
  hist(data_raw$Spending_Score, prob=TRUE, col='grey' )
  lines(density(data_raw$Spending_Score))
  par(mfrow=c(1, 1)) 
}

  # scale<-function(a){
#   b = (a-min(a))/(max(a)-min(a))
#   return(b)
# }

scale <- function(a){
  return((a-mean(a)/sd(a)))
}


### NORMALIZATION
data <- data_raw
data$Age <- scale(data_raw$Age)
data$Annual_Income=scale(data_raw$Annual_Income)
data$Spending_Score=scale(data_raw$Spending_Score)
  

### DISTRIBUTION
{
  par(mfrow=c(2, 2))
  hist(data$Age, prob=TRUE, col='grey' )
  lines(density(data$Age))
  hist(data$Annual_Income, prob=TRUE, col='grey' )
  lines(density(data$Annual_Income))
  hist(data$Spending_Score, prob=TRUE, col='grey' )
  lines(density(data$Spending_Score))
  par(mfrow=c(1, 1))
} 


### SELECT NUMBER OF CLUSTERS
wssplot(data, nc=10)
num <- 5


### FIT AND PLOT 3D
out <- findSeed(data,num)
out
set.seed(out[,1])
fit <- kmeans(data, num)
data$Cluster <- fit$cluster 

# PLOT 3d
plot_ly(data, x=~Age, y=~Annual_Income, z=~Spending_Score, color=~Cluster)

# PLOT 2D
clusplot(data, fit$cluster, main='Klasteryzacja',color=TRUE, shade=TRUE,labels=2, lines=0,
         xlab="Annual_Income", ylab="Spending_Score")


# FLAGS
sil2 <- silhouette(fit$cluster, dist(data))
fviz_silhouette(sil2)
