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
        # UI input code goes here
      ),
      mainPanel(
        # UI output code goes here
      )
    )
  ),
  server = function(input, output, session) {

    # server code goes here

  }
)
