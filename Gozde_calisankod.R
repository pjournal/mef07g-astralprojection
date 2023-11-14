install.packages("WDI")
library(WDI)

install.packages("remotes")
library(remotes)

install_github('vincentarelbundock/WDI')


#DENEME2

indicator_codes <- c("SP.POP.TOTL", "NY.GDP.PCAP.CD","SP.POP.DPND","FP.CPI.TOTL.ZG","SL.UEM.TOTL.ZS","SL.TLF.CACT.FE.ZS","SL.TLF.CACT.MA.ZS")
countries <- c("TUR", "USA")
start_date <- 2018
end_date <- 2023
world_bank_data_2 <- WDI( indicator = indicator_codes,
                        country = countries,
                        start = start_date, 
                        end = end_date, 
                        extra = TRUE)

saveRDS(world_bank_data_2, file = "world_bank_data.rds")
loaded_data <- readRDS("world_bank_data.rds")
loaded_data
colnames(loaded_data)

#"NY.GDP.MKTP.CD"


#"SP.POP.TOTL", "NY.GDP.PCAP.CD","SH.DYN.MORT",

"SI.POV.GINI"

#"FP.CPI.TOTL.ZG" --ENFLASYON

"SL.EMP.TOTL.SP.ZS" : #Employment to Population Ratio:
  
  "SP.POP.TOTL.WB.AG25-54"

# Female Labor Force Participation Rate:
#   Indicator Code: SL.TLF.CACT.FE.ZS
# Male Labor Force Participation Rate:
#   Indicator Code: SL.TLF.CACT.MA.ZS
# Female Unemployment Rate:
#   Indicator Code: SL.UEM.TOTL.FE.ZS
# Male Unemployment Rate:
#   Indicator Code: SL.UEM.TOTL.MA.ZS


#DENEME1
# country_code <- "TR"
# indicator_code <- "SP.POP.TOTL.FE.IN"
# start_date <- 2018
# end_date <- 2023
# 
# world_bank_data <- WDI( indicator = indicator_code,
#                         country = country_code,
#                         start = start_date, 
#                         end = end_date, 
#                         extra = TRUE)
# 
# saveRDS(world_bank_data, file = "world_bank_data.rds")
# loaded_data <- readRDS("world_bank_data.rds")
# loaded_data