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
#load required libraries
library(rJava)
library(xlsxjars)
library(xlsx)
library(reshape2)
#clear screen. make things pretty.
#cat("\014")
#select file: Rn data (.xlsx / excel file)
myRnFile <- file.choose()
#load file as table into R 
	# Sheet Index  = Sheet Number. Usually =1
	# xlsx sheet may take a few momenets to load
	# NOTE: startRow should be the first row where the header "Well" appears. 8 is default.
rn_data <- read.xlsx2(myRnFile, sheetIndex = 2, header = FALSE, startRow = 8, colClasses = c("character", "numeric", "character", "numeric")) 
#set column names
colnames(rn_data) = c("Well", "Cycle", "Target.Name", "Rn")
#remove first line
rn_data <- rn_data[-1,]
#convert blank cells to NA
rn_data[rn_data==""] <- NA
#omit NA cells
rn_data <- na.omit(rn_data)
#renumber rows
row.names(rn_data) <- 1:nrow(rn_data)
#convert dataframe into LinReg Format
rn_linReg <- dcast(rn_data, Well + Target.Name ~ Cycle)
#save as excel file, ready for linreg
write.xlsx2(rn_linReg, file = choose.files(caption="Save As...", filters = c("Excel Workbook (.xlsx)", "*.xlsx")))
#Your File is now ready to import into LinRegPCR. 
#Remember: Your file needs to already be open in excel for LinRegPCR to process it
