reticulate::use_virtualenv('510kTimelinePredictor', required = T)
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

source("./functions/load_vresults.R")
source("./functions/collect_user_input.R")
source("./functions/plot_productcode.R")
source("./functions/plot_review_adv.R")

vresults <- load_vresults()


