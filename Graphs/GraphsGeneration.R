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
library(mFilter)
library(x12)

# Data import
GDP <- read_xlsx("Data/RealGDP.xlsx", range = "A4:C112",
                 col_names = c("Date", "GDP", "GDP_SA"))
CPI <- read_xlsx("Data/NonVolatileCPI.xlsx", range = "A4:B168",
                 col_names = c("Date", "CPI"))

# Time Series Objects
gdp <- ts(GDP$GDP, frequency = 4, start = c(1996, 1))
log_gdp <- log(gdp)
inflation <- ts(CPI$CPI, frequency = 12, start = c(2010,1))

# X12 Filter
log_gdp_x12 <- x12work(log_gdp, transform.function = "none", keep_x12out = F,
                       x12path = "C:/Program Files (x86)/x12arima/x12a.exe")
log_gdpsa <- log_gdp_x12$d11
gdp_sa <- exp(log_gdpsa)

# Cycle
log_gdpsa_hp <- hpfilter(log_gdpsa, freq = 1600, type = "lambda")
log_gdpsa_cycle <- log_gdpsa_hp$cycle

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
ggsave(filename = "Graphs/GDPFull.png", width = 16, height = 10, units = "cm")
## Real GDP 2010 - 2012
dates <- seq(from = as.Date("2010-03-01"), to = as.Date("2012-12-01"), by = "3 months")
dates <- paste0(quarters.Date(dates), "/", format(dates, "%y"))
autoplot(window(gdp, start = c(2010,1), end = c(2012,4))) + theme_minimal() + 
  labs(title = "Chilean Real Gross Domestic Product",
       x = "Year", y = "Billions of CLP", 
       caption = "Source: Own elaboration based on data from the Central Bank of Chile") +
  scale_y_continuous(expand = c(0,0), limits = c(34000, 44000),
                     breaks = seq(34000, 44000, 2000)) +
  scale_x_continuous(expand = c(0,0.2), limits = c(2010, 2012.8),
                     breaks = seq(2010, 2012.8, 0.25),
                     labels = dates)
ggsave(filename = "Graphs/GDP20102013.png", width = 16, height = 10, units = "cm")
## Real GDP Subseries
ggsubseriesplot(gdp) + theme_minimal() +
  labs(title = "Chilean Real GDP Subseries Plot",
       y = "Billions of CLP", 
       caption = "Source: Own elaboration based on data from the Central Bank of Chile") +
  scale_y_continuous(expand = c(0,0), limits = c(19500, 55000),
                     breaks = seq(20000, 55000, 5000))
ggsave(filename = "Graphs/GDP_Subseries.png", width = 16, height = 10, units = "cm")
## Log Real GDP
autoplot(log_gdp) + theme_minimal() + 
  labs(title = "Log (Chilean Real GDP)",
       x = "Year", y = "Ln(Billions of CLP)", 
       caption = "Source: Own elaboration based on data from the Central Bank of Chile") +
  scale_y_continuous(expand = c(0,0), limits = c(9.8, 11),
                     breaks = seq(9.8, 11, 0.2)) +
  scale_x_continuous(expand = c(0,1), limits = c(1996, 2023),
                     breaks = seq(1996, 2023, 3))
ggsave(filename = "Graphs/LogGDP.png", width = 16, height = 10, units = "cm")
## Real GDP Seasonally Adjusted
autoplot(gdp_sa) + theme_minimal() + 
  labs(title = "Chilean Real Gross Domestic Product Seasonally Adjusted",
       x = "Year", y = "Billions of CLP", 
       caption = "Source: Own elaboration based on data from the Central Bank of Chile") +
  scale_y_continuous(expand = c(0,0), limits = c(19500, 55000),
                     breaks = seq(20000, 55000, 5000)) +
  scale_x_continuous(expand = c(0,1), limits = c(1996, 2023),
                     breaks = seq(1996, 2023, 3))
ggsave(filename = "Graphs/GDP_SA.png", width = 16, height = 10, units = "cm")
## Real GDP Cycle
autoplot(log_gdpsa_cycle) + theme_minimal() + 
  labs(title = "Cycle of Ln(Chilean Real GDP SA)",
       x = "Year", y = "Ln(Billions of CLP)", 
       caption = "Source: Own elaboration based on data from the Central Bank of Chile") +
  scale_y_continuous(expand = c(0,0), limits = c(-0.15, 0.05),
                     breaks = seq(from = -15, to = 5, by = 5)/100) +
  geom_hline(yintercept = 0) + 
  scale_x_continuous(expand = c(0,1), limits = c(1996, 2023),
                     breaks = seq(1996, 2023, 3)) +
  annotate("rect", xmin = 2019.75, xmax = 2021,
         ymin = -Inf, ymax = Inf, alpha = 0.2, fill = "red") +
  annotate("rect", xmin = 2008, xmax = 2010,
           ymin = -Inf, ymax = Inf, alpha = 0.2, fill = "red") +
  annotate("rect", xmin = 1997, xmax = 1998.75, ymin = -Inf, ymax = Inf,
           alpha = 0.2, fill = "blue") +
  annotate("rect", xmin = 2021, xmax = 2023, ymin = -Inf, ymax = Inf,
           alpha = 0.2, fill = "blue")
ggsave(filename = "Graphs/LogGDP_Cycle.png", width = 16, height = 10, units = "cm")
## Inflation Rate
autoplot(inflation) + theme_minimal() +
  labs(title = "Chilean Monthly Inflation Rate",
       x = "Year", y = "Rate (%)", 
       caption = "Source: Own elaboration based on data from the Central Bank of Chile") +
  scale_y_continuous(expand = c(0,0), limits = c(-0.11, 1.6),
                     breaks = seq(-10, 160, 20)/100) +
  scale_x_continuous(expand = c(0,1), limits = c(2010, 2024),
                     breaks = seq(2010, 2024, 2)) +
  geom_hline(yintercept = 0)
ggsave(filename = "Graphs/InflationRate.png", width = 16, height = 10, units = "cm")
## Log Real GDP After X12
autoplot(log_gdp, alpha = 0.5) + autolayer(log_gdpsa, size = 1) +
  theme_minimal() + theme(legend.position = "none") +
  labs(title = "Ln(Chilean Real GDP) Seasonally Adjusted",
       y = "Ln(Billions of CLP)", x = "Year",
       caption = "Source: Own elaboration based on data from the Central Bank of Chile") +
  scale_y_continuous(expand = c(0,0), limits = c(9.8, 11),
                     breaks = seq(9.8, 11, 0.2)) +
  scale_x_continuous(expand = c(0,1), limits = c(1996, 2023),
                     breaks = seq(1996, 2023, 3))
ggsave(filename = "Graphs/LogGDPSAX12.png", width = 16, height = 10, units = "cm")
## Real GDP After X12
autoplot(gdp, alpha = 0.5) + autolayer(gdp_sa, size = 1) +
  theme_minimal() + theme(legend.position = "none") +
  labs(title = "Chilean Real GDP Seasonally Adjusted",
       y = "Billions of CLP", x = "Year",
       caption = "Source: Own elaboration based on data from the Central Bank of Chile") +
  scale_y_continuous(expand = c(0,0), limits = c(19500, 55000),
                     breaks = seq(20000, 55000, 5000)) +
  scale_x_continuous(expand = c(0,1), limits = c(1996, 2023),
                     breaks = seq(1996, 2023, 3))
ggsave(filename = "Graphs/GDPSAX12.png", width = 16, height = 10, units = "cm")