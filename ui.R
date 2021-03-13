library(shiny)
library(ggplot2)
library(DT)
library(scales)
library(leaflet)
library(stringr)

fluidPage(title="US Energy app",
        
  navbarPage(
    
    title = "Navigation",
    id = "nav",
    position = "static-top",
    collapsible = TRUE,
    selected = "Compare states",
    tabPanel(
      title = "About",
        tags$h1("Welcome to Project 2 of CS 424!", `style` = "text-align:center"),
        tags$h4("Created by: Parasdeep (Spring 2021)", `style` = "text-align:right"),
        tags$u(tags$h3("Purpose:", `style` = "font-weight:bold")),
        tags$ul(tags$li("Visualize the energy produced by various sources in the U.S.A (Basic Visualizations)", `style` = "font-size:20px"),
                tags$li("Compare the energy produced by various sources between any two states",`style` = "font-size:20px"),
                tags$li("Geographically visualize variance in energy production across the country", `style` = "font-size:20px")),
        tags$u(tags$h3("The Data:", `style` = "font-weight:bold")),
        tags$ul(tags$li("A CSV file detailing the energy produced in the U.S.A from 1990 - 2019", `style` = "font-size:20px"),
                tags$li("The data divides energy production by the following categories: Year, State, Producer, and source",`style` = "font-size:20px"),
                tags$li("Please find the link to the data source here:", tags$a(`href` = "https://www.eia.gov/electricity/data/state/", "Source"), `style` = "font-size:20px")),
        tags$u(tags$h3("Guide:", `style` = "font-weight:bold")),
        tags$ul(tags$li("Please use the navbar above to navigate the app", `style` = "font-size:20px"),
                tags$li("Base Visualizations: Full page dedicated to a single visualization",`style` = "font-size:20px"),
                tags$li("Compare: Base visualizations with comparisons between states through filters", `style` = "font-size:20px"),
                tags$li("US map: Inside Compare, change tabs to geographical comparison of data", `style` = "font-size:20px"),
                tags$li("If you receive an error in Compare, it means that no data is available for that combination of filters", `style` = "font-size:20px")),
        tags$u(tags$h3("Known bugs:", `style` = "font-weight:bold")),
        tags$ul(tags$li("Choosing a source/year/state combination that has no corresponding value in the data returns an error", `style` = "font-size:20px"),
                tags$li("If your choices result in a single observation, the y-ticks will be bugged and repeat the same value",`style` = "font-size:20px"),
                tags$li("Both of the second graphs in compare states are 'squished' due to the legend size. X-axis labels become distorted",`style` = "font-size:20px"))
        
    ),
    tabPanel("Illinois 2018",
      sidebarLayout(
        sidebarPanel(
          width = 2,
          tags$head(tags$style("#mapIL{height:90vh !important;}")),
          checkboxGroupInput(
            inputId = "SourcesIL", 
            label = "Pick the sources", 
            choices = c("Biomass", "Coal", "Gas", "Hydro", "None", "Nuclear", "Oil", "Other", "Solar", "Wind")
          ),
          checkboxInput(inputId = 'allIL', label = 'All', value = TRUE),
          actionButton("reset_button", "Reset view"),
          tags$h5("Many plants do not output any energy. They are represented by the *None* source")
        ),
        mainPanel(
          width = 10,
          title = "Illinois 2018",
          leafletOutput("mapIL")
        )
      )
    ),
    tabPanel("Compare states",
             fluidRow(
               column(2,
                      sidebarLayout(
                        sidebarPanel(width = 12,
                           checkboxGroupInput(
                             inputId = "Sources1", 
                             label = "Top map sources", 
                             choices = c("Biomass", "Coal", "Gas", "Hydro", "None", "Nuclear", "Oil", "Other", "Solar", "Wind")
                          ),
                          checkboxInput(inputId = 'all1', label = 'All', value = TRUE),
                         checkboxGroupInput(
                           inputId = "Sources2", 
                           label = "Bottom map sources", 
                           choices = c("Biomass", "Coal", "Gas", "Hydro", "None", "Nuclear", "Oil", "Other", "Solar", "Wind")
                          ),
                         checkboxInput(inputId = 'all2', label = 'All', value = TRUE)
                         ),
                        mainPanel()
                      )
               ),
               column(width = 8,
                      tags$head(tags$style("#map1{height:45vh !important;}
                                            #map2{height:45vh !important;")),
                       leafletOutput("map1"),
                       leafletOutput("map2")
                      
               ),
               column(width = 2,
                      sidebarLayout(
                        sidebarPanel(width = 12,
                                     selectInput(inputId = "Year1",
                                                 label = "Top map year",
                                                 choices = c(2000, 2010, 2018),
                                                 selected = 2000),
                                     selectInput(inputId = "State1",
                                                 label = "Top map state",
                                                 choices = state.name,
                                                 selected = "Illinois"),
                                     selectInput(inputId = "style1",
                                                 label = "Top map style",
                                                 choices = c("Toner (B&W)"),
                                                 selected = "Toner (B&W)"),
                                     selectInput(inputId = "Year2",
                                                 label = "Bottom map year",
                                                 choices = c(2000, 2010, 2018),
                                                 selected = 2018),
                                     selectInput(inputId = "State2",
                                                 label = "Bottom map state",
                                                 choices = state.name,
                                                 selected = "Illinois"),
                                     selectInput(inputId = "style2",
                                                 label = "Bottom map style",
                                                 choices = c("Toner (B&W)"),
                                                 selected = "Toner (B&W)"),
                                     
                                     actionButton("reset_button1", "Reset top map zoom"),
                                     actionButton("reset_button2", "Reset bottom map zoom"),
                                     
                                     ),
                        mainPanel()
                      )
               )
        
      )
    )
  )
)
