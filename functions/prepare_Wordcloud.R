#################################################################################################
# Author: Ozan Aygun
# Description: Function to prepare a WordCloud from given text vector (Corpus)
#################################################################################################

prepare_Wordcloud <- function(wtext){
  
  wtext <- wtext
  docs <- Corpus(VectorSource(wtext))
  docs <- tm_map(docs, removeWords, stopwords("english"))
  dtm <- TermDocumentMatrix(docs)
  dtm <- removeSparseTerms(dtm,0.99)
  m <- as.matrix(dtm)
  v <- sort(rowSums(m), decreasing = TRUE)
  d <- data.frame(word = names(v), freq = v)
  set.seed(1234)
  par(mar = c(0,0,0,0))
  wordcloud(words = d$word, freq = d$freq, min.freq = 5, max.words = 300,scale=c(4,.01),
            random.order = FALSE,rot.per = 0.45,colors = brewer.pal(8,"Dark2"))
  
}