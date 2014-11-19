#######################
### Set Environment ###
#######################
setwd('H:/Machine_Learning/SwiftKey/')
setwd('C:\\Users\\Ivan.Liuyanfeng\\Desktop\\Data_Mining_Work_Space\\SwiftKey')
setwd('/Users/ivan/Work_directory/SwiftKey')
Sys.setenv(JAVA_HOME="C:\\Program Files\\Java\\jre7\\")

rm(list=ls(all=TRUE));gc(reset=TRUE);par(mfrow=c(1,1))
require(tm); require(SnowballC); require(data.table)
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
load('data_18_Nov_2014/Corpus/twitter_corpus.RData')
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

stem_blog <- tm_map(tokenized_blog, stemDocument, 'english') # SnowballStemmer
stem_news <- tm_map(tokenized_news, stemDocument, 'english') # SnowballStemmer
stem_twitter <- tm_map(tokenized_twitter, stemDocument, 'english') # SnowballStemmer
save(stem_blog, file='data_18_Nov_2014/stemming/blog_stemming.RData')
save(stem_news, file='data_18_Nov_2014/stemming/news_stemming.RData')
save(stem_twitter, file='data_18_Nov_2014/stemming/twitter_stemming.RData')


##############################
### Transfer to Data Frame ###
##############################
load('data_18_Nov_2014/stemming/twitter_stemming.RData')

stem_df_blog <- data.frame(text=unlist(sapply(stem_blog, '[',"content")),stringsAsFactors=F)
stem_df_news <- data.frame(text=unlist(sapply(stem_news, '[',"content")),stringsAsFactors=F)
stem_df_twitter <- data.frame(text=unlist(sapply(stem_twitter, '[',"content")),stringsAsFactors=F)
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
grams <- 3  # 1/2/3
ngram_pred <- ngramify(split_num, stem_df_news, grams)
dim(ngram_pred)
round(object.size(ngram_pred),0)

save(ngram_pred, file='data_18_Nov_2014/ngrams/news_Unigrams.RData')
save(ngram_pred, file='data_18_Nov_2014/ngrams/news_Bigrams.RData')
save(ngram_pred, file='data_18_Nov_2014/ngrams/news_Trigrams.RData')

######################
## Ngrams Cleansing ##
######################
load('data_18_Nov_2014/ngrams/blog_trigrams.RData')

tail(ngram_pred, 50)
head(ngram_pred,50)
test_ngram <- ngram_pred[1:10,]
ngram_pred_clean<-test_ngram[regexpr(pattern = '^([a-zA-Z])(?!(\\1{1,}))[a-zA-Z]*([a-zA-Z]+-([a-zA-Z]){2,})?(\'(s)?)?$', test_ngram[,1], perl=T )>0,]

#########################
## Combine Three Files ##
#########################
load('data_18_Nov_2014/ngrams/blog_Unigrams.RData')
blog_Unigrams<-ngram_pred
load('data_18_Nov_2014/ngrams/news_Unigrams.RData')
news_Unigrams<-ngram_pred
load('data_18_Nov_2014/ngrams/twitter_Unigrams.RData')
twitter_Unigrams<-ngram_pred
rm(ngram_pred)
