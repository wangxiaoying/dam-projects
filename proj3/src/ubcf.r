# normalize
useritem_n <- useritem
for (i in 1:n)
{
	useritem_n[i,] <- norm_mean(useritem[i,])
}

# modeling
model_ub <- function(onlyIntersect = TRUE, ignoreOther = TRUE)
{
	# build matrix
	sims <- matrix(c(1:n),ncol=1) # column 1 is user id
	sims <- cbind(sims,rep(NA, times=n), rep(0, times=n)) # column 2 is similarity, column 3 indicates overlapped

	# calculate similarities between selected user and other users
	for (i in 1:n)
	{
		if (i!=selUser)
		{
			sims[i,3] <- 1-min(is.na(useritem[i,selMovies]))
			if (sims[i,3] || !ignoreOther || !onlyIntersect)
			{
				sims[i,2] <- simil(rbind(na2zero(useritem_n[selUser,]),na2zero(useritem_n[i,])), method=selMethod)[1]
			}
		}
	}
	
	# sort by similarity
	if (onlyIntersect)
	{
		sims_sorted <- sims[order(sims[,3], sims[,2], decreasing=TRUE, na.last=TRUE),]
	}else
	{
		sims_sorted <- sims[order(sims[,2], decreasing=TRUE, na.last=TRUE),]
	}
	return (sims_sorted)
}

# predict
predict_ub <- function(sims_sorted, selK, enhanced = FALSE)
{
	result <- useritem[selUser,]
	orgK <- selK
	# decrease K if there are no enough candidates
	#while (selK>0 && is.na(sims_sorted[selK,2]))
	#{
	#	selK <- selK - 1
	#}
	if (!enhanced)
	{
		for (mv in selMovies)
		{
      temp_sorted <- subset(sims_sorted, !is.na(useritem[sims_sorted[,1], mv]))
			result[mv] <- weighted.mean(useritem[temp_sorted[1:selK,1],mv],temp_sorted[1:selK,2], na.rm = TRUE)
		}
	}
	else
	{
		for (mv in selMovies)
		{
		  temp_sorted <- subset(sims_sorted, !is.na(useritem[sims_sorted[,1], mv]))
			result[mv] <- useritem_baseline[selUser,mv] + weighted.mean(useritem_ref[temp_sorted[1:selK,1],mv],temp_sorted[1:selK,2], na.rm = TRUE)
		}
	}
	# print result
	print(paste("Method:",selMethod," K:",orgK,"(actual=",selK,")"," Enhanced:",enhanced))
	print(cbind("MovieID"=selMovies,"Predicted"=result[selMovies],"Actual"=actualRatings))
	print(paste("RMSE:",calcRMSE(result[selMovies],actualRatings)))
  
  #save result
  result_data <<- cbind(result_data, result[selMovies])
}