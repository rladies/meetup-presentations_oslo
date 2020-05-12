
library(shiny)
library(shinydashboard)
library(gapminder)
library(DT)
library(tidyverse)
library(plotly)
library(colourpicker)

# User interface:
ui <- dashboardPage(
  skin = "purple",
  dashboardHeader(title = "Supercool shiny app",
                  tags$li(a(href = 'https://rladies.org/',
                            img(src = 'logo.png',
                                title = "Rladies Home", height = "30px"),
                            style = "padding-top:10px; padding-bottom:10px;"),
                          class = "dropdown")), 
  dashboardSidebar(
    sidebarMenu(id = 'menu',
                menuItem("Table", tabName = "table_tab", icon=icon("chart-bar")),
                menuItem("Plot", tabName = "plot_tab", icon=icon("object-group")),
                menuItem("Animated chart", tabName = "animated_tab", icon = icon("spinner"))
    )
  ),
  dashboardBody(
    # includeCSS("www/custom.css"),
    includeCSS("www/rladies_stylesheet.css"),
    tabItems(
      tabItem(tabName = "table_tab", h2("Data table"),
              dataTableOutput(outputId = "gapminder_table")),
      tabItem(tabName = "plot_tab", h2("First plot"),
              fluidRow(
                box(
                  textInput(
                    inputId = "plot_title", 
                    label = "Select title for plot:", 
                    value = "GDP vs life expectancy"),
                  sliderInput(inputId = "year_limits", label = "Select years", 
                              min = min(gapminder$year), max = max(gapminder$year),
                              value = c(1977, 2002)
                  ),
                  selectInput(inputId = "continents", label = "Continents",
                              choices = levels(gapminder$continent),
                              multiple = TRUE,
                              selected = "Europe"),
                  numericInput(inputId = "point_size", label = "Point size", value = 2, min = 1),
                  colourInput(inputId="colour", label="Point colour", value = "#88398a"),
                  actionButton(#<<
                    inputId = 'animate_button', #<<
                    label = 'Animate this selection'#<<
                  )#<<
                ),
                box(plotOutput("gapminder_plot"))
              )),
      tabItem(
        tabName = "animated_tab", 
        h2("The best stats you've ever seen"),
        box(
          plotlyOutput("animated_plot")
        )
      )
    )
  )
)

# R code goes here:
server <- function(input, output, session) {
  
  
  output$gapminder_table <- renderDataTable(datatable(
    data = gapminder, 
    filter = ('top')
  ))
  
  output$gapminder_plot <- renderPlot({ 
    
    gapminder_data <- gapminder %>% 
      filter(
        year >= input$year_limits[1] & year <= input$year_limits[2],
        continent %in% input$continents 
      )
    
    ggplot(
      data = gapminder_data, 
      aes(x = year, y = lifeExp, color = country)
    ) +
      geom_line() +
      geom_point(size = input$point_size, color = input$colour) +
      scale_colour_manual(values = country_colors) + 
      theme(legend.position="none") +
      ggtitle(input$plot_title)
  })
  
  output$animated_plot <- renderPlotly({
    
    gapminder_data <- gapminder %>% 
      filter(
        year >= input$year_limits[1] & year <= input$year_limits[2],
        continent %in% input$continents 
      )
    
    p <- ggplot(#<<
      data = gapminder_data, #<<
      aes(x = gdpPercap, y = lifeExp, color = country, frame = year)#<<
    ) + #<<
      geom_point() + #<<
      scale_colour_manual(values = country_colors) + 
      theme(legend.position="none")
    
    ggplotly(p)
  })
  
  observeEvent(input$animate_button, { #<<
    updateTabItems(session, 'menu', 'animated_tab')#<<
  })#<<
}

# Run the application 
shinyApp(ui = ui, server = server)
