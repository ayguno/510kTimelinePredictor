reticulate::use_virtualenv('oz5env', required = T)
library(reticulate)
library(shiny)
library(shinymaterial)

shinyServer(function(input, output,session) { 
   
   # this would increase the upload limit to 30MB  
   options(shiny.maxRequestSize=30*1024^2) 

     # Collect user input and convert them into pipeline-ready features
     
     global.values <- reactiveValues()
     global.values$dev_prior <- NULL
     global.values$sp_prior <- NULL
     global.values$keywords <- NULL
     global.values$sub_type <- NULL
     global.values$pr_code <- NULL
     global.values$review_code <- NULL
     global.values$class_code <- NULL
     global.values$pdf_file <- NULL
     global.values$user_input <- NULL

    observeEvent(input$switch,{
      global.values$dev_prior <- input$dev_prior
      global.values$sp_prior <- input$sp_prior
      global.values$keywords <- input$keywords
      global.values$sub_type <- input$sub_type
      global.values$pr_code <- input$pr_code
      global.values$review_code <- input$review_code
      global.values$class_code <- input$class_code
      global.values$pdf_file <- input$pdf_file
      
    }, ignoreNULL = FALSE)
    
    
observeEvent(c(global.values$dev_prior,global.values$sp_prior,
               global.values$keywords,global.values$sub_type,global.values$pr_code,global.values$review_code,
               global.values$class_code,global.values$pdf_file),{  

  
  
  dev_prior<- global.values$dev_prior 
  sp_prior <- global.values$sp_prior 
  keywords <- global.values$keywords 
  sub_type <- global.values$sub_type 
  pr_code <-global.values$pr_code 
  review_code <- global.values$review_code 
  class_code <- global.values$class_code 
  pdf_file <- global.values$pdf_file
  global.values$user_input <- collect_user_input(dev_prior,sp_prior,keywords,sub_type,pr_code,review_code,class_code,pdf_file)
  user_input <- global.values$user_input 
  
  cat("dev_prior: ",dev_prior,"\n" )
  cat("sp_prior: ", sp_prior, "\n") 
  cat('keywords: ',keywords,"\n" )
  cat('sub_type: ',sub_type,"\n" )
  cat('pr_code: ',pr_code,"\n" )
  cat('review_code: ',review_code,"\n" )
  cat('class_code: ',class_code,"\n" )
  
  
  
    
    
    output$prediction <- renderUI({

      ##############################################################################################
      #
      # Using Python scripts to process user input and return a prediction from saved model objects
      #
      ##############################################################################################
      source_python("./functions/make_predictions.py")
      preds <- round(make_prediction(r_to_py(user_input)),2)
      ##############################################################################################

      cat("preds: ", preds, "\n")
      
      tags$h3(paste0(preds," days"))
    
    })
    
    #####################################################################
    # Produce prediction plot in middle column from validation results
    #####################################################################
    # If a product code is available prepare the plot based on product code
    # UI entry points for the plot and predictions
    output$pred_plot <- renderPlotly({
      
      if(pr_code != "Unknown"){
        Sys.setlocale('LC_ALL','C')
        pcode <- substr(gsub("\\|","",pr_code),1,3)
        plist <- plot_productcode(results = vresults, pcode = pcode)
        p <- plist$p
        subtitle_text1 <- paste0("Product code: ",pr_code)
        subtitle_text2 <- paste0("MAE: ",plist$mae)
      }
      
      # If a product code is not available prepare the plot based on review med speciality code
      if(pr_code == "Unknown"){
        Sys.setlocale('LC_ALL','C') 
        rcode <- substr(gsub("\\|","",review_code),1,2)
        plist <- plot_review_adv(results = vresults, rcode = review_code)
        p <- plist$p
        subtitle_text1 <- paste0("Review advisory: ",review_code)
        subtitle_text2 <- paste0("MAE: ",plist$mae)
      }

      ggplotly(p)
      
    })
    
    output$subtitle1 <- renderUI({
      
      if(pr_code != "Unknown"){
        Sys.setlocale('LC_ALL','C')
        subtitle_text1 <- paste0("Product code: ",pr_code)
      }
      
      # If a product code is not available prepare the plot based on review med speciality code
      if(pr_code == "Unknown"){
        Sys.setlocale('LC_ALL','C') 
        subtitle_text1 <- paste0("Review advisory: ",review_code)
      }
      
      tags$h6(subtitle_text1)
      
      })
    
    output$subtitle2 <- renderUI({
      
      if(pr_code != "Unknown"){
        Sys.setlocale('LC_ALL','C')
        pcode <- substr(gsub("\\|","",pr_code),1,3)
        plist <- plot_productcode(results = vresults, pcode = pcode)
        p <- plist$p
        subtitle_text2 <- paste0("MAE: ",plist$mae)
      }
      
      # If a product code is not available prepare the plot based on review med speciality code
      if(pr_code == "Unknown"){
        Sys.setlocale('LC_ALL','C') 
        rcode <- substr(gsub("\\|","",review_code),1,2)
        plist <- plot_review_adv(results = vresults, rcode = review_code)
        p <- plist$p
        subtitle_text2 <- paste0("MAE: ",plist$mae)
      }
      
      tags$h6(subtitle_text2)
      
      })
    
    
    ##########################################################
    # Prepare a Word Cloud and Bar Plot with prepared corpus
    ##########################################################

    # UI entry points for the wordcloud and barplot
    output$Word_cloud <- renderPlot({
      
      withProgress({
        
      # If user did not provide any keyword or text use review class/product code information
      if (keywords == "" & is.null(pdf_file)){
        
        if(pr_code != "Unknown"){
          # If product code is available use it
          
          cat("Using Product Code \n")
          pcode <- substr(gsub("\\|","",pr_code),1,3)
          wtext <- vresults$TEXT_FEATURES[vresults$PRODUCTCODE == pcode]
       
        } else if(pr_code == "Unknown"){
          # If a product code is not available prepare the plots based on review med speciality code
          
          Sys.setlocale('LC_ALL','C')
          rcode <- substr(gsub("\\|","",review_code),1,2)
          wtext <- vresults$TEXT_FEATURES[vresults$REVIEWADVISECOMM == review_code]
        
        }
        
      }else{
        # If user provided some text, either keywords or pdf file, use it to prepare
        wtext <- user_input$TEXT_FEATURES

      }
      
      
      prepare_Wordcloud(wtext = wtext)
      
      },message = "Updating predictions based on your input",min = 0,max = 1000, value = 10) 
      
      },res = 100)
    
    
    
    output$Bar_plot <- renderPlot(
      
      
      
      # If user did not provide any keyword or text use review class/product code information
      if (keywords == "" & is.null(pdf_file)){
       
        if(pr_code != "Unknown"){
          # If product code is available use it
          cat("Using Product Code")
          pcode <- substr(gsub("\\|","",pr_code),1,3)
          wtext <- vresults$TEXT_FEATURES[vresults$PRODUCTCODE == pcode]
          prepare_Barplot(wtext = wtext)
          
          
        } else if(pr_code == "Unknown"){
          # If a product code is not available prepare the plots based on review med speciality code
          Sys.setlocale('LC_ALL','C')
          rcode <- substr(gsub("\\|","",review_code),1,2)
          wtext <- vresults$TEXT_FEATURES[vresults$REVIEWADVISECOMM == review_code]
          prepare_Barplot(wtext = wtext)
          
          
        }
        
      }else{
        # If user provided some text, either keywords or pdf file, use it to prepare
        wtext <- user_input$TEXT_FEATURES
        prepare_Barplot(wtext = wtext)
        
      }
        
      
      
    )
    
      
   
}, ignoreNULL = FALSE)      

    
    
})
