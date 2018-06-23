
library(shiny)
library(shinymaterial)

server <- function(input, output) {
    
    observeEvent(input$switch,{
    
    # Collect user input and convert them into pipeline-ready features
    dev_prior <- input$dev_prior
    sp_prior <- input$sp_prior
    keywords <- input$keywords
    sub_type <- input$sub_type
    pr_code <- input$pr_code
    review_code <- input$review_code
    class_code <- input$class_code
    pdf_file <- input$pdf_file  
        
     
    user_input <<- collect_user_input(dev_prior,sp_prior,keywords,sub_type,pr_code,review_code,class_code,pdf_file)
    
    # Produce prediction plot in middle column from validation results
    # If a product code is available prepare the plot based on product code
    p<- qplot(x = 1:100, y = 1:100)
    
    if(pr_code != "Unknown"){
        pcode <- substr(gsub("\\|","",pr_code),1,3)
        plist <- plot_productcode(results = vresults, pcode = pcode)
        p <- plist$p
        subtitle_text1 <- paste0("Product code: ",pr_code)
        subtitle_text2 <- paste0("MAE: ",plist$mae)
    }
    
    # If a product code is not available prepare the plot based on review med speciality code
    if(pr_code == "Unknown"){
        rcode <- substr(gsub("\\|","",review_code),1,2)
        plist <- plot_review_adv(results = vresults, rcode = review_code)
        p <- plist$p
        subtitle_text1 <- paste0("Review advisory: ",review_code)
        subtitle_text2 <- paste0("MAE: ",plist$mae)
    }
    
    output$pred_plot <- renderPlotly(
        
        ggplotly(p)
    )
    
    output$subtitle1 <- renderUI(
        
        tags$h6(subtitle_text1)
        
    )
    
    output$subtitle2 <- renderUI(
        
        tags$h6(subtitle_text2)
        
    )
    
    
    }, ignoreNULL = FALSE, ignoreInit = FALSE) #End of "switch" button observer
    
}