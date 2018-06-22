
library(shiny)
library(shinymaterial)

server <- function(input, output) {
    
    observeEvent(input$switch,{
    
    # Collect user input and convert them into pipeline-ready features
    user_input <- data.frame(DEVICENAME_PRIOR_CLEARANCE_TO_DATE = 0,
                             APPLICANT_PRIOR_CLEARANCE_TO_DATE = 0,
                             TEXT_FEATURES = "")
    # Numeric features
    user_input$DEVICENAME_PRIOR_CLEARANCE_TO_DATE <- input$dev_prior
    user_input$APPLICANT_PRIOR_CLEARANCE_TO_DATE <- input$sp_prior
    
    # Text features
    
    
    
    
    cat(user_input$DEVICENAME_PRIOR_CLEARANCE_TO_DATE, "\n")
    cat(user_input$APPLICANT_PRIOR_CLEARANCE_TO_DATE, "\n")
    
    }, ignoreNULL = FALSE, ignoreInit = FALSE) #End of "switch" button observer
    
}