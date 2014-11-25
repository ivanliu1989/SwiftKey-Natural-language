require(stringr); require(data.table)

predictWordcloud <- function(input){
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
    
    predict <- data.frame(ngram.freq=0,ngram.pred="")
    
    if (len>=3){
        ##trigram 
        W1 <- str[len-2]; W2 <- str[len-1]; W3 <- str[len]
        ngram <- Quatrgrams_model[list(W1, W2, W3)]
        predict <- rbind(predict, data.frame(ngram$freq,ngram$pred))
        
        if(nrow(predict)<6){
            ##bigram
            ngram <- Trigrams_model[list(W2, W3)]
            predict <- predict <- rbind(predict, data.frame(ngram$freq,ngram$pred)) 
        }
        
        if(nrow(predict)<6){
            ##unigram
            ngram <- Bigrams_model[list(W3)]
            predict <- predict <- rbind(predict, data.frame(ngram$freq,ngram$pred))    
        }
        
    }else if(len==2){
        W1 <- str[len-1]; W2 <- str[len]
        ngram <- Trigrams_model[list(W1, W2)]
        predict <- predict <- rbind(predict, data.frame(ngram$freq,ngram$pred))
        
        if(nrow(predict)<6){
            ##unigram
            ngram <- Bigrams_model[list(W2)]
            predict <- predict <- rbind(predict, data.frame(ngram$freq,ngram$pred))    
        }
        
    }else if(len==1){
        W1 <- str[len]
        ngram <- Bigrams_model[list(W1)]
        predict <- predict <- rbind(predict, data.frame(ngram$freq,ngram$pred))
        
    }    
    
    if(nrow(predict)<5){
        ngram <- Unigrams_model
        predict <- data.frame(ngram$freq,ngram$pred)
    }
    return(predict)
}