#This script will convert the default FRAP data into the wide format, for ease of analysis.
  #Update: 2/7/2018_ now compatible with up to 4 channels
  #NOTE: Most common cause of error is not having the most recent version of Java on your computer!

#remove any old data from R workbook
rm(list=ls())

#first check for required packages. Install if not present
pkgTest <- function(x)
{
  if (!require(x,character.only = TRUE))
  {
    install.packages(x,dep=TRUE)
    if(!require(x,character.only = TRUE)) stop("Package not found")
  }
}
pkgTest("rJava")
pkgTest("xlsxjars")
pkgTest("xlsx")
pkgTest("reshape2")
pkgTest("dplyr")
pkgTest("tcltk")
#load required libraries
library(rJava)
library(xlsxjars)
library(xlsx)
library(reshape2)
library(dplyr)
library(tcltk)

#select FRAP csv file
rawdata <- choose.files(caption = "Select raw data csv file")

#load csv data file into R
 df <- read.csv(file = rawdata, header = TRUE, stringsAsFactors = FALSE, 
               colClasses = c("ROI ID"="character", "Frame Id"="character", "Time"="numeric")) 

#subset dataframe to only necessary columns. **Adjust as necessary**
df <- df %>% select(matches('Total.Int|Time|ROI|Frame')) 

#convert df into wide format for each channel.  
#You may receive an error if you have less than 4 channels. Ignore this error.
 
CH1 <- dcast(df, Time + Frame.Id ~ ROI.ID, value.var = "Total.Int..CH1")
CH2 <- dcast(df, Time + Frame.Id ~ ROI.ID, value.var = "Total.Int..CH2")
CH3 <- dcast(df, Time + Frame.Id ~ ROI.ID, value.var = "Total.Int..CH3")
CH4 <- dcast(df, Time + Frame.Id ~ ROI.ID, value.var = "Total.Int..CH4")

#save excel file with each channel as a separate sheet

  #first select your save directory
savedirect <- tk_choose.dir(default="", caption="Select Directory to save FRAP data")

#file name
#today <- Sys.Date()
today <- format(Sys.time(), "%Y.%m.%d-t%H%M")
xlsxfilename <- paste(savedirect,"/FRAPanalysis_",today,".xlsx", sep="")

#writing file
write.xlsx2(CH1, file = xlsxfilename, sheetName = "CH1", row.names=TRUE, append = FALSE)
write.xlsx2(CH2, file = xlsxfilename, sheetName = "CH2", row.names=TRUE, append = TRUE)
write.xlsx2(CH3, file = xlsxfilename, sheetName = "CH3", row.names=TRUE, append = TRUE)
write.xlsx2(CH4, file = xlsxfilename, sheetName = "CH4", row.names=TRUE, append = TRUE)

