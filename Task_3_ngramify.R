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
grams <- 1  # 1/2/3/4
ngram_pred <- ngramify(split_num, stem_df_twitter, grams)
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

cbind(head(blog_Unigrams), head(news_Unigrams), head(twitter_Unigrams))
Unigrams_all <- merge.data.frame(x = blog_Unigrams,y = news_Unigrams, by = 'terms', all = T)
Unigrams_all <- merge.data.frame(x = Unigrams_all,y = twitter_Unigrams, by = 'terms',all = T)
Unigrams_all[is.na(Unigrams_all)]<-0
Unigrams_all$freq_all <- Unigrams_all[,2] + Unigrams_all[,3] + Unigrams_all[,4]
Unigrams_all$freq.x <- NULL
Unigrams_all$freq.y <- NULL
Unigrams_all$freq <- NULL
Unigrams_all <- Unigrams_all[order(Unigrams_all$freq_all,decreasing = T),]
head(Unigrams_all, 20)
dim(Unigrams_all)
round(object.size(Unigrams_all),0)

save(Unigrams_all, file='data_18_Nov_2014/ngrams/Bigrams_All.RData')

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
# Trigram
Trigrams_all_cleaned <- Unigrams_all[!is.na(Unigrams_all_unicode),]
Trigrams_all_dirt <- Unigrams_all[is.na(Unigrams_all_unicode),]
dim(Trigrams_all_cleaned); head(Trigrams_all_cleaned)

?regex
?regexpr

save(Unigrams_all_cleaned, file='data_18_Nov_2014/ngrams/Unigrams_All_cleaned.RData')
save(Bigrams_all_cleaned, file='data_18_Nov_2014/ngrams/Bigrams_All_cleaned.RData')
save(Trigrams_all_cleaned, file='data_18_Nov_2014/ngrams/Trigrams_All_cleaned.RData')

#############
## predict ##
#############
load('data_18_Nov_2014/ngrams/Trigrams_All_cleaned.RData')
input <- 'are you'
predict <- grep(input, Trigrams_all_cleaned[,1])
Trigrams_all_cleaned[predict[1:5],]
