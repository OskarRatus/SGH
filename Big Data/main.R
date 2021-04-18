####
# Inosphere Dataset
# Classification of radar returns from the ionosphere
# No missing data
####

library(readr)
library(rattle)
library(purrr)
library(ggplot2)
library(tidyr)

#### Functions 
ConfusionMatrix <- function(prediction, testSet){
  out <- list(ConfusionMatrix = table(c(), c()),
              Accuracy = NA)
  out$ConfusionMatrix <- table(round(prediction), round(testSet), dnn = list("Prediction", "Reference"))
  out$Accuracy <- sum(diag(out$ConfusionMatrix))/sum(out$ConfusionMatrix)
  return(out)
}

##### Load data
# Loading data from URL
data = read.csv("https://archive.ics.uci.edu/ml/machine-learning-databases/ionosphere/ionosphere.data", header = FALSE)
# Preprocessing
names(data)[35] <- "target"
# recode target values
data[, 35] <- sapply(data[,35], function(x) ifelse(x == 'g', 1, 0))
# delete cols with only one value
data <- data[,apply(data, 2, function(x) length(unique(x))) > 1]

set.seed(10)
# Splitting into train and test
rand  <- sample(1 : nrow(data), 0.8 * nrow(data))
train <- data[rand,]
test  <- data[-rand,]
head(train)
head(test)

#####


# Exploring the data
data[,-34] %>%
  gather() %>%                             
  ggplot(aes(value)) +                    
  facet_wrap(~ key, scales = "free") +   
  geom_density() 

cor = round(cor(data[,1:33]),2)
ggplot(data = melt(cor), aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile()



#### Classificaton Trees ####
library(rpart)
rpart_int <- rpart(target~., data=train, cp = 0.0001, method = "class", parms = list(split = "information")) # cp = 0 lowers restriction on tree, more branches \ parms = 'information'
plot(rpart_int)
text(rpart_int)
rpart_pred <- predict(rpart_int, test[,-34])
ConfusionMatrix(rpart_pred[,2], test[,34])

# Choice of optimal tree on the basis of CV
rpart_int$cptable
plotcp(rpart_int)
# Choose minimal error of given cp (Complexity Parameter)
cp_opt    <- rpart_int$cptable[which(rpart_int$cptable[, 4] == min(rpart_int$cptable[, 4])), 1]
rpart_opt <- prune(rpart_int, cp_opt)
plot(rpart_opt)
text(rpart_opt)
fancyRpartPlot(rpart_opt)
# Prediction
rpart_pred <- predict(rpart_opt, test[,-34])
ConfusionMatrix(rpart_pred[,2], test[,34])

library(rattle)
fancyRpartPlot(rpart_opt)



#### Conditional tree ####
library(party)
ctree_int <- ctree(target~., train, controls = ctree_control(mincriterion = .90, teststat = 'max', maxdepth = 3)) # teststat = 'max'
ctree_pred <- predict(ctree_int, test[,-34])

plot(ctree_int)
ConfusionMatrix(ctree_pred, test[,34])



##### Bagging
library(ipred)
n <- seq(50, 500, by = 20)
out <- rep(NA, length(n))
as.factor(train[,34])
for (i in 1:length(n)) {
  bagg_int  <- bagging(target~., data = train, nbagg = i)
  bagg_pred <- predict(bagg_int, test)
  out[i]    <- ConfusionMatrix(bagg_pred, test[,34])$Accuracy
  
}
plot(y =out, x = n, type = 'l')


bagg_opt  <- bagging(target~., data = train, nbagg = 420)
bagg_pred <- predict(bagg_opt, test)
ConfusionMatrix(bagg_pred, test[,34])



##### Random Forest
library(randomForest)
rf_int <- randomForest(target~., data = train, ntree = 500, do.trace = F)
varImpPlot(rf_int, main = 'Random Forest')
plot(rf_int, main = 'Random Forest')

mtry  <- c(1:ncol(train))
error <- c()

for(i in 1:length(mtry)){
  print(i)
  error[i] <- randomForest(target~., data=train, ntree=50, 
                          mtry=mtry[i])$mse[50]
}
mtry_opt <- mtry[which.min(error)]
plot(mtry, error, type="l") 
rf_opt <- randomForest(target~., data=train, ntree=250, mtry=mtry_opt, do.trace=T)
rf_pred <- predict(rf_opt, test)
ConfusionMatrix(rf_pred, test[,34])
