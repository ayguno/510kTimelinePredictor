library(shiny)
library(shinymaterial)

ui <- material_page(
    title = " 510k Timeline Predictor",
    tags$h3("Page Content"),
    nav_bar_color = "deep-purple darken-3",
    
    tags$head(
        tags$style(HTML("h6 {color: #2e1baa; font-weight: bold}"))
    ),
    
    material_row(
    
        # Column to keep inputs
        material_column(width = 4,
            
            material_card(title = "Tell me a little bit about this product",
                          depth = 5,
                tags$h6("About the device:"),
                material_slider(input_id = "dev_prior", 
                                    label = "Number of prior submissions about this device",
                                    initial_value = 0, min_value = 0, max_value = 500),
                
                material_text_box(input_id = "keywords",label = "Keywords about the device (e.g: Device Name, Intended Use)"),
                
                tags$h6("About the sponsor:"),
                material_slider(input_id = "sp_prior", 
                                label = "Number of prior submissions from this sponsor",
                                initial_value = 0, min_value = 0, max_value = 500, color = "#ef5350"),
                
                
                tags$h6("About the anticipated submission:"),
        
                material_radio_button(input_id = "sub_type",
                                      label = "Type of 510k",
                                      choices = c("Traditional" = "traditional",
                                                  "Special" = "special")),
                
                material_dropdown(input_id = "pr_code",label = "Product code", selected = "|GZB| : Stimulator, Spinal-Cord, Implanted (Pain Relief)",
                                  choices = c("Unknown",unique(vresults$pcode_name))),
                
                material_dropdown(input_id = "review_code",label = "Review Advisery Committee", selected = "|SU| : General Plastic Surgery",
                                  choices = c(unique(vresults$REVIEWADVISECOMM))),
                
                material_dropdown(input_id = "class_code",label = "Class Advisery Committee", selected = "|NE| : Neurology",
                                  choices = c(unique(vresults$CLASSADVISECOMM))),
                
                material_file_input(input_id = "pdf_file", label = "Upload PDF", color = "INDIGO"),
                
                # Switch to start new predictions
                material_button(input_id = "switch", label = "Predict Time!", depth = 5,color = "purple accent-3", icon = "update")
                
               
                          
            )
        ),
        
        # Column to present plot
        material_column(width = 4,
                        
                        material_card(title = "",
                                      depth = 5,
                        
                        plotlyOutput(outputId = "pred_plot"),
                        tags$br(),
                        htmlOutput(outputId = "subtitle1"),
                        htmlOutput(outputId = "subtitle2")
                                      
                        )
                        
        ),
        
        # Column to provide some metrics
        material_column(width = 4,
                        
                        material_card(title = "This process might take...",
                                      depth = 5
                        )
        )
        
    )
)


