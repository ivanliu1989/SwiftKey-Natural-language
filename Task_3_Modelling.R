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

## get raw data
en_US <- file.path('.','final','en_US')

con <- file("./final/en_US/en_US.blogs.txt")
blogs <- readLines(con)
close(con)
con <- file("./final/en_US/en_US.news.txt")
news <- readLines(con)
close(con)
con <- file("./final/en_US/en_US.twitter.txt")
twitter <- readLines(con)
close(con)
length(blogs);length(news);length(twitter)
head(blogs);head(news);head(twitter)
all <- c(blogs, news, twitter) ## all raw text
length(all); head(all)
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

## tokenization
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

load('data_18_Nov_2014/blog_stemming_corpus.RData')
stem_df <- data.frame(text=unlist(sapply(stem_docs, '[',"content")),stringsAsFactors=F)
save(stem_df, file='data_18_Nov_2014/blog_df.RData')
dim(stem_df); 
load('data_18_Nov_2014/blog_df.RData')
nrow(stem_df)
stem_df_sample <- head(stem_df, nrow(stem_df)/10)
# stem_df<-df[regexpr(pattern = '^([a-zA-Z])(?!(\\1{1,}))[a-zA-Z]*([a-zA-Z]+-([a-zA-Z]){2,})?(\'(s)?)?$', df, perl=T )>0]
token_delim <- " \\t\\r\\n.!?,;\"()"
# df_ngram
onetoken <- NGramTokenizer(stem_df_sample, Weka_control(min=1,max=1))
bitoken <- NGramTokenizer(stem_df, Weka_control(min=2,max=2))
tritoken <- NGramTokenizer(stem_df, Weka_control(min=3,max=3))
quatrtoken <- NGramTokenizer(stem_df, Weka_control(min=4,max=4))

#####################
## Chunks Spliting ##
#####################
rm(list=ls(all=TRUE));gc(reset=TRUE);par(mfrow=c(1,1))
load('data_18_Nov_2014/blog_df.RData')
source('SwiftKey-Natural-language/Task_4.5_ngram_split_func.R')
split_num <- 100
grams <- 3
ngram_pred <- system.time(ngramify(split_num, stem_df, grams))


version3 <- function (){
    a <- data.frame(k=1:1000000, v=rep(1,1000000))
    b <- data.frame(k=500001:1500000, v=rep(1,1000000))
    a <- a[order(a$k),]
    b <- b[order(b$k),]
    a$v[a$k %in% b$k] <-  a$v[a$k %in% b$k] + b$v[b$k %in% a$k]
    c <- rbind(a, b[!(b$k %in% a$k),])
    c
}
size4 <- unlist(lapply(extended[grep("[^ ]*[aeiouyAEIOUY]+[^ ]* [^ ]*[aeiouyAEIOUY]+[^ ]* [^ ]*[aeiouyAEIOUY]+[^ ]* [^ ]*[aeiouyAEIOUY]+[^ ]*", extended)], function(x) make.ngrams(txt.to.words(x, splitting.rule = "[ \t\n]+"), ngram.size = 4)))