output <- function()
{
  for(i in 1:nrow(result_data))
  {
    temp_u <- c(selUser, result_data$MovieID[i], result_data$up2[i], result_data$up10[i], result_data$up50[i], result_data$uc2[i], result_data$uc10[i], result_data$uc50[i], "u")
    temp_U <- c(selUser, result_data$MovieID[i], result_data$Up2[i], result_data$Up10[i], result_data$Up50[i], result_data$Uc2[i], result_data$Uc10[i], result_data$Uc50[i], "U")
    temp_i <- c(selUser, result_data$MovieID[i], result_data$ip2[i], result_data$ip10[i], result_data$ip50[i], result_data$ic2[i], result_data$ic10[i], result_data$ic50[i], "i")
    temp_I <- c(selUser, result_data$MovieID[i], result_data$Ip2[i], result_data$Ip10[i], result_data$Ip50[i], result_data$Ic2[i], result_data$Ic10[i], result_data$Ic50[i], "I")
    write.table(rbind(temp_u, temp_U, temp_i, temp_I), append=TRUE, file="output.dat", quote=FALSE, sep="::", col.names=FALSE, row.names=FALSE)  
  }
  
}