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
library(flexdashboard)
library(jsonlite)


Location <- c('East','West','South','North','NorthEast','SouthEast','SouthWest','NorthWest')
industry <- c('Finance','Media','Healthcare','Retail','Telecommunications','Automotive','Digital Marketing', 'Professional Services','Cyber Security', 'Mining','Government','Manufacturing','Transport')
skills <- c('Python','R programming', 'Java', 'SQL', 'C++', 'C', 'Interpersonal skills', 'Machine Learning', 'Deep Learning', 'Data Visualisation', 'Data wrangling')
jobtype <- c('Full time', 'Full time', 'Internship')

home_page <- div(
  ui <- dashboardPage(
    dashboardHeader(title = "Data Scientist Hunt"),
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
                  )
                  
                )
        ),
        tabItem(tabName = "Saved",
                h1("Saved applications")
        ),
        tabItem(tabName = "Applied",
                h1("Jobs Applied")
        )
      ),
      fluidRow(
        box(
          title="Analyst Intern, Analytics",status="warning",solidHeader=TRUE,
          "Full-time job $1000",
          br(), "Industry: Delivery", br(), "Skills: Python", width = 3,
          fluidRow(
            gaugeOutput("gauge1"),
            box(actionButton("button1", label="Save", icon = icon("save")),
                uiOutput("but1")),
            box(actionButton("applybutton1", label="Apply", icon = icon("th")),
                uiOutput("applybut1"))
          )
        ),
        box(
          title="Analyst Intern, Analytics",status="warning",solidHeader=TRUE,
          "Full-time job $1000",
          br(), "Industry: Delivery", br(), "Skills: Python", width = 3,
          # title = p("Title 1", 
          #           actionButton("titleBtId", "", icon = icon("refresh"),
          #                        class = "btn-xs", title = "Update"),
          fluidRow(
            gaugeOutput("gauge2"),
            box(actionButton("button2", label="Save", icon = icon("save")),
                uiOutput("but2")),
            box(actionButton("applybutton2", label="Apply", icon = icon("th")),
                uiOutput("applybut2"))
          )
          #width=3
        ),
        
        box(
          title="Anlayst Intern, Analytics",status="warning",solidHeader=TRUE,
          "Full-time job $1000",
          br(), "Industry: Delivery", br(), "Skills: Python", width = 3,
          fluidRow(
            gaugeOutput("gauge3"),
            box(actionButton("button3", label="Save", icon = icon("save")),
                uiOutput("but3")),
            box(actionButton("applybutton3", label="Apply", icon = icon("th")),
                uiOutput("applybut3"))
          )
          #width=3
        ),
        
        box(
          title = "Daily Updates", background = "black", "Catch What's on the Data Science News Today!",
          actionButton("titleBtId", "", icon = icon("refresh"),
                       class = "btn-xs", title = "Update",
                       onclick ="window.open('https://medium.com/towards-data-science/how-data-scientists-level-up-their-coding-skills-edf15bbde334', '_blank')"),
          width = 3, solidHeader = TRUE, status = "warning",
          uiOutput("boxContentUI2")
        )
      )
      
    )
  )
)

server <- function(input, output, session) {
  json_data  <- reactive({
    toJSON(
      list(
        expected_alary = input$Salary,
        industry = input$Industry,
        location = input$Location,
        expected_hours = input$Type,
        skills = input$Skills
        
      ),
      pretty = TRUE
    )})
  
  output$jsonview <- renderPrint({
    req(json_data())
  })
  
  output$gauge = renderGauge({
    gauge(98, 
          min = 0, 
          max = 100, 
          sectors = gaugeSectors(success = c(80, 100), 
                                 warning = c(50, 79),
                                 danger = c(0, 49)),
          symbol = "%",
          label = "MATCH")
  })
  output$gauge1 = renderGauge({
    gauge(98, 
          min = 0, 
          max = 100, 
          sectors = gaugeSectors(success = c(80, 100), 
                                 warning = c(50, 79),
                                 danger = c(0, 49)),
          symbol = "%",
          label = "MATCH")
  })
  output$gauge2 = renderGauge({
    gauge(60, 
          min = 0, 
          max = 100, 
          sectors = gaugeSectors(success = c(80, 100), 
                                 warning = c(50, 79),
                                 danger = c(0, 49)),
          symbol = "%",
          label = "MATCH")
  })
  output$gauge3 = renderGauge({
    gauge(40, 
          min = 0, 
          max = 100, 
          sectors = gaugeSectors(success = c(80, 100), 
                                 warning = c(50, 79),
                                 danger = c(0, 49)),
          symbol = "%",
          label = "MATCH")
  })
  output$boxContentUI2 <- renderUI({
    input$titleBtId
  }) 
  output$but1 <- renderUI({
    input$button1
  })
  output$but2 <- renderUI({
    input$button2
  }) 
  output$but3 <- renderUI({
    input$button3
  }) 
  output$applybut1 <- renderUI({
    input$applybutton1
  })
  output$applybut2 <- renderUI({
    input$applybutton2
  }) 
  output$applybut3 <- renderUI({
    input$applybutton3
  }) 
  
  
}





shinyApp(ui, server)

# Run the application 
shinyApp(ui = ui, server = server)