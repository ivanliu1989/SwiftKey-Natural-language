tokenization <- function (docs, trans = c(T,T,T,T,T,T,T,T), ChartoSpace = c('/','@','\\|'),
              stopWords = 'english', ownStopWords = c(), profanity = data.frame()) {
    
    cat(paste('\nPlease wait for initializing and summrising the input files......'))
    require(tm); require(SnowballC)
    cat(paste('\nDocuments below will be processed soon!\n'))
    print(summary(docs))
    cat(paste('\nStart tokenization processes...'))
    
    # cat(paste('\nuse the utf8 encoding on the macintosh without the need to recompile...'))
    # tm_map(docs, function(x) iconv(x, to='UTF-8-MAC', sub='byte'))
    # tm_map(docs, function(x) iconv(enc2utf8(x), sub = "byte"))
    
    # Simple Transformation
    cat(paste('\n\n1.Simple Transformation:', trans[1]))
    if(trans[1] == T){
        toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
        for (i in ChartoSpace){
            docs <- tm_map(docs, toSpace, i)
            cat(paste('\n ->Character:', i, 'has been transformed into white space!'))
        }
    }
    # Specific Transformations/Profanity filtering
    cat(paste('\n8.Specific Transformations/Profanity filtering:', trans[8]))
    if(trans[8] == T){
        cat(paste('\n', nrow(profanity), 'words will be filtered, following is a sample of the words:\n'))
        print(head(profanity,5))
        toString <- content_transformer(function(x, from, to) gsub(from, to, x))
        for (i in 1:nrow(profanity)){
            # cat(paste('\n ->Transfer', profanity[i,1], 'to', profanity[i,2]))
            docs <- tm_map(docs, toString, profanity[i,1], profanity[i,2])
        }
        cat('\n ->Specific Transformations/Profanity filtering have been done to raw document!')
    }
    # Lowercase
    cat(paste('\n2.Lowercase Transformation:', trans[2]))
    if(trans[2] == T){
        docs <- tm_map(docs, content_transformer(tolower))
        cat('\n ->All CAPITAL characters have been transformed to lower cases!')
    }
    
    # Remove Numbers
    cat(paste('\n3.Remove Numbers:', trans[3]))
    if(trans[3] == T){
        docs <- tm_map(docs, removeNumbers)
        cat('\n ->All NUMBERs have been eliminated from raw document!')
    }
    
    # Remove Punctuations
    cat(paste('\n4.Remove Punctuations:', trans[4]))
    if(trans[4] == T){
        docs <- tm_map(docs, removePunctuation)
        cat('\n ->All Punctuations have been eliminated from raw document!')
    }
    
    # Remove English Stop Words
    cat(paste('\n5.Remove Stop Words:', trans[5]))
    if(trans[5] == T){
        cat(paste('\n->Remove', stopWords, 'Stop Words:'))
        cat(paste('\n->Stop Words including:\n' ))
        print(stopwords(stopWords))
        cat(paste('\n->',length(stopwords(stopWords)), 'words in total'))
        docs <- tm_map(docs, removeWords, stopwords(stopWords))
        cat('\n ->Stop Words have been eliminated from raw document!')
    }
    
    # Remove Own Stop Words
    cat(paste('\n6.Remove Own Stop Words:', trans[6]))
    if(trans[6] == T){
        cat(paste('\n ->Remove Own Stop Words:'))
        cat(paste('\n ->Stop Words including:\n'))
        print(ownStopWords)
        cat('\n ->', paste(length(ownStopWords), 'words in total'))
        docs <- tm_map(docs, removeWords, ownStopWords)
        cat('\n ->Own Stop Words have been eliminated from raw document!')
    }
    
    # Strip Whitespace
    cat(paste('\n7.Strip Whitespace:', trans[7]))
    if(trans[7] == T){
        docs <- tm_map(docs, stripWhitespace)
        cat('\n ->Whitespaces have been stripped from raw document!')
    }
    
   
    
    # Complete messages
    cat('\n\nDocument has been tokenized!')
    cat(summary(docs))
    return(docs)
}