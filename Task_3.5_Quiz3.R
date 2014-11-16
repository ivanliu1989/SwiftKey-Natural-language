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
index <- grep('a case of', ste)

stem_path <- file.path('.','final/en_US')
dir(stem_path)

con <- file(paste(stem_path, dir(stem_path)[1], sep='/'),'r')
en_US_blogs <- readLines(con)
close(con)

con <- file(paste(stem_path, dir(stem_path)[2], sep='/'),'r')
en_US_news <- readLines(con)
close(con)

con <- file(paste(stem_path, dir(stem_path)[3], sep='/'),'r')
en_US_twitter <- readLines(con)
close(con)

sentence <- 'you must be'
index<-grep(sentence, en_US_blogs)
index2<-grep(sentence, en_US_news)
index3<-grep(sentence, en_US_twitter)
index; index2; index3
length(index); length(index2); length(index3)
en_US_blogs[index]
en_US_news[index2]
en_US_twitter[index3]

answer <- 'asleep'
grep(answer, en_US_blogs[index])
grep(answer, en_US_news[index2])
grep(answer, en_US_twitter[index3])

