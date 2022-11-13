#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(jsonlite)
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
library(httr)



Location <- c('Tampines','East','West','South','North','NorthEast','SouthEast','SouthWest','NorthWest')
industry <- c('Finance','Media','Healthcare','Retail','Telecommunications','Automotive','Digital Marketing', 'Professional Services','Cyber Security', 'Mining','Government','Manufacturing','Transport')
skills <- c('Python','R programming', 'Java', 'SQL', 'C++', 'C', 'Interpersonal skills', 'Machine Learning', 'Deep Learning', 'Data Visualisation', 'Data wrangling')
jobtype <- c('full time', 'full time', 'internship')
data1=toJSON('https://www.forbes.com/sites/bernardmarr/2022/10/31/the-top-5-data-science-and-analytics-trends-in-2023/?sh=2b3dab75c411')


panel_div <- function(class_type, content) {
    div(class = sprintf("panel panel-%s", class_type),
        div(class = "panel-body", content)
    )
}


ui <- shinyUI(navbarPage(
  title = tags$img(src="logo.png", height = "120px", width = "200px"), id = "navBar",
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
            fluidRow(
                style = "height:50px;"),
            
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
              column(8, align="center", offset = 2,
                     hr(),
                     div(id = 'filter6',(textInput("filter6", label = "What Skills do you possess?")),
                         tags$style(type="text/css", "#filter6 {color : white; font-size:20px;}"),
                         actionButton("data scientist", label="Data Scientist"),
                         actionButton("data analyst", label="Data Analyst"),
                         
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
             body=shinydashboard::dashboardBody(
               
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
                                                          
                                                          uiOutput("box_list"),
                                                          
                                                          box(
                                                            title = "Daily Updates", background = "black", "Catch What's on the Data Science News Today!",
                                                            actionButton("titleBtId", "", icon = icon("refresh"),
                                                                         class = "btn-xs", title = "Update",
                                                                         onclick ="window.open('https://medium.com/towards-data-science/how-data-scientists-level-up-their-coding-skills-edf15bbde334', '_blank')"),
                                                            width = 3, solidHeader = TRUE, status = "warning",
                                                            uiOutput("boxContentUI2")
                                                          )
                                                        )
                                              ),
                                              
                                              tabPanel("Career Guide",
                                                       fluidRow(
                                                         box(
                                                           title = "Guides",
                                                           width = 12,
                                                           height = 100,
                                                           actionButton(inputId = 'Finding Jobs', label ="Finding Jobs", width = 200),
                                                           actionButton(inputId = 'Resume', label ="Resume", width = 200),
                                                           actionButton(inputId = 'Interview', label ="Interview" ,width = 200),
                                                           actionButton(inputId = 'Contracts', label ="Contracts" ,width = 200)
                                                         )
                                                       ),
                                                       fluidRow(
                                                         h4("Frequently Asked Interview Questions"),
                                                         tabBox(
                                                           title = "Foodpanda",
                                                           side="right",
                                                           id="tabset1",
                                                           width = 5,
                                                           height = 200,
                                                           tabPanel("Answers", "1) Briefly introduce yourself: What’s your name?How long have you been working as [profession]?What do you love about your job? What are your top 2-3 achievements that are relevant to the job you’re applying for?"),
                                                           tabPanel("Questions", "1) Tell me something about yourself"), tags$a(href="https://www.foodpanda.com/", "Research about FoodPanda")),
                                                         tabBox(
                                                           title = "Google",
                                                           side="right",
                                                           id="tabset2",
                                                           width = 5,
                                                           height = 200,
                                                           tabPanel("Answers", "1) Although at first glance this might seem like a straightforward question, you should grab any opportunity you can to show your interest in the company."),
                                                           tabPanel("Questions", "1) How did you hear about this position?"), tags$a(href="https://careers.google.com/", "Research about Google"))
                                                       ),
                                                       fluidRow(
                                                         box(
                                                           title = "Data Science Career Pathways",
                                                           width = 12,
                                                           height = 100,
                                                           actionButton(inputId = 'Data Science', label ="Data Science", width = 280),
                                                           actionButton(inputId = 'Data Engineering', label ="Data Engineering", width = 280),
                                                           actionButton(inputId = 'Data Analytics', label ="Data Analytics" ,width = 280)
                                                         )
                                                       )
                                              ),
                                              tabPanel("Learn!",
                                                       fluidRow(
                                                         box(
                                                           title = "Intro to R Programming",
                                                           width = 3,
                                                           height = 200,
                                                           img(src="john_hopkins_uni_logo.png", width=150, style="display: block; margin-left: auto; margin-right: auto;vertical-align:middle"),
                                                           tags$a(href="https://www.coursera.org/learn/r-programming", "Link to the course")),
                                                         box(
                                                           title = "Applied Data Science with Python",
                                                           width = 3,
                                                           height = 200,
                                                           img(src="University-of-Michigan-Logo.png", width=150, style="display: block; margin-left: auto; margin-right: auto;vertical-align:middle"),
                                                           tags$a(href="https://www.coursera.org/specializations/data-science-python", "Link to the course")),
                                                         box(
                                                           title = "Machine Learning",
                                                           width = 3,
                                                           height = 200,
                                                           img(src="Stanford-logo.png", width=150, style="display: block; margin-left: auto; margin-right: auto;vertical-align:middle"),
                                                           tags$a(href="https://www.coursera.org/specializations/machine-learning-introduction", "Link to the course"))
                                                       ),
                                                       fluidRow(
                                                         box(
                                                           title = "Technical Test Practice",
                                                           width = 12,
                                                           height = 100,
                                                           actionButton(inputId = 'Easy', label ="easy", width = 280),
                                                           actionButton(inputId = 'Moderate', label ="moderate", width = 280),
                                                           actionButton(inputId = 'Hard', label ="hard" ,width = 280),
                                                         )
                                                       )),
                                              tabPanel("My Profile",
                                                       img(src="resume_photo.jpeg", width=200, style="display: block; margin-left: auto; margin-right: auto;"),
                                                       h4("NAME: SARAH NG JIA HUI"),
                                                       h4('MAJOR : DATA SCIENCE AND ANALYTICS(HONS)'),
                                                       h4('UNIVERSITY: NATIONAL UNIVERSITY OF SINGAPORE'),
                                                       h4('SKILLS: Python, Java, SQL, R programming, Machine Learning'),
                                                      fileInput("file", "Upload Your Resume"))
                                              
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

# Define server logic required to daw a histogram
server <- function(input, output) {
  
  values <- reactiveValues()
  user_input  <- reactive({
    list(
      expected_salary = input$Salary,
      industry = input$Industry,
      location = input$Location,
      expected_hours = input$Type,
      skills = input$Skills
      
    )
  })
  x<-eventReactive(input$search, {
    
    x <- httr::POST(
                    #"http://127.0.0.1:5000/recommendation"
                    "http://data-provider-service:5000/recommendation"
                    , body = user_input()
                    , encode = "json")
    x <- httr::content(x,as="text",encoding = "UTF-8")
    x<-gsub("NaN","NA",x)
    x<-RJSONIO::fromJSON(x,nullValue=NA)
    x
  })
  
  output$jsonview <- renderPrint({
    req(json_data())
  })
  
  observe({
    list_data<-x()
    
    gauge_function<-function(i)
    {
      flexdashboard::gauge(value=i, 
                           min = 0, 
                           max = 100, 
                           sectors = flexdashboard::gaugeSectors(success = c(80, 100), 
                                                                 warning = c(50, 79),
                                                                 danger = c(0, 49)),
                           symbol = "%",
                           label = "MATCH")
    }
    # call the module UI n times
    lista<-lapply(round((100*list_data$similarity_scores)),gauge_function)
    names(lista)<-paste0("gauge",1:length(list_data$similarity_scores))
    
    for(i in names(lista))
    {
      message("aqui")
      message(i)
      message(as.character(lista[[i]]))
      output[[i]] = flexdashboard::renderGauge(expr=as.expression(lista[[i]]),quoted=TRUE)
      output[[paste0(i,"save")]] = flexdashboard::renderGauge(expr=as.expression(lista[[i]]),quoted=TRUE)
      output[[paste0(i,"apply")]] = flexdashboard::renderGauge(expr=as.expression(lista[[i]]),quoted=TRUE)
      
      
    }
    
    
    
    
    
    
  })
  
  
  boxes<-reactive({
    list_data<-x()
    v <- list()
    v[[4]]<-     box(
      title = "Daily Updates", background = "black", "Catch What's on the Data Science News Today!",
      actionButton("titleBtId", "", icon = icon("refresh"),
                   class = "btn-xs", title = "Update",
                   onclick ="window.open('https://medium.com/towards-data-science/how-data-scientists-level-up-their-coding-skills-edf15bbde334', '_blank')"),
      width = 3, solidHeader = TRUE, status = "warning",
      #uiOutput("boxContentUI2")
    )
    
    for (i in 1:(length(list_data$similarity_scores))){
      #for (i in 1:3){
      if(i<4){
        index<-i  
      }else{
        index<-i+1
      }
      
      
      v[[index]] <- 
        box(
          title=list_data$title[i],status="warning",solidHeader=TRUE,
          paste0(list_data$hours[i] ," job $:",list_data$max_salary[i]),
          br(), "Industry:",input$Industry , br(), paste0("Skills: ",paste0(c(input$Skills,unlist(list_data$relevant_skills[[index[i]]])),collapse = ",") ), width = 3,
          fluidRow(
            flexdashboard::gaugeOutput(paste0("gauge",i)),
            box(actionButton(paste0("button",index), label="Save", icon = icon("save")),
                #uiOutput("but3")
            ),
            box(actionButton(paste0("apply",index), label="Apply", icon = icon("th")),
                #uiOutput("applybut3")
            )
          )
          #width=3
        )
      
    }
    
    cutt<-c(1,which(1:length(v)%%4==0),length(v))
    mat<-cbind((rev(rev(cutt)[-1])+1),cutt[-1])
    mat[1,1]<-1
    
    
    finalist<-list()
    for(j in 1:nrow(mat))
    {
      finalist[[j]]<-fluidRow(v[mat[j,1]:mat[j,2]]) 
      
    }
    
    finalist
  })
  
  
  boxes_save<-reactive({
    
    list_data<-x()
    v <- list()
    print(v)
    index<-c()
    for (i in 1:(length(list_data$similarity_scores))){
      
      index<-c(index,input[[paste0("button",i)]])
    }
    index<-which(index>0)
    
    j <-1
    
    
    
    while(j<=length(index))
    {
      v[[j]] <- 
        box(
          title=list_data$title[index[j]],status="warning",solidHeader=TRUE,
          paste0(list_data$hours[index[j]] ," job $:",list_data$max_salary[index[j]]),
          br(), "Industry:",input$Industry , br(), paste0("Skills: ",paste0(c(input$Skills,unlist(list_data$relevant_skills[[index[j]]])),collapse = ",") ), width = 3,
          fluidRow(
            flexdashboard::gaugeOutput(paste0("gauge",index[j],"save"))
            #uiOutput("widgets")
          )
          #width=3
        )
      j<-j+1
    }
    
    
    
    
    v
    
  })
  
  
  boxes_apply<-reactive({
    
    list_data<-x()
    v <- list()
    print(v)
    index<-c()
    for (i in 1:(length(list_data$similarity_scores))){
      
      index<-c(index,input[[paste0("apply",i)]])
    }
    index<-which(index>0)
    
    j <-1
    
    
    
    while(j<=length(index))
    {
      v[[j]] <- 
        box(
          title=list_data$title[index[j]],status="warning",solidHeader=TRUE,
          paste0(list_data$hours[index[j]] ," job $:",list_data$max_salary[index[j]]),
          br(), "Industry:",input$Industry , br(), paste0("Skills: ",paste0(c(input$Skills,unlist(list_data$relevant_skills[[index[j]]])),collapse = ",") ), width = 3,
          fluidRow(
            flexdashboard::gaugeOutput(paste0("gauge",index[j],"apply"))
          )
          #width=3
        )
      j<-j+1
    }
    
    
    
    
    v
    
  })
  
  output$box_list <- renderUI(boxes())
  output$box_list_saved <- renderUI(boxes_save())
  output$box_list_apply <- renderUI(boxes_apply())
}
    
shinyApp(ui, server)

