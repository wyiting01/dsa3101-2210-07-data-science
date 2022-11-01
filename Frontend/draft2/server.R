#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
server <- {
  function(input, output, session) {
    output$out1 <- renderPrint(input$in1)
    output$out2 <- renderPrint(input$in2)
    output$out3 <- renderPrint(input$in3)
    output$out4 <- renderPrint(input$in4)
    output$out5 <- renderPrint(input$in5)
    # Navbar ------------------------------------------------------------------
    shinyjs::addClass(id = "navBar", class = "navbar-right")
    
    # DT Options --------------------------------------------------------------
    options(DT.options = list( lengthMenu = c(10, 20),
                               dom = 'tl'
    ))  
  }
  
}
