tokenization <- function (docs, trans = c(T,T,T,T,T,T,T,T), ChartoSpace = c('/','@','\\|'),
              stopWords = 'english', ownStopWords = c(), profanity = data.frame()) {
    
    cat(paste('/nPlease wait for initializing and summrising the input files......'))
    require(tm); require(SnowballC)
    cat(paste('/nThere are', 'nchar(docs)', 'characters in input/unprocessed document!'))
    cat(summary(docs))
    cat(paste('/nStart tokenization processes...'))
    
    # Simple Transformation
    cat(paste('/nSimple Transformation:', trans[1]))
    if(trans[1] == T){
        toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
        for (i in ChartoSpace){
            docs <- tm_map(docs, toSpace, i)
            cat(paste('->Character:', i, 'has been transformed into white space!'))
        }
    }
    
    # Lowercase
    cat(paste('/nLowercase Transformation:', trans[2]))
    if(trans[2] == T){
        docs <- tm_map(docs, content_transformer(tolower))
        cat('->All CAPITAL characters have been transformed to lower cases!')
    }
    
    # Remove Numbers
    cat(paste('/nRemove Numbers:', trans[3]))
    if(trans[3] == T){
        docs <- tm_map(docs, removeNumbers)
        cat('->All NUMBERs have been eliminated from raw document!')
    }
    
    # Remove Punctuations
    cat(paste('/nRemove Punctuations:', trans[4]))
    if(trans[4] == T){
        docs <- tm_map(docs, removePunctuation)
        cat('->All Punctuations have been eliminated from raw document!')
    }
    
    # Remove English Stop Words
    cat(paste('/nRemove Stop Words:', trans[5]))
    if(trans[5] == T){
        cat(paste('->Remove', stopWords, 'Stop Words:'))
        cat(paste('->Stop Words including:' ))
        cat(stopwords(stopWords))
        cat(paste('->',length(stopwords(stopWords)), 'words in total'))
        docs <- tm_map(docs, removeWords, stopwords(stopWords))
        cat('->Stop Words have been eliminated from raw document!')
    }
    
    # Remove Own Stop Words
    cat(paste('/nRemove Own Stop Words:', trans[6]))
    if(trans[6] == T){
        cat(paste('->Remove Own Stop Words:'))
        cat(paste('->Stop Words including:' ))
        cat(ownStopWords)
        cat('->', paste(length(ownStopWords), 'words in total'))
        docs <- tm_map(docs, removeWords, ownStopWords)
        cat('->Own Stop Words have been eliminated from raw document!')
    }
    
    # Strip Whitespace
    cat(paste('/nStrip Whitespace:', trans[7]))
    if(trans[7] == T){
        docs <- tm_map(docs, stripWhitespace)
        cat('->Whitespaces have been stripped from raw document!')
    }
    
    # Specific Transformations/Profanity filtering
    cat(paste('/nSpecific Transformations/Profanity filtering:', trans[8]))
    if(trans[8] == T){
        toString <- content_transformer(function(x, from, to) gsub(from, to, x))
        for (i in nrow(profanity)){
            cat(paste('->Transfer', profanity[i,1], 'to', profanity[i,2]))
            docs <- tm_map(docs, toString, profanity[i,1], profanity[i,2])
        }
        cat('->Specific Transformations/Profanity filtering have been done to raw document!')
    }
    
    # Complete messages
    cat('/nDocument has been tokenized!')
    cat(summary(docs))
    return(docs)
}