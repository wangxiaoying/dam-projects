termCluster <- function(){
	#get subset as spam and ham
	data1$xxxtype <- data1_type
	spam <- subset(data1, xxxtype=="spam")
	ham <- subset(data1, xxxtype=="ham")
	# spam <- subset(data, data[, xxxtype]=="spam")
	# ham <- subset(data, data[, xxxtype]=="ham")

	#remove added xxxtype column
	spam$xxxtype <- NULL
	ham$xxxtype <- NULL
	data1$xxxtype <- NULL

	#get the frequency of each word in spam and ham
	sumHam <- colSums(ham)
	sumSpam <- colSums(spam)

	#build the data frame for clustering
	t_data <- as.data.frame(t(data1[0:0,]))
	t_data$ham <- sumHam
	t_data$spam <- sumSpam

	#use kmeans to cluster the terms into num_kinds groups
	term_cluster <- kmeans(t_data, num_kinds)
	t_data$cluster <- term_cluster$cluster

	return(t_data)
}

compressMatrix <- function(data, is_self){
	#reduce dimension, by merge the columns of the sparse matrix
	mergedData <- data[,0:0]
	for (i in 1:num_kinds)
	{
		temp <- subset(t_data, t_data$cluster == i)
		if(is_self){
			if(nrow(temp) != 1){
				mergedData[,i] <- rowSums(data[,rownames(temp)])
			}else{
				mergedData[,i] <- data[,rownames(temp)[1]]
			}
		}else{
			rows <- intersect(rownames(temp),colnames(data))
			if(length(rows) > 1){
				mergedData[,i] <- rowSums(data[,rows])
			}else if(length(rows) == 0){
				mergedData[,i] <- 0
			}else{
				mergedData[,i] <- data[,rows[1]]
			}
		}
	}

	return(mergedData)
}

messageCluster <- function(mergedData, type){
	#clustering use kmeans and kmedoids & result compare
	for(K in c(2, 4, 8, 16))
	{
		resultkmeans <- kmeans(mergedData, K)
		resultkmedoids <- pam(mergedData, K)
    
		CrossTable(type, resultkmeans$cluster, prop.chisq=FALSE, prop.c=FALSE, prop.r=FALSE, dnn=c('actual cluster', 'result cluster'))
		CrossTable(type, resultkmedoids$cluster, prop.chisq=FALSE, prop.c=FALSE, prop.r=FALSE, dnn=c('actual cluster', 'result cluster'))
		CrossTable(resultkmeans$cluster, resultkmedoids$cluster, prop.chisq=FALSE, prop.c=FALSE, prop.r=FALSE, dnn=c('kmeans cluster', 'kmedoids cluster'))
	}

	# compare with the classified when k = 2
	resultkmeans <- kmeans(mergedData, 2)
	resultkmedoids <- pam(mergedData, 2)
	CrossTable(type, resultkmeans$cluster, prop.chisq=FALSE, prop.c=FALSE, prop.r=FALSE, dnn=c('actual cluster', 'result cluster'))
	CrossTable(type, resultkmedoids$cluster, prop.chisq=FALSE, prop.c=FALSE, prop.r=FALSE, dnn=c('actual cluster', 'result cluster'))
}

classify <- function(){
	#use naiveBayes to train the model
	nb <- naiveBayes(mergedData1, data1_type)
	
	#use the model to classify data2
	type2 <- predict(nb, mergedData2)

	return(type2)
}


