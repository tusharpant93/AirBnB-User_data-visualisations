   #Introduction

The purpose of this project is to perform data analysis and visualization for the AirBnB user pathways data set. User pathways are the routes by which people navigate a website. The AirBnB data set contains data on user pathways for user sessions in the past year in a US city.

We used R to perform data analysis and visualization to explore and identify trends in user pathways, and uncover insights to understand how people are using the AirBnB site through the following steps:
  
##Load Required Packages
##Clean Up and Prepare Data for Analysis
##Exploratory Data Analysis
##Data Visualization
##Summary of Findings

   #Packages Required
  
library(tibble) # used to create tibbles
library(tidyr) # used to tidy up data
library(prettydoc) # document themes for R Markdown
library(DT) # used for displaying R data objects (matrices or data frames) as tables on HTML pages
library(lubridate) # used for date/time functions
library(magrittr) # used for piping
library(ggplot2) # used for data visualization
library(dplyr) # used for data manipulation

    #Data Preparation - Source Data and Code Book

##The source data can be found at databits.io in the form of a txt file.

##The code book can be found at databits.io in the form of a rdf file.

***The following is the code used to evaluate the variables in the source data. 
We noted that there is a total of 7,756 observations in the data set, and 21 variables, which are listed below.***

  # Read data via the source data url provided above
  AirBnB <- read.delim(url
                       ("http://databits.io/static_content/challenges/airbnb-user-pathways-challenge/airbnb_session_data.txt"), 
                       sep = "|", na.strings = 'NULL')

# Store data as tibble
AirB_tib <- as_tibble(AirBnB)

# Find total number of observations  
nrow(AirB_tib)

# Get variable names
names(AirB_tib)

# Get summary information on the AirBnB data set variables
summary(AirB_tib)

To clean the data, we first inspected the source data and noted that there are missing values for some observations for the “next session” fields (i.e. next session id, next session date), which indicates that the unique visitor did not open another session after his or her first session. However, these null values are not just missing data, but actually tells us something - that the user did not visit the site again. Therefore, we will choose to keep the null values in our data set.

In addition, we noted that the “ts_min” and “ts_max” date/time fields indicate the date/time when the session started and the date/time when the session ended. For this information, we would like to calculate the actual duration of the entire session.

Finally, we noted that the “dim_device_app_combo” fields indicate the device/application combination from the user agent of the session. We would like to separate the column into individual device and application columns, so that we may perform analysis on the user pathways by application and device.

# Read source data
AirBnB <- read.delim(url
                     ("http://databits.io/static_content/challenges/airbnb-user-pathways-challenge/airbnb_session_data.txt"), 
                     sep = "|", na.strings = 'NULL')

# Store data as tibble
AirB_tib <- as_tibble(AirBnB)

# Separate into Device and Application columns for the "dim_device_app_combo" fields

AirB_tibClean <- AirB_tib %>% 
  separate(dim_device_app_combo, 
           into = c("Device", "Application"), sep = " - ") %>%
  separate(next_dim_device_app_combo,
           into = c("Next_Device", "Next_Application"), 
           sep = " - ") 

# Convert the start and end times from string to date/time format

AirB_tibClean$Start_Time <- ymd_hms(AirB_tibClean$ts_min)
AirB_tibClean$End_Time <- ymd_hms(AirB_tibClean$ts_max)

AirB_tibClean$Next_Start_Time <- ymd_hms(AirB_tibClean$next_ts_min)
AirB_tibClean$Next_End_Time <- ymd_hms(AirB_tibClean$next_ts_max)

# When we substract the difference of the times, the result is in seconds,
# so we divide by 60 to get the duration in minutes

AirB_tibClean$Duration <- 
  (AirB_tibClean$End_Time - AirB_tibClean$Start_Time) / 60

AirB_tibClean$Next_Duration <- 
  (AirB_tibClean$Next_End_Time - AirB_tibClean$Next_Start_Time) / 60

# Read first 8 rows of the cleaned data set

datatable(head(AirB_tibClean, 8),options = list(scrollX=TRUE, pageLength=4))
# Get summary statistics for each variable
summary(AirB_tibClean)

# Display structure of cleaned data set 
str(AirB_tibClean)

# Average duration of each session

mean(AirB_tibClean$Duration)

