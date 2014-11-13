setwd('/Users/ivan/Work_directory/SwiftKey')
require(tm); require(SnowballC); require(data.table)
require(ggplot2); require(RWeka); require(qdap);
require(scales); require(gridExtra); require(wordcloud)
source('SwiftKey-Natural-language/Task_1.5_Tokenization_func.R')


en_US <- file.path('.','final','en_US')
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


validCharWords<-words[regexpr(pattern = '^([a-zA-Z])(?!(\\1{1,}))[a-zA-Z]*([a-zA-Z]+-([a-zA-Z]){2,})?(\'(s)?)?$', words, perl=T )>0]
sample_df <- data.frame(text=unlist(sapply(sample_corpus, '[',"content")),stringsAsFactors=F)


stem_docs <- tm_map(tokenized_docs, stemDocument, 'english') # SnowballStemmer