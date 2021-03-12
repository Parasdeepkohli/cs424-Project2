library(shiny)
library(ggplot2)
library(DT)
library(scales)
library(leaflet)
library(stringr)

function(input, output){
  
  source("Preprocessing.R")
  input_data_2018 <- preprocess("Input_data_2018.csv")

  # getColor <- function(df) {
  #   sapply(df$, function(mag) {
  #     if(mag <= 4) {
  #       "green"
  #     } else if(mag <= 5) {
  #       "orange"
  #     } else {
  #       "red"
  #     } })
  # }
  # 
  
  Illinois_data <- subset(input_data_2018, PSTATEABB == "IL")
  
  output$map <- renderLeaflet({
    
    leaflet(Illinois_data) %>%
    addTiles() %>%
    addCircleMarkers(label = ~as.character(PNAME))
    
  })
  
}