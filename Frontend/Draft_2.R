

# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
# Developed with R version 3.3.2 (64-bit)
library(shiny)
library(shiny.router)
library(shinydashboard)
library(shinyWidgets)
library(png)
library(flexdashboard)


ui <- fluidPage(
    br(),
    dashboardHeader(title = "Data Scientist Hunt"),
    fluidRow(
        column(8, align = 'right' ,offset = 2,
               hr(),
               div(id = 'skip button',
                   actionButton("skip", label="Skip to home page")))
    ),
    fluidRow(
        setBackgroundImage(
            src = "https://source.unsplash.com/Q1p7bh3SHj8/4069x2010"  #https://source.unsplash.com/Q1p7bh3SHj8/4069x2010
        ),
        fluidRow(
            column(8, align="center", offset = 2,
                   hr(),
                   div(id = 'filter1',(textInput("filter1", label = "Which Location would you like to work in?")),
                       tags$style(type="text/css", "#filter1 {color : white;font-size:20px;}"),
                       actionButton("east", label="East"),
                       actionButton("north", label="North"),
                       actionButton("south", label="South"),
                       actionButton("west", label="West"),
                       actionButton("northeast", label="NorthEast"),
                       actionButton("southeast", label="Southeast"),
                       actionButton("northwest", label="Northwest"),
                       actionButton("southwest", label="Southwest")
                   )))),
    fluidRow(
        
        style = "height:150px;"),
    
    fluidRow(
        column(8, align="center", offset = 2,
               hr(),
               div(id = 'filter2',(textInput("filter2", label = "Which Industry would you like to work in?")),
                   tags$style(type="text/css", "#filter2 {color : white; font-size:20px;}" ),
                   actionButton("Finance", label="Finance"),
                   actionButton("media", label="Media"),
                   actionButton("healthcare", label="Healthcare"),
                   actionButton("retail", label="Retail"),
                   actionButton("telecommunications", label="Telecommunications"),
                   actionButton("automotive", label="Automotive"),
                   actionButton("digitalmarketing", label="Digital Marketing"),
                   actionButton("professional_services", label="Professional services"),
                   actionButton("cyber_security", label="Cyber Security"),
                   actionButton("mining", label="Mining"),
                   actionButton("Government", label="Government"),
                   actionButton("manufacturing", label="Manufacturing"),
                   actionButton("transport", label="transport")
               ))),
    fluidRow(
        
        style = "height:150px;"),
    
    fluidRow(
        column(8, align="center", offset = 2,
               hr(),
               div(id = 'filter3',(textInput("filter3", label = "What Skills do you possess?")),
                   tags$style(type="text/css", "#filter3 {color : white; font-size:20px;}"),
                   actionButton("python", label="Python"),
                   actionButton("R", label="R programming"),
                   actionButton("Java", label="Java"),
                   actionButton("SQL", label="SQL"),
                   actionButton("C++", label="C++"),
                   actionButton("Interpersonal skills", label="Interpersonal skills"),
                   actionButton("Machine learning", label="Machine learning"),
                   actionButton("deep learning", label="Deep learning"),
                   actionButton("Data visualisation", label="Data visualisation"),
                   actionButton("Data wrangling", label="Data wrangling"),
                   actionButton("Software engineering", label="Software engineering"),
                   actionButton("modelling", label="Modelling")
               ))),
    fluidRow(
        
        style = "height:150px;"),
    
    fluidRow(
        column(8, align="center", offset = 2,
               hr(),
               div(id = 'filter4',textInput("filter4", label = "What Job Type are you looking for?")),
               tags$style(type="text/css", "#filter4 {color : white; font-size:20px;}"),
               actionButton("fulltime", label="Full time"),
               actionButton("Parttime", label="Part time"),
               actionButton("Intern", label="Intern")
        )),

fluidRow(
    
    style = "height:150px;"),

fluidRow(
    column(8, align="center", offset = 2,
           hr(),
           div(id = 'integer',
               sliderInput("integer", "What is your Expected Salary per month?:",
                           min = 0, max = 10000,
                           value = 0, step = 500),
               tags$style(type="text/css", "#integer {color : white; font-size:20px;}")
               ))),

fluidRow(
    
    style = "height:150px;"),

fluidRow(
    column(8, align = "right", offset = 2,
           hr(),
           div(id = 'search1',
               actionButton("search", label="Search")))
)
)


server <- {
    function(input, output, session) {
        output$out1 <- renderPrint(input$in1)
        output$out2 <- renderPrint(input$in2)
        output$out3 <- renderPrint(input$in3)
        output$out4 <- renderPrint(input$in4)
        output$out5 <- renderPrint(input$in5)
    }
    
}
# Run the application 
shinyApp(ui = ui, server = server)
