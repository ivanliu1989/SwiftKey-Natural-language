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
load('data_18_Nov_2014/ngrams/Trigrams_all_freq_cleaned.RData')

input <- 'how are you'
system.time(predict <- Unigrams_all[Unigrams_all$terms == input, ])
predict[1:5, ]

###################
## Split Columns ##
###################
load('completed/Trigrams_all_freq_cleaned.RData') # 6231160
class(Unigrams_all$terms)
Unigrams_all$terms <- as.character(Unigrams_all$terms)
Trigram_all <- as.data.table(Unigrams_all)
rm(Unigrams_all)
Trigram_all[,ngram:=strsplit(terms, '\\s')]
Trigram_all[, `:=`(w1=sapply(ngram, function(s) s[1]),
                   w2=sapply(ngram, function(s) s[2]),
                   w3=sapply(ngram, function(s) s[3]),
                   terms=NULL, ngram=NULL)]
Trigram_all <- as.data.frame(Trigram_all)

head(Trigram_all); dim(Trigram_all); object.size(Trigram_all)
Trigram_all_clean <- str_replace_all(Trigram_all$w3, "[^a-z]", NA)
length(Trigram_all_clean[is.na(Trigram_all_clean)])
Trigram_all[is.na(Trigram_all_clean),]
Trigram_all <- Trigram_all[!is.na(Trigram_all_clean),]

save(Trigram_all, file='completed/Trigrams_completed.RData')
