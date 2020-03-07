library(maps)
library(mapproj)
source("helpers.R")
counties <- readRDS("data/counties.rds")

# User interface ----
ui <- fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with 
        information from the 2010 US Census."),
      
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = c("Percent White", "Percent Black",
                              "Percent Hispanic", "Percent Asian"),
                  selected = "Percent White"),
      
      sliderInput("range", 
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 100))
    ),
    
    mainPanel(plotOutput("map"))
  )
)

# Server logic ----
server <- function(input, output){
  output$map <- renderPlot({
    data <- switch(input$var, 
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)
    if(input$var=="Percent White"){
      color="darkgreen"
    }
    if(input$var=="Percent Black"){
      color="black"
    }
    if(input$var=="Percent Asian"){
      color="purple"
    }
    if(input$var=="Percent Hispanic"){
      color="orange"
    }
    percent_map(var = data, color = color, legend.title = input$var, max = max(input$range), min = min(input$range))
    })
}

# Run app ----
shinyApp(ui, server)