### Plot1.R
# This procedure reads in the 'household_power_consumption.txt' file
# and outputs a histogram to a .png file


## Part 1 -- Read in the data
# Load the 'household_power_consumption.txt' file
# File is semi-colon delimited

# In order to maximize speed, column types will be determined ahead of time and 
# specified at the time of import

# First reading of top of the file to determine column types
mydata <- read.csv('household_power_consumption.txt', sep=";", header=TRUE, nrows=5)
# Ran into a problem with importing headers after using skip, so read and save now
datanames <- names(data)

# In order to minimize memory usage, desired rows will be determined ahead of time and 
# only those rows will be imported into the data.frame
# Note that the rows in the source file are in chronological order so no further row
# filtering/deleting is required.

# Read the date column in as date format and determine which rows are in the date range
setClass('myDate')
setAs("character","myDate", function(from) as.Date(from, format="%d/%m/%Y") )
daterows <- read.csv('household_power_consumption.txt', sep=";", header=TRUE, 
                     colClasses="myDate")[,1]
# Create a logical vector of rows in (TRUE) and out (FALSE) of the date range
indates <- (daterows>=as.Date("2007-02-01") & daterows<=as.Date("2007-02-02"))
# This line counts the number of TRUEs, which are the lines in the date range
sum(indates)
# These lines determine the first and last rows which are TRUE; these will be imported
minrow <- min(which(indates == TRUE))
maxrow <- max(which(indates == TRUE))
rm(indates)

# Read data, with date and time columns as text
mydata <- read.csv('household_power_consumption.txt', sep=";", header=TRUE, 
                   skip=minrow-1, nrow=(maxrow-minrow+1), 
                   col.names = datanames, 
                   colClasses=c("character", "character", 
                                "numeric", "numeric", "numeric", "numeric", 
                                "numeric", "numeric", "numeric"))
# Combine the date and time columns and reformat as POSIX date
library("lubridate")
mydata$DateTime <- with(mydata, paste(Date, Time, sep=" "))
mydata$DateTime <- with(mydata, as.POSIXct(DateTime, format="%d/%m/%Y %H:%M:%S"))


## Part 2 -- create the plot
png("plot1.png", width = 480, height = 480, units = "px")
hist(mydata$Global_active_power, col="red", main="Global Active Power", 
     xlab="Global Active Power (kilowatts)", ylim=c(0,1200))
dev.off()




