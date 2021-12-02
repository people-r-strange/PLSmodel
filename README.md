README
================
Vivienne Maxwell
11/30/2021

# Predicting Biogenic Silica percentages in lake sediment cores from High Arctic settings

Contributors

  - [Vivienne Maxwell](https://github.com/people-r-strange)

  - [Dr. Stoudt](https://github.com/sastoudt)

  - [Dr. de Wet](https://www.smith.edu/academics/faculty/greg-de-wet)

## I. Background

Biogenic Silica (BSi) is used as a proxy for past temperatures in High
Arctic settings. Typically, greater amounts of BSi in sediment cores
indicate warmer temperatures. Recently paleoclimatologists have begun to
use Fourier Transform Infrared (FTIR) spectroscopy to collect
information on BSi. However, the offloaded relative absorbance data make
comparison with other proxies difficult. The goal of this
[project](https://www.causeweb.org/usproc/eusrc/2021/virtual-posters/7)
is to develop a universal calibration model using PLS to convert
absorbance spectra into percentages of BSi and TOC so as to provide
paleoclimatologists with a more universal way of analyzing and
understanding their results.

## II. Repo Organization

The repository is organized into the following four folders:

  - [Code](https://github.com/people-r-strange/PLSmodel/tree/main/Code)

  - [csvFiles](https://github.com/people-r-strange/PLSmodel/tree/main/csvFiles)

  - [dataViz](https://github.com/people-r-strange/PLSmodel/tree/main/dataViz)

  - [Samples](https://github.com/people-r-strange/PLSmodel/tree/main/Samples)

### `Code`

The code folder contains four scripts:

  - [01\_createDataFrameScript.R](https://github.com/people-r-strange/PLSmodel/blob/main/Code/01_createDataFrameScript.R):
    This code takes the offloaded OPUS files and reformats them into a
    suitable data frame for the PLS model

  - [01\_createDataFrame.R](https://github.com/people-r-strange/PLSmodel/blob/main/Code/01_createDataFrame.R)
    : This code does the same thing as the aforementioned script, only
    this code includes function which allow for more efficient
    processing

  - [02\_createModelScript.R](https://github.com/people-r-strange/PLSmodel/blob/main/Code/02_createModelScript.R)
    : This code loads the data frame created in the first script, inputs
    the dataframe into the PLS model, creates an RMSEP curve and loading
    plots.

  - [03\_modelAccuracy.R](https://github.com/people-r-strange/PLSmodel/blob/main/Code/03_modelAccuracy.R)
    : This code assess the model accuracy by creating two plots: (1)
    plot that compares the actual percentages of BSi to the predicted
    percentages of BSi; (2) plot that calculates the residuals (actual
    minus observed) and detects any overfitting and underfitting

### `csvFiles`

This folder contains all of the generated csv files.

  - [absorbance.csv](https://github.com/people-r-strange/PLSmodel/blob/main/csvFiles/absorbance.csv)
    : Absorbance values

  - [wavenumber.csv](https://github.com/people-r-strange/PLSmodel/blob/main/csvFiles/wavenumber.csv)
    : Wavenumber values

  - [wet-chem-data.csv](https://github.com/people-r-strange/PLSmodel/blob/main/csvFiles/wet-chem-data.csv)
    : BSi percentages that were calculated using the wet chemical
    digestion method. These are considered the “actual” BSi values.

  - [wetChemAbsorbance.csv](https://github.com/people-r-strange/PLSmodel/blob/main/csvFiles/wetChemAbsorbance.csv)
    : This contains the “actual” BSi values and the absorbance values.
    This dataset is what is inputted into the PLS model.

### `dataViz`

This folder is divided into four sub-folders:

  - [crossValidation](https://github.com/people-r-strange/PLSmodel/tree/main/dataViz/Greenland/crossValidation)

  - [LoadingPlots](https://github.com/people-r-strange/PLSmodel/tree/main/dataViz/Greenland/LoadingPlots)

  - [modelAccuracy](https://github.com/people-r-strange/PLSmodel/tree/main/dataViz/Greenland/modelAccuracy)

  - [residuals](https://github.com/people-r-strange/PLSmodel/tree/main/dataViz/Greenland/residuals)

Within each of these folders, there are visualizations for:

  - full spectrum: 7500 - 368cm^{-1}

  - truncated spectrum: 3750 - 368cm^{-1}

  - specific spectrum: 435 - 480cm^{-1}

  - specific spectrum : 790 - 830cm^{-1}

  - specific spectrum : 1050 - 1280cm^{-1}

### `Samples`

For the samples folder there are two subfolders. The
[alaskaSamples](https://github.com/people-r-strange/PLSmodel/tree/main/Samples/alaskaSamples)
folder contains the 100 alaskan samples. The
[greenlandSamples](https://github.com/people-r-strange/PLSmodel/tree/main/Samples/greenlandSamples)
contains the 28 samples from Greenland.

## III. Objectives

The first step in this project was to create a PLS model using 28
samples from Greenland.

Currently, the goal is to input 100 Alaskan samples into the Greenland
model and predict BSi percentages. However, there is a resolution error
between the Greenland samples and the Alaskan samples, which require
interpolation.

Once the Alaskan sample resolution issue has been resolved, the next
step to is begin answering some of our questions.

### Questions we’d like to answer

1.  Specific Spectrum vs. All Spectrum: Is it beneficial to run the
    calibration model over a specific portion of the spectrum versus the
    entire spectrum? If so, which portion of the spectrum should we use?
    -\> We’ve determined that it is more beneficial to run the model on
    a specific portion of the spectrum (3750 - 368 cm^-1)

2.  Recommended number of samples: Can we pinpoint the recommended
    number of samples required to run the calibration model?

3.  Universal Preprocessing: Can all of the data be preprocessed in the
    same way, or do we need to provide our user with various options for
    preprocessing the data?

4.  Transferable Results: How transferable are these results from one
    lake site to another? Do we observe a difference between cold and
    warm climates? What about at different localities within a cold
    climate?

5.  Marine cores: How is this all transferable to the marine
    environment?

## IV. End Goal

The end goal is to create a Shiny App that would allow
paleoclimatologists and other users to upload their list of lake
sediment core files, run them through the calibration model and download
the predicted percentages of BSi.
