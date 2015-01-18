convertData <- function(data_src, start_index, end_index){
	
	if(ncol(data_src) == 1){
		colNum <- 1
	}else{
		colNum <- 2
	}

	#formatting the source
	temp <- Corpus(DataframeSource(as.data.frame(data_src[start_index:end_index, colNum])))
	temp <- tm_map(temp, stripWhitespace)  
	temp <- tm_map(temp,  content_transformer(tolower))
	temp <- tm_map(temp, removeWords, stopwords("english"))
	temp <- tm_map(temp, removePunctuation) 
	temp <- tm_map(temp, stripWhitespace)

	#convert data to term frequency matrix
	dtm <- DocumentTermMatrix(temp)
	# data <- as.data.frame(inspect(dtm))
  	data <- as.data.frame(as.matrix(dtm))

	#only consider weather the term is in the message or not
	# data <- as.data.frame(ifelse(0 == data, 0, 1))

	#sort the terms by the frequency
	# data <- data[order(-colSums(data))]
	# data <- data[,1:500]

	return(data)
}

readData <- function(data_src){
  size <- 1
  start_index <- 1
  end_index <- start_index + step_width - 1
  mergedData <- data.frame()
  
  while(TRUE){
    if(start_index > nrow(data_src)){
      break
    }
    data <- convertData(data_src, start_index, end_index)
    mergedData <- rbind(mergedData, compressMatrix(data, FALSE))
    
    start_index <- start_index + step_width
    end_index <- ifelse((start_index+step_width) < nrow(data_src), start_index+step_width-1, nrow(data_src))
  }

  return (mergedData)
}





