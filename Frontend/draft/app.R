#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shiny.router)
library(shinydashboard)
library(shinyWidgets)
library(png)
#library(flexdashboard)
library(jsonlite)
library(reticulate)


Location <- c('East','West','South','North','NorthEast','SouthEast','SouthWest','NorthWest')
industry <- c('Finance','Media','Healthcare','Retail','Telecommunications','Automotive','Digital Marketing', 'Professional Services','Cyber Security', 'Mining','Government','Manufacturing','Transport')
skills <- c('Python','R programming', 'Java', 'SQL', 'C++', 'C', 'Interpersonal skills', 'Machine Learning', 'Deep Learning', 'Data Visualisation', 'Data wrangling')
jobtype <- c('Full time', 'Full time', 'Internship')

gaugeServer <- function(id, value) {
  moduleServer(
    id,
    function(input, output, session) {
      output$mapgauge<-flexdashboard::renderGauge({
        #output$mapgauge<-renderUI({
        #tagList(
        flexdashboard::gauge(value=value, 
                             min = 0, 
                             max = 100, 
                             sectors = flexdashboard::gaugeSectors(success = c(80, 100), 
                                                                   warning = c(50, 79),
                                                                   danger = c(0, 49)),
                             symbol = "%",
                             label = "MATCH")
        #)
      })
    })
}

gaugeUI <- function(id) {
  ns <- NS(id)
  flexdashboard::gaugeOutput(ns("mapgauge"))
  #uiOutput(ns("mapgauge"))
  
}


ui <- dashboardPage(
  header=dashboardHeader(title = "Data Scientist Hunt"),
  sidebar=dashboardSidebar(
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
                                 tabPanel( value= "search_panel",
                                           textInput("search", label=NULL, value="Find jobs"
                                           )),
                                 
                                 tabPanel("Jobs",
                                          h4("This page lists saved jobs?")),
                                 tabPanel("Career Guide",
                                          h4("This page has resume support etc.")),
                                 tabPanel("Learn!",
                                          h4("This page has technical test and courses")),
                                 tabPanel("My Profile",
                                          h4("This page contains user profile"))
                                 
                ),
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
                         actionButton("search", label = "Search", width = '250px'))
                ),
                
                uiOutput("box_list")
                
                
                
              )
      ),
      tabItem(tabName = "Saved",
              h1("Saved applications"),
              uiOutput("box_list_saved")
      ),
      tabItem(tabName = "Applied",
              h1("Jobs Applied"),
              uiOutput("box_list_apply")
      )
    )
  )
  
)


server <- function(input, output, session) {
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
    
    x <- httr::POST("http://127.0.0.1:5000/recommendation"
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
      output[[i]] = renderGauge(expr=as.expression(lista[[i]]),quoted=TRUE)
      output[[paste0(i,"save")]] = renderGauge(expr=as.expression(lista[[i]]),quoted=TRUE)
      output[[paste0(i,"apply")]] = renderGauge(expr=as.expression(lista[[i]]),quoted=TRUE)
      
      
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
          br(), "Industry: Delivery", br(), paste0("Skills: ",paste0(unlist(list_data$relevant_skills[[i]]),collapse = ",") ), width = 3,
          fluidRow(
            gaugeOutput(paste0("gauge",i)),
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
          br(), "Industry: Delivery", br(), paste0("Skills: ",paste0(unlist(list_data$relevant_skills[[index[j]]]),collapse = ",") ), width = 3,
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
          br(), "Industry: Delivery", br(), paste0("Skills: ",paste0(unlist(list_data$relevant_skills[[index[j]]]),collapse = ",") ), width = 3,
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

# Run the application 
shinyApp(ui = ui, server = server)