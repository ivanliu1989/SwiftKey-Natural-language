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
class(ngram_pred$terms)
Unigrams_all_cleaned$terms <- as.character(Unigrams_all_cleaned$terms)
Quatrgrams_blog <- as.data.table(ngram_pred)
rm(ngram_pred)

Quatrgrams_blog[,ngram:=strsplit(terms, '\\s')]
Quatrgrams_blog[, `:=`(w1=sapply(ngram, function(s) s[1]),
                    w2=sapply(ngram, function(s) s[2]),
                    w3=sapply(ngram, function(s) s[3]),
                    w4=sapply(ngram, function(s) s[4]),
                   terms=NULL, ngram=NULL)]
Quatrgrams_blog <- as.data.frame(Quatrgrams_blog)

head(Quatrgrams_blog); dim(Quatrgrams_blog); object.size(Quatrgrams_blog)
Trigram_all_clean <- str_replace_all(Unigrams_all$w1, "[^a-z]", NA)
length(Trigram_all_clean[is.na(Trigram_all_clean)])
Unigrams_all[is.na(Trigram_all_clean),]
Unigrams_all <- Unigrams_all[!is.na(Trigram_all_clean),]

save(Unigrams_all, file='completed/Unigrams_completed.RData')

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
for (i in vocabulary){
    Trigram_all_trimmed <- rbind(Trigram_all_trimmed, Trigram_all[which(Trigram_all$term==i),][1:10,])
}
for (i in 1:nrow(Traingram_all_trimmed)){
    Trigram_all_trimmed$p <- Trigram_all_trimmed[i,1]/sum(Trigram_all[which(Trigram_all$term==i),1])
}
