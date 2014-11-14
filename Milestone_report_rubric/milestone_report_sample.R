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

plot(quatrtoken, terms=findFreqTerms(quatrtoken, lowfreq=10)[1:50], corThreshold=0.5)

# freq_onetoken
freq_onetoken <- sort(table(onetoken), decreasing=T)
wf_onetoken <- data.frame(word=names(freq_onetoken), freq = freq_onetoken) 
head(wf_onetoken)
subset(wf_onetoken, freq > 500) %>%
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
# freq_quatrtoken
freq_quatrtoken <- sort(table(quatrtoken), decreasing=T)
wf_quatrtoken <- data.frame(word=names(freq_quatrtoken), freq = freq_quatrtoken) 
head(wf_quatrtoken)
subset(wf_quatrtoken, freq > 3) %>%
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
##########################################################################################################################################











save(tokenized_docs, file='data/en_US_tokenized_sample_ALL.RData') ## all 3 doc tokens