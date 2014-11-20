###########################
### Tasks to accomplish ###
###########################
# 1. Build a predictive model based on the previous data modeling steps - 
# you may combine the models in any way you think is appropriate.
# 2. Evaluate the model for efficiency and accuracy - use timing software to evaluate the computational complexity of your model. 
# Evaluate the model accuracy using different metrics like perplexity, accuracy at the first word, second word, and third word.

#############################
### Questions to consider ###
#############################
# 1. How does the model perform for different choices of the parameters and size of the model? 
# 2. How much does the model slow down for the performance you gain?
# 3. Does perplexity correlate with the other measures of accuracy?
# 4. Can you reduce the size of the model (number of parameters) without reducing performance? 

##############
### Script ###
##############
require(stringr)
input <- 'How are you?'
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
    
    return(word)
}
predictNgrams(input)

################
### Script 2 ###
################
# grab a coffee, this bit takes a while...
N4T <- as.data.table(table(ngram))
setnames(N4T, 'N', 'freq')
N4T[,ngram:=strsplit(ngram, '\\s')]
N4T[, `:=`(w1=sapply(ngram, function(s) s[1]),
           w2=sapply(ngram, function(s) s[2]),
           w3=sapply(ngram, function(s) s[3]),
           w4=sapply(ngram, function(s) s[4]),
           ngram=NULL)]
setkeyv(N4T, c('w1', 'w2', 'w3', 'freq'))
system.time(icegrams <- N4T[list('i', 'love', 'ice')])
user  system elapsed 
0.004   0.000   0.005 
> icegrams
w1   w2  w3 freq    w4
1:  i love ice    1  cold
2:  i love ice    1 cream
> system.time({
    N3T <- N4T[, sum(freq), by=c('w1', 'w2', 'w3')]
    setnames(N3T, c('V1'), c('freq'))
    setkeyv(N3T,  c('w1', 'w2', 'freq'))
})
user  system elapsed 
6.636   0.514   7.148
