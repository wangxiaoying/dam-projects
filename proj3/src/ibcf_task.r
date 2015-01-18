allResults <- matrix(nrow=12,ncol=length(selMovies))

for (idx in 1:length(selMovies))
{
	selItem <- selMovies[idx]
	selMethod <- "pearson"
	imodel <- model_ib()
	allResults[1,idx] <-predict_ib(imodel,2)
	allResults[2,idx] <-predict_ib(imodel,2, enhanced = TRUE)
	allResults[3,idx] <-predict_ib(imodel,10)
	allResults[4,idx] <-predict_ib(imodel,10, enhanced = TRUE)
	allResults[5,idx] <-predict_ib(imodel,50)
	allResults[6,idx] <-predict_ib(imodel,50, enhanced = TRUE)

	selMethod <- "cosine"
	imodel <- model_ib()
	allResults[7,idx] <-predict_ib(imodel,2)
	allResults[8,idx] <-predict_ib(imodel,2, enhanced = TRUE)
	allResults[9,idx] <-predict_ib(imodel,10)
	allResults[10,idx] <-predict_ib(imodel,10, enhanced = TRUE)
	allResults[11,idx] <-predict_ib(imodel,50)
	allResults[12,idx] <-predict_ib(imodel,50, enhanced = TRUE)
}

#save results
result_data <<- cbind(result_data, t(allResults))

for (i in 1:12)
{
	print(paste("[Scheme",i,"]"))
	x<-allResults[i,]
	y<-actualRatings
	print(cbind("MovieID"=selMovies,"Predicted"=x,"Actual"=y))
	print(paste("RMSE:",calcRMSE(x,y)))
}