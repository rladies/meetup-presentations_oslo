
library(shiny)
library(shinydashboard)

# User interface:
ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody()
)

# R code goes here:
server <- function(input, output) {
  
}

# Run the application 
shinyApp(ui = ui, server = server)
