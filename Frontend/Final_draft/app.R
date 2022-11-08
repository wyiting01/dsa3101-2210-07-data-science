#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(jsonlite)
library(httr)
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

get_recommendation<-function(input)
{
  user_input = list(
    expected_salary= input$Salary,
    expected_hours= input$Type,
    job_title=input$Jobtitle,
    location= input$Location,
    industry= input$Industry,
    skills= input$Skills
    
  )
  
  res <- httr::POST("http://127.0.0.1:5000/recommendation"
                    , body = user_input
                    , encode = "json")
  appData <- httr::content(res,as="text",encoding = "UTF-8")
  appData<-gsub("NaN","NA",appData)
  appData<-RJSONIO::fromJSON(appData,nullValue=NA)
  #appData<-do.call(rbind.data.frame, appData)
  return(appData)
  
}

add_click<-function(input)
{
  user_input = list(
    url= input$url
  )
  res <- httr::POST("http://127.0.0.1:5000/add_click"
                    , body = user_input
                    , encode = "json")
  appData <- httr::content(res,as="text",encoding = "UTF-8")
  return(appData)
  
}

get_articles<-function()
{
  res <- httr::GET('http://127.0.0.1:5000/get_articles')
  appData <- httr::content(res)
  return(appData)
}

get_rating<-function()
{
  res <- httr::GET('http://127.0.0.1:5000/get_rating')
  appData <- httr::content(res)
  return(appData)
}



update_rating<-function(input)
{
  user_input = list(
    rating= input$rating
  )
  res <- httr::POST("http://127.0.0.1:5000/update_rating"
                    , body = user_input
                    , encode = "json")
  appData <- httr::content(res)
  return(appData)
  
}

Location <- c('East','West','South','North','NorthEast','SouthEast','SouthWest','NorthWest')
industry <- c('Finance','Media','Healthcare','Retail','Telecommunications','Automotive','Digital Marketing', 'Professional Services','Cyber Security', 'Mining','Government','Manufacturing','Transport')
skills <- c('Python','R programming', 'Java', 'SQL', 'C++', 'C', 'Interpersonal skills', 'Machine Learning', 'Deep Learning', 'Data Visualisation', 'Data wrangling')
jobtype <- c('Full time', 'Part time', 'Internship')
#testing daily updates
data1=toJSON('https://www.forbes.com/sites/bernardmarr/2022/10/31/the-top-5-data-science-and-analytics-trends-in-2023/?sh=2b3dab75c411')

panel_div <- function(class_type, content) {
  div(class = sprintf("panel panel-%s", class_type),
      div(class = "panel-body", content)
  )
}

ui <- shinyUI(navbarPage(
  title = tags$img(src="logo-removebg-preview.png", height = "120px", width = "200px"), id = "navBar",
                         theme = "paper.css",
                         collapsible = TRUE,
                         inverse = TRUE,
                         windowTitle = "Data Dreams",
                         position = "fixed-top",
                         header = tags$style(
                           ".navbar-right {
                       float: right !important;
                       }",
                           "body {padding-top: 75px;}"),
                         
                         tabPanel("FORM", value = "form",
                                  
                                  shinyjs::useShinyjs(),
                                  
                                  tags$head(tags$script(HTML('
                                       var fakeClick = function(tabName) {
                                       var dropdownList = document.getElementsByTagName("a");
                                       for (var i = 0; i < dropdownList.length; i++) {
                                       var link = dropdownList[i];
                                       if(link.getAttribute("data-value") == tabName) {
                                       link.click();
                                       };
                                       }
                                       };
                                       '))),
                     
                                  fluidRow(
                                    column(3),
                                    column(6,
                                           tags$div(align = "right", 
                                                    tags$a("Skip to home page", 
                                                           onclick="fakeClick('home')", 
                                                           class="btn btn-primary btn-lg",
                                                           style="width:150 ;height: 50;"))
                                    )
                                  
                                  ),
                
                                  
                                  # WHAT
                                  fluidRow(
                                    column(3),
                                    column(6,
                                           div(id = 'introheader',(p("DataDreams"))),
                                           tags$style(type="text/css", "#introheader {text-align: center;color : white;font-size:40px;font-weight : bold}")
                                           
                                           
                                    ),
                                    column(3)
                                  ),
                                  
                                  fluidRow(
                                    style = "height:50px;"),
                                  
                                  
                                  fluidRow(
                                    column(3),
                                    column(6,
                                           div(id = 'introbody',(p("An interactive tool to help you explore the paths to take as a Data Scientist. With information about the 
                                                    similarity scores generated specially for you based on your filters, tips and tricks on how to pass a job interview, and more, you can 
                                                     build your own path based on what is meaningful to you"))),
                                           tags$style(type="text/css", "#introbody {text-align: center;color : white;font-size:20px}")
                                           
                                           
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
                                    column(3),
                                    column(6,
                                           tags$div(align = "right", 
                                                    tags$a("Search", 
                                                           onclick="fakeClick('home')", 
                                                           class="btn btn-primary btn-lg",
                                                           style="width:150 ;height: 50;"))
                                    )
                                  )),
                         tabPanel("HOME", value = "home",
                                  dashboardPage(        
                                    dashboardHeader(title = "DataDreams"),
                                    dashboardSidebar(
                                      sidebarMenu(
                                        menuItem("Search", tabName = "Search", icon = icon("search")),
                                        menuItem("Saved", tabName = "Saved", icon = icon("save")),
                                        menuItem("Applied", tabName = "Applied", icon = icon("thumbs-up"))
                                      )
                                    ),
                                    dashboardBody(
                                      
                                      tabItems(
                                        tabItem("Search",
                                                fluidPage(
                                                  br(),
                                                  fluidRow(),
                                                  ui <- navbarPage(fluid = TRUE, title = "GetHired",
                                                                   tabsetPanel(
                                                                   tabPanel( value= "search_panel",
                                                                             textInput("search", label=NULL, value="Find jobs"
                                                                             ),title = "Home",
                                                                             fluidRow(
                                                                               column(4,
                                                                                      hr(),
                                                                                      sliderInput(inputId = "Salary", label = "Expected Salary:",
                                                                                                  min = 0, max = 10000,
                                                                                                  value = 0, step = 500)),
                                                                               column(4,
                                                                                      hr(),
                                                                                      selectInput(inputId = 'Industry', label='Industry', c(Choose='', industry), selectize=FALSE)
                                                                               ),
                                                                               column(4,
                                                                                      hr(),
                                                                                      selectInput(inputId = 'Location', label = 'Location', c(Choose='', Location),selectize=FALSE)
                                                                               )
                                                                             ),
                                                                             fluidRow(
                                                                               column(4,
                                                                                      hr(),
                                                                                      selectInput(inputId = 'Type', label = 'Job type', c(Choose='', jobtype),selectize=FALSE)
                                                                               ),
                                                                               column(4,
                                                                                      hr(),
                                                                                      selectInput(inputId = 'Skills', label = 'Skills', c(Choose='', skills), selectize=FALSE)
                                                                               ),
                                                                               column(4,
                                                                                      hr(),
                                                                                      selectInput(inputId = 'Jobtitle', label = 'Job title', c(Choose='', c('Data Analyst','Data Scientist')), selectize=FALSE)	
                                                                               ),	
                                                                               column(4,	
                                                                                      hr(),
                                                                                      actionButton("search", label = "Search", width = '250px')),
       
                                                                             ),
                                                                             br(),
                                                                             fluidRow(
                                                                               dataTableOutput('ex4'),
                                                                               
                                                                               box(
                                                                                 title = "Daily Updates", background = "black", "Catch What's on the Data Science News Today!",
                                                                                 actionButton("titleBtId", "", icon = icon("refresh"),
                                                                                              class = "btn-xs", title = "Update",
                                                                                              onclick ="window.open('https://medium.com/towards-data-science/how-data-scientists-level-up-their-coding-skills-edf15bbde334', '_blank')"),
                                                                                 width = 3, solidHeader = TRUE, status = "warning",
                                                                                 uiOutput("boxContentUI2")
                                                                               )
                                                                             )),
                                                              
                                                                   tabPanel("Career Guide",
                                                                            h4("This page has resume support etc.")),
                                                                   tabPanel("Learn!",
                                                                            h4("This page has technical test and courses")),
                                                                   tabPanel("My Profile",
                                                                            h4("This page contains user profile"), fileInput("file", "Upload Your Resume"))
                                                                   
                                                  ))
                                                  
                                                  
                                                )
                                        ),
                                        tabItem(tabName = "Saved",
                                                h1("Saved applications")
                                        ),
                                        tabItem(tabName = "Applied",
                                                h1("Jobs Applied")
                                        )
                                      )
                                      # ,
                                      # fluidRow(
                                      #   dataTableOutput('ex4'),
                                      # 
                                      #   box(
                                      #     title = "Daily Updates", background = "black", "Catch What's on the Data Science News Today!",
                                      #     actionButton("titleBtId", "", icon = icon("refresh"),
                                      #                  class = "btn-xs", title = "Update",
                                      #                  onclick ="window.open('https://medium.com/towards-data-science/how-data-scientists-level-up-their-coding-skills-edf15bbde334', '_blank')"),
                                      #     width = 3, solidHeader = TRUE, status = "warning",
                                      #     uiOutput("boxContentUI2")
                                      #   )
                                      # )
                                    ), 
                                    sidebarPanel(
                                      width=3
                                    )
                                  ))
))

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  dta<-eventReactive(input$search,{
    
    dta<-get_recommendation(input)
    dta$relevant_skills<-NULL
    nn<-names(dta)
    dta<-as.data.frame(do.call(cbind, dta))
    names(dta)<-nn
    dta
    
  })
  
  output$ex4 <- renderDataTable(dta(), options = list(searching = FALSE, paging=FALSE))
}

shinyApp(ui, server)