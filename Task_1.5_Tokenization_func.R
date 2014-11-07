tokenization <- function (docs, trans = c(T,T,T,T,T,T,T,T), ChartoSpace = c('/','@','\\|'),
              stopWords = 'english', ownStopWords = c(), profanity = data.frame()) {
    
    print(paste('Please wait for initializing and summrising the input files......'))
    require(tm); require(SnowballC)
    print(paste('There are', 'nchar(docs)', 'characters in input/unprocessed document!'))
    summary(docs)
    print(paste('Start tokenization processes...'))
    
    # Simple Transformation
    print(paste('Simple Transformation:', trans[1]))
    if(trans[1] == T){
        toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
        for (i in ChartoSpace){
            docs <- tm_map(docs, toSpace, i)
            print(paste('Character:', i, 'has been transformed into white space!'))
        }
    }
    
    # Lowercase
    print(paste('Lowercase Transformation:', trans[2]))
    if(trans[2] == T){
        docs <- tm_map(docs, content_transformer(tolower))
        print('All CAPITAL characters have been transformed to lower cases!')
    }
    
    # Remove Numbers
    print(paste('Remove Numbers:', trans[3]))
    if(trans[3] == T){
        docs <- tm_map(docs, removeNumbers)
        print('All NUMBERs have been eliminated from raw document!')
    }
    
    # Remove Punctuations
    print(paste('Remove Punctuations:', trans[4]))
    if(trans[4] == T){
        docs <- tm_map(docs, removePunctuation)
        print('All Punctuations have been eliminated from raw document!')
    }
    
    # Remove English Stop Words
    print(paste('Remove Stop Words:', trans[5]))
    if(trans[5] == T){
        print(paste('Remove', stopWords, 'Stop Words:'))
        print(paste('Stop Words including:' ))
        stopwords(stopWords)
        print(length(stopwords(stopWords)), 'words in total')
        docs <- tm_map(docs, removeWords, stopwords(stopWords))
        print('Stop Words have been eliminated from raw document!')
    }
    
    # Remove Own Stop Words
    print(paste('Remove Own Stop Words:', trans[6]))
    if(trans[6] == T){
        print(paste('Remove Own Stop Words:'))
        print(paste('Stop Words including:' ))
        ownStopWords
        print(length(ownStopWords), 'words in total')
        docs <- tm_map(docs, removeWords, ownStopWords)
        print('Own Stop Words have been eliminated from raw document!')
    }
    
    # Strip Whitespace
    print(paste('Strip Whitespace:', trans[7]))
    if(trans[7] == T){
        docs <- tm_map(docs, stripWhitespace)
        print('Whitespaces have been stripped from raw document!')
    }
    
    # Specific Transformations/Profanity filtering
    print(paste('Specific Transformations/Profanity filtering:', trans[8]))
    if(trans[8] == T){
        toString <- content_transformer(function(x, from, to) gsub(from, to, x))
        for (i in nrow(profanity)){
            print(paste('Transfer', profanity[i,1], 'to', profanity[i,2]))
            docs <- tm_map(docs, toString, profanity[i,1], profanity[i,2])
        }
        print('Specific Transformations/Profanity filtering have been done to raw document!')
    }
    
    # Complete messages
    print('Document has been tokenized!')
    summary(docs)
}