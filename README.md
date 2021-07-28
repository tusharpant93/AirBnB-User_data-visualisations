# AirBnB-User_data-visualisations
The purpose of this project is to perform data analysis and visualization for the AirBnB user pathways data set. User pathways are the routes by which people navigate a website. The Airbnb data set contains data on user pathways for user sessions in the past year in a US city.
We noticed that the dataset have included the platform and devices users used while browsing the site. So we are curious about the most used device and platforms among all users.

Also, the statistical question we really want to dig into is the relationship between the user interactions and booking actions. Our hypothesis on this topic is here:

  1. The more the user search, the likely the user is going to send message.
  2. The more the user send message/search, the likely the user is going to book.

We are going to run regression model to examine our hypothesis.

We used R to perform data analysis and visualization to explore and identify trends in user pathways, and uncover insights to understand how people are using the Airbnb site through the following steps:
  
Load Required Packages
Clean Up and Prepare Data for Analysis
Exploratory Data Analysis
Data Visualization
Summary of Findings
There appears to be a somewhat positive correlation between those variables:

1. the number of messages sent and the number of bookings placed.
2. the number of searches made and the number of messages sent
3. the number of searches made and the number of bookings placed.

However, the only relevant strong correlation as a linear model is the one between the number of searches made and the number of bookings placed. The coefficient is about 0.15. We can make an inference that we are 95% confident that on average 6 to 7 searches made will probably result in 1 booking placed.

We initially guess that the messages sent may have a greater impact on the booking placed as we believe sending messages means the user is interested in booking. However, the result proves our guess is not that right. This may caused by the increasing number of travel agents on Airbnb who frequently browse, search and asking for prices but seldom make bookings. This also explains that there are individuals in the dataset who visits the Airbnb sites for hundreds of times and send hundreds of messages. After all, most of us are not browsing Airbnb all day and night for whatever reason.
6. Summary
Based on the work above, it appears that most users access the site with their iPhones, Android Phones, or desktop computer. 

It appears that most users use the default application browser for their phone to access the site (i.e. iPhone users typically use the iOS application and Android users typically use the Android application). 

The most popular web browser for desktops is Chrome.In addition, looking at the number of visits and actions of each unique users, the majority of users only visit the site once or twice. 

For frequent users, there appears to be a somewhat positive correlation between the number of searches made, the number of messages sent, and the number of bookings made. However, only the number of searches made and the number of bookings placed have a strong linear correlation. 

As such, a potential strategy that AirBnB can use to increase the number of bookings, is to encourage people to try out the site and make some searches. 

If they pushed more ads to iPhone, Android, and Chrome users to try their website and make some searches for potential places to stay in future vacations, then that may increase the number of messages sent, and more importantly, the number of bookings made.
