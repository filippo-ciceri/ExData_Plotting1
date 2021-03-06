#download raw data
if (!file.exists("household_power_consumption.txt")) { 
    fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    filename <- "temp.zip"
    download.file(fileURL, filename)
    unzip(filename)
    file.remove(filename)
}

#first read data from the table
from_num = grep("^1/2/2007", readLines("household_power_consumption.txt"))[[1]]
to_num = max(grep("^2/2/2007", readLines("household_power_consumption.txt")))
data <- read.table('household_power_consumption.txt',
                   na.strings = "?",
                   header = TRUE,
                   sep=";",
                   skip = from_num,
                   nrows = to_num - from_num -1,
                   col.names = c('Date',
                                 'Time',
                                 'Global_active_power',
                                 'Global_reactive_power',
                                 'Voltage',
                                 'Global_intensity',
                                 'Sub_metering_1',
                                 'Sub_metering_2',
                                 'Sub_metering_3'))

#parse dates and times
data$Time <- strptime(paste(data$Date,data$Time,sep=" "), format="%d/%m/%Y %H:%M:%S")
data$Date <- as.Date(data$Date, "%d/%m/%Y")

#create the graph
dev.new()
par(bg = 'white')
hist(data$Global_active_power,
     col='red', 
     ylab='Frequency', 
     xlab='Global Active Power (kilowatts)',
     main="Global Active Power")
dev.copy(png, "plot1.png", width = 480, height = 480)
dev.off()