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
save(blog_corpus, file='data_18_Nov_2014/blog_corpus.RData')
save(news_corpus, file='data_18_Nov_2014/news_corpus.RData')
save(twitter_corpus, file='data_18_Nov_2014/twitter_corpus.RData')
object.size(en_US_corpus); gc()

###############################
### Tokenization & Stemming ###
###############################
load('data_18_Nov_2014/blog_corpus.RData')
source('SwiftKey-Natural-language/Task_1.5_Tokenization_func.R')

trans <- c(F,T,T,T,F,F,T,T)
ChartoSpace <- c('/','\\|')
stopWords <- 'english'
ownStopWords <- c()
swearwords <- read.table('SwiftKey-Natural-language/profanity filter/en', sep='\n')
names(swearwords)<-'swearwords'
filter <- rep('***', length(swearwords))
profanity <- data.frame(swearwords, target = filter)
profanity <- rbind(profanity, data.frame(swearwords = c("[^[:alpha:][:space:]']","â ","ã","ð"), target = c(" ","'","'","'")))
tokenized_docs <- tokenization(blog_corpus, trans, ChartoSpace,
                               stopWords, ownStopWords, profanity)
stem_docs <- tm_map(tokenized_docs, stemDocument, 'english') # SnowballStemmer

save(tokenized_docs, file='data_18_Nov_2014/blog_tokenized_corpus.RData')
save(stem_docs, file='data_18_Nov_2014/blog_stemming_corpus.RData')

##############################
### Transfer to Data Frame ###
##############################
load('data_18_Nov_2014/blog_stemming_corpus.RData')

stem_df <- data.frame(text=unlist(sapply(stem_docs, '[',"content")),stringsAsFactors=F)
save(stem_df, file='data_18_Nov_2014/blog_df.RData')

################################
## Chunks Spliting for Ngrams ##
################################
load('data_18_Nov_2014/blog_df.RData')
source('SwiftKey-Natural-language/Task_4.5_ngram_split_func.R')

split_num <- 100
grams <- 4
ngram_pred <- ngramify(split_num, stem_df, grams)
dim(ngram_pred)
round(object.size(ngram_pred),0)

save(ngram_pred, file='data_18_Nov_2014/ngrams/blog_trigrams.RData')

######################
## Ngrams Cleansing ##
######################
load('data_18_Nov_2014/ngrams/blog_trigrams.RData')

tail(ngram_pred, 50)





