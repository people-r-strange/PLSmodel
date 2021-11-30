#Load relevant libraries----
library(tidyverse)

## read in txt files automatically----
fname <- list.files("Samples/greenlandSamples", full.names = T) ###1:28

##FUNCTION 1: Add Sample Names----
  
  addSampleNames <- function(fname) {
  ## creates list of txt files
  filelist <- lapply(fname, read.delim, header = F)
  
  ## Adding sample IDs (reference to lake core)
  names(filelist) <- gsub(".*/(.*)\\..*", "\\1", fname)
  
  return(filelist)
}
  #Save list of txt files with sample names
  filelist <- addSampleNames(fname) ###28
  
##FUNCTION 2: Rename column header from "wavenumbers" to "Vi"----
  
  dropNames <- function(data) {
    names(data) <- paste("V", 1:ncol(data), sep = "")
    return(data)
  }
##FUNCTION 3: Transforms the large list of dataframes [3697:2] into correct format [1:3697]----
    
    # assign name to our function, input list of dataframes we want function to work on (filelist)
    transform_df <- function(filelist) {
      
      # save the transformed df to a new list of df called reformattedData [1:3697]
      reformattedData <- lapply(filelist, function(x) {
        pivot_wider(x, names_from = V1, values_from = V2)
      })
      
      # Unlist the reformattedData list into matrix (each of the 28 elements has one row of 3697 wavenumber values)
      wavenumber_matrix <- lapply(reformattedData, names) 
      
      # convert matrix into dataframe [28:3697]
      wavenumber_df <- as.data.frame(do.call("rbind",wavenumber_matrix))
      
      # add row names permanently
      wavenumber_df$dataset <- row.names(wavenumber_df) ## make this a specific column, don't trust it to store
      
      # creating new list of df where there aren't any wavenumbers...only absorbance values [1:3697]
      absorbance_matrix <- lapply(reformattedData, dropNames)
      
      # Dataframe of [28:3697]where absorbance values are in cells
      ##need to resolve mismatch in wavenumbers before moving forward
      absorbance_df <- do.call(rbind.data.frame, absorbance_matrix)
      
      ## adds column for each row to remind us which file it is
      absorbance_df$dataset <- names(filelist)
      
      ## Make data sample name in first column
      wavenumber <- wavenumber_df[,c(ncol(wavenumber_df),1:(ncol(wavenumber_df)-1))]
      
      absorbance <- absorbance_df[,c(ncol(absorbance_df),1:(ncol(absorbance_df)-1))]
      
      ## returning the waveNumberInfo too
      return(list(absorbance = absorbance, wavenumber = wavenumber))
    }
  
  
 output <- transform_df(filelist) ###1:28
  
  #write csv files 
 # write.csv(output$absorbance, "csvFiles/absorbance.csv", row.names = F)
 # write.csv(output$wavenumber, "csvFiles/wavenumber.csv", row.names = F)
  
##FUNCTION 4: Add Calibration Data ----
  
    #Read in calibration csv with same number of samples as our transformedData 
    wet_chem_data <- read_csv("csvFiles/wet-chem-data.csv") ###28
  
    #Read in absorbance values for each sample
    absorbance <- read_csv("csvFiles/absorbance.csv") ###28:3698
    
    addWetChem <- function(absorbance) {
      
      #Rename wet_chem_data columns 
      names(wet_chem_data)[1] <- "dataset"
      names(wet_chem_data)[2] <- "BSiPercent"
      
      #bind calibration data to transformed data
      wetChemAbsorbance <- full_join(wet_chem_data, absorbance, by = "dataset")
      
      ## this replaces .0 with a space, the backslashes escape the special character . in regular expressions
      wetChemAbsorbance$dataset = gsub("\\.0","",wetChemAbsorbance$dataset) 
      
      ## this replaces cm with a space, the backslashes escape the special character . in regular expressions
      wetChemAbsorbance$dataset = gsub("cm","",wetChemAbsorbance$dataset)
      
      return(wetChemAbsorbance)
    }
    
    wetChemAbsorbance <- addWetChem(absorbance) ###28:3699
    
    #Write csv file 
    write.csv(wetChemAbsorbance,"csvFiles/wetChemAbsorbance.csv",row.names=F)
    
    
    
    
    
    
    
    
    
    
    
## Big Function (Not completed) ----
  runAll <- function(fname) {
    sampleNames <- addSampleNames(fname)
    listAbsorbanceWavenumber <- transform_df(sampleNames)
    return(listAbsorbanceWavenumber)
  }
  
  output <- runAll(fname)
  