rm(list=ls(all=TRUE));gc(reset=TRUE);par(mfrow=c(1,1))
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

en_US_blogs_sample <- sample(en_US_blogs, length(en_US_blogs)/10)
en_US_news_sample <- sample(en_US_news, length(en_US_news)/10)
en_US_twitter_sample <- sample(en_US_twitter, length(en_US_twitter)/10)

save(en_US_blogs_sample, file='data/sample/en_US_blogs_sample.RData')
save(en_US_news_sample, file='data/sample/en_US_news_sample.RData')
save(en_US_twitter_sample, file='data/sample/en_US_twitter_sample.RData')

en_US <- file.path('.','data','sample')
en_US_corpus_sample <- Corpus(DirSource(en_US, encoding="UTF-8"), 
                         readerControl = list(reader = readPlain,language = "en_US",load = TRUE))
save(en_US_corpus_sample, file='data/en_US_corpus_sample_ALL.RData') ## all 3 doc corpus sample

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
tokenized_docs <- tokenization(en_US_corpus_sample, trans, ChartoSpace,
                               stopWords, ownStopWords, profanity)
stem_docs <- tm_map(tokenized_docs, stemDocument, 'english') # SnowballStemmer
save(stem_docs, file='data/sample/stem_docs.RData') ## all 3 doc corpus sample

##########################################################################################################################################
stem_df <- data.frame(text=unlist(sapply(stem_docs, '[',"content")),stringsAsFactors=F)
# stem_df<-df[regexpr(pattern = '^([a-zA-Z])(?!(\\1{1,}))[a-zA-Z]*([a-zA-Z]+-([a-zA-Z]){2,})?(\'(s)?)?$', df, perl=T )>0]
token_delim <- " \\t\\r\\n.!?,;\"()"
# df_ngram
onetoken <- NGramTokenizer(stem_df, Weka_control(min=1,max=1))
bitoken <- NGramTokenizer(stem_df, Weka_control(min=2,max=2, delimiters = token_delim))
tritoken <- NGramTokenizer(stem_df, Weka_control(min=3,max=3, delimiters = token_delim))
quatrtoken <- NGramTokenizer(stem_df, Weka_control(min=4,max=4, delimiters = token_delim))
save(onetoken, file='data/sample/onetoken.RData')
save(bitoken, file='data/sample/bitoken.RData')
save(tritoken, file='data/sample/tritoken.RData')
save(quatrtoken, file='data/sample/quatrtoken.RData')

#################
### bar chart ###
#################
# freq_onetoken
freq_onetoken <- sort(table(onetoken), decreasing=T)
wf_onetoken <- data.frame(word=names(freq_onetoken), freq = freq_onetoken) 
head(wf_onetoken)
subset(wf_onetoken, freq > 500) %>%
    ggplot(aes(word, freq)) +
    geom_bar(stat='identity') + 
    theme(axis.text.x=element_text(angle=45,hjust=1))
# freq_bitoken
freq_bitoken <- sort(table(bitoken), decreasing=T)
wf_bitoken <- data.frame(word=names(freq_bitoken), freq = freq_bitoken) 
head(wf_bitoken)
subset(wf_bitoken, freq > 50) %>%
    ggplot(aes(word, freq)) +
    geom_bar(stat='identity') + 
    theme(axis.text.x=element_text(angle=45,hjust=1))
# freq_tritoken
freq_tritoken <- sort(table(tritoken), decreasing=T)
wf_tritoken <- data.frame(word=names(freq_tritoken), freq = freq_tritoken) 
head(wf_tritoken)
subset(wf_tritoken, freq > 5) %>%
    ggplot(aes(word, freq)) +
    geom_bar(stat='identity') + 
    theme(axis.text.x=element_text(angle=45,hjust=1))
# freq_quatrtoken
freq_quatrtoken <- sort(table(quatrtoken), decreasing=T)
wf_quatrtoken <- data.frame(word=names(freq_quatrtoken), freq = freq_quatrtoken) 
head(wf_quatrtoken)
subset(wf_quatrtoken, freq > 3) %>%
    ggplot(aes(word, freq)) +
    geom_bar(stat='identity') + 
    theme(axis.text.x=element_text(angle=45,hjust=1))

save(freq_onetoken, file='./SwiftKey-Natural-language/Other/freq_onetoken.RData')
save(freq_bitoken, file='./SwiftKey-Natural-language/Other/freq_bitoken.RData')
save(freq_tritoken, file='./SwiftKey-Natural-language/Other/freq_tritoken.RData')
save(freq_quatrtoken, file='./SwiftKey-Natural-language/Other/freq_quatrtoken.RData')

save(wf_onetoken, file='./SwiftKey-Natural-language/Other/wf_onetoken.RData')
save(wf_bitoken, file='./SwiftKey-Natural-language/Other/wf_bitoken.RData')
save(wf_tritoken, file='./SwiftKey-Natural-language/Other/wf_tritoken.RData')
save(wf_quatrtoken, file='./SwiftKey-Natural-language/Other/wf_quatrtoken.RData')

wf_onetoken$ngrams <- '1-gram'
wf_bitoken$ngrams <- '2-grams'
wf_tritoken$ngrams <- '3-grams'
wf_quatrtoken$ngrams <- '4-grams'
wf_alltoken<- rbind(subset(wf_onetoken, freq > 500),subset(wf_bitoken, freq > 50),subset(wf_tritoken, freq > 10),subset(wf_quatrtoken, freq > 3))
save(wf_alltoken, file='./SwiftKey-Natural-language/Other/wf_alltoken.RData')
ggplot(wf_alltoken,aes(x=word,y=freq)) + 
    geom_bar(stat='identity',color='grey60',fill='#56B4E9') + facet_wrap(~ngrams, scales = "free") + 
    xlab('Terms')+ylab('Frequency') + theme(legend.position='none') + 
    theme_bw() + geom_text(aes(label=format(freq,big.mark=","),size=3),labels=comma,vjust=-0.2) 


##################
### word cloud ###
##################
library(wordcloud); set.seed(888)
wordcloud(names(freq_onetoken), freq_onetoken, min.freq=50, colors=brewer.pal(6, 'Dark2'), rot.per=.2, scale=c(5,.1))
wordcloud(names(freq_bitoken), freq_bitoken, min.freq=10, colors=brewer.pal(6, 'Dark2'), rot.per=.2, scale=c(5,.1))
wordcloud(names(freq_tritoken), freq_tritoken, min.freq=5, colors=brewer.pal(6, 'Dark2'), rot.per=.2, scale=c(5,.1))
wordcloud(names(freq_quatrtoken), freq_quatrtoken, min.freq=3, colors=brewer.pal(6, 'Dark2'), rot.per=.2, scale=c(5,.1))

##########################################################################################################################################
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
Bigram_DTM <- DocumentTermMatrix(stem_docs, control = list(tokenize = BigramTokenizer))
Trigram_DTM <- DocumentTermMatrix(stem_docs, control = list(tokenize = TrigramTokenizer))
Quatrgram_DTM <- DocumentTermMatrix(stem_docs, control = list(tokenize = QuatrgramTokenizer))

#########################
### Correlation Plots ###
#########################
plot(Onegram_DTM, terms=findFreqTerms(Onegram_DTM, lowfreq=10)[1:50], corThreshold=0.5)
plot(Bigram_DTM, terms=findFreqTerms(Bigram_DTM, lowfreq=10)[1:50], corThreshold=0.5)
plot(Trigram_DTM, terms=findFreqTerms(Trigram_DTM, lowfreq=10)[1:50], corThreshold=0.5)
plot(Quatrgram_DTM, terms=findFreqTerms(Quatrgram_DTM, lowfreq=10)[1:50], corThreshold=0.5)


##########################################################################################################################################











save(tokenized_docs, file='data/en_US_tokenized_sample_ALL.RData') ## all 3 doc tokens