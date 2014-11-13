setwd('/Users/ivan/Work_directory/SwiftKey')
rm(list=ls(all=TRUE));gc(reset=TRUE);par(mfrow=c(1,1))
require(tm); require(SnowballC); require(data.table)
require(ggplot2); require(RWeka); require(qdap);
require(scales); require(gridExtra); require(wordcloud)
source('SwiftKey-Natural-language/Task_1.5_Tokenization_func.R')


en_US <- file.path('.','final','en_US_s')
en_US.document <- Corpus(DirSource(en_US, encoding="UTF-8"), 
                         readerControl = list(reader = readPlain,language = "en_US",load = TRUE))


# simple, lowercase, numbers, punctuations, stopwords, ownstop, whitespace, specific
docs <- en_US.document[1]
trans <- c(F,T,T,T,F,F,T,T)
ChartoSpace <- c('/','\\|')
stopWords <- 'english'
ownStopWords <- c()
swearwords <- read.table('SwiftKey-Natural-language/profanity filter/en', sep='\n')
names(swearwords)<-'swearwords'
filter <- rep('***', length(swearwords))
profanity <- data.frame(swearwords, target = filter)
profanity <- rbind(profanity, data.frame(swearwords = c("[^[:alpha:][:space:]']","â ","ã","ð"), target = c(" ","'","'","'")))
tokenized_docs <- tokenization(docs, trans, ChartoSpace,
                               stopWords, ownStopWords, profanity)


save(tokenized_docs, file=paste('data/',meta(en_US.document[[1]])$id,'_token.RData', sep=''))

load('data/en_US.blogs.txt_token.RData')
tokenized_docs<-words[regexpr(pattern = '^([a-zA-Z])(?!(\\1{1,}))[a-zA-Z]*([a-zA-Z]+-([a-zA-Z]){2,})?(\'(s)?)?$', tokenized_docs, perl=T )>0]
sample_df <- data.frame(text=unlist(sapply(sample_corpus, '[',"content")),stringsAsFactors=F)
stem_docs <- tm_map(tokenized_docs, stemDocument, 'english') # SnowballStemmer


tokenized_docs<-tokenized_docs[regexpr(pattern = '^([a-zA-Z])(?!(\\1{1,}))[a-zA-Z]*([a-zA-Z]+-([a-zA-Z]){2,})?(\'(s)?)?$', tokenized_docs, perl=T )>0]
stem_docs <- tm_map(tokenized_docs, stemDocument, 'english') # SnowballStemmer
df <- data.frame(text=unlist(sapply(tokenized_docs, '[',"content")),stringsAsFactors=F)


### create sample ###
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

en_US_blogs_sample <- sample(en_US_blogs, length(en_US_blogs)/100)
en_US_news_sample <- sample(en_US_news, length(en_US_news)/100)
en_US_twitter_sample <- sample(en_US_twitter, length(en_US_twitter)/100)
write.table(en_US_blogs_sample, file='final/en_US_s/en_US_blogs_sample.txt',row.names = F)
write.table(en_US_news_sample, file='final/en_US_s/en_US_news_sample.txt',row.names = F)
write.table(en_US_twitter_sample, file='final/en_US_s/en_US_twitter_sample.txt',row.names = F)

token_delim <- " \\t\\r\\n.!?,;\"()"
onetoken <- NGramTokenizer(sample_df, Weka_control(min=1,max=1))
bitoken <- NGramTokenizer(sample_df, Weka_control(min=2,max=2, delimiters = token_delim))
tritoken <- NGramTokenizer(sample_df, Weka_control(min=3,max=3, delimiters = token_delim))
quatrtoken <- NGramTokenizer(sample_df, Weka_control(min=4,max=4, delimiters = token_delim))
