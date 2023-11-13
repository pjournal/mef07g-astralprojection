install.packages("WDI")
library(WDI)

install.packages("remotes")
library(remotes)

install_github('vincentarelbundock/WDI')
#DENEME1
country_code <- "TR"
indicator_code <- "SP.POP.TOTL.FE.IN"
start_date <- 2018
end_date <- 2023

world_bank_data <- WDI( indicator = indicator_code,
                        country = country_code,
                        start = start_date, 
                        end = end_date, 
                        extra = TRUE)