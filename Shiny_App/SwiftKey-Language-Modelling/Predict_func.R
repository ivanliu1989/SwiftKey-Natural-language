require(stringr); require(data.table)

predictNgrams <- function(input){
    ## clean input text
    # remove numbers, punctuations
    word <- gsub("[^a-zA-Z\n\']", " ", input)
    # convert all words to lowercase
    word <- tolower(word)
    # remove extra spaces
    trim <- function(x) return(gsub("^ *|(?<= ) | *$", "", x, perl=T))
    word<-trim(word)      
    
    str <- unlist(str_split(word," "))
    len <- length(str)
    
    predict <- c()
    
    if (len>=3){
        ##trigram 
        W1 <- str[len-2]; W2 <- str[len-1]; W3 <- str[len]
        ngram <- Quatrgrams_model[list(W1, W2, W3)]
        predict <- head(ngram[order(ngram$freq, decreasing=T),]$pred)
        
        if(length(predict)<6){
            ##bigram
            ngram <- Trigrams_model[list(W2, W3)]
            predict <- c(predict,head(ngram[order(ngram$freq, decreasing=T),]$pred))    
        }
        
        if(length(predict)<6){
            ##unigram
            ngram <- Bigrams_model[list(W3)]
            predict <- c(predict,head(ngram[order(ngram$freq, decreasing=T),]$pred))    
        }
        
    }else if(len==2){
        W1 <- str[len-1]; W2 <- str[len]
        ngram <- Trigrams_model[list(W1, W2)]
        predict <- head(ngram[order(ngram$freq, decreasing=T),]$pred)
        
        if(length(predict)<6){
            ##unigram
            ngram <- Bigrams_model[list(W2)]
            predict <- c(predict,head(ngram[order(ngram$freq, decreasing=T),]$pred))    
        }
        
    }else if(len==1){
        W1 <- str[len]
        ngram <- Bigrams_model[list(W1)]
        predict <- head(ngram[order(ngram$freq, decreasing=T),]$pred)
        
    }    
    
    predict <- predict[!is.na(predict)]
    
    if(length(predict)<5){
        predict <- c(predict, Unigrams_model$pred)
    }
    return(predict[1:5])
}