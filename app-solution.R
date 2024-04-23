# load packages –---------------------------------------------------------------

library(tidyverse)
library(shiny)

# load data –-------------------------------------------------------------------

weather <- read_csv("data/weather.csv")

# create app –------------------------------------------------------------------

shinyApp(
  ui = fluidPage(
    titlePanel("Weather Forecasts"),
    sidebarLayout(
      sidebarPanel(
        selectInput(
          "city", "Select a city",
          choices = c("Chicago", "Durham", "Sedona", "New York", "Los Angeles")
        ),
        selectInput(
          "var", "Select a variable",
          choices = c()
        )
      ),
      mainPanel(
        tabsetPanel(
          tabPanel("Plot", plotOutput("plot")),
          tabPanel("Data", dataTableOutput("data"))
        )
      )
    )
  ),
  server = function(input, output, session) {

    # weather for selected city
    weather_city <- reactive({
      weather |>
        filter(city %in% input$city)
    })

    # weather variables that are numeric and not constant for selected city
    weather_vars <- reactive({
      weather_city() |>
        select(where(is.numeric)) |>
        select(where(function(x) var(x) != 0)) |>
        names()
    })

    # update the select input when weather_vars changes
    observe({
      updateSelectInput(inputId = "var", choices = weather_vars())
    })

    # make plot
    output$plot <- renderPlot({
      req(input$var)
      weather_city() |>
        ggplot(aes_string(x = "time", y = input$var)) +
        labs(title = paste(input$city, "-", input$var)) +
        geom_line() +
        theme_bw()
    })

    # make table
    output$data <- renderDataTable({
      weather_city() |>
        select(city, time, input$var)
    })
  }
)
