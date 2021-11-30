#Load relevant libraries----
library(pls)
library(tidyverse)
library(scales)
library(readr)
#Load Absorbance Data----
  #Read in data containing wet chem BSi percentages 
  wetChemAbsorbance <- read_csv("csvFiles/wetChemAbsorbance.csv") ### 28 3699
  
  #Remove sample names 
  wetChemAbsorbance <- wetChemAbsorbance %>%
    select(-1)
  dim(wetChemAbsorbance) ## 28 3698
  
#Code for PLS model----
  
    ##Select CV based on number of samples
    
    ### Cross-Validation is 5-fold ###
    plsModel <- plsr(BSiPercent~., ncomp = 10, data=wetChemAbsorbance, validation = "CV", segments = 5)
  
  ###There is a predict function in the pls package to predict BSi percentages for data without wet chem BSi percentages
 # predict(plsModel, ncomp = 1:10, newdata = newData)
  
    ### Summary of Cross Validation and number of components
    print(summary(plsModel))
#Root Mean Squared Error Plots----
  
      #Plot RMSEP
      plot(RMSEP(plsModel))
    
      ## save root mean squared error of prediction to object res
      RMSEP <- RMSEP(plsModel)
      
      #Dataframe with cross validation and number of components
      Five_fold_CV <- cbind.data.frame(cv = RMSEP$val[1,,], ncomps = 0:10)
      
      #Number of components graph 
      ggplot(Five_fold_CV, aes(ncomps, cv)) +
        geom_line() +
        labs(title = "Cross-validated Root Mean Squared Error of Prediction (RMSEP) Curve", 
             subtitle="CV is 5-fold",
             y = "RMSEP", 
             x = "Number of Components") +
        scale_x_continuous(breaks = c(1:10)) + 
        theme_minimal()
      
#Create "test data" with different loadings ----
  
    ## Load Opus txt file 
       # reading in list of txt files and converting it to a df
        
      ## read in txt files automatically
      fname <- list.files("Samples/greenlandSamples", full.names = T)
      
      ##FUNCTION 1: Add Sample Names
      addSampleNames <- function(fname) {
        ## creates list of txt files
        filelist <- lapply(fname, read.delim, header = F)
        
        ## Adding sample IDs (reference to lake core)
        names(filelist) <- gsub(".*/(.*)\\..*", "\\1", fname)
        
        return(filelist)
      }
      
      #Save list of txt files with sample names
      filelist <- addSampleNames(fname)
      
      # save the transformed df to a new list of df called reformattedData
      reformattedData <- lapply(filelist, function(x) {
        pivot_wider(x, names_from = V1, values_from = V2)
      })
      
      # Unlist the reformattedData list into matrix
      wavenumber_matrix <- lapply(reformattedData, names) 
      
      # convert matrix into dataframe
      wavenumber_df <- as.data.frame(do.call("rbind",wavenumber_matrix))
      
      wavenumber <- as.numeric(as.vector(unname(t(wavenumber_df[1,])))) ### 1 3697
  
      
#Data frame for different loadings
      #loadings, #first column of random opus txt file)
      loadingPlotData<- cbind.data.frame(loadings_1 = plsModel$loadings[,1], 
                                  loadings_2= plsModel$loadings[,2], 
                                  loadings_3 = plsModel$loadings[,3], 
                                  weighted_loading_1 = plsModel$loading.weights[,1], 
                                  weighted_loading_2 = plsModel$loading.weights[,2], 
                                  weighted_loading_3 = plsModel$loading.weights[,3], 
                                  wavenumber = wavenumber)
      
#Loading Plots----
 
         #Loading plot for Full Spectrum loading 1 with legend and vertical lines
         
         ggplot(loadingPlotData, aes(x=wavenumber)) + 
         geom_line (aes(y = weighted_loading_1, colour = "1st Component")) +
         geom_line (aes(y = weighted_loading_2, color = "2nd Component")) + 
         geom_line (aes(y = weighted_loading_3, colour = "3rd Component")) + 
         
         scale_colour_manual("", 
                             breaks = c("1st Component", "2nd Component", "3rd Component"),
                             values = c("blue", "dark green", "orange")) +
         
         labs(y="Weighted Loadings", 
              x=expression(Wavenumber(cm^-1)), 
              title='Loading Plot for Three Components: Full Spectrum, n = 28',
              subtitle= expression("Where wavenumber ranges from ~7500 to ~370" ~ cm^{-1}))+
         scale_x_reverse() + 
         theme_minimal()
      