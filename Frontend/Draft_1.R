#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
Location <- c('East','West','South','North','NorthEast','SouthEast','SouthWest','NorthWest')
industry <- c('Finance','Media','Healthcare','Retail','Telecommunications','Automotive','Digital Marketing', 'Professional Services','Cyber Security', 'Mining','Government','Manufacturing','Transport')
skills <- c('Python','R programming', 'Java', 'SQL', 'C++', 'C', 'Interpersonal skills', 'Machine Learning', 'Deep Learning', 'Data Visualisation', 'Data wrangling')
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
                fluidRow(
                ),
                ui <- navbarPage(fluid = TRUE, title = "GetHired",
                                 tabPanel( value= "search_panel",
                                           textInput("search", label=NULL, value="Find jobs",
                                           )),
                                 
                                 tabPanel("Jobs",
                                          h4("This page lists saved jobs?")),
                                 tabPanel("Career Guide",
                                          h4("This page has resume support etc.")),
                                 tabPanel("Companies",
                                          h4("This page has a list of companies")),
                                 tabPanel("My Profile",
                                          h4("This page contains user profile"))
                                 
                ),
                fluidRow(
                  column(4,
                         hr(),
                         sliderInput("integer", "Expected Salary:",
                                     min = 0, max = 10000,
                                     value = 0, step = 500)),
                  column(4,
                         hr(),
                         selectInput('in2', 'Industry', c(Choose='', industry), selectize=FALSE)
                  ),
                  column(4,
                         hr(),
                         selectInput('in3', 'Location', c(Choose='', Location),selectize=FALSE)
                  )
                ),
                fluidRow(
                  column(4,
                         hr(),
                         sliderInput("integer", "Expected Hours:",
                                     min = 0, max = 10,
                                     value = 1)),
                  column(4,
                         hr(),
                         selectInput('in5', 'Skills', c(Choose='', skills), selectize=FALSE)
                  ),
                  column(4,
                         hr(),
                         actionButton("search", label = "Search", width = '250px'))
                )
                
              )
              )
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  output$out1 <- renderPrint(input$in1)
  output$out2 <- renderPrint(input$in2)
  output$out3 <- renderPrint(input$in3)
  output$out4 <- renderPrint(input$in4)
  output$out5 <- renderPrint(input$in5)
}

# Run the application 
shinyApp(ui = ui, server = server)
