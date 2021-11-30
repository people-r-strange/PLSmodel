# Predicting Biogenic Silica percentages in lake sediment cores from High Arctic settings 

## I. Background

Biogenic Silica (BSi) is used as a proxy for past temperatures in High Arctic settings. Typically, greater amounts of BSi in sediment cores indicate warmer temperatures. Recently paleoclimatologists have begun to use Fourier Transform Infrared (FTIR) spectroscopy to collect information on BSi. However, the offloaded relative absorbance data make comparison with other proxies difficult. The goal of this [project](https://www.causeweb.org/usproc/eusrc/2021/virtual-posters/7) is to develop a universal calibration model using PLS to convert absorbance spectra into percentages of BSi and TOC so as to provide paleoclimatologists with a more universal way of analyzing and understanding their results.

## II. Repo Organization 

The repository is organized into the following four folders: 

* Code

* csvFiles

* dataViz

* Samples

### Code 

The code folder contains four scripts: 

* 01_createDataFrameScript.R : This code takes the offloaded OPUS files and reformats them into a suitable data frame for the PLS model 

* 01_createDataFrame.R : This code does the same thing as the aforementioned script, only this code includes function which allow for more efficient processing

* 02_createModelScript.R : This code loads the data frame created in the first script, inputs the dataframe into the PLS model, creates an RMSEP curve and loading plots. 

* 03_modelAccuracy.R : This code assess the model accuracy by creating two plots: (1) plot that compares the actual percentages of BSi to the predicted percentages of BSI; (2) plot that calculates the residuals (actual minus observed) and detects any overfitting and underfitting 

