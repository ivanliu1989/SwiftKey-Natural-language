ngramify <- function(split_num=100, ngram_df, grams = 3){
    require(RWeka)
    cat(paste('Input data frame (rows:',nrow(ngram_df), 'size:',object.size(ngram_df)/1024/1024,
              'mb \n are goint to split into', split_num, 'and', grams, 'grams prediction table...'))
    cat(paste('/n Start to create chunks...'))
    chunks <- list()
    for (i in 1:split_num){
        chunks[[i]] <- ngram_df[(ceiling(nrow(ngram_df)/split_num)*(i-1)+1):(ceiling(nrow(ngram_df)/split_num)*i),1]
    } 
    gc()
    cat(paste('/n Start to convert chunks into n-grams matrix...'))
    ngram_chunks <- list()
    for (j in 1:split_num){
        ngram_chunks[[j]] <- NGramTokenizer(chunks[[j]], Weka_control(min=grams,max=grams))    
    }
    gc()
    cat(paste('/n Start to integrate chunks into one matrix...'))
    ngram_chunks_all <- c()
    for (z in 1:split_num){
        ngram_chunks_all <- c(ngram_chunks_all, ngram_chunks[[z]])
    }
    gc()
    cat(paste('/n Start to calculate the frequency of each term...'))
    ngram_freq_tb <- sort(table(ngram_chunks_all), decreasing=T)
    gc()
    cat(paste('/n Finishing the process...'))
    ngram_pred <- data.frame(terms = names(ngram_freq_tb), freq = ngram_freq_tb)
    return(ngram_pred)
    
}
