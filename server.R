
library(shiny)
library(shinymaterial)

server <- function(input, output) {
    
    observeEvent(input$switch,{
    
    dev_prior <- input$dev_prior
    sp_prior <- input$sp_prior
    keywords <- input$keywords
    sub_type <- input$sub_type
    pr_code <- input$pr_code
    review_code <- input$review_code
    class_code <- input$class_code
    pdf_file <- input$pdf_file  
        
    # Collect user input and convert them into pipeline-ready features 
    user_input <<- collect_user_input(dev_prior,sp_prior,keywords,sub_type,pr_code,review_code,class_code,pdf_file)
                      
    
    }, ignoreNULL = FALSE, ignoreInit = FALSE) #End of "switch" button observer
    
}