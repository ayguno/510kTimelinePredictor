#################################################################################################
# Author: Ozan Aygun
# Description: Function to load validation results, and precess them in useful form for the app
#################################################################################################

load_vresults <- function(){
    
    require(dplyr)
    # Load validation results
    vresults <- readRDS("./datasets/validation_results_extended.rds")
    # Add a new pcode_name column
    vresults$pcode_name <- paste0("|",vresults$PRODUCTCODE,"|"," : ",vresults$PRODUCTCODENAME)
    
    # Retrieve Med Speciality Codes
    medspeciality <- read.csv("./datasets/MedSpeciality.csv", stringsAsFactors = F, header = T)
    names(medspeciality)[1] <- "Speciality"
    medspeciality$Speciality <- gsub(pattern = " |&|/|,","_",medspeciality$Speciality)
    medspeciality$Speciality <- gsub(pattern = "__|___","_",medspeciality$Speciality)
    medspeciality$code_speciality <- gsub("_|__"," ",paste0("|",medspeciality$Medical.Specialty.Code,"|"," : ",medspeciality$Speciality))
    medspeciality <- dplyr::select(medspeciality, -Regulation.No., -Medical.Specialty.Code)
    
    vresults$REVIEWADVISECOMM <- as.character(vresults$REVIEWADVISECOMM)
    vresults$CLASSADVISECOMM <- as.character(vresults$CLASSADVISECOMM)
    for(i in seq_along(medspeciality$Speciality)){
        scode <- medspeciality$Speciality[i]
        selector_REVIEWADVISECOMM <- which(vresults$REVIEWADVISECOMM == scode)   
        selector_CLASSADVISECOMM <- which(vresults$CLASSADVISECOMM == scode)
        vresults$REVIEWADVISECOMM[selector_REVIEWADVISECOMM] <- medspeciality$code_speciality[i]
        vresults$CLASSADVISECOMM[selector_CLASSADVISECOMM] <- medspeciality$code_speciality[i]
    }
    
    return(vresults)
    
}