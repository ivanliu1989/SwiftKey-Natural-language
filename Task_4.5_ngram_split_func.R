load('data_18_Nov_2014/blog_df.RData')
c <- 100
chunks <- list()
for (i in 1:c){
    chunks[[i]] <- stem_df[(ceiling(nrow(stem_df)/c)*(i-1)+1):(ceiling(nrow(stem_df)/c)*i),1]
} 
ngram_chunks <- list()
for (j in 1:c){
    ngram_chunks[[j]] <- NGramTokenizer(chunks[[j]], Weka_control(min=3,max=3))    
}
ngram_chunks_all <- c()
for (z in 1:c){
    ngram_chunks_all <- c(ngram_chunks_all, ngram_chunks[[z]])
}
length(ngram_chunks_all); object.size(ngram_chunks_all); gc()
ngram_freq_tb <- table(ngram_chunks_all)