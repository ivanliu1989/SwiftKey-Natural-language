setwd('H:/Machine_Learning/SwiftKey/')
setwd('C:\\Users\\Ivan.Liuyanfeng\\Desktop\\Data_Mining_Work_Space\\SwiftKey')
setwd('/Users/ivan/Work_directory/SwiftKey')
Sys.setenv(JAVA_HOME="C:\\Program Files\\Java\\jre7\\")

rm(list=ls(all=TRUE));gc(reset=TRUE);par(mfrow=c(1,1))
require(tm); require(SnowballC); require(data.table)
require(ggplot2); require(RWeka); require(qdap);
require(scales); require(gridExtra); require(wordcloud)

load('data/stemming_en_US_ALL.RData')
load('SwiftKey-Natural-language/Other/wf_alltoken.RData')
load('SwiftKey-Natural-language/Other/wf_onetoken.RData')
load('SwiftKey-Natural-language/Other/wf_bitoken.RData')
load('SwiftKey-Natural-language/Other/wf_tritoken.RData')
load('SwiftKey-Natural-language/Other/wf_quatrtoken.RData')
stem_df <- data.frame(text=unlist(sapply(stem_docs, '[',"content")),stringsAsFactors=F)

#############################################################################################
load('SwiftKey-Natural-language/Other/wf_onetoken.RData')
load('SwiftKey-Natural-language/Other/wf_bitoken.RData')
load('SwiftKey-Natural-language/Other/wf_tritoken.RData')
load('SwiftKey-Natural-language/Other/wf_quatrtoken.RData')
par(mfcol = c(1,4))
sparcity_onetoken <- nrow(wf_onetoken)/sum(wf_onetoken[,2])
table(wf_onetoken[,2])
hist(log10(table(wf_onetoken[,2])), xlab="", col = "#56B4E9", 
     ylab="Number of words", main = "Unigram")
sparcity_bitoken <- nrow(wf_bitoken)/sum(wf_bitoken[,2])
table(wf_bitoken[,2])
hist(log10(table(wf_bitoken[,2])), xlab="Word frequency in corpus  (log10)", col = "#56B4E9", 
     ylab="", main = "Bigrams")
sparcity_tritoken <- nrow(wf_tritoken)/sum(wf_tritoken[,2])
table(wf_tritoken[,2])
hist(log10(table(wf_tritoken[,2])), xlab="", col = "#56B4E9", 
     ylab="", main = "Trigrams")
sparcity_quatrtoken <- nrow(wf_quatrtoken)/sum(wf_quatrtoken[,2])
table(wf_quatrtoken[,2])
hist(log10(table(wf_quatrtoken[,2])), xlab="", col = "#56B4E9", 
     ylab="", main = "Quargrams")


#############################################################################################
#unigram
sort_one_freq <- cbind(wf_onetoken, wf_onetoken$freq/sum(wf_onetoken$freq))
head(sort_one_freq)
colnames(sort_one_freq) <- c("Word", "Freq", "Pct_Freq")
running_freq = 0
words_counted_50 = 0
while(running_freq<0.50){
    running_freq <- running_freq + sort_one_freq[(words_counted_50+1),3]
    words_counted_50 <- words_counted_50 + 1
}
running_freq = 0
words_counted_90 = 0
while(running_freq<0.90){
    running_freq <- running_freq + sort_one_freq[(words_counted_90+1),3]
    words_counted_90 <- words_counted_90 + 1
}
words_counted_50/nrow(wf_onetoken)
words_counted_90/nrow(wf_onetoken)

sparcity_one <- data.frame('Unigram', words_counted_50,words_counted_50/nrow(wf_onetoken)*100, words_counted_90, words_counted_90/nrow(wf_onetoken)*100)
names(sparcity_one) <- c('Type', '50% Coverage', '% of Total', '90% Coverage', '% of Total')
#bigram
sort_two_freq <- cbind(wf_bitoken, wf_bitoken$freq/sum(wf_bitoken$freq))
head(sort_two_freq)
colnames(sort_two_freq) <- c("Word", "Freq", "Pct_Freq")
running_freq = 0
words_counted_50 = 0
while(running_freq<0.50){
    running_freq <- running_freq + sort_two_freq[(words_counted_50+1),3]
    words_counted_50 <- words_counted_50 + 1
}
running_freq = 0
words_counted_90 = 0
while(running_freq<0.90){
    running_freq <- running_freq + sort_two_freq[(words_counted_90+1),3]
    words_counted_90 <- words_counted_90 + 1
}
words_counted_50/nrow(wf_bitoken)
words_counted_90/nrow(wf_bitoken)

sparcity_two <- data.frame('Bigram', words_counted_50,words_counted_50/nrow(wf_bitoken)*100, 
                           words_counted_90, words_counted_90/nrow(wf_bitoken)*100)
names(sparcity_two) <- c('Type', '50% Coverage', '% of Total', '90% Coverage', '% of Total')
#Trigram
sort_three_freq <- cbind(wf_tritoken, wf_tritoken$freq/sum(wf_tritoken$freq))
head(sort_three_freq)
colnames(sort_three_freq) <- c("Word", "Freq", "Pct_Freq")
running_freq = 0
words_counted_50 = 0
while(running_freq<0.50){
    running_freq <- running_freq + sort_three_freq[(words_counted_50+1),3]
    words_counted_50 <- words_counted_50 + 1
}
running_freq = 0
words_counted_90 = 0
while(running_freq<0.90){
    running_freq <- running_freq + sort_three_freq[(words_counted_90+1),3]
    words_counted_90 <- words_counted_90 + 1
}
words_counted_50/nrow(wf_tritoken)
words_counted_90/nrow(wf_tritoken)

sparcity_three <- data.frame('Trigram', words_counted_50,words_counted_50/nrow(wf_tritoken)*100, 
                           words_counted_90, words_counted_90/nrow(wf_tritoken)*100)
names(sparcity_three) <- c('Type', '50% Coverage', '% of Total', '90% Coverage', '% of Total')
#Quatrgram
sort_four_freq <- cbind(wf_quatrtoken, wf_quatrtoken$freq/sum(wf_quatrtoken$freq))
head(sort_four_freq)
colnames(sort_four_freq) <- c("Word", "Freq", "Pct_Freq")
running_freq = 0
words_counted_50 = 0
while(running_freq<0.50){
    running_freq <- running_freq + sort_four_freq[(words_counted_50+1),3]
    words_counted_50 <- words_counted_50 + 1
}
running_freq = 0
words_counted_90 = 0
while(running_freq<0.90){
    running_freq <- running_freq + sort_four_freq[(words_counted_90+1),3]
    words_counted_90 <- words_counted_90 + 1
}
words_counted_50/nrow(wf_quatrtoken)
words_counted_90/nrow(wf_quatrtoken)

sparcity_four <- data.frame('Quatrgram', words_counted_50,words_counted_50/nrow(wf_quatrtoken)*100, 
                             words_counted_90, words_counted_90/nrow(wf_quatrtoken)*100)
names(sparcity_four) <- c('Type', '50% Coverage', '% of Total', '90% Coverage', '% of Total')

#Combine
sparcity_all <- rbind(sparcity_one,sparcity_two,sparcity_three,sparcity_four)
names(sparcity_all) <- c('Type', '50% Coverage', '% of Total Row', '90% Coverage', '% of Total Row')
sparcity_all
save(sparcity_all, file='SwiftKey-Natural-language/Other/sparcity_all.RData')
