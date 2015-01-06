# Plot 1

file <- "household_power_consumption.txt"

inputData <- read.table(file, header=TRUE, sep=";", 
                   col.names=c("Date", "Time", "Global Active Power", "Global Reactive Power", 
                               "Voltage", "Global Intensity", "Sub Metering 1", "Sub Metering 2", "Sub Metering 3"), 
                   na.strings = "?",
                   stringsAsFactors = FALSE)

endDate <- as.Date("02/02/2007", "%d/%m/%Y")
startDate <- as.Date("01/02/2007", "%d/%m/%Y")

data <- inputData[as.Date(inputData$Date,"%d/%m/%Y") >= startDate & 
                   as.Date(inputData$Date,"%d/%m/%Y") <= endDate,]

png(file="plot1.png", width=480, height=480)

hist(as.numeric(data$Global.Active.Power), 
     breaks = 24, 
     col = "red", 
     main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)")

dev.off()