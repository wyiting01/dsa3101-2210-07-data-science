#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram

library(shiny)
library(shiny.router)
library(shinydashboard)
library(shinyWidgets)
library(png)
library(flexdashboard)
library(dplyr)
library(stringr)
library(png)
library(shinyjs)
library(DT)
library(visNetwork)
library(rintrojs)


panel_div <- function(class_type, content) {
  div(class = sprintf("panel panel-%s", class_type),
      div(class = "panel-body", content)
  )
}

  ui <- shinyUI(navbarPage(
    
    # title = img(src='logo-removebg-preview.png', height = "40px"), id = "navBar",
    # theme = "paper.css",
    # collapsible = TRUE,
    # inverse = TRUE,
    # windowTitle = "Los Angeles County Career PathFinder",
    # position = "fixed-top",
    # footer = includeHTML("./www/include_footer.html"),
    # header = tags$style(
    #   ".navbar-right {
    #                    float: right !important;
    #                    }",
    #   "body {padding-top: 75px;}"),
    # 
    # tabPanel("HOME", value = "home",
    #          
    #          shinyjs::useShinyjs(),
    #          
    #          tags$head(tags$script(HTML('var fakeClick = function(tabName) {
    #          var dropdownList = document.getElementsByTagName("a");
    #          for (var i = 0; i < dropdownList.length; i++) {var link = dropdownList[i];
    #          if(link.getAttribute("data-value") == tabName) {link.click();
    #          };
    #          }
    #          };
    #                                     ')))),
    fluidPage(
    h6("Powered by:"),
    tags$img(src='logo-removebg-preview.png', height=120, width=200),
    br(),
    dashboardHeader(title = "Data Scientist Hunt"),
    fluidRow(
      column(8, align = 'right' ,offset = 2,
             hr(),
             div(id = 'skip button',
                 actionButton("skip", label="Skip to home page")))
    ),
    # WHAT
    fluidRow(
      column(3),
      column(6,
             shiny::HTML("<br><br><center> <h1>What you'll find here</h1> </center><br>"),
             shiny::HTML(
             "<h5>An interactive tool to help you explore the paths to take as a Data Scientist. With information about the 
                                                  similarity scores generated specially for you based on your filters, tips and tricks on how to pass a job interview, and more, you can 
                                                   build your own path based on what is meaningful to you.</h5>")
      ),
      column(3)
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
))
