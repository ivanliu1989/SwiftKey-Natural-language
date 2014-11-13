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


en_US_corpus_sample <- Corpus(VectorSource(c(en_US_blogs_sample,en_US_news_sample,en_US_twitter_sample)))
save(en_US_corpus_sample, file='data/en_US_corpus_sample_ALL.RData') ## all 3 doc corpus sample

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

save(tokenized_docs, file='data/tokenized_en_US_ALL.RData') ## all 3 doc tokens