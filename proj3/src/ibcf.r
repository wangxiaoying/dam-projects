# define some functions
calcRMSE <- function (a,b) {
	sqrt(sum((a-b)^2,na.rm=TRUE)/length(a))
}

na2zero <- function (x) {
	y <- x
	y[is.na(y)] <- 0
	return (y)
}

# normalize
useritem_n <- useritem
for (j in 1:m)
{
	useritem_n[,j] <- norm_mean(useritem[,j])
}

# modeling
model_ib <- function(onlyIntersect = TRUE, ignoreOther = TRUE)
{
	# build matrix
	sims <- matrix(c(1:m),ncol=1) # column 1 is item id
	sims <- cbind(sims,rep(NA, times=m), rep(0, times=m)) # column 2 is similarity, column 3 indicates overlapped

	# calculate similarities between selected item and other items
	for (j in 1:m)
	{
		if (j!=selItem)
		{
			sims[j,3] <- !is.na(useritem[selUser, j])
			if (sims[j,3] || !ignoreOther || !onlyIntersect)
			{
				sims[j,2] <- simil(rbind(na2zero(useritem_n[,selItem]),na2zero(useritem_n[,j])), method=selMethod)[1]
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
predict_ib <- function(sims_sorted, selK, enhanced = FALSE)
{
	orgK <- selK
	# decrease K if there are no enough candidates
	while (selK>0 && is.na(sims_sorted[selK,2]))
	{
		selK <- selK - 1
	}
	if (!enhanced)
	{
		ans <- weighted.mean(useritem[selUser,sims_sorted[1:selK,1]],sims_sorted[1:selK,2], na.rm = TRUE)
	}
	else
	{
		ans <- useritem_baseline[selUser,selItem] + weighted.mean(useritem_ref[selUser,sims_sorted[1:selK,1]],sims_sorted[1:selK,2], na.rm = TRUE)
	}
	# print result
	#print(paste("Method:",selMethod," K:",orgK,"(actual=",selK,")"," Enhanced:",enhanced))
	#print(cbind(selItem,ans))
	return (ans)
}