#Load relevant libraries----
library(tidyverse)

## read in txt files automatically----
fname <- list.files("Samples/greenlandSamples", full.names = T) 
###Dimensions = 1:28 (Greenland) ###1:100 (Alaska)

###Components of Function 1-----
##List with all text files (Two methods depending on separator) 
#filelist <- lapply(fname, read.delim, header = F) 
#add , for alaska samples
filelist <- lapply(fname, read.table, sep="") 
### Dimensions = 28 [1:3697] (Greenland) 100 [1:1882] (Alaska)
 
## Adding sample IDs (reference to lake core)
names(filelist) <- gsub(".*/(.*)\\..*", "\\1", fname)

###Components of Function 2-------
# save the transformed df to a new list of df called reformattedData [1:3697] (Greenland)
reformattedData <- lapply(filelist, function(x){pivot_wider(x, names_from = V1, values_from = V2)})

# Unlist the reformattedData list into matrix (each of the 28 elements has one row of 3697 wavenumber values)
wavenumber2 <- lapply(reformattedData, names)

# convert matrix into dataframe [28:3697]
wavenumber <- as.data.frame(do.call("rbind",wavenumber2))
(wavenumber$V1) #3996.31543 ALASKA
(wavenumber$V1882) #368.38622 ALASKA

(wavenumber$V1) #7496.97825 // 7496.94889 GREENLAND
(wavenumber$V3697) #368.38766 GREENLAND


# add row names permanently
wavenumber$dataset <- names(filelist) ## make this a specific column, don't trust it to store

#Rename column header from "wavenumbers" to "Vi" (FUNCTION #3)
dropNames <- function(data){
  names(data)=paste("V", 1:ncol(data), sep="")
  return(data)
}

# creating new list of df where there aren't any wavenumbers...only absorbance values [1:3697]
absorbanceValues2 <- lapply(reformattedData, dropNames)

# Dataframe of [28:3697]where absorbance values are in cells
##need to resolve mismatch in wavenumbers before moving forward
absorbanceValue <- do.call(rbind.data.frame,absorbanceValues2)

lapply(reformattedData, ncol) %>% unlist() %>% summary()

#checking summary
#lapply(reformattedData, ncol) %>% unlist() %>% summary()
#which are not 1882
#which(unlist(lapply(reformattedData, ncol)) != 1882)
###AW-34.5 (8_31_16).0  AW-7.5 (8_31_16).0   AW-73 (8_31_16).0 

## adds column for each row to remind us which file it is
absorbanceValue$dataset <- names(filelist)

## Make data sample name in first column
wavenumber <- wavenumber[,c(ncol(wavenumber),1:(ncol(wavenumber)-1))] ### 28:3698

absorbance <- absorbanceValue[,c(ncol(absorbanceValue),1:(ncol(absorbanceValue)-1))] ### 28:3698

write.csv(wavenumber, "csvFiles/wavenumber.csv")

write.csv(absorbance, "csvFiles/absorbance.csv")

###Components of Function 4-----
#Read in calibration csv with same number of samples as our transformedData 
wet_chem_data <- read_csv("csvFiles/wet-chem-data.csv") ###28

#Read in absorbance values for each sample
absorbance <- read_csv("csvFiles/absorbance.csv") ###28:3698

#Rename wet_chem_data columns 
names(wet_chem_data)[1] <- "dataset"
names(wet_chem_data)[2] <- "BSiPercent"
