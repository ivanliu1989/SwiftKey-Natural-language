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
en_US_corpus <- Corpus(DirSource(en_US, encoding="UTF-8"), 
                       readerControl = list(reader = readPlain,language = "en_US",load = TRUE))
blog_corpus <- en_US_corpus[1]
news_corpus <- en_US_corpus[2]
twitter_corpus <- en_US_corpus[3]
