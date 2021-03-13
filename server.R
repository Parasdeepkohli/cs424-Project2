library(shiny)
library(ggplot2)
library(DT)
library(scales)
library(leaflet)
library(stringr)

function(input, output, session){
  
  source("Preprocessing.R")

  results2018 <- preprocess("Input_data_2018.csv")
  results2010 <- preprocess("Input_data_2010.csv")
  results2000 <- preprocess("Input_data_2000.csv")

  input_data_2018 <- results2018[[1]]
  s2018 <- results2018[[2]]
  
  input_data_2010 <- results2010[[1]]
  s2010 <- results2010[[2]]
  
  input_data_2000 <- results2000[[1]]
  s2000 <- results2000[[2]]
  
  Illinois_lat = 40.011111
  Illinois_lng = -89.047222
  Illinois_zoom = 7
  
  Illinois_data <- subset(input_data_2018, PSTATEABB == "IL")
  factpal <- colorFactor(c('#093eb0','#1f78b4','#496331','#33a02c','#fb9a99','#e31a1c','#fdbf6f','#ff7f00','#cab2d6','#6a3d9a','#800080'),
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
  
  output$map1 <- renderLeaflet({
    
    st <- setNames(c(state.abb, "US-Total"), c(state.name, "US-Total"))[input$State1]
    if (input$Year1 == 2000){datafile <- input_data_2000}
    else if (input$Year1 == 2010){datafile <- input_data_2010}
    else{datafile <- input_data_2018}
    
    if (input$Year1 == 2000){sfile<- s2000}
    else if (input$Year1 == 2010){sfile <- s2010}
    else{sfile <- s2018}
    
    if (input$style1 == "Hard boundries (B&W)"){style <- providers$Stamen.Toner}
    else if (input$style1 == "Muted boundries"){style <- providers$CartoDB.Positron}
    else{style <- providers$Esri.NatGeoWorldMap}
    
    factpal2 <- colorFactor(c('#093eb0','#1f78b4','#496331','#33a02c','#fb9a99','#e31a1c','#fdbf6f','#ff7f00','#cab2d6','#6a3d9a','#800080'),
                            domain = datafile$PrimarySource)
    
    if (st != "US-Total"){map1_data <- subset(datafile, PSTATEABB == as.character(st))}
    else {map1_data <- datafile}
    map1_data <- map1_data[map1_data$PrimarySource %in% input$Sources1, ]
    map1_data <- subset(map1_data, (input$MinSlider<= PrimaryValue) & ( PrimaryValue <= input$MaxSlider))
    
    leaflet(map1_data) %>%
      addProviderTiles(style) %>%
      addCircleMarkers(label = ~as.character(paste0(PNAME, " || Main Source: ", PrimarySource, " || ", "Sources:", sfile[PNAME])), 
                       color = ~factpal2(PrimarySource), fillOpacity = 1, 
                       labelOptions = labelOptions(textsize = "16px"),
                       popup = ~as.character(paste(
                         "Percentage renewable: ", map1_data$Percent_renew,
                         "% ",
                         "|| Percentage non-renewable: ", map1_data$Percent_nonRenew,
                         "% ",
                         "|| Biomass: ", map1_data$Biomass, 
                         " Mwh ",
                         "|| Coal: ", map1_data$Coa,
                         " Mwh ",
                         "|| Gas: ", map1_data$Gas,
                         " Mwh ",
                         "|| Hydro: ", map1_data$Hydro,
                         " Mwh ",
                         "|| Nuclear: ", map1_data$Nuclear,
                         " Mwh ",
                         "|| Oil: ", map1_data$Oil,
                         " Mwh ",
                         "|| Other: ", map1_data$Other,
                         " Mwh ",
                         "|| Solar: ", map1_data$Solar,
                         " Mwh ",
                         "|| Wind: ", map1_data$Wind,
                         " Mwh ",
                         "|| Geothermal: ", map1_data$Geothermal,
                         " Mwh")),
                       popupOptions = popupOptions(textsize = "20px"),
                       radius = ~sqrt(map1_data$Radius)) %>%
      addLegend("topright", pal = factpal2, values = ~PrimarySource,
                title = paste0("Energy Source (", input$Year1, ")"),
                opacity = 1
      )
    
    
  })
  
  output$map2 <- renderLeaflet({
    
    st <- setNames(c(state.abb, "US-Total"), c(state.name, "US-Total"))[input$State2]
    if (input$Year2 == 2000){datafile <- input_data_2000}
    else if (input$Year2 == 2010){datafile <- input_data_2010}
    else{datafile <- input_data_2018}
    
    if (input$Year2 == 2000){sfile<- s2000}
    else if (input$Year2 == 2010){sfile <- s2010}
    else{sfile <- s2018}
    
    if (input$style2 == "Hard boundries (B&W)"){style <- providers$Stamen.Toner}
    else if (input$style2 == "Muted boundries"){style <- providers$CartoDB.Positron}
    else{style <- providers$Esri.NatGeoWorldMap}
    
    factpal2 <- colorFactor(c('#093eb0','#1f78b4','#496331','#33a02c','#fb9a99','#e31a1c','#fdbf6f','#ff7f00','#cab2d6','#6a3d9a','#800080'),
                            domain = datafile$PrimarySource)
    
    
    if (input$merge == TRUE){mySources <- input$Sources1}
    else{mySources <- input$Sources2}
    
    if (st != "US-Total"){map2_data <- subset(datafile, PSTATEABB == as.character(st))}
    else {map2_data <- datafile}
    map2_data <- map2_data[map2_data$PrimarySource %in% mySources, ]
    map2_data <- subset(map2_data, (input$MinSlider<= PrimaryValue) & ( PrimaryValue <= input$MaxSlider))
    
    leaflet(map2_data) %>%
      addProviderTiles(style) %>%
      addCircleMarkers(label = ~as.character(paste0(PNAME, " || Main Source: ", PrimarySource, " || ", "Sources:", sfile[PNAME])), 
                       color = ~factpal2(PrimarySource), fillOpacity = 1, 
                       labelOptions = labelOptions(textsize = "16px"),
                       popup = ~as.character(paste(
                         "Percentage renewable: ", map2_data$Percent_renew,
                         "% ",
                         "|| Percentage non-renewable: ", map2_data$Percent_nonRenew,
                         "% ",
                         "|| Biomass: ", map2_data$Biomass, 
                         " Mwh ",
                         "|| Coal: ", map2_data$Coa,
                         " Mwh ",
                         "|| Gas: ", map2_data$Gas,
                         " Mwh ",
                         "|| Hydro: ", map2_data$Hydro,
                         " Mwh ",
                         "|| Nuclear: ", map2_data$Nuclear,
                         " Mwh ",
                         "|| Oil: ", map2_data$Oil,
                         " Mwh ",
                         "|| Other: ", map2_data$Other,
                         " Mwh ",
                         "|| Solar: ", map2_data$Solar,
                         " Mwh ",
                         "|| Wind: ", map2_data$Wind,
                         " Mwh ",
                         "|| Geothermal: ", map2_data$Geothermal,
                         " Mwh")),
                       popupOptions = popupOptions(textsize = "20px"),
                       radius = ~sqrt(map2_data$Radius)) %>%
      addLegend("topright", pal = factpal2, values = ~PrimarySource,
                title = paste0("Energy Source (", input$Year2, ")"),
                opacity = 1
      )
    
    
  })
  
  
  observe({
    updateCheckboxGroupInput(
      session, 'SourcesIL', choices = c("Biomass", "Coal", "Gas", "Hydro", "None", "Nuclear", "Oil", "Other", "Solar", "Wind", "Geothermal"),
      selected = if (input$allIL) c("Biomass", "Coal", "Gas", "Hydro", "None", "Nuclear", "Oil", "Other", "Solar", "Wind", "Geothermal")
      
    )
  })
  
  observe({
    updateCheckboxGroupInput(
      session, 'Sources1', choices = c("Biomass", "Coal", "Gas", "Hydro", "None", "Nuclear", "Oil", "Other", "Solar", "Wind", "Geothermal"),
      selected = if (input$all1) c("Biomass", "Coal", "Gas", "Hydro", "None", "Nuclear", "Oil", "Other", "Solar", "Wind", "Geothermal")
      
    )
  })
  
  observe({
    updateCheckboxGroupInput(
      session, 'Sources2', choices = c("Biomass", "Coal", "Gas", "Hydro", "None", "Nuclear", "Oil", "Other", "Solar", "Wind", "Geothermal"),
      selected = if (input$all2) c("Biomass", "Coal", "Gas", "Hydro", "None", "Nuclear", "Oil", "Other", "Solar", "Wind", "Geothermal")
      
    )
  })
  
  observe({
    input$reset_button
    leafletProxy("mapIL") %>% setView(lat = Illinois_lat, lng = Illinois_lng, zoom = Illinois_zoom)
  })
  
  observe({
    input$reset_button1
    
    st <- setNames(c(state.abb, "US-Total"), c(state.name, "US-Total"))[input$State1]
    if (input$Year1 == 2000){datafile <- input_data_2000}
    else if (input$Year1 == 2010){datafile <- input_data_2010}
    else{datafile <- input_data_2018}
    
    if (st != "US-Total"){map1_data <- subset(datafile, PSTATEABB == as.character(st)) 
                          zoom <- 6}
    else {map1_data <- datafile 
          zoom <- 4}
    
    map1_data <- subset(map1_data, (input$MinSlider<= PrimaryValue) & ( PrimaryValue <= input$MaxSlider))
    
    leafletProxy("map1", data = map1_data) %>% setView(lat = mean(as.numeric(map1_data$LAT)), lng = mean(as.numeric(map1_data$LON)), zoom = zoom)
  })

  observe({
    input$reset_button2
    
    st <-setNames(c(state.abb, "US-Total"), c(state.name, "US-Total"))[input$State2]
    if (input$Year2 == 2000){datafile <- input_data_2000}
    else if (input$Year2 == 2010){datafile <- input_data_2010}
    else{datafile <- input_data_2018}
    
    if (st != "US-Total"){map2_data <- subset(datafile, PSTATEABB == as.character(st))
                          zoom <- 6}
    else {map2_data <- datafile
          zoom <- 4}
    
    map2_data <- subset(map2_data, (input$MinSlider<= PrimaryValue) & ( PrimaryValue <= input$MaxSlider))
    leafletProxy("map2", data = map2_data) %>% setView(lat = mean(as.numeric(map2_data$LAT)), lng = mean(as.numeric(map2_data$LON)), zoom = zoom)
  })
  
}