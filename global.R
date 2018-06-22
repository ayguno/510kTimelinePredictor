library(shiny)
library(shinymaterial)
library(dplyr)
require(hunspell)
require(pdftools)
require(stringr)
require(tesseract)

source("./functions/load_vresults.R")
source("./functions/collect_user_input.R")

vresults <- load_vresults()




