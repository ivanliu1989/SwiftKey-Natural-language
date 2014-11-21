ngramify <- function(split_num=100, ngram_df, grams = 3){
    require(RWeka)
    cat(paste('Input data frame (rows:',nrow(ngram_df), '| size:',round(object.size(ngram_df)/1024/1024,0),
              'mb) \n are going to split into', split_num, 'and', grams, 'grams prediction chunks...'))
    cat(paste('\n (Step 1 of 5) Start to create chunks...'))
    
    chunks <- list()
    for (i in 1:split_num){
        chunks[[i]] <- ngram_df[(ceiling(nrow(ngram_df)/split_num)*(i-1)+1):(ceiling(nrow(ngram_df)/split_num)*i),1]
    } 
    rm(ngram_df); gc()
    
    cat(paste('\n (Step 2 of 5) Start to convert chunks into n-grams matrix...'))
    ngram_chunks <- list()
    for (j in 1:split_num){
        ngram_chunks[[j]] <- NGramTokenizer(chunks[[j]], Weka_control(min=grams,max=grams))    
    }
    rm(chunks); gc()
    
    cat(paste('\n (Step 3 of 5) Start to integrate chunks into one matrix...'))
    ngram_chunks_all <- c()
    for (z in 1:split_num){
        ngram_chunks_all <- c(ngram_chunks_all, ngram_chunks[[z]])
    }
    rm(ngram_chunks); gc()
    
    cat(paste('\n (Step 4 of 5) Start to calculate the frequency of each term...'))
    ngram_freq_tb <- sort(table(ngram_chunks_all), decreasing=T)
    rm(ngram_chunks_all); gc()
    
    cat(paste('\n (Step 5 of 5) Finishing the process...'))
    ngram_pred <- data.frame(terms = names(ngram_freq_tb), freq = ngram_freq_tb, row.names = NULL, stringsAsFactors = F)
    rm(ngram_freq_tb); gc()
    
    return(ngram_pred)
}
