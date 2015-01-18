######1######

#get data
iris<-read.csv("iris.data.csv")

#randomly order the data
set.seed(12345)
iris_rand<-iris[order(runif(150)),]

#split the data into training data & testing data
mid<-150*0.7
iris_train<-iris_rand[1:mid,]
iris_test<-iris_rand[(mid+1):150,]

######2######

#use C50 to build the decision tree
library(C50)
iris_model<-C5.0(iris_train[-5],iris_train$class)

#evaluate the decision tree
iris_pred<-predict(iris_model,iris_test)
library(gmodels)
CrossTable(iris_test$class,iris_pred,prop.chisq=FALSE,prop.c=FALSE,prop.r=FALSE,dnn=c('actual class','predicted class'))

#improve the accuracy of decision trees
iris_boost10<-C5.0(iris_train[-5],iris_train$class,trials=10)

#evalute the decision tree
iris_boost_pred10<-predict(iris_boost10,iris_test)
CrossTable(iris_test$class,iris_boost_pred10,prop.chisq=FALSE,prop.c=FALSE,prop.r=FALSE,dnn=c('actual class','predicted class'))

######3######

#use knn function to train the data
library(class)
cl<-factor(iris_train$class)
iris_knn_pred11<-knn(iris_train[-5],iris_test[-5],cl,k=11)
CrossTable(iris_test$class,iris_knn_pred11,prop.chisq=FALSE,prop.c=FALSE,prop.r=FALSE,dnn=c('actual class','predicted class'))

#varying a different number of k including 1, 3, 5, 11, 17 and 21
iris_knn_pred<-knn(iris_train[-5],iris_test[-5],cl,k=1)
CrossTable(iris_test$class,iris_knn_pred,prop.chisq=FALSE,prop.c=FALSE,prop.r=FALSE,dnn=c('actual class','predicted class'))

iris_knn_pred<-knn(iris_train[-5],iris_test[-5],cl,k=3)
CrossTable(iris_test$class,iris_knn_pred,prop.chisq=FALSE,prop.c=FALSE,prop.r=FALSE,dnn=c('actual class','predicted class'))

iris_knn_pred<-knn(iris_train[-5],iris_test[-5],cl,k=5)
CrossTable(iris_test$class,iris_knn_pred,prop.chisq=FALSE,prop.c=FALSE,prop.r=FALSE,dnn=c('actual class','predicted class'))

iris_knn_pred<-knn(iris_train[-5],iris_test[-5],cl,k=11)
CrossTable(iris_test$class,iris_knn_pred,prop.chisq=FALSE,prop.c=FALSE,prop.r=FALSE,dnn=c('actual class','predicted class'))

iris_knn_pred<-knn(iris_train[-5],iris_test[-5],cl,k=17)
CrossTable(iris_test$class,iris_knn_pred,prop.chisq=FALSE,prop.c=FALSE,prop.r=FALSE,dnn=c('actual class','predicted class'))

iris_knn_pred<-knn(iris_train[-5],iris_test[-5],cl,k=21)
CrossTable(iris_test$class,iris_knn_pred,prop.chisq=FALSE,prop.c=FALSE,prop.r=FALSE,dnn=c('actual class','predicted class'))

#normalize the normalizing the first 4 attributes
normalize<-function(x){
	return ((x-min(x))/(max(x)-min(x)))
}
iris_n<-as.data.frame(lapply(iris_rand[-5],normalize))

#split the data into training data & testing data
iris_train_n<-iris_n[1:mid,]
iris_test_n<-iris_n[(mid+1):150,]

#use knn function to train the data
iris_knn_pred_n<-knn(iris_train_n,iris_test_n,cl,k=11)
CrossTable(iris_test$class,iris_knn_pred_n,prop.chisq=FALSE,prop.c=FALSE,prop.r=FALSE,dnn=c('actual class','predicted class'))

#z-score standardization
iris_z<-as.data.frame(scale(iris_rand[-5]))

#split the data into training data & testing data
iris_train_z<-iris_z[1:mid,]
iris_test_z<-iris_z[(mid+1):150,]

#use knn function to train the data
iris_knn_pred_z<-knn(iris_train_z,iris_test_z,cl,k=11)
CrossTable(iris_test$class,iris_knn_pred_z,prop.chisq=FALSE,prop.c=FALSE,prop.r=FALSE,dnn=c('actual class','predicted class'))

#compare
print("compare the the knn classification model k=11")
print("original")
CrossTable(iris_test$class,iris_knn_pred11,prop.chisq=FALSE,prop.c=FALSE,prop.r=FALSE,dnn=c('actual class','predicted class'))
print("normalization")
CrossTable(iris_test$class,iris_knn_pred_n,prop.chisq=FALSE,prop.c=FALSE,prop.r=FALSE,dnn=c('actual class','predicted class'))
print("standardization")
CrossTable(iris_test$class,iris_knn_pred_z,prop.chisq=FALSE,prop.c=FALSE,prop.r=FALSE,dnn=c('actual class','predicted class'))