##We noted that there are 630 unique visitors in the data set, and 7756 unique sessions in the data set, which means on average each user had over 12 sessions (7756 sessions / 630 unique visitors = 12.31 sessions / visitor).

#Exploratory Data Analysis and Visualization

##First I wanted to see how many sessions used a certain device to access the website (i.e. iPhone, Android Phone, Desktop). This way, we can focus our analysis on the most popular devices. The most used devices appear to be iPhones, Desktops, and Android Phones.

##I also wanted to see how many sessions used a # Show number of sessions by application, sorted from most used to least used
AirB_App <- AirB_tibClean %>% group_by(Application) %>% count(Application, sort = TRUE)

# Show all the devices used to access the website
datatable(AirB_App)certain application to access the website, to determine which are the most used applications. The most used applications appear to be iOS, Web, and Chrome.

# Show number of sessions by application, sorted from most used to least used
AirB_App <- AirB_tibClean %>% group_by(Application) %>% count(Application, sort = TRUE)

# Show all the devices used to access the website
datatable(AirB_App)

# Create a function to display a barchart of the number of sessions by application, based on the chosen device

DeviceChart <- function(selectdevice) {
  AirBDevice <- AirB_tibClean %>% filter(Device == selectdevice) %>% 
    group_by(Application) %>% count(Application, sort = TRUE)
  
  ggplot(AirBDevice, 
         aes(x = Application, y = n, fill = Application)) +
    geom_bar(stat="identity") + 
    labs(title = "Total Sessions by Application", 
         x = "Application", y = "Number of Sessions") +
    theme(legend.position="none", panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(), 
          axis.line = element_line(colour = "black"))
}

# Display barchart of Total Sessions by application for the top three most used devices
DeviceChart('iPhone')

DeviceChart('Android Phone')

DeviceChart('Desktop')

AirB_Visit <- AirB_tibClean %>% 
  group_by(id_visitor) %>%
  count(id_visitor, sort = TRUE)

ggplot(AirB_Visit, aes(n)) + 
  geom_density(kernel = "gaussian", color = "red") + 
  labs(title = "Frequency Distribution of Visits per User", 
       x = "Number of Visits", y = "Frequency") + 
  theme(legend.position="none", 
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.line = element_blank())
# Create table showing the total number of searches, messages, and bookings made by each unique frequent visitor, where a frequent visitor is someone who visited the site at least 10 times

ActionByVisitor <- AirB_tibClean %>% group_by(id_visitor) %>% filter(n() >= 10) %>% summarize(Search = sum(did_search), Message = sum(sent_message), Booking = sum(sent_booking_request))

# See if there are any patterns between number of searches made and number of messages sent

ggplot(ActionByVisitor, aes(Search, Message)) + 
  geom_jitter(color = 'purple') +
  labs(title = "Actions Made by Frequent Users") + 
  theme(legend.position="none", 
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.line = element_blank())
# See if there are any patterns between number of searches made and number of bookings placed

ggplot(ActionByVisitor, aes(Search, Booking)) + 
  geom_jitter(color = 'blue') +
  labs(title = "Actions Made by Frequent Users") + 
  theme(legend.position="none", 
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.line = element_blank())
# See if there are any patterns between number of messages made and number of bookings placed

ggplot(ActionByVisitor, aes(Message, Booking)) + 
  geom_jitter(color = 'green') +
  labs(title = "Actions Made by Frequent Users") + 
  theme(legend.position="none", 
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.line = element_blank())
##There appears to be a somewhat positive correlation between the number of messages sent and the number of bookings placed, although the correlation is not a very strong linear relationship.

#Summary
Based on the work above, it appears that most users access the site with their iPhones, Android Phones, or desktop computer. 
It appears that most users use the default application browser for their phone to access the site (i.e. iPhone users typically use the iOS application and Android users typically use the Android application). 
The most popular web browser for desktops is Chrome.In addition, looking at the number of visits and actions of each unique users, the majority of users only visit the site once or twice. 
However, for frequent users, there appears to be a somewhat positive correlation between the number of searches made, the number of messages sent, and the number of bookings made. 
As such, a potential strategy that AirBnB can use to increase the number of bookings, is to encourage people to try out the site and make some searches. 
If they pushed more ads to iPhone, Android, and Chrome users to try their website and make some searches for potential places to stay in future vacations, then that may increase the number of messages sent, and more importantly, the number of bookings made.