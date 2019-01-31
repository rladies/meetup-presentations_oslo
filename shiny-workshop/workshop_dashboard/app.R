## app.R ##
library(shiny)
library(shinydashboard)
library(colourpicker)
library(googleVis)
library(tidyverse)
library(gapminder)
library(DT)
library(plotly)


ui <- dashboardPage(skin="purple",
  dashboardHeader(title = "Supercool shiny app",
                  tags$li(a(href = 'https://rladies.org/',
                            img(src = 'logo.png',
                                title = "Rladies Home", height = "30px"),
                                style = "padding-top:10px; padding-bottom:10px;"),
                                class = "dropdown")), #end dashboardHeader
#  dbHeader,
  dashboardSidebar(
    sidebarMenu(
      menuItem("Interactive table", tabName = "interactive_table", icon=icon("chart-bar")),
      menuItem("Interactive plot", tabName = "interactive_plot", icon=icon("object-group")),
      menuItem("Motion chart", tabName = "motion_chart", icon = icon("spinner"))
    )
  ),
  
  dashboardBody(
    includeCSS("www/rladies_stylesheet.css"),
    
    ########################################
    
     tabItems(
       tabItem(tabName = "interactive_table", h2("Build an interactive table"),
               fluidRow(
                 DT::dataTableOutput("table")
                 
               )  #end fluidRow    
       ),#end tab
       
       
       
       tabItem(tabName = "interactive_plot", h2("Interactive plot"),
               fluidRow(
                 box(
                   textInput(inputId = "title", label="Title", value = "GDP vs life expectancy"),
                   numericInput(inputId = "size", label="Point size", value = 2, min = 1),
                   checkboxInput(inputId = "fit", label="Add line of best fit", FALSE),
                   colourInput("colour", "Point colour", value = "#88398a"),
                   selectInput(inputId="continents", label="Continents",
                               choices = levels(gapminder$continent),
                               multiple = TRUE,
                               selected = "Europe"),
                   sliderInput("years", "Years",
                               min(gapminder$year), max(gapminder$year),
                               value = c(1977, 2002))
                 ),#end box
                 
                 box(plotOutput("plot"))#, width = "600px", height = "600px")) 
                 
               )#end fluidRow
               
       ),#end tab
       
       


       
       tabItem(tabName = "motion_chart", 
               h2("Build a motion chart"),
               fluidRow( plotlyOutput("motion_chart")
                         
                         
               )#end fluidRow    
       )#end
       
    )#end tabItems
  )#end dashboardBody
)#end dashboardPage
        
    
server <- function(input, output) { 
  
  
  output$plot <- renderPlot({
    data <- subset(gapminder,
                   continent %in% input$continents &
                     year >= input$years[1] & year <= input$years[2])
    
    
    p <- ggplot(data, aes(year, lifeExp)) +
      geom_point(size = input$size, col = input$colour) +
      scale_x_log10() +
      ggtitle(input$title) +
      theme_minimal()    
    if (input$fit) {
      p <- p + geom_smooth(method = "lm")
    }
    p
    
  })

  output$table <- DT::renderDataTable({
    data <- gapminder
  })
  
  
  output$motion_chart <- renderPlotly({
    
    pp <- gapminder %>%
      plot_ly(
        x = ~gdpPercap, 
        y = ~lifeExp, 
        size = ~pop, 
        color = ~continent, 
        frame = ~year, 
        text = ~country, 
        hoverinfo = "text",
        type = 'scatter',
        mode = 'markers'
      ) %>%
      layout(
        xaxis = list(
          type = "log"
        )
      )
    ggplotly(pp)
    

  })
  
  
}#end server function

shinyApp(ui, server)