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

Location <- c('East','West','South','North','NorthEast','SouthEast','SouthWest','NorthWest')
industry <- c('Finance','Media','Healthcare','Retail','Telecommunications','Automotive','Digital Marketing', 'Professional Services','Cyber Security', 'Mining','Government','Manufacturing','Transport')
skills <- c('Python','R programming', 'Java', 'SQL', 'C++', 'C', 'Interpersonal skills', 'Machine Learning', 'Deep Learning', 'Data Visualisation', 'Data wrangling')
jobtype <- c('Full time', 'Full time', 'Internship')
# Define UI for application that draws a histogram
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
                                   tabPanel("Learn!",
                                            h4("This page has technical test and courses")),
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
                           selectInput('in3', 'Job type', c(Choose='', jobtype),selectize=FALSE)
                    ),
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
      ),
      fluidRow(
        box(
          title="Analyst Intern, Anlytics",status="warning",solidHeader=TRUE,
          "Full-time job $1000",
          br(), "Industry: Delivery", br(), "Skills: Python",
          fluidRow(
            gaugeOutput("gauge1"),
          ),
          width=4,
          
        ),
        box(
          title="Analyst Intern, Anlytics",status="warning",solidHeader=TRUE,
          "Full-time job $1000",
          br(), "Industry: Delivery", br(), "Skills: Python",
          fluidRow(
            gaugeOutput("gauge2"),
          ),
          width=4,
        ),
        
        box(
          title="Anlayst Intern, Anlytics",status="warning",solidHeader=TRUE,
          "Full-time job $1000",
          br(), "Industry: Delivery", br(), "Skills: Python",
          fluidRow(
            gaugeOutput("gauge3")
          ),
          width=4,
        )
      )
    )
  )
)


filter1_page <- div(
  ui <-  fluidPage(
    br(),
    fluidRow(
    ),
    fluidRow(
      setBackgroundImage(
        src = "https://source.unsplash.com/Q1p7bh3SHj8/4069x2010"  #https://source.unsplash.com/Q1p7bh3SHj8/4069x2010
      ),
      fluidRow(
        column(8, align="center", offset = 2,
               hr(),
               div(id = 'filter1',(textInput("filter1", label = "Which Location would you like to work in?")),
                   tags$style(type="text/css", "#filter1 {color : white;font-size:20px;}",),
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
      column(8, align = "right", offset = 2,
             hr(),
             div(id = 'next_page1',
                 actionButton("skip", label="Skip"),
                 actionButton("next", label="Next")))
    )))
filter2_page <- div(
  ui <-  fluidPage(
    br(),
    fluidRow(
    ),
    fluidRow(
      column(8, align="center", offset = 2,
             hr(),
             div(id = 'filter2',(textInput("filter2", label = "Which Industry would you like to work in?")),
                 tags$style(type="text/css", "#filter2 {color : white; font-size:20px;}", ),
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
                 actionButton("transport", label="transport"),
             ))),
    fluidRow(
      column(8, align = "right", offset = 2,
             hr(),
             div(id = 'next_page1',
                 actionButton("skip", label="Skip"),
                 actionButton("next", label="Next")))
    )
  ))

filter3_page <- div(
  ui <-  fluidPage(
    br(),
    fluidRow(
    ),
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
                 actionButton("modelling", label="Modelling"),
             ))),
    fluidRow(
      column(8, align = "right", offset = 2,
             hr(),
             div(id = 'next_page1',
                 actionButton("skip", label="Skip"),
                 actionButton("next", label="Next")))
    )
  ))
filter4_page <- div(
  ui <-  fluidPage(
    br(),
    fluidRow(
    ),
    fluidRow(
      column(8, align="center", offset = 2,
             hr(),
             div(id = 'filter4',textInput("filter4", label = "What Job Type are you looking for?")),
             tags$style(type="text/css", "#filter4 {color : white; font-size:20px;}"),
             actionButton("fulltime", label="Full time"),
             actionButton("Parttime", label="Part time"),
             actionButton("Intern", label="Intern"),
      ))),
  fluidRow(
    column(8, align = "right", offset = 2,
           hr(),
           div(id = 'next_page1',
               actionButton("skip", label="Skip"),
               actionButton("next", label="Next")))
  )
)

filter5_page <- div(
  ui <-  fluidPage(
    br(),
    fluidRow(
    ),
    fluidRow(
      column(8, align="center", offset = 2,
             hr(),
             div(id = 'integer',
                 sliderInput("integer", "What is your Expected Salary per month?:",
                             min = 0, max = 10000,
                             value = 0, step = 500),
                 tags$style(type="text/css", "#integer {color : white; font-size:20px;}")))
    ),
    fluidRow(
      column(8, align = "right", offset = 2,
             hr(),
             div(id = 'next_page1',
                 actionButton("skip", label="Skip"),
                 actionButton("next", label="Next")))
    )
  ))

router <- make_router(
  route("/", home_page),
  route("filter1", filter1_page),
  route("filter2", filter2_page),
  route("filter3", filter3_page),
  route("filter4", filter4_page),
  route("filter5", filter5_page)
)
ui <- fluidPage(
  tags$ul(
    tags$li(a(href = route_link("/"), "Dashboard")),
    tags$li(a(href = route_link("filter1"), "filter1")),
    tags$li(a(href = route_link("filter2"), "filter2")),
    tags$li(a(href = route_link("filter3"), "filter3")),
    tags$li(a(href = route_link("filter4"), "filter4")),
    tags$li(a(href = route_link("filter5"), "filter5"))
  ),
  router$ui
)

server <- function(input, output, session) {
  router$server(input, output, session)
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
}

shinyApp(ui, server)

# Run the application 
shinyApp(ui = ui, server = server)