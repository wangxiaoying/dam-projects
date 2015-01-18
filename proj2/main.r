library("tm")
library("gmodels")
library("cluster")
library("e1071")

source("reading.r")
source("clustering.r")

num_kinds <- 12
step_width <- 5000
data2_size <- 20000

#read in dataset 1(after pretreatment used python)
data_src1 <- read.table("SMSx1.txt", encoding="UTF-8", sep="\t", quote="")
data_src2 <- read.table("SMSx2.txt", encoding="UTF-8", sep="\t", quote="")

data1_type <- data_src1$V1

data1 <- convertData(data_src1, 1, nrow(data_src1))

t_data <- termCluster()

mergedData1 <- compressMatrix(data1, TRUE)

#task 1
#normalization
# lapply(mergedData1, scale)
messageCluster(mergedData1, data1_type)


mergedData2 <- readData(data_src2)

#task 2
data2_type <- classify()

#task 3
#normalization
# lapply(mergedData2, scale)
messageCluster(mergedData2[1:data2_size,], data2_type[1:data2_size])
