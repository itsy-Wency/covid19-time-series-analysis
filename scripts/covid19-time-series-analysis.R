install.packages(c("tidyverse","readxl","lubridate"))
install.packages("lubridate")
# Load libraries
library(tidyverse)
library(readxl)
library(lubridate)

#1. DATA IMPORT AND EXPLORATION
# Load Excel files
confirmed <- read.csv("C:/Users/USER/Desktop/confirmed_global.csv", check.names = FALSE)
deaths    <- read.csv("C:/Users/USER/Desktop/deaths_global.csv", check.names = FALSE)
recovered <- read.csv("C:/Users/USER/Desktop/recovered.csv", check.names = FALSE)
#Preview
head(confirmed)

#Display Structure
str(confirmed)
#Summary
summary(confirmed)
#Missing Values
colSums(is.na(confirmed))

names(confirmed)[1:4] <- c("Province_State","Country_Region","Lat","Long")
names(deaths)[1:4] <- c("Province_State","Country_Region","Lat","Long")
names(recovered)[1:4] <- c("Province_State","Country_Region","Lat","Long")


#Reshape Data from Wide to Long
confirmed_long <- confirmed %>%
  pivot_longer(
    cols = -c(Province_State, Country_Region, Lat, Long),
    names_to = "Date",
    values_to = "Confirmed"
  )

deaths_long <- deaths %>%
  pivot_longer(
    cols = -c(Province_State, Country_Region, Lat, Long),
    names_to = "Date",
    values_to = "Deaths"
  )

recovered_long <- recovered %>%
  pivot_longer(
    cols = -c(Province_State, Country_Region, Lat, Long),
    names_to = "Date",
    values_to = "Recovered"
  )

#Convert Date
confirmed_long$Date <- mdy(confirmed_long$Date)
deaths_long$Date <- mdy(deaths_long$Date)
recovered_long$Date <- mdy(recovered_long$Date)

#Merge datasets
covid_data <- confirmed_long %>%
  left_join(deaths_long, by=c("Province_State","Country_Region","Lat","Long","Date")) %>%
  left_join(recovered_long, by=c("Province_State","Country_Region","Lat","Long","Date"))


#Global data
covid_global <- covid_data %>%
  group_by(Date) %>%
  summarise(
    Confirmed = sum(Confirmed, na.rm=TRUE),
    Deaths = sum(Deaths, na.rm=TRUE),
    Recovered = sum(Recovered, na.rm=TRUE)
  )

#2. DATA VISUALIZATION
#Time Series Plot
# Confirmed
ggplot(covid_global, aes(Date, Confirmed)) +
  geom_line(color="blue") +
  ggtitle("Global Confirmed Cases")

# Deaths
ggplot(covid_global, aes(Date, Deaths)) +
  geom_line(color="red") +
  ggtitle("Global Deaths")

# Recovered
ggplot(covid_global, aes(Date, Recovered)) +
  geom_line(color="green") +
  ggtitle("Global Recoveries")

#Top Countries Bar Plot
top_countries <- covid_data %>%
  group_by(Country_Region) %>%
  summarise(TotalCases = max(Confirmed, na.rm = TRUE)) %>%
  arrange(desc(TotalCases)) %>%
  slice(1:10)
ggplot(top_countries, aes(reorder(Country_Region, TotalCases), TotalCases)) +
  geom_bar(stat="identity", fill="orange") +
  coord_flip() +
  ggtitle("Top 10 Countries by Cases")

#Daily COVID-19 Trends
covid_global <- covid_global %>%
  arrange(Date) %>%
  mutate(
    NewCases = Confirmed - lag(Confirmed),
    NewDeaths = Deaths - lag(Deaths),
    NewRecovered = Recovered - lag(Recovered)
  )

ggplot(covid_global, aes(Date)) +
  geom_line(aes(y=NewCases, color="Cases")) +
  geom_line(aes(y=NewDeaths, color="Deaths")) +
  geom_line(aes(y=NewRecovered, color="Recovered")) +
  labs(
    title="Daily COVID-19 Trends",
    y="Count",
    color="Legend"
  )

#3. Time Series Analysis
#Growth Rates
covid_global <- covid_global %>%
  mutate(
    GrowthCases = (NewCases / lag(Confirmed)) * 100,
    GrowthDeaths = (NewDeaths / lag(Deaths)) * 100,
    GrowthRecovered = (NewRecovered / lag(Recovered)) * 100
  )
#clean null values
covid_global$GrowthCases[is.infinite(covid_global$GrowthCases)] <- 0
covid_global$GrowthDeaths[is.infinite(covid_global$GrowthDeaths)] <- 0
covid_global$GrowthRecovered[is.infinite(covid_global$GrowthRecovered)] <- 0
covid_global[is.na(covid_global)] <- 0
#Plot the Growth rates
ggplot(covid_global, aes(Date)) +
  geom_line(aes(y=GrowthCases, color="Cases")) +
  geom_line(aes(y=GrowthDeaths, color="Deaths")) +
  geom_line(aes(y=GrowthRecovered, color="Recovered")) +
  labs(
    title="COVID-19 Growth Rates (%)",
    y="Growth Rate (%)",
    color="Legend"
  )

#Calculate Daily Change per Country
covid_country <- covid_data %>%
  group_by(Country_Region, Date) %>%
  summarise(Confirmed = sum(Confirmed, na.rm=TRUE)) %>%
  arrange(Country_Region, Date) %>%
  mutate(
    DailyChange = Confirmed - lag(Confirmed)
  )
#Identify Countries with Highest Increases
top_increase <- covid_country %>%
  group_by(Country_Region) %>%
  summarise(MaxIncrease = max(DailyChange, na.rm=TRUE)) %>%
  arrange(desc(MaxIncrease)) %>%
  slice(1:10)

top_increase

#Identify countires with decreases
top_decrease <- covid_country %>%
  group_by(Country_Region) %>%
  summarise(MaxDecrease = min(DailyChange, na.rm=TRUE)) %>%
  arrange(MaxDecrease) %>%
  slice(1:10)

top_decrease

#Visualize
ggplot(top_increase, aes(reorder(Country_Region, MaxIncrease), MaxIncrease)) +
  geom_bar(stat="identity", fill="red") +
  coord_flip() +
  ggtitle("Top Countries with Highest Daily Increase")

#Correlation Analysis
cor_data <- covid_global %>%
  select(Confirmed, Deaths, Recovered)

cor(cor_data, use="complete.obs")

#Sample analysis for Philippines
ph_data <- covid_data %>%
  filter(Country_Region == "Philippines") %>%
  group_by(Date) %>%
  summarise(Confirmed = sum(Confirmed))

ggplot(ph_data, aes(Date, Confirmed)) +
  geom_line(color="blue") +
  ggtitle("COVID-19 Cases in Philippines")
