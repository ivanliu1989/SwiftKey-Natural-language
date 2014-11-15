setwd('H:/Machine_Learning/SwiftKey/')
setwd('C:\\Users\\Ivan.Liuyanfeng\\Desktop\\Data_Mining_Work_Space\\SwiftKey')
setwd('/Users/ivan/Work_directory/SwiftKey')
Sys.setenv(JAVA_HOME="C:\\Program Files\\Java\\jre7\\")

rm(list=ls(all=TRUE));gc(reset=TRUE);par(mfrow=c(1,1))
require(tm); require(SnowballC); require(data.table)
require(ggplot2); require(RWeka); require(qdap);
require(scales); require(gridExtra); require(wordcloud)

load('data/stemming_en_US_ALL.RData')
stem_df <- data.frame(text=unlist(sapply(stem_docs, '[',"content")),stringsAsFactors=F)

require(caret)
index <- createDataPartition(stem_df[,1], p = .1, list=F)
