# import required packages
library(stats)
library(proxy)

# read train data
train_data <- read.csv("train.csv", header = FALSE, sep=",", quote = "", na.strings = "NA")
test_data <- read.csv("test.csv", header = FALSE, sep=",", quote = "", na.strings = "NA")

# prepare data
useritem <- as.matrix(train_data)
n <- dim(useritem)[1]
m <- dim(useritem)[2]
selUser <- test_data[1,1]
selMovies <- test_data$V2
actualRatings <- test_data$V3

# calculate baseline parameters
avg_overall <- mean(useritem, na.rm=TRUE)
avg_peruser <- apply(useritem,1,mean,na.rm=TRUE)
avg_peritem <- apply(useritem,2,mean,na.rm=TRUE)

useritem_baseline <- matrix(data=-avg_overall,nrow=n,ncol=m)
for (i in 1:n)
{
	useritem_baseline[i,] <- useritem_baseline[i,]+avg_peruser[i]
}
for (j in 1:m)
{
	useritem_baseline[,j] <- useritem_baseline[,j]+avg_peritem[j]
}
useritem_ref <- useritem-useritem_baseline

# common functions
calcRMSE <- function (a,b) {
	sqrt(sum((a-b)^2,na.rm=TRUE)/length(a))
}

na2zero <- function (x) {
	y <- x
	y[is.na(y)] <- 0
	return (y)
}

norm_mean <- function (x) {
x-mean(x,na.rm=TRUE)
}