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

################
### Script 3 ###
################
setwd('H:/Machine_Learning/SwiftKey/')
setwd('C:\\Users\\Ivan.Liuyanfeng\\Desktop\\Data_Mining_Work_Space\\SwiftKey')
setwd('/Users/ivan/Work_directory/SwiftKey')
Sys.setenv(JAVA_HOME="C:\\Program Files\\Java\\jre7\\")

rm(list=ls(all=TRUE));gc(reset=TRUE);par(mfrow=c(1,1))
require(tm); require(SnowballC); require(stringr);require(RWeka); 
require(qdap); require(scales); require(gridExtra); require(data.table)

load('completed/Quatrgrams_completed.RData') 
load('completed/Trigrams_completed.RData') 
load('completed/Bigrams_completed.RData') 
load('completed/Unigrams_completed.RData') 

save(Bigrams_all,Quatrgrams_all,Trigram_all,Unigrams_all,file='completed/ngrams_completed_matrix.RData')
load('completed/ngrams_completed_matrix.RData') 

dim(Unigrams_all); dim(Bigrams_all); dim(Trigram_all); dim(Quatrgrams_all)
head(Unigrams_all);head(Bigrams_all);head(Trigram_all);head(Quatrgrams_all)

Trigram_all<-as.data.table(Trigram_all)
Trigram_all[,ngram:=strsplit(term, '\\s')]
Trigram_all[, `:=`(w1=sapply(ngram, function(s) s[1]),
                      w2=sapply(ngram, function(s) s[2]),
#                       w3=sapply(ngram, function(s) s[3]),
#                       w4=sapply(ngram, function(s) s[4]),
                      term=NULL, ngram=NULL)]
setnames(Unigrams_all, c('freq', 'pred'))
setnames(Bigrams_all, c('freq', 'w1', 'pred'))
setnames(Trigram_all, c('freq', 'pred', 'w1','w2'))
setnames(Quatrgrams_all, c('freq','w1','w2','w3', 'pred'))

object.size(Unigrams_all)
Unigrams_all <- Unigrams_all[1:10,]
save(Bigrams_all,Quatrgrams_all,Trigram_all,Unigrams_all,file='completed/ngrams_model.RData')
Quatrgrams_all <- as.data.table(Quatrgrams_all)


###########################
### Prediction Modeling ###
###########################
setkeyv(Bigrams_all, c('w1','freq','pred'))
setkeyv(Trigram_all, c('w1','w2','freq','pred'))
setkeyv(Quatrgrams_all, c('w1','w2','w3', 'freq', 'pred'))

system.time(predict <- Quatrgrams_all[list('how', 'are', 'you')])
predict

require(stringr)
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
        ngram <- Quatrgrams_all[list(W1, W2, W3)]
        predict <- head(trigram[order(trigram$freq, decreasing=T),]$pred)
        
        if(length(predict)<6){
            ##bigram
            ngram <- Trigram_all[list(W2, W3)]
            predict <- c(predict,head(ngram[order(ngram$freq, decreasing=T),]$pred))    
        }
        
        if(length(predict)<6){
            ##unigram
            ngram <- Bigrams_all[list(W3)]
            predict <- c(predict,head(ngram[order(ngram$freq, decreasing=T),]$pred))    
        }
        
        predict <- predict[!is.na(predict)]
        
        if(length(predict)<5){
            predict <- c(predict, Unigrams_all$pred[1:5])
        }
    }    
    return(predict)
}

input <- 'tell me something about'

system.time(result <- predictNgrams(input))
result





