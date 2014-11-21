#######################
### Set Environment ###
#######################
setwd('H:/Machine_Learning/SwiftKey/')
setwd('C:\\Users\\Ivan.Liuyanfeng\\Desktop\\Data_Mining_Work_Space\\SwiftKey')
setwd('/Users/ivan/Work_directory/SwiftKey')
Sys.setenv(JAVA_HOME="C:\\Program Files\\Java\\jre7\\")

rm(list=ls(all=TRUE));gc(reset=TRUE);par(mfrow=c(1,1))
require(tm); require(SnowballC); require(stringr);require(RWeka); 
require(qdap); require(scales); require(gridExtra); require(data.table)

##################
## Test Predict ##
##################
load('completed/Trigrams_completed.RData')

Trigram_all <- as.data.table(Trigram_all)
input <- 'how are'
system.time(predict <- Trigram_all[Trigram_all$terms == input, ])
system.time(predict <- match(input, Trigram_all$terms))
predict

###################
## Split Columns ##
###################
load('completed/Trigrams_all_freq_cleaned.RData') # 6231160
class(Trigram_all$term)
Trigram_all$term <- as.character(Trigram_all$term)
Trigram_all <- as.data.table(Trigram_all)
rm(ngram_pred)

Trigram_all[,ngram:=strsplit(term, '\\s')]
Trigram_all[, `:=`(w1=sapply(ngram, function(s) s[1]),
                    w2=sapply(ngram, function(s) s[2]),
                    # w3=sapply(ngram, function(s) s[3]),
                    # w4=sapply(ngram, function(s) s[4]),
                   term=NULL, ngram=NULL)]
Trigram_all <- as.data.frame(Trigram_all)

head(Trigram_all); dim(Trigram_all); object.size(Trigram_all)

    Trigram_all_clean <- str_replace_all(Unigrams_all$w1, "[^a-z]", NA)
    length(Trigram_all_clean[is.na(Trigram_all_clean)])
    Unigrams_all[is.na(Trigram_all_clean),]
    Unigrams_all <- Unigrams_all[!is.na(Trigram_all_clean),]

save(Trigram_all, file='completed/Trigrams_completed.RData')

##########################
## Probabilities Matrix ##
##########################
load('completed/Trigrams_completed.RData')
head(Trigram_all); dim(Trigram_all); object.size(Trigram_all)
Trigram_all <- data.table(Trigram_all)

Bigrams_all <- Bigrams_all[, `:=`(terms = paste(w1,w2,sep=' '), 
                           w1=NULL, w2=NULL)]
setnames(Trigram_all, c('freq', 'term'))
save(Trigram_all, file='completed/Trigrams_completed_trimmed.RData')

# only keep top 10 of each term
vocabulary <- names(table(Trigram_all$term))
Trigram_all <- as.data.frame(Trigram_all)

Trigram_all_trimmed <- data.frame(freq=NULL,pred=NULL,term=NULL)
# for (i in vocabulary){
#     row <- ifelse(nrow(Trigram_all[which(Trigram_all$term==i),])<10,nrow(Trigram_all[which(Trigram_all$term==i),]),10)
#     Trigram_all_trimmed <- rbind(Trigram_all_trimmed, Trigram_all[which(Trigram_all$term==i),][1:row,])
# }
# for (i in 1:nrow(Trigram_all)){
#     Trigram_all$p[i] <- Trigram_all[i,1]/sum(Trigram_all[which(Trigram_all$term==Trigram_all[i,3]),1])
# }

### predict time ###
setkeyv(Trigram_all, c( 'w1','w2','w3','freq'))
Trigram_all[list('how', 'are', 'you')]
system.time(a <- tail(Trigram_all[list('how are')]))
