# Bikeshare Data Analytics Case Studies #

# This is a case study to pass the Google Data Analytics Certification Program offered by Google Career Certificates Team through Coursera. 
# The entire process is done according to the guidelines provided by google to do the entire work in 6 phases. 
# Ask, Prepare, Process, Analyze, Share & Act

# THIS CODE IS STILL A PROTOTYPE

# Original data source: https://divvy-tripdata.s3.amazonaws.com/index.html
# License agreement: https://ride.divvybikes.com/data-license-agreement

#===========#
## Process ##
#===========#

# install required packages
# tidyverse for data import and wrangling
# lubridate for date functions
# ggplot for visualization

library(tidyverse)  #helps wrangle data
library(lubridate)  #helps wrangle date attributes
library(ggplot2)  #helps visualize data
getwd() #displays your working directory
setwd #sets your working directory to simplify calls to data

# Collect and merge data into a single file
list_of_files <- list.files(
  path = "path\\dir",
  pattern = "csv",
  full.names = TRUE
)

head(list_of_files)
biketrips_2021 <- readr::read_csv(list_of_files)

# inspect data frame
head(biketrips_2021)
str(biketrips_2021)
colnames(biketrips_2021)
summary(biketrips_2021)

# There are a few problems we will need to fix:
# (1) The data can only be aggregated at the ride-level, which is too granular. We will want to add some additional columns of data -- such as day, month, year -- that provide additional opportunities to aggregate the data.
# (2) We will want to add a calculated field for length of ride. We will add "ride_length" to the entire dataframe.
# (3) There are some rides where trip duration shows up as negative, including several hundred rides where Divvy took bikes out of circulation for Quality Control reasons. We will want to delete these rides.

# create new table
bike_trips <- select(biketrips_2021, ride_id, rideable_type, member_casual, started_at, ended_at)
glimpse(bike_trips)

# Add columns that list the date, year, month, day of each ride
# This will allow us to aggregate ride data for each month, day, or year ... before completing these operations we could only aggregate at the ride level

bike_trips$date <- as.Date(bike_trips$started_at)

bike_trips$year <- format(as.Date(bike_trips$date), "%Y")
bike_trips$month <- format(as.Date(bike_trips$date), "%m")
bike_trips$day <- format(as.Date(bike_trips$date), "%d")
bike_trips$day_of_week <- format(as.Date(bike_trips$date), "%A")
glimpse(bike_trips)

# Add a "ride_length" calculation to all_trips (in seconds)
bike_trips$ride_length <- difftime(bike_trips$ended_at, bike_trips$started_at)
glimpse(bike_trips)

# Convert "ride_length" from difftime to numeric so we can run calculations on the data
is.difftime(bike_trips$ride_length)
bike_trips$ride_length <- as.numeric(as.character(bike_trips$ride_length))
is.numeric(bike_trips$ride_length)

# Remove bad data
# The dataframe includes a few hundred entries when ride_length value was 0 or negative secs.
# We will create a new version of the dataframe (v2) since data is being removed.
bike_trips_v2 <- filter(bike_trips, ride_length > 0)
glimpse(bike_trips_v2)

#===========#
## Analyze ##
#===========#

# Descriptive analysis on ride_length (in seconds)
mean(bike_trips_v2$ride_length) #average values (total ride length / rides)
median(bike_trips_v2$ride_length) #midpoint number in the ascending array of ride lengths
max(bike_trips_v2$ride_length) #longest ride
min(bike_trips_v2$ride_length) #shortest ride
summary(bike_trips_v2$ride_length)

# Compare members and casual users
aggregate(bike_trips_v2$ride_length ~ bike_trips_v2$member_casual, FUN = mean)
aggregate(bike_trips_v2$ride_length ~ bike_trips_v2$member_casual, FUN = median)
aggregate(bike_trips_v2$ride_length ~ bike_trips_v2$member_casual, FUN = max)
aggregate(bike_trips_v2$ride_length ~ bike_trips_v2$member_casual, FUN = min)

# ordered day_of_week
bike_trips_v2$day_of_week <- ordered(bike_trips_v2$day_of_week, levels=c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))

# the average ride time by each day for members vs casual users
aggregate(bike_trips_v2$ride_length ~ bike_trips_v2$member_casual + bike_trips_v2$day_of_week, FUN = mean)

# analyze ridership data by type and weekday
bike_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%  #creates weekday field using wday()
  group_by(member_casual, weekday) %>%  #groups by usertype and weekday
  summarise(number_of_rides = n()							#calculates the number of rides and average duration 
            ,average_duration = mean(ride_length)) %>% 		# calculates the average duration
  arrange(member_casual, weekday)								# sorts

#=========#
## Share ##
#=========#

# visualize the number of rides by rider type
bike_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")

# visualization for average duration
bike_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge")

# Create a csv file
counts <- aggregate(bike_trips_v2$ride_length ~ bike_trips_v2$member_casual + bike_trips_v2$day_of_week, FUN = mean)
write.csv(bike_trips_v2, file = 'path\\file_names.csv')
