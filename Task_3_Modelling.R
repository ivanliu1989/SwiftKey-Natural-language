###########################
### Tasks to accomplish ###
###########################
# 1. Build basic n-gram model - using the exploratory analysis you performed, 
# build a basic n-gram model for predicting the next word based on the previous 1, 2, or 3 words.
# 2. Build a model to handle unseen n-grams - in some cases people will want to type a combination of words that does not appear in the corpora. 
# Build a model to handle cases where a particular n-gram isn't observed.

#############################
### Questions to consider ###
#############################
# 1. How can you efficiently store an n-gram model (think Markov Chains)?
# 2. How can you use the knowledge about word frequencies to make your model smaller and more efficient?
# 3. How many parameters do you need (i.e. how big is n in your n-gram model)?
# 4. Can you think of simple ways to "smooth" the probabilities 
# (think about giving all n-grams a non-zero probability even if they aren't observed in the data) ?
# 5. How do you evaluate whether your model is any good?
# 6. How can you use backoff models to estimate the probability of unobserved n-grams?

###############################
### Tips, tricks, and hints ###
###############################
# 1. Size: the amount of memory (physical RAM) required to run the model in R
# 2. Runtime: The amount of time the algorithm takes to make a prediction given the acceptable input
# 3. Here are a few tools that may be of use to you as you work on their algorithm:
# * object.size(): this function reports the number of bytes that an R object occupies in memory
# * Rprof(): this function runs the profiler in R that can be used to determine where bottlenecks in your function may exist. 
# The profr package (available on CRAN) provides some additional tools for visualizing and summarizing profiling data.
# * gc(): this function runs the garbage collector to retrieve unused RAM for R. In the process it tells you how much memory is currently being used by R.

##############
### Script ###
##############
setwd('H:/Machine_Learning/SwiftKey/')
setwd('C:\\Users\\Ivan.Liuyanfeng\\Desktop\\Data_Mining_Work_Space\\SwiftKey')
setwd('/Users/ivan/Work_directory/SwiftKey')
Sys.setenv(JAVA_HOME="C:\\Program Files\\Java\\jre7\\")

rm(list=ls(all=TRUE));gc(reset=TRUE);par(mfrow=c(1,1))
require(tm); require(SnowballC); require(data.table)
require(ggplot2); require(RWeka); require(qdap);
require(scales); require(gridExtra); require(wordcloud)

en_US <- file.path('.','final','en_US')
en_US_corpus <- Corpus(DirSource(en_US, encoding="UTF-8"), 
                              readerControl = list(reader = readPlain,language = "en_US",load = TRUE))
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
tokenized_docs <- tokenization(en_US_corpus, trans, ChartoSpace,
                               stopWords, ownStopWords, profanity)

stem_docs <- tm_map(tokenized_docs, stemDocument, 'english') # SnowballStemmer
save(tokenized_docs, file='data/tokenized_docs_all.RData')
save(stem_docs, file='data/stem_docs_all.RData')

load('data/stem_docs_all.RData')
Onegram_DTM <- DocumentTermMatrix(stem_docs)
save(Onegram_DTM, file='data/Unigram_DTM.RData')
class(Onegram_DTM); dim(Onegram_DTM)
inspect(Onegram_DTM[1,2100:3000])

token_delim <- " \\t\\r\\n.!?,;\"()"
OnegramTokenizer <- function(x) 
    NGramTokenizer(x, Weka_control(min = 1, max = 1))
BigramTokenizer <- function(x) 
    NGramTokenizer(x, Weka_control(min = 2, max = 2, delimiters = token_delim))
TrigramTokenizer <- function(x) 
    NGramTokenizer(x, Weka_control(min = 3, max = 3, delimiters = token_delim))
QuatrgramTokenizer <- function(x) 
    NGramTokenizer(x, Weka_control(min = 4, max = 4, delimiters = token_delim))
# dtm_ngram
Onegram_DTM <- DocumentTermMatrix(stem_docs, control = list(tokenize = OnegramTokenizer))
class(Onegram_DTM); dim(Onegram_DTM)
Bigram_DTM <- DocumentTermMatrix(stem_docs[1], control = list(tokenize = BigramTokenizer))
class(Bigram_DTM); dim(Bigram_DTM)
Trigram_DTM <- DocumentTermMatrix(stem_docs[1], control = list(tokenize = TrigramTokenizer))
class(Bigram_DTM); dim(Bigram_DTM)
Quatrgram_DTM <- DocumentTermMatrix(stem_docs[1], control = list(tokenize = QuatrgramTokenizer))
class(Bigram_DTM); dim(Bigram_DTM)
