reticulate::use_virtualenv('510kTimelinePredictor', required = T)
library(reticulate)
library(shiny)
library(shinymaterial)

server <- function(input, output, session) {
    
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
        
    material_spinner_show(session, "prediction")
    
    user_input <<- collect_user_input(dev_prior,sp_prior,keywords,sub_type,pr_code,review_code,class_code,pdf_file)
    
    ##############################################################################################
    #
    # Using Python scripts to process user input and return a prediction from saved model objects
    #
    # Next steps: App works locally using main Anaconda 3 (C:\Users\OZAN\ANACON~1\),but fails when deployed to server
    # We need to establish a virtual python environment with required dependencies and give another try
    ##############################################################################################
    source_python("./functions/make_predictions.py")
    preds <- round(make_prediction(r_to_py(user_input)),2)
    ##############################################################################################
    
    material_spinner_hide(session, "prediction")
    
    output$prediction <- renderUI(
        
        tags$h3(paste0(preds," days."))
        
    )
    
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
    
    output$pred_plot <- renderPlotly(ggplotly(p))
    output$subtitle1 <- renderUI(tags$h6(subtitle_text1))
    output$subtitle2 <- renderUI(tags$h6(subtitle_text2))
    
    
    }, ignoreNULL = FALSE, ignoreInit = FALSE) #End of "switch" button observer
    
}