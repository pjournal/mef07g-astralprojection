
install.packages("WDI")
library(WDI)

install.packages("remotes")
library(remotes)

install_github('vincentarelbundock/WDI')

WDIsearch("health")

country_code <- "TR"
indicator_code <- "SH.XPD.CHEX.GD.ZS"
start_date <- 2015
end_date <- 2020

world_bank_data <- WDI(indicator = indicator_code, country = country_code,
                       start = start_date, end = end_date, extra = TRUE)

# indicator_codes <- c("NY.GDP.MKTP.CD", "SP.POP.TOTL", "NY.GDP.PCAP.CD")
# countries <- c("TUR", "USA")
# years <- 2015:2020
# 
# world_bank_data <- WDI(indicator = indicator_codes, country = countries,
#                        start = min(years), end = max(years), extra = TRUE)
# 
# print(world_bank_data)
