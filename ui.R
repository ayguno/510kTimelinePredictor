library(shiny)
library(shinymaterial)

ui <- material_page(
    title = " 510k Timeline Predictor",
    tags$h3("Page Content"),
    nav_bar_color = "deep-purple darken-3",
    
    material_row(
    
        # Column to keep inputs
        material_column(width = 4,
            
            material_card(title = "Tell me a little bit about this product",
                          depth = 5,
                tags$h6("About the device:"),
                material_slider(input_id = "dev_prior", 
                                    label = "Number of prior submissions about this device",
                                    initial_value = 0, min_value = 0, max_value = 500),
                
                material_slider(input_id = "dev_prior", 
                                label = "Number of prior submissions about this device",
                                initial_value = 0, min_value = 0, max_value = 500),
                
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
                                  choices = c("other",unique(vresults$pcode_name))),
                
                material_dropdown(input_id = "review_code",label = "Review Advisery Committee", selected = "Neurology",
                                  choices = c(unique(vresults$REVIEWADVISECOMM))),
                
                material_dropdown(input_id = "class_code",label = "Class Advisery Committee", selected = "Neurology",
                                  choices = c(unique(vresults$REVIEWADVISECOMM)))
                          
            )
        ),
        
        # Column to present plot
        material_column(width = 4,
                        
                        material_card(title = "Current predictions for similar devices",
                                      depth = 5
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


