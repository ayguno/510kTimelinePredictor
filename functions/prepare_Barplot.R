#################################################################################################
# Author: Ozan Aygun
# Description: Function to prepare a Barplot of most frequent words from given text vector (Corpus)
#################################################################################################

prepare_Barplot <- function(wtext){
  
  wtext <- wtext
  docs <- Corpus(VectorSource(wtext))
  docs <- tm_map(docs, removeWords, stopwords("english"))
  dtm <- TermDocumentMatrix(docs)
  dtm <- removeSparseTerms(dtm,0.99)
  m <- as.matrix(dtm)
  v <- sort(rowSums(m), decreasing = TRUE)
  d <- data.frame(word = names(v), freq = v)
  par(mar = c(4,7,0,4))
  bp <- barplot(d[1:15,]$freq, las = 2, 
                names.arg = d[1:15,]$word,
                col = 'navy', font = 2, 
                xlab = "Word Counts", 
                horiz = T, xlim = c(0,max(d[1:15,]$freq + max(d[1:15,]$freq)/5 )))
  text(y = bp, x = d[1:15,]$freq + 0.5, label = d[1:15,]$freq, pos = 4, cex = 1.0, col = "magenta", font = 2)
  
}