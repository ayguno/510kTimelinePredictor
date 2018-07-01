reticulate::use_virtualenv('oz5env', required = T)
library(reticulate)
library(shiny)
library(shinymaterial)

ui <- material_page(
    title = " 510k Timeline Predictor",
    tags$h3("Page Content"),
    nav_bar_color = "deep-purple darken-3",
    
    tags$head(
        tags$style(HTML("h6 {color: #2e1baa; font-weight: bold;
                            }.shiny-notification {
                                              background-color:#360160;
                                              color: #fff;
                                              font-size: 15pt;
                                              height: 100px;
                                              width: 700px;
                                              position:fixed;
                                              top: calc(50% - 50px);;
                                              left: calc(60% - 400px);;
                                            }
                        
                        "))
    ),
    
    material_row(
    
        # Column to keep inputs
        material_column(width = 5,
            
            material_card(title = "Tell me a little bit about this product",
                          depth = 5,
                          
                material_row(
                  
                    material_column(width = 6,
                      material_card(depth = 5,
                        tags$h6("About the device:"),
                        material_slider(input_id = "dev_prior", 
                                            label = "Prior submissions about this device",
                                            initial_value = 0, min_value = 0, max_value = 500, color = "#aa2ef7")
                       
                       
                    )),
                    material_column(width = 6,
                      material_card(depth = 5,              
                        tags$h6("About the sponsor:"),
                        material_slider(input_id = "sp_prior", 
                                        label = "Prior submissions from this sponsor",
                                        initial_value = 0, min_value = 0, max_value = 500, color = "#aa2ef7")
                    )
                
                )),
               
                material_card(depth = 5, 
                tags$h6("About the anticipated submission:"),
                material_row(
                   
                        material_column(width = 9,
                            material_text_box(input_id = "keywords",color = "#aa2ef7",
                                              label = "Keywords about the device (e.g: Intended Use)")
                        ),
                        material_column(width = 3,
                            material_radio_button(input_id = "sub_type",color = "#aa2ef7",
                                                  label = "Type of 510k",
                                                  choices = c("Traditional" = "traditional",
                                                              "Special" = "special"))
                        )
                      
                ),
                
                
                material_dropdown(color = "#aa2ef7",input_id = "pr_code",label = "Product code", selected = "|GZB| : Stimulator, Spinal-Cord, Implanted (Pain Relief)",
                                  choices = c("Unknown",unique(vresults$pcode_name))),
                
                material_row(
                
                  material_column(width = 6,
                    material_dropdown(color = "#aa2ef7",input_id = "review_code",label = "Review Advisery Committee", selected = "|SU| : General Plastic Surgery",
                                      choices = c(unique(vresults$REVIEWADVISECOMM)))
                  ),
                  
                  material_column(width = 6,
                    material_dropdown(color = "#aa2ef7",input_id = "class_code",label = "Class Advisery Committee", selected = "|NE| : Neurology",
                                      choices = c(unique(vresults$CLASSADVISECOMM)))
                  )  
                
                )),
                material_row(
                  
                  material_column(width = 5,
                
                    material_file_input(input_id = "pdf_file", label = "Upload PDF", color = "INDIGO")
                  ),
                  material_column(width = 1,{}
                  ),                
                  material_column(width = 6,
                    # Switch to start new predictions
                    material_button(input_id = "switch", label = "Predict Time!", depth = 5,color = "purple accent-3", icon = "update")
                  )
                )
                          
            )
        ),
        
        # Column to present plot
        material_column(width = 4,
                        
                        material_card(title = "",
                                      depth = 5,
                        
                        plotlyOutput(outputId = "pred_plot",height = 350),
                        tags$br(),
                        htmlOutput(outputId = "subtitle1"),
                        htmlOutput(outputId = "subtitle2")
                                      
                        ),

                        material_card(title = "This process might take...",
                                       depth = 5,
                                 material_row(  
                                       material_column(width = 3,
                                        icon('calendar')
                                       ),
                                       material_column(width = 9,
                                         htmlOutput(outputId = "prediction")
                                       )
                                 )    
                        )
                        
                        
        ),
        
        # Column to provide wordcloud and barplot 
         material_column(width = 3,
                        material_card(title = "",
                                      depth = 5,
                                      material_row(material_column(width = 1,{icon('cloud')}),
                                                   material_column(width = 10,tags$h6("Word cloud from text processing")),
                                                   material_column(width = 1,{})
                                      ),
                                      plotOutput(outputId = "Word_cloud", height = 250)
                                      #tags$br(),
                                      #htmlOutput(outputId = "subtitle1")
                                      #htmlOutput(outputId = "subtitle2")
                                      
                        ),
                        material_card(title = "",
                                      depth = 5,
                                      material_row(material_column(width = 1,{icon('bar-chart')}),
                                                   material_column(width = 10,tags$h6("Counts of most frequent words")),
                                                   material_column(width = 1,{})
                                      ),
                                      plotOutput(outputId = "Bar_plot", height = 250)
                                      #tags$br()
                                      #htmlOutput(outputId = "subtitle1"),
                                      #htmlOutput(outputId = "subtitle2")
                                      
                        )
                        
                        
        )
        
    )
)


