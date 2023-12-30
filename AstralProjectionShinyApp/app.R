
# Shiny uygulamasını yüklemek için shiny paketini yükleyin
if (!require("shiny")) {
  install.packages("shiny")
}
library(shiny)
library(ggplot2)
library(dplyr)

world_bank_data <- readRDS("world_bank_data.rds")

# Tüm ülkeleri ve yılları seçili olarak getir
selected_countries <- unique(world_bank_data$Country)
selected_years <- unique(world_bank_data$Year)

# Shiny uygulamasını oluştur
ui <- fluidPage(
  titlePanel("Development Indicators Comparison"),
  tabsetPanel(
    tabPanel("Single Indicator Comparison",
             sidebarLayout(
               sidebarPanel(
                 selectizeInput("countryFilter1", "Select Country:", choices = selected_countries, selected = selected_countries, multiple = TRUE),
                 selectizeInput("yearFilter1", "Select Year:", choices = selected_years, selected = selected_years, multiple = TRUE),
                 selectInput("indicatorFilter1", "Select Indicator:", choices = c("Inflation Rate", "Unemployment Rate", "Age Dependency Ratio", "GDP", "Population"), selected = "Inflation Rate")
               ),
               mainPanel(
                 plotOutput("indicatorPlot1")
               )
             )
    ),
    tabPanel("Double Indicator Comparison",
             sidebarLayout(
               sidebarPanel(
                 selectizeInput("countryFilter2", "Select Country:", choices = selected_countries, selected = selected_countries, multiple = TRUE),
                 selectizeInput("yearFilter2", "Select Year:", choices = selected_years, selected = selected_years, multiple = TRUE),
                 selectInput("indicatorFilter2", "Select Indicators:", choices = c("Inflation Rate and Unemployment Rate", "Inflation and Gdp Per Capita"), selected = "Inflation Rate and Unemployment Rate")
               ),
               mainPanel(
                 plotOutput("indicatorPlot2")
               )
             )
    ),
    tabPanel("Labor Force Participation Rates",
             sidebarLayout(
               sidebarPanel(
                 selectizeInput("countryFilter3", "Select Country:", choices = selected_countries, selected = selected_countries, multiple = TRUE),
                 selectizeInput("yearFilter3", "Select Year:", choices = selected_years, selected = selected_years, multiple = TRUE)
               ),
               mainPanel(
                 plotOutput("maleLaborRatePlot"),
                 plotOutput("femaleLaborRatePlot")
               )
             )
  )
 )
)

server <- function(input, output) {
  # Single Indicator ggplot grafiğini oluşturun
  output$indicatorPlot1 <- renderPlot({
    # Seçilen yılı, ülkeyi ve gösterilecek göstergeyi filtreleyin
    filtered_data <- subset(world_bank_data, 
                            Year %in% input$yearFilter1 & 
                              Country %in% input$countryFilter1)
    
    # Belirtilen göstergeye göre ggplot grafiğini oluşturun
    if (input$indicatorFilter1 == "Inflation Rate") {
      ggplot(filtered_data, aes(x = Year, y = Inflation, color = Country, group = Country)) +
        geom_line() +
        geom_text(aes(label = scales::comma(Inflation, big.mark = ",")), 
                  position = position_dodge(width = 0.9), 
                  vjust = -0.5, 
                  size = 3) +
        labs(
          title = "Inflation Rate Comparison",
          x = "Year",
          y = "Inflation Rate",
          color = "Country"
        ) +
        theme_minimal() +
        theme(legend.position = "bottom",   
              legend.title = element_blank(),
              legend.box = "horizontal",  
              legend.margin = margin(t = 0, r = 0, b = 0, l = 0),  
              plot.title = element_text(size = 12), 
              axis.text = element_text(size = 10),  
              legend.text = element_text(size = 10))
    } else if (input$indicatorFilter1 == "Unemployment Rate") {
      ggplot(filtered_data, aes(x = Year, y = UnemploymentRate, color = Country)) +
        geom_line() +
        geom_text(aes(label = paste0(scales::comma(round(UnemploymentRate, 2), big.mark = ","), "%")), 
                  position = position_dodge(width = 0.9), 
                  vjust = -0.5, 
                  size = 3) +
        labs(
          title = "Unemployment Rate Comparison",
          x = "Year",
          y = "Unemployment Rate",
          color = "Country"
        ) +
        theme_minimal() +
        theme(legend.position = "bottom",   
              legend.title = element_blank(),
              legend.box = "horizontal",  
              legend.margin = margin(t = 0, r = 0, b = 0, l = 0),  
              plot.title = element_text(size = 12), 
              axis.text = element_text(size = 10),  
              legend.text = element_text(size = 10))
    } else if (input$indicatorFilter1 == "Age Dependency Ratio") {
      ggplot(filtered_data, aes(x = Year, y = AgeDependancyRatio, color = Country, group = Country)) +
        geom_line() +
        geom_text(aes(label = paste0(scales::comma(round(AgeDependancyRatio), big.mark = ","), "%")), 
                  position = position_dodge(width = 0.9), 
                  vjust = -0.5, 
                  size = 3) +
        labs(
          title = "Age Dependency Ratio Comparison",
          x = "Year",
          y = "Age Dependency Ratio (%)",
          color = "Country"
        ) + 
        theme_minimal() +
        theme(legend.position = "bottom",   
              legend.title = element_blank(),
              legend.box = "horizontal",  
              legend.margin = margin(t = 0, r = 0, b = 0, l = 0),  
              plot.title = element_text(size = 12), 
              axis.text = element_text(size = 10),  
              legend.text = element_text(size = 10))+
        scale_y_continuous(labels = scales::percent_format(scale = 1), limits = c(40, 60), breaks = seq(40, 60, by = 10))
    } else if (input$indicatorFilter1 == "GDP") {
      ggplot(filtered_data, aes(x = Year, y = GdpPerCapita, fill = Country)) +
        geom_bar(stat = "identity", position = "dodge", alpha = 0.7) +
        geom_text(aes(label = scales::label_number_si(accuracy = 1)(GdpPerCapita)), 
                  position = position_dodge(width = 0.9), 
                  vjust = -0.5, 
                  size = 3) +
        labs(
          title = "GDP per Capita Comparison (USD)",
          x = "Year",
          y = "GDP per Capita (USD)",
          fill = "Country"
        ) +
        scale_y_continuous(labels = scales::label_number_si(accuracy = 1)) +  
        theme_minimal() +
        theme(legend.position = "bottom",   
              legend.title = element_blank(),
              legend.box = "horizontal",  
              legend.margin = margin(t = 0, r = 0, b = 0, l = 0),  
              plot.title = element_text(size = 12), 
              axis.text = element_text(size = 10),  
              legend.text = element_text(size = 10))
    } else if (input$indicatorFilter1 == "Population") {
      ggplot(filtered_data, aes(x = factor(Year), y = Population / 1e6, fill = Country)) +
        geom_bar(stat = "identity", position = "dodge", alpha = 0.7) +
        geom_text(aes(label = scales::label_number_si(accuracy = 1)(Population)), 
                  position = position_dodge(width = 0.9), 
                  vjust = -0.5, 
                  size = 3) +
        labs(
          title = "Total Population Comparison",
          x = "Year",
          y = "Population (Million)",
          fill = "Country"
        ) +
        scale_y_continuous(labels = scales::label_number_si(accuracy = 1)) + 
        theme_minimal() +
        theme(legend.position = "bottom",   
              legend.title = element_blank(),
              legend.box = "horizontal",  
              legend.margin = margin(t = 0, r = 0, b = 0, l = 0),  
              plot.title = element_text(size = 12), 
              axis.text = element_text(size = 10),  
              legend.text = element_text(size = 10))
    }
  })
  
  # Double Indicator ggplot grafiğini oluşturun
  output$indicatorPlot2 <- renderPlot({
    # Seçilen yılı, ülkeyi ve gösterilecek göstergeyi filtreleyin
    filtered_data <- subset(world_bank_data, 
                            Year %in% input$yearFilter2 & 
                              Country %in% input$countryFilter2)
    
    if (input$indicatorFilter2 == "Inflation Rate and Unemployment Rate") {
      ggplot(filtered_data, aes(x = Year, y = UnemploymentRate, color = Country, size = Inflation)) +
        geom_point() +
        labs(title = " Inflation Rate and Unemployment Rate Comparison",
             x = "Year",
             y = "UnemploymentRate",
             color = "Country") +
        theme_minimal() +
        theme(legend.position = "bottom",   
              legend.title = element_blank(),
              legend.box = "horizontal",  
              legend.margin = margin(t = 0, r = 0, b = 0, l = 0),  
              plot.title = element_text(size = 12), 
              axis.text = element_text(size = 10),  
              legend.text = element_text(size = 10))
    } else if (input$indicatorFilter2 == "Inflation and Gdp Per Capita") {
      filtered_data <- filtered_data %>%
        filter(!is.na(Inflation))  # NA değerleri filtrele
      
      ggplot(filtered_data, aes(x = Year, group = Country)) +
        geom_line(aes(y = GdpPerCapita, color = Country, linetype = "GdpPerCapita"), size = 1.2) +
        geom_line(aes(y = Inflation * 400, color = Country, linetype = "Inflation"), size = 1.2) +
        
        scale_linetype_manual(values = c("GdpPerCapita" = "solid", "Inflation" = "dotted")) +
        
        labs(title = "Inflation and Gdp Per Capita (USD) Comparison",
             x = "Year", 
             y = "GdpPerCapita",
             color = "Country",
             linetype = "Indicator") +
        
        scale_y_continuous(name = "GdpPerCapita",
                           sec.axis = sec_axis(~./400, name = "Inflation", breaks = seq(0, 100, by = 20))) +
        
        theme_minimal() +
        theme(legend.position = "bottom",   
              legend.title = element_blank(),
              legend.box = "horizontal",  
              legend.margin = margin(t = 0, r = 0, b = 0, l = 0),  
              plot.title = element_text(size = 12), 
              axis.text = element_text(size = 10),  
              legend.text = element_text(size = 10))
    }
  })
  # Gender Labor Rates ggplot grafiğini oluşturun
  output$maleLaborRatePlot <- renderPlot({
    filtered_data <- subset(world_bank_data, 
                            Year %in% input$yearFilter3 & 
                              Country %in% input$countryFilter3)
    
    ggplot(filtered_data, aes(x = Year, y = MaleLaborRate, color = Country, group = Country)) +
      geom_line() +
      labs(
        title = "Male Labor Rate Comparison",
        x = "Year",
        y = "Male Labor Rate",
        color = "Country"
      ) +
      theme_minimal() +
      theme(legend.position = "bottom",   
            legend.title = element_blank(),
            legend.box = "horizontal",  
            legend.margin = margin(t = 0, r = 0, b = 0, l = 0),  
            plot.title = element_text(size = 12), 
            axis.text = element_text(size = 10),  
            legend.text = element_text(size = 10))
  })
  
  output$femaleLaborRatePlot <- renderPlot({
    filtered_data <- subset(world_bank_data, 
                            Year %in% input$yearFilter3 & 
                              Country %in% input$countryFilter3)
    
    ggplot(filtered_data, aes(x = Year, y = FemaleLaborRate, color = Country, group = Country)) +
      geom_line() +
      labs(
        title = "Female Labor Rate Comparison",
        x = "Year",
        y = "Female Labor Rate",
        color = "Country"
      ) +
      theme_minimal() +
      theme(legend.position = "bottom",   
            legend.title = element_blank(),
            legend.box = "horizontal",  
            legend.margin = margin(t = 0, r = 0, b = 0, l = 0),  
            plot.title = element_text(size = 12), 
            axis.text = element_text(size = 10),  
            legend.text = element_text(size = 10))
  })
}

# Uygulamayı çalıştırın
shinyApp(ui, server)


