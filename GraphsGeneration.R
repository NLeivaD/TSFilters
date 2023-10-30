################################################################################
### TIME SERIES FILTERS - NICOLAS LEIVA DIAZ'S GITHUB REPOSITORY             ###
### GRAPHS GENERATION - OCTOBER 2023                                         ###
### NICOLAS LEIVA DIAZ - NS.LEIVA.D@GMAIL.COM                                ###
################################################################################

# This script replicates the graphs used in the README file of my GitHub 
# Repository "Time Series Filters".

# Setup
rm(list = ls())
setwd("C:/Users/Usuario/Desktop/Prim_2023/Ayudantias/MC2/Ayudantias/TSFilters")

# Packages load
library(readxl)
library(forecast)
library(ggplot2)

# Data import
GDP <- read_xlsx("Data/RealGDP.xlsx", range = "A4:B112",
                 col_names = c("Date", "GDP"))

# Time Series Objects
gdp <- ts(GDP$GDP, frequency = 4, start = c(1996, 1))

# Graphs
## Real GDP Full
autoplot(gdp) + theme_minimal() + 
  labs(title = "Chilean Real Gross Domestic Product",
       x = "Year", y = "Billions of CLP", 
       caption = "Source: Own elaboration based on data from the Central Bank of Chile") +
  scale_y_continuous(expand = c(0,0), limits = c(19500, 55000),
                     breaks = seq(20000, 55000, 5000)) +
  scale_x_continuous(expand = c(0,1), limits = c(1996, 2023),
                     breaks = seq(1996, 2023, 3))
ggsave(filename = "Graphs/GDPFull.png", width = 8, height = 5, units = "cm")
## Real GDP 2010 - 2014
autoplot(window(gdp, start = c(2010,1), end = c(2014,4))) + theme_minimal() + 
  labs(title = "Chilean Real Gross Domestic Product",
       x = "Year", y = "Billions of CLP", 
       caption = "Source: Own elaboration based on data from the Central Bank of Chile") +
  scale_y_continuous(expand = c(0,0), limits = c(34000, 46000),
                     breaks = seq(34000, 46000, 2000)) +
  scale_x_continuous(expand = c(0,0.2), limits = c(2010, 2014),
                     breaks = seq(2010, 2014, 1))
ggsave(filename = "Graphs/GDP20102024.png", width = 8, height = 5, units = "cm")