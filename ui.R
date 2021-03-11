library(shiny)
library(ggplot2)
library(DT)
library(scales)
library(usmap)
library(stringr)

fluidPage(title="US Energy app",
          
          navbarPage(
            
            title = "Navigation",
            id = "nav",
            position = "static-top",
            collapsible = TRUE,
            selected = "About",
            tabPanel(
              title = "About",
              tags$div(
                tags$style(type = 'text/css',
                           '.container-fluid {background-color: black; color: white}'
                           ),
                tags$h1("Welcome to Project 1 of CS 424!", `style` = "text-align:center"),
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
                
              )
            )
          )
)