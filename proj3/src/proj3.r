# main

#read in data
source("proj3_read.r")

result_data <<- data.frame(test_data$V2)

#user_user based
source("ubcf.r")
source("ubcf_task.r")

#item_item based
source("ibcf.r")
source("ibcf_task.r")

colnames(result_data) <- c("MovieID", "up2", "Up2", "up10", "Up10", "up50", "Up50", 
                           "uc2", "Uc2", "uc10", "Uc10", "uc50", "Uc50",
                           "ip2", "Ip2", "ip10", "Ip10", "ip50", "Ip50",
                           "ic2", "Ic2", "ic10", "Ic10", "ic50", "Ic50")

source("output.r")
output()
