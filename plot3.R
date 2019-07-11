#####################################################
# Obtain name of the file (.zip archive with dataset)
#####################################################

urlLinkToDataSet <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

library(dplyr)

fileName <- URLdecode(urlLinkToDataSet) %>% basename()




###################
# Download the file
###################

if (!file.exists(fileName)) {
  download.file(urlLinkToDataSet, fileName, method = "curl")
  print ("File was downloaded successfully")
} else {
  cat("The file [", fileName, "] already exists!")
}




################
# Unzip the file
################

library(tools)
dirName <- file_path_sans_ext(fileName)

if (!file.exists(dirName)) { 
  dir.create(dirName)
  unzip(fileName, exdir = dirName)
  print ("File was unzipped successfully")
}




#############################
# Read files into data frames
#############################

filePath <- list.files(dirName, full.names = T)


# Since we need data from 2007-02-01 and 2007-02-02 only, let's extracted the required rows (2880 out of 2,075,258 rows)
extractedRows <- grep("^[1,2]/2/2007", readLines(filePath), value = TRUE)

# grep function above didn't read the header, we need to take it from the file
header <- read.table(filePath, nrows = 1, header = FALSE, sep = ';')

powerConsumptionData <- read.table(text = extractedRows, header = FALSE, 
                                   sep = ";", na.strings = "?", col.names = unlist(header))

powerConsumptionData$DateTime <- strptime(paste(powerConsumptionData$Date, powerConsumptionData$Time), 
                                          format = "%d/%m/%Y %H:%M:%S")



####################
# Painting plot3.png
####################

png(filename = "plot3.png", width = 480, height = 480)

plot(powerConsumptionData$DateTime, as.numeric(powerConsumptionData$Sub_metering_1), 
     xlab = "", ylab = "Energy sub metering", type = "l", col = "black")

lines(powerConsumptionData$DateTime, as.numeric(powerConsumptionData$Sub_metering_2), type = "l", col = "red")
lines(powerConsumptionData$DateTime, as.numeric(powerConsumptionData$Sub_metering_3), type = "l", col = "blue")

legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), lty = 1, lwd = 2)

dev.off()




