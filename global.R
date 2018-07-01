if(!file.exists('oz5env')){
untar('oz5env.tar.xz')
}
if(!file.exists('functions')){
untar('functions.tar.xz')
}

reticulate::use_virtualenv('oz5env', required = T)
library(reticulate)
library(shiny)
library(shinymaterial)
library(dplyr)
library(ggplot2)
library(plotly)
library(hunspell)
library(pdftools)
library(stringr)
library(tesseract)
library(qdapRegex)
library(tm)
library(SnowballC)
library(wordcloud)
library(shinydashboard)

source("./functions/load_vresults.R")
source("./functions/collect_user_input.R")
source("./functions/plot_productcode.R")
source("./functions/plot_review_adv.R")
source("./functions/prepare_Wordcloud.R")
source("./functions/prepare_Barplot.R")

vresults <- load_vresults()


