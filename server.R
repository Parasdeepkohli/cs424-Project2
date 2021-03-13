library(shiny)
library(ggplot2)
library(DT)
library(scales)
library(leaflet)
library(stringr)

function(input, output, session){
  
  source("Preprocessing.R")

  results2018 <- preprocess("Input_data_2018.csv")
  #results2010 <- preprocess("Input_data_2010.csv")
  results2000 <- preprocess("Input_data_2000.csv")

  input_data_2018 <- results2018[[1]]
  s2018 <- results2018[[2]]
  
  initial_lat = 40.011111
  initial_lng = -89.047222
  initial_zoom = 7
  
  Illinois_data <- subset(input_data_2018, PSTATEABB == "IL")
  factpal <- colorFactor(c('#a6cee3','#1f78b4','#b2df8a','#33a02c','#fb9a99','#e31a1c','#fdbf6f','#ff7f00','#cab2d6','#6a3d9a','#800080'),
                         domain = Illinois_data$PrimarySource)
  
  
  output$mapIL <- renderLeaflet({
    
    Illinois_data <- Illinois_data[Illinois_data$PrimarySource %in% input$SourcesIL, ]
    
    leaflet(Illinois_data) %>%
    addProviderTiles(providers$Stamen.Toner) %>%
    addCircleMarkers(label = ~as.character(paste0(PNAME, " (Main Source: ", PrimarySource, ")")), color = ~factpal(PrimarySource), fillOpacity = 1, 
                     labelOptions = labelOptions(textsize = "15px"),
                     popup = ~as.character(paste0("All Sources: ", s2018[PNAME])),
                     popupOptions = popupOptions(textsize = "15px")) %>%
      addLegend("bottomright", pal = factpal, values = ~PrimarySource,
                title = "Primary energy Source",
                opacity = 1
      )
    
  })
  
  
  observe({
    updateCheckboxGroupInput(
      session, 'SourcesIL', choices = c("Biomass", "Coal", "Gas", "Hydro", "None", "Nuclear", "Oil", "Other", "Solar", "Wind"),
      selected = if (input$allIL) c("Biomass", "Coal", "Gas", "Hydro", "None", "Nuclear", "Oil", "Other", "Solar", "Wind")
      
    )
  })
  
  observe({
    input$reset_button
    leafletProxy("mapIL") %>% setView(lat = initial_lat, lng = initial_lng, zoom = initial_zoom)
  })
  
}