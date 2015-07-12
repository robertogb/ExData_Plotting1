# This script constructs the plot number 2 
# Steps:
# - get the data from https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
# - extract data for the period between 2007-02-01 and 2007-02-02
# - construct the plot2.png plot.
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
png(filename = "plot2.png", height = 480, width = 480)

## construct the plot
plot(period$Global_active_power,
     type = "l",
     xlab = "",
     ylab = "Global Active Power (kilowatts)",
     xaxt = "n"
)

# Draw the date axis
axis.Date(side = 1,
          at = seq.Date(from = as.Date("2007-02-01"), 
                        to = as.Date("2007-02-03"),
                        by = "day"),
          format="%a")
# workaround for the above code
prevLocale <- Sys.getlocale("LC_TIME") 
Sys.setlocale("LC_TIME", "English")
dateLabels <- c(format(as.Date("2007-02-01"),"%a"),
                format(as.Date("2007-02-02"),"%a"),
                format(as.Date("2007-02-03"),"%a"))
axis(1, c(0, nrow(period)/2, nrow(period)), labels = dateLabels) 
Sys.setlocale("LC_TIME", prevLocale)

# close the PNG file
dev.off()
