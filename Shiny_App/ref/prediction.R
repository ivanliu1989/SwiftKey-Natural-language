library(stringr)
load("predict.rdata")

###prediction function
predict3gram <- function(input) {
    ###clean the input
    #remove numbers, punctuations
    word <- gsub("[^a-zA-Z\n\']", " ", input)
    #convert all words to lowercase
    word <- tolower(word)
    ##remove extra spaces
    trim <- function(x) return(gsub("^ *|(?<= ) | *$", "", x, perl=T))
    word<-trim(word)      
    
    
    str <- unlist(str_split(word," "))
    len <- length(str)
    
    if (len>=3){
        ##trigram 
        ngram<- paste(str[len-2],str[len-1],str[len])
        hit <- freq4gDF[freq4gDF$start == ngram,]
        sgt<-sgt4g
        
        if(nrow(hit)==0){
            ##bigram
            ngram<- paste(str[len-1],str[len])
            hit <- freq3gDF[freq3gDF$start == ngram,]
            sgt<-sgt3g
        }
        
        if(nrow(hit)==0){
            ##unigram 
            ngram<- paste(str[len])
            hit<- freq2gDF[freq2gDF$start == ngram,]
            sgt<-sgt2g
        }
    }
    
    if (len==2){
        ##bigram
        ngram<- paste(str[len-1],str[len])
        hit <- freq3gDF[freq3gDF$start == ngram,]
        sgt<-sgt3g
        
        
        if(nrow(hit)==0){
            ##unigram 
            ngram<- paste(str[len])
            hit<- freq2gDF[freq2gDF$start == ngram,]
            sgt<-sgt2g
        }    
    }
    
    
    if (len==1){
        ##unigram 
        ngram<- paste(str[len])
        hit<- freq2gDF[freq2gDF$start == ngram,]
        sgt<-sgt2g   
    }
    #if no hit for all of them, return "the"
    if(nrow(hit)==0){return(paste(input,"the"))}
    
    ###prediction
    hit$p <- sapply(hit$freq,FUN=function(x) sgt$p[sgt$r==x])
    # order by probability
    hit <- hit[with(hit,order(-p)),]
    
    return(paste('[', input, hit[1:5,]$end,'\n]'))
}