# Plot 3

file <- "household_power_consumption.txt"

inputData <- read.table(file, header=TRUE, sep=";", 
                   col.names=c("Date", "Time", 
                               "Global Active Power", "Global Reactive Power", 
                               "Voltage", "Global Intensity", 
                               "Sub_Metering_1", "Sub_Metering_2", "Sub_Metering_3"), 
                   na.strings = "?",
                   stringsAsFactors = FALSE)

endDate <- as.Date("02/02/2007", "%d/%m/%Y")
startDate <- as.Date("01/02/2007", "%d/%m/%Y")

data <- inputData[as.Date(inputData$Date,"%d/%m/%Y") >= startDate & 
                   as.Date(inputData$Date,"%d/%m/%Y") <= endDate,]

thursday <- data[weekdays(as.Date(data$Date,"%d/%m/%Y")) == "Thursday",]
friday <- data[weekdays(as.Date(data$Date,"%d/%m/%Y")) == "Friday",]

thursday$Time <- as.numeric(as.POSIXlt(thursday$Time, format="%H:%M:%S"))
friday$Time <- as.numeric(as.POSIXlt(friday$Time, format="%H:%M:%S"))+
    (thursday$Time[1440]-as.numeric(as.POSIXlt(friday$Time[1], format="%H:%M:%S"))+1)
twoDays <- rbind(thursday, friday)

png(file="plot3.png", width=480, height=480)

with(twoDays, plot(twoDays$Time, Sub_Metering_1, xaxt="n", xlab="", ylab="Energy sub metering", type = "l"))
lines(twoDays$Time, twoDays$Sub_Metering_2, type="l", col="red")
lines(twoDays$Time, twoDays$Sub_Metering_3, type="l", col="blue")
axis(1, at = c(twoDays$Time[1],twoDays$Time[1440],twoDays$Time[2880]), 
     labels = c("Thu", "Fri", "Sat"))
legend("topright", lty = 1, col = c("black", "blue", "red"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.off()