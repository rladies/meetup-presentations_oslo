## app.R ##
library(shiny)
library(shinydashboard)
library(colourpicker)
library(googleVis)
library(tidyverse)
library(gapminder)


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
      menuItem("Interactive plot", tabName = "interactive_plot", icon=icon("object-group")),
      menuItem("Interactive table", tabName = "interactive_table", icon=icon("chart-bar")),
      menuItem("Motion chart", tabName = "motion_chart", icon = icon("spinner"))
    )
  ),
  
  dashboardBody(
   
    includeCSS("www/custom.css"),
    
     tabItems(

#1.tab
      tabItem(tabName = "interactive_plot", h2("Interactive plot"),
        fluidRow(
          box(
            textInput("title", "Title", "GDP vs life expectancy"),
            numericInput("size", "Point size", 2, 1),
            checkboxInput("fit", "Add line of best fit", FALSE),
            colourInput("colour", "Point colour", value = "#88398a"),
            selectInput("continents", "Continents",
                          choices = levels(gapminder$continent),
                          multiple = TRUE,
                          selected = "Europe"),
            sliderInput("years", "Years",
                          min(gapminder$year), max(gapminder$year),
                          value = c(1977, 2002))
          ),#end box
          
          box(plotOutput("plot"))#, width = "600px", height = "600px")) 
          
        )#end fluidRow
          

          
        
        ),#end 1. tab
      
#2. tab      
      tabItem(tabName = "interactive_table", h2("Build an interactive table"),
              fluidRow(
                box( ), #end box
                box() 
                
              )  #end fluidRow    
              

              
      ),#end 2. tab
      


#3.tab
      tabItem(tabName = "motion_chart", 
              h2("Build a motion chart with GoogleVis"),
      fluidRow(
      box(), #end box
      box() 
      
    )  #end fidRow    

    # a("Rapport kontrollavspilling, periode: des 2015 - mars 2016", 
    #  href = "https://livereports.questback.com/?auth=BnGnsweOMmdbLp7pDXixJg2&rid=3450742")
              
              
      )#end 3. tab

    )#end tabItems
  )#end dashboardBody
)#end dashboardPage
        
    
server <- function(input, output) { 
  
  output$plot <- renderPlot({
    data <- subset(gapminder,
                   continent %in% input$continents &
                     year >= input$years[1] & year <= input$years[2])
    
    p <- ggplot(data, aes(gdpPercap, lifeExp)) +
      geom_point(size = input$size, col = input$colour) +
      scale_x_log10() +
      ggtitle(input$title) +
      theme_minimal()    
    if (input$fit) {
      p <- p + geom_smooth(method = "lm")
    }
    p
  })

  
}#end server function

shinyApp(ui, server)