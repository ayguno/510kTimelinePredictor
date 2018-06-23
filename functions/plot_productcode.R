#################################################################################################
# Author: Ozan Aygun
# Description: Function to prepare the plot based on product code
#################################################################################################

plot_productcode <- function(results,pcode){
    
    require(dplyr)
    require(ggplot2)
    subdata <- dplyr::filter(results, PRODUCTCODE == pcode)
    mae = round(median(subdata$Absolute_Error),2)
    edge = max(c(max(subdata$DECISIONTIME),max(subdata$preds_lgbm)))
    subdata$PREDICTION <- round(subdata$preds_lgbm,2)
    
    a <- subdata$KNUMBER
    b <- subdata$DEVICENAME
    c <- subdata$DECISIONTIME
    d <- subdata$PREDICTION
    
    p<- ggplot(data = subdata)+
        geom_point(data = subdata,color = "navy", size = 4,alpha = 0.5, 
                   aes(x = PREDICTION, y = DECISIONTIME,
                       text = sprintf("KNUMBER: %s<br>DEVICENAME: %s", a,b)))+
        geom_abline(x = c(0,0), y = c(1000,1000), linetype = "dashed", size = 1, color = "magenta")+
        ylim(0, edge + 10)+
        xlim(0, edge + 10)+
        xlab(label = "Model predictions (calendar days)")+
        ylab(label = "Real Decision time (calendar days)")+
        labs(title = "Current predictions for similar devices")+
        theme(
            axis.text = element_text(size = 8, face = "bold", colour = "navy"),
            axis.title = element_text(size = 15, face = "bold", colour = "navy"),
            plot.title = element_text(size = 18, face = "bold", colour = "navy", hjust = 0.5),
            plot.subtitle = element_text(size = 12, face = "bold", colour = "navy", hjust = 0.5),
            panel.background = element_rect(fill = "slategray1"),
            panel.border = element_rect(color = "navy", fill = NA),
            panel.grid.major = element_line(size = 0.05, colour = "grey", linetype = "dotted"),
            panel.grid.minor = element_blank()
        )
    
     plist <- list(p = p, mae = mae)
     return(plist)
}