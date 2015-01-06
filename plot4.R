# Plot 4

file <- "household_power_consumption.txt"

inputData <- read.table(file, header=TRUE, sep=";", 
                   col.names=c("Date", "Time", 
                               "Global Active Power", "Global_reactive_power", 
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

plot3 <- function(x) {
    with(x, plot(x$Time, Sub_Metering_1, xaxt="n", xlab="", ylab="Energy sub metering", type = "l"))
    lines(x$Time, x$Sub_Metering_2, type="l", col="red")
    lines(x$Time, x$Sub_Metering_3, type="l", col="blue")
    drawAxis(x)
    legend("topright", lty=1, bty="n", col = c("black", "blue", "red"), 
           legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
}

plot1 <- function(x) {
    plot(x$Time, x$Global.Active.Power, type="l", xaxt="n", xlab="", ylab="Global Active Power")
    drawAxis(x)
}

plot2 <- function(x) {
    with(x, plot(x$Time, x$Voltage, xaxt="n", xlab="datetime", ylab="Voltage", type = "l"))
    drawAxis(x)
}

plot4 <- function(x) {
    with(x, plot(x$Time, x$Global_reactive_power, xaxt="n", xlab="datetime", ylab="Global_reactive_power", type = "l"))
    drawAxis(x)
}

drawAxis <- function(x) {
    axis(1, at = c(x$Time[1],x$Time[1440],x$Time[2880]), 
         labels = c("Thu", "Fri", "Sat"))
}

png(file="plot4.png", width=480, height=480)

par(mfrow = c(2, 2), mar = c(4, 2, 2, 2), oma = c(0, 0, 0, 0)) 
with(twoDays, {
    plot1(twoDays)
    plot2(twoDays)
    plot3(twoDays) 
    plot4(twoDays) 
})

dev.off()