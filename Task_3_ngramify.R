#######################
### Set Environment ###
#######################
setwd('H:/Machine_Learning/SwiftKey/')
setwd('C:\\Users\\Ivan.Liuyanfeng\\Desktop\\Data_Mining_Work_Space\\SwiftKey')
setwd('/Users/ivan/Work_directory/SwiftKey')
Sys.setenv(JAVA_HOME="C:\\Program Files\\Java\\jre7\\")

rm(list=ls(all=TRUE));gc(reset=TRUE);par(mfrow=c(1,1))
require(tm); require(SnowballC); require(data.table); require(stringr)
require(ggplot2); require(RWeka); require(qdap);
require(scales); require(gridExtra); require(wordcloud)

##################
### Get Corpus ###
##################
en_US <- file.path('.','final','en_US')
en_US_corpus <- Corpus(DirSource(en_US, encoding="UTF-8"), 
                       readerControl = list(reader = readPlain,language = "en_US",load = TRUE))
blog_corpus <- en_US_corpus[1]
news_corpus <- en_US_corpus[2]
twitter_corpus <- en_US_corpus[3]
# writeCorpus
save(blog_corpus, file='data_18_Nov_2014/Corpus/blog_corpus.RData')
save(news_corpus, file='data_18_Nov_2014/Corpus/news_corpus.RData')
save(twitter_corpus, file='data_18_Nov_2014/Corpus/twitter_corpus.RData')
object.size(en_US_corpus); gc()

###############################
### Tokenization & Stemming ###
###############################
load('data_18_Nov_2014/Corpus/blog_corpus.RData')
source('SwiftKey-Natural-language/func/Task_1.5_Tokenization_func.R')

trans <- c(F,T,T,T,F,F,T,T)
ChartoSpace <- c('/','\\|')
stopWords <- 'english'
ownStopWords <- c()
swearwords <- read.table('SwiftKey-Natural-language/profanity filter/en', sep='\n')
names(swearwords)<-'swearwords'
filter <- rep('***', length(swearwords))
profanity <- data.frame(swearwords, target = filter)
profanity <- rbind(profanity, data.frame(swearwords = c("[^[:alpha:][:space:]']","â ","ã","ð"), target = c(" ","'","'","'")))

tokenized_blog <- tokenization(blog_corpus, trans, ChartoSpace,
                               stopWords, ownStopWords, profanity)
tokenized_news <- tokenization(news_corpus, trans, ChartoSpace,
                               stopWords, ownStopWords, profanity)
tokenized_twitter <- tokenization(twitter_corpus, trans, ChartoSpace,
                                  stopWords, ownStopWords, profanity)
save(tokenized_blog, file='data_18_Nov_2014/tokenized/blog_tokenized.RData')
save(tokenized_news, file='data_18_Nov_2014/tokenized/news_tokenized.RData')
save(tokenized_twitter, file='data_18_Nov_2014/tokenized/twitter_tokenized.RData')

# stem_blog <- tm_map(tokenized_blog, stemDocument, 'english') # SnowballStemmer
# stem_news <- tm_map(tokenized_news, stemDocument, 'english') # SnowballStemmer
# stem_twitter <- tm_map(tokenized_twitter, stemDocument, 'english') # SnowballStemmer
# save(stem_blog, file='data_18_Nov_2014/stemming/blog_stemming.RData')
# save(stem_news, file='data_18_Nov_2014/stemming/news_stemming.RData')
# save(stem_twitter, file='data_18_Nov_2014/stemming/twitter_stemming.RData')


##############################
### Transfer to Data Frame ###
##############################
load('data_18_Nov_2014/tokenized/twitter_tokenized.RData')

stem_df_blog <- data.frame(text=unlist(sapply(tokenized_docs, '[',"content")),stringsAsFactors=F)
stem_df_news <- data.frame(text=unlist(sapply(tokenized_news, '[',"content")),stringsAsFactors=F)
stem_df_twitter <- data.frame(text=unlist(sapply(tokenized_twitter, '[',"content")),stringsAsFactors=F)
save(stem_df_blog, file='data_18_Nov_2014/df/blog_df.RData')
save(stem_df_news, file='data_18_Nov_2014/df/news_df.RData')
save(stem_df_twitter, file='data_18_Nov_2014/df/twitter_df.RData')

################################
## Chunks Spliting for Ngrams ##
################################
rm(list=ls(all=TRUE));gc(reset=TRUE);par(mfrow=c(1,1))
load('data_18_Nov_2014/df/blog_df.RData')
load('data_18_Nov_2014/df/news_df.RData')
load('data_18_Nov_2014/df/twitter_df.RData')
source('SwiftKey-Natural-language/func/Task_4.5_ngram_split_func.R')

split_num <- 100
grams <- 4  # 1/2/3/4
ngram_pred <- ngramify(split_num, stem_df_blog, grams)
dim(ngram_pred)
round(object.size(ngram_pred),0)

save(ngram_pred, file='data_18_Nov_2014/ngrams/twitter_Unigrams.RData')
save(ngram_pred, file='data_18_Nov_2014/ngrams/twitter_Bigrams.RData')
save(ngram_pred, file='data_18_Nov_2014/ngrams/twitter_Trigrams.RData')
# save(ngram_pred, file='data_18_Nov_2014/ngrams/blog_Quatrgrams.RData')

#########################
## Combine Three Files ##
#########################
load('data_18_Nov_2014/ngrams/split/blog_Trigrams.RData')
blog_Unigrams<-ngram_pred
dim(blog_Unigrams)
load('data_18_Nov_2014/ngrams/split/news_Trigrams.RData')
news_Unigrams<-ngram_pred
dim(news_Unigrams)
load('data_18_Nov_2014/ngrams/split/twitter_Trigrams.RData')
twitter_Unigrams<-ngram_pred
dim(twitter_Unigrams)

rm(ngram_pred)

load('completed/Quatrgram_blog_completed.RData')
load('completed/Quatrgram_news_completed.RData')
load('completed/Quatrgram_twitter_completed.RData')

dim(Quatrgram_blog_cleaned);dim(Quatrgram_news_cleaned);dim(Quatrgram_twitter_cleaned);
cbind(head(Quatrgram_blog_cleaned), head(Quatrgram_news_cleaned), head(Quatrgram_twitter_cleaned))
Quatrgrams_all <- merge.data.frame(x = Quatrgram_blog_cleaned,y = Quatrgram_news_cleaned, by = 'terms', all = T)
Quatrgrams_all <- merge.data.frame(x = Quatrgrams_all,y = Quatrgram_twitter_cleaned, by = 'terms',all = T)
Quatrgrams_all[is.na(Quatrgrams_all)]<-0
Quatrgrams_all$freq_all <- Quatrgrams_all[,2] + Quatrgrams_all[,3] + Quatrgrams_all[,4]
Quatrgrams_all$freq.x <- NULL
Quatrgrams_all$freq.y <- NULL
Quatrgrams_all$freq <- NULL
Quatrgrams_all <- Quatrgrams_all[order(Quatrgrams_all$freq_all,decreasing = T),]
head(Quatrgrams_all, 20)
dim(Quatrgrams_all)
round(object.size(Quatrgrams_all),0)

save(Quatrgrams_all, file='completed/Quatrgrams_all_completed.RData')

######################
## Ngrams Cleansing ##
######################
require(stringr)
rm(list=ls(all=TRUE));gc(reset=TRUE);par(mfrow=c(1,1))
load('data_18_Nov_2014/ngrams/Unigrams_All.RData')
load('data_18_Nov_2014/ngrams/Bigrams_All.RData')
load('data_18_Nov_2014/ngrams/Trigrams_All.RData')
load('data_18_Nov_2014/ngrams/Quatrgrams_All.RData')

dim(Unigrams_all)
# [^a-z]
# [^a-z][:blank:][^a-z]
# [^a-z][:blank:][^a-z][:blank:][^a-z]
cbind(head(Unigrams_all, 50),tail(Unigrams_all, 50))
Unigrams_all_unicode <- str_replace_all(Unigrams_all[,1], "[^a-z][:blank:][^a-z]", NA)
length(Unigrams_all_unicode[is.na(Unigrams_all_unicode)])

# Unigram
Unigrams_all_cleaned <- Unigrams_all[!is.na(Unigrams_all_unicode),]
Unigrams_all_dirt <- Unigrams_all[is.na(Unigrams_all_unicode),]
dim(Unigrams_all_cleaned); head(Unigrams_all_cleaned)
Unigrams_all_cleaned <- Unigrams_all_cleaned[1:10,]
# Bigram
Bigrams_all_cleaned <- Unigrams_all[!is.na(Unigrams_all_unicode),]
Bigrams_all_dirt <- Unigrams_all[is.na(Unigrams_all_unicode),]
dim(Bigrams_all_cleaned); head(Bigrams_all_cleaned)
### Trigram ###
load('data_18_Nov_2014/ngrams/split/twitter_Trigrams.RData')
dim(ngram_pred)
cbind(head(ngram_pred, 50),tail(ngram_pred, 50))
Unigrams_all_unicode <- str_replace_all(Unigrams_all[,1], "[^a-z][:blank:][^a-z][:blank:][^a-z]", NA)
length(Unigrams_all_unicode[is.na(Unigrams_all_unicode)])

Trigrams_twitter_cleaned <- ngram_pred[!is.na(Unigrams_all_unicode),]
Trigrams_twitter_dirt <- Unigrams_all[is.na(Unigrams_all_unicode),]
dim(Trigrams_twitter_cleaned); head(Trigrams_twitter_cleaned)

save(Trigrams_twitter_cleaned, file='data_18_Nov_2014/ngrams/Trigrams_twitter_cleaned.RData')

?regex
?regexpr

save(Unigrams_all_cleaned, file='data_18_Nov_2014/ngrams/Unigrams_All_cleaned.RData')
save(Bigrams_all_cleaned, file='data_18_Nov_2014/ngrams/Bigrams_All_cleaned.RData')
save(Trigrams_all_cleaned, file='data_18_Nov_2014/ngrams/Trigrams_All_cleaned.RData')

########################
## Ngrams Cleansing 2 ##
########################
rm(list=ls(all=TRUE));gc(reset=TRUE);par(mfrow=c(1,1))
load('data_18_Nov_2014/ngrams/Trigrams_news_cleaned.RData')

dim(Trigrams_blog_cleaned)
Trigrams_blog_cleaned <- Trigrams_blog_cleaned[-which(Trigrams_blog_cleaned[,2] == 1), ]
save(Trigrams_blog_cleaned, file='data_18_Nov_2014/ngrams/Trigrams_blog_freq_cleaned.RData')

dim(Trigrams_news_cleaned)
Trigrams_news_cleaned <- Trigrams_news_cleaned[-which(Trigrams_news_cleaned[,2] == 1), ]
save(Trigrams_news_cleaned, file='data_18_Nov_2014/ngrams/Trigrams_news_freq_cleaned.RData')

dim(Trigrams_twitter_cleaned)
Trigrams_twitter_cleaned <- Trigrams_twitter_cleaned[-which(Trigrams_twitter_cleaned[,2] == 1), ]
save(Trigrams_twitter_cleaned, file='data_18_Nov_2014/ngrams/Trigrams_twitter_freq_cleaned.RData')

load('data_18_Nov_2014/ngrams/Bigrams_all_cleaned.RData')
dim(Bigrams_all_cleaned)
Bigrams_all_cleaned <- Bigrams_all_cleaned[-which(Bigrams_all_cleaned[,2] == 1), ]
save(Bigrams_all_cleaned, file='data_18_Nov_2014/ngrams/Bigrams_all_freq_cleaned.RData')

load('data_18_Nov_2014/ngrams/Trigrams_all_freq_cleaned.RData.RData')
dim(Unigrams_all)
Bigrams_all_cleaned <- Bigrams_all_cleaned[-which(Bigrams_all_cleaned[,2] == 1), ]
save(Bigrams_all_cleaned, file='data_18_Nov_2014/ngrams/Bigrams_all_freq_cleaned.RData')

#############
## predict ##
#############
load('data_18_Nov_2014/ngrams/Trigrams_All_cleaned.RData')
input <- 'are you'
predict <- grep(input, Trigrams_all_cleaned[,1])
Trigrams_all_cleaned[predict[1:5],]
