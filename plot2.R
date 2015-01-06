# Plot 2

file <- "household_power_consumption.txt"

inputData <- read.table(file, header=TRUE, sep=";", 
                   col.names=c("Date", "Time", 
                               "Global Active Power", "Global Reactive Power", 
                               "Voltage", "Global Intensity", 
                               "Sub Metering 1", "Sub Metering 2", "Sub Metering 3"), 
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

png(file="plot2.png", width=480, height=480)

plot(twoDays$Time, twoDays$Global.Active.Power, type="l", xaxt="n", xlab="", ylab="Global Active Power (kilowatts)")
axis(1, at = c(twoDays$Time[1],twoDays$Time[1440],twoDays$Time[2880]), 
     labels = c("Thu", "Fri", "Sat"))

dev.off()