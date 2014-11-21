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
load('data_18_Nov_2014/ngrams/Unigrams_All_cleaned.RData')

input <- 'how are you'
system.time(predict <- Unigrams_all[Unigrams_all$terms == input, ])
match(input, Unigrams_all$terms)
predict[1:5, ]

###################
## Split Columns ##
###################
load('completed/Trigrams_all_freq_cleaned.RData') # 6231160
class(Unigrams_all_cleaned$terms)
Unigrams_all_cleaned$terms <- as.character(Unigrams_all_cleaned$terms)
Unigrams_all <- as.data.table(Unigrams_all_cleaned)
rm(Unigrams_all_cleaned)

Unigrams_all[,ngram:=strsplit(terms, '\\s')]
Unigrams_all[, `:=`(w1=sapply(ngram, function(s) s[1]),
                   terms=NULL, ngram=NULL)]
Unigrams_all <- as.data.frame(Unigrams_all)

head(Unigrams_all); dim(Unigrams_all); object.size(Unigrams_all)
Trigram_all_clean <- str_replace_all(Unigrams_all$w1, "[^a-z]", NA)
length(Trigram_all_clean[is.na(Trigram_all_clean)])
Unigrams_all[is.na(Trigram_all_clean),]
Unigrams_all <- Unigrams_all[!is.na(Trigram_all_clean),]

save(Unigrams_all, file='completed/Unigrams_completed.RData')
