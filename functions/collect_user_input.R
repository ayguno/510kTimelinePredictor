#################################################################################################
# Author: Ozan Aygun
# Description: Function to collect user input and convert them into pipeline-ready features
#################################################################################################


collect_user_input <- function(dev_prior,
                               sp_prior,
                               keywords,
                               sub_type,
                               pr_code,
                               review_code,
                               class_code,
                               pdf_file
                               ){
    require(hunspell)
    require(pdftools)
    require(stringr)
    require(tesseract)    
    
    user_input <- data.frame(DEVICENAME_PRIOR_CLEARANCE_TO_DATE = 0,
                             APPLICANT_PRIOR_CLEARANCE_TO_DATE = 0,
                             TEXT_FEATURES = "")
    # Numeric features
    user_input$DEVICENAME_PRIOR_CLEARANCE_TO_DATE <- dev_prior
    user_input$APPLICANT_PRIOR_CLEARANCE_TO_DATE <- sp_prior
    
    # Text features
    user_input$TEXT_FEATURES <- paste(user_input$TEXT_FEATURES,keywords,sep = " ")
    user_input$TEXT_FEATURES <- paste(user_input$TEXT_FEATURES,paste0("type",sub_type),sep = " ")
    user_input$TEXT_FEATURES <- paste(user_input$TEXT_FEATURES,paste0("productcode",tolower(substr(gsub("\\|","",pr_code),1,3))),sep = " ")
    user_input$TEXT_FEATURES <- paste(user_input$TEXT_FEATURES,paste0("reviewadvisecomm",tolower(substr(gsub("\\|","",review_code),1,2))),sep = " ")
    user_input$TEXT_FEATURES <- paste(user_input$TEXT_FEATURES,paste0("classadvisecomm",tolower(substr(gsub("\\|","",class_code),1,2))),sep = " ")
    
    # If user supplies a PDF file, extract text contents 
    if (!is.null(pdf_file)) {
        
        cat("PDF loaded by user... \n")
        pdfurl <- pdf_file$datapath 
        # Note that wrapping the pdf_url into paste and collapse ~ combines all the pages 
        # of the pdf text into a single character string object:
        txt <- paste(pdf_text(pdfurl), sep = " ", collapse = "~")
        closeAllConnections()
        
        # Check if pdf text is empty: implies pdf is image
        pdf_check <- gsub("~","", txt)
        
        # if pdf is image, perform image processing
        if(pdf_check == ""){
            
            cat("This pdf could be an image...\n")
            cat("Performing image recognition...\n")
            cat("This could take a little please be patient...\n")
            # Start by converting to image(s)
            try(images <- pdf_convert(pdf = pdfurl, format = "png", dpi = 400))
            closeAllConnections()
            txt <- NULL
            try(for(j in 1:length(images)){
                txt[j] <- ocr(image = images[j])
                cat("Completed extracting image:",j, "\n")
            })
            txt <- paste0(txt,sep = " ", collapse = "~")
            unlink(images)
            txt <- gsub("[^A-Za-z0-9 ]","",txt)
            cat("Completed image recognition...\n")
            
            # Perform a spellcheck using hunspell package at this point
            cat("Performing a spellcheck...\n")
            bad_words <- hunspell(txt)
            bad_words[[1]]
            suggestions <- hunspell_suggest(bad_words[1][[1]])
            # Get the first suggestion for each 'bad word'
            suggestions <- sapply(suggestions, function(x){
                return(x[1])})
            if(length(suggestions) > 0){
                conversion_table <- data.frame(bad_words = bad_words[1][[1]],
                                               suggestions = suggestions, stringsAsFactors = FALSE)
                # Don't keep NAs
                conversion_table <- conversion_table[complete.cases(conversion_table),]
                if (nrow(conversion_table) >0){
                    # Last step is to replace all bad words with the selected ones
                    for (replacing in 1:nrow(conversion_table)){
                        txt <- gsub(pattern = conversion_table$bad_words[replacing],
                                    replacement = conversion_table$suggestions[replacing],
                                    x = txt)}
                }
                
            }# End of spellcheck 
            cat("...completed spellcheck.\n")
            
        } # End of image recognition
        
        txt <- gsub("[^A-Za-z0-9 ]","",txt)
        # Remove the extra white space and convert to lowercase
        txt <- tolower(gsub("\\s+", " ", str_trim(txt)))
        #Attach the text extracted from pdf to other text features
        user_input$TEXT_FEATURES <- paste(user_input$TEXT_FEATURES,txt,sep = " ")    
        
        #cat(txt,"\n")   
        
    }# End of user PDF option
    
    return(user_input)
    
    #cat(input$pdf_file$datapath, "\n")
    #cat(user_input$DEVICENAME_PRIOR_CLEARANCE_TO_DATE, "\n")
    #cat(user_input$APPLICANT_PRIOR_CLEARANCE_TO_DATE, "\n")
    #cat(user_input$TEXT_FEATURES, "\n")
    
}
