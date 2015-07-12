# This script constructs the plot number 1 
# Steps:
# - get the data from https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
# - extract data for the period between 2007-02-01 and 2007-02-02
# - construct the plot1.png plot.
# - create the PNG file with a width of 480 pixels and a height of 480 pixels.

dataUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipFile <- "household_power_consumption.zip"
if (!file.exists(zipFile)) {
    download.file(url = dataUrl,
                  destfile = zipFile,
                  method = "libcurl",
                  quiet = TRUE)
}
zipFileInfo <- unzip(zipFile, list=TRUE)

data <- read.csv(unz(zipFile, as.character(zipFileInfo$Name)),
                 sep = ";",
                 na.strings = "?",
                 stringsAsFactors = FALSE)

period <- data[(data$Date=="1/2/2007" | data$Date=="2/2/2007"),]

period$Time <- strptime(paste(period$Date,period$Time), "%d/%m/%Y %H:%M:%S")
period$Date <- as.Date(period$Date, "%d/%m/%Y")

# create the PNG file with a width of 480 pixels and a height of 480 pixels.
png(filename = "plot1.png", height = 480, width = 480)

## construct the plot
hist(period$Global_active_power,
     col = "red",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")

# close the PNG file
dev.off()
