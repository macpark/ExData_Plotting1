
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

plot1 <- function() {
    tbl <- prepare4Data()
    png(filename = "plot1.png", width = 480, height = 480, units = "px")
    hist(tbl$Global_active_power, main="Global Active Power", xlab="Global Active Power (kilowatts)", col="red")
    dev.off()
}

plot1()