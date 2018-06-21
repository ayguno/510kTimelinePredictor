library(shiny)
library(shinymaterial)

ui <- material_page(
    title = " 510k Timeline Predictor",
    tags$h3("Page Content"),
    nav_bar_color = "deep-purple darken-3",
    
    material_row(
    
        # Column to keep inputs
        material_column(width = 4,
            
            material_card(title = "Tell me a little bit about your product",
                          depth = 5,
                material_number_box(input_id = "sub_prior", 
                                    label = "Number of prior submissions about this device",
                                    initial_value = 0, min_value = 0, max_value = 1000),
                material_radio_button(input_id = "sub_type",
                                      label = "Type of 510k",
                                      choices = c("Traditional" = "Traditional",
                                                  "Special" = "Special"))
                          
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

server <- function(input, output) {
    
}

shinyApp(ui = ui, server = server)