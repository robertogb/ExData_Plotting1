# This script constructs the plot number 4
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
png(filename = "plot4.png", height = 480, width = 480)

par(mfcol=c(2,2))
Sys.setlocale("LC_TIME", "English")
dateLabels <- c(format(as.Date("2007-02-01"),"%a"),
                format(as.Date("2007-02-02"),"%a"),
                format(as.Date("2007-02-03"),"%a"))
colors <- c("black", "red", "blue")

with(period, {
    # top left
    plot(Global_active_power,
         type = "l", xlab = "", ylab = "Global Active Power", xaxt = "n")
    axis(1, c(0, nrow(period)/2, nrow(period)), labels = dateLabels)
    
    # bottom left
    # construct the plot area
    plot(Sub_metering_1,
         type = "n", xlab = "", ylab = "Energy sub metering", xaxt = "n")
    axis(1, c(0, nrow(period)/2, nrow(period)), labels = dateLabels)
    # Plot the data
    lines(Sub_metering_1, col = colors[1])
    lines(Sub_metering_2, col = colors[2])
    lines(Sub_metering_3, col = colors[3])
    # Plot the legend
    legend("topright", bty="n",
           legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
           col = colors,
           lty = c(1,1,1))

        # top right
    plot(Voltage,
         type = "l", xlab = "datetime", xaxt = "n")
    axis(1, c(0, nrow(period)/2, nrow(period)), labels = dateLabels)
    
    # bottom right
    plot(Global_reactive_power,
         type = "l", xlab = "datetime", xaxt = "n")
    axis(1, c(0, nrow(period)/2, nrow(period)), labels = dateLabels)
}
)

Sys.setlocale("LC_TIME", "Spanish")

# close the PNG file
dev.off()
