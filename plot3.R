
prepare4Data <- function() {
    cacheFile <- "plotData.csv"
    
    if(file.exists(cacheFile)) {
        rtbl <- read.csv(cacheFile)
        rtbl$DateTime <- strptime(rtbl$DateTime, "%Y-%m-%d %H:%M:%S")
    }
    else {
        filename <- "exdata-data-household_power_consumption.zip"
        fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        
        if(!file.exists(filename)) {
            download.file(fileURL, destfile=filename, method="curl")
        }
        
        con <- unz(filename, "household_power_consumption.txt")
        rtbl <- read.table(con, header=TRUE, sep=';', na.strings="?", colClasses=c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"))
        #close(con)
        rtbl <- rtbl[(rtbl$Date == "1/2/2007") | (rtbl$Date == "2/2/2007"),]
        rtbl$DateTime <- strptime(paste(rtbl$Date, rtbl$Time), "%d/%m/%Y %H:%M:%S")
        write.csv(rtbl, cacheFile)
    }
    rtbl
}

plot3 <- function() {
    tbl <- prepare4Data()
    png(filename = "plot3.png", width = 480, height = 480, units = "px")
    cols = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
    plot(tbl$DateTime, tbl$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
    lines(tbl$DateTime, tbl$Sub_metering_2, type="l", col="red")
    lines(tbl$DateTime, tbl$Sub_metering_3, type="l", col="blue")
    legend("topright", lty=1, lwd=1, col=c("black","blue","red"), legend=cols)
    dev.off()
}

plot3()