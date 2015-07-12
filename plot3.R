# This script constructs the plot number 3
# Steps:
# - get the data from https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
# - extract data for the period between 2007-02-01 and 2007-02-02
# - construct the plot3.png plot.
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
png(filename = "plot3.png", height = 480, width = 480)

## construct the plot area
plot(period$Sub_metering_1,
     type = "n",
     xlab = "",
     ylab = "Energy sub metering",
     xaxt = "n"
)

# Draw the date axis
# axis.Date(side = 1,
#           at = seq.Date(from = as.Date("2007/2/1"), 
#                         to = as.Date("2007/2/3"),
#                         by = "day"),
#           format="%a")
# workaround for the above code
prevLocale <- Sys.getlocale("LC_TIME") 
Sys.setlocale("LC_TIME", "English")
dateLabels <- c(format(as.Date("2007-02-01"),"%a"),
                format(as.Date("2007-02-02"),"%a"),
                format(as.Date("2007-02-03"),"%a"))
axis(1, c(0, nrow(period)/2, nrow(period)), labels = dateLabels)
Sys.setlocale("LC_TIME", prevLocale)

colors <- c("black", "red", "blue")
# Plot the data
lines(period$Sub_metering_1, col = colors[1])
lines(period$Sub_metering_2, col = colors[2])
lines(period$Sub_metering_3, col = colors[3])

# Plot the legend
legend("topright",
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = colors,
       lty = c(1,1,1))

# close the PNG file
dev.off()
