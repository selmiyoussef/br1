### MICE package for missing value
##Mice: Multivariate Imputation by Chained Equations
##SELMI YOUSSEF
##imputation with mice on iris dataset
################################################################
data(iris)
#is.na(iris) ?
summary(iris)

install.packages("missForest")
library(missForest)
#Generate 15% of misssing value
iris.mis <- prodNA(iris, noNA = 0.15)
summary(iris.mis)
#working with only numeric value for this step 
iris.mis=subset(iris.mis,select=-c(Species))
#install.packages("mice")
library(mice)
#each ligne show the  missing value for each variable
md.pattern(iris.mis)
#plot of missing value
install.packages("VIM")
library(VIM)
mice_plot <- aggr(iris.mis, col=c('navyblue','yellow'),numbers=TRUE, sortVars=TRUE,labels=names(iris.mis), cex.axis=.7,gap=3, ylab=c("Missing data","Pattern"))
#step of imputation of missing value

imp=mice(iris.mis,m=5,method='pmm',seed='100')#pmm:predictive mean matching.
#summary of parametres
summary(imp)
#density of observed data VS imputed data 
#blue for observed data and red for imputed data
densityplot(imp)
#which variables does mice() use as predictors 
#for imputation of each incomplete variable
imp$pred
# here we have 5 imputed data
#for example the first data imputed
#build model on 5 datasets
#linear regression for ecah imputed data set -5 regression are run
fit <- with(data=imp,exp = lm(Sepal.Width ~ Sepal.Length + Petal.Width))#combien results of 5 models
#pool coefi and standard errors across all  regression models
combine=pool(fit)#the averaged(the pooled) results
round(summary(combine))
#
complete_iris=complete(imp,1)

