###########################
### Tasks to accomplish ###
###########################
# 1. Tokenization - identifying appropriate tokens such as words, punctuation, and numbers. 
# Writing a function that takes a file as input and returns a tokenized version of it.
# 2. Profanity filtering - removing profanity and other words you do not want to predict.

###############################
### Tips, tricks, and hints ###
###############################
# 1. Loading the data in.
# 2. Sampling. You can use the rbinom function to "flip a biased coin" to determine 
# whether you sample a line of text or not.
# 3. If you need a refresher on regular expressions, 
# take a look at Jeff Leek's lectures from Getting and Cleaning Data: Part 1 Part 2

##############
### Script ###
##############
setwd('H:/Machine Learning/SwiftKey/')
setwd('C:\\Users\\Ivan.Liuyanfeng\\Desktop\\Data_Mining_Work_Space\\SwiftKey')
setwd('/Users/ivan/Work_directory/SwiftKey')
rm(list=ls(all=TRUE));gc(reset=TRUE);par(mfrow=c(1,1))
require(tm); require(SnowballC); require(data.table)

# getSources();getReaders();getTransformations()
en_US <- file.path('.','final','en_US')
length(dir(en_US))
en_US.document <- Corpus(DirSource(en_US, encoding="UTF-8"), 
                         readerControl = list(reader = readPlain,language = "en_US",load = TRUE))
en_US.document
class(en_US.document)
class(en_US.document[[1]])

# exploring the Corpus
inspect(en_US.document[1])

#########################
### Tokenization Func ###
#########################
load('SwiftKey-Natural-language/Task_1.5_Tokenization_func.R')
docs <- en_US.document[1]
# simple, lowercase, numbers, punctuations, stopwords, ownstop, whitespace, specific
trans <- c(F,T,T,T,F,F,T,T)
ChartoSpace <- c('/','\\|')
stopWords <- 'english'
ownStopWords <- c()
# List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words
# Mr. P.M. / '"‘ASC-II
# tm_map(sdocs, removeWords, swears)
swearwords <- read.table('SwiftKey-Natural-language/profanity filter/en', sep='\n')
filter <- rep('***', length(swearwords))
profanity <- data.frame(raw = swearwords, target = filter)
tokenized_docs <- tokenization(docs, trans, ChartoSpace,
                               stopWords, ownStopWords, profanity)
inspect(tokenized_docs)
# save tokenized docs as text file and RData
writeCorpus(tokenized_docs, file=paste('data/',meta(stem_docs[[1]])$id,'_token.txt', sep=''))
save(tokenized_docs, file=paste('data/',meta(stem_docs[[1]])$id,'_token.RData', sep=''))

################
### Stemming ###
################
wordStem('runs')
getStemLanguages()
stem_docs <- tm_map(tokenized_docs, stemDocument, 'english') # SnowballStemmer
inspect(stem_docs)
meta(stem_docs[[1]])$id
# save stemming docs as text file and RData
writeCorpus(stem_docs, file=paste('data/',meta(stem_docs[[1]])$id,'_stem.txt', sep=''))
save(stem_docs, file=paste('data/',meta(stem_docs[[1]])$id,'_stem.RData', sep=''))

###############
### n grams ###
###############
stem_path <- file.path('.','data/')
dir(stem_path)
con <- file(paste(stem_path, dir(stem_path)[2], sep=''),'r')
sample_num <- length(readLines(con)) * 0.05
close(con)
con <- file(paste(stem_path, dir(stem_path)[2], sep=''),'r')
sample <- readLines(con, sample_num)
close(con)
sample.document <- Corpus(VectorSource(sample))
save(sample.document, file=paste('data/','sample.RData', sep=''))

library("RWeka")
# ngrams_test <- NGramTokenizer(stem_docs, Weka_control(min = 3, max = 3, delimiters = " \\r\\n\\t.,;:\"()?!"))
BigramTokenizer <- function(x) 
    NGramTokenizer(x, Weka_control(min = 2, max = 2))
TrigramTokenizer <- function(x) 
    NGramTokenizer(x, Weka_control(min = 3, max = 3))

############################
### Document Term Matrix ###
############################
load('data/en_US.blogs.txt_stem.RData') # stem_docs
con <- file('data/en_US.blogs.txt_stem.txt','r')
stem_docs <- readLines(con)
close(con)

dtm_docs <- DocumentTermMatrix(sample.document, control = list(tokenize = TrigramTokenizer))
# tdm_docs <- TermDocumentMatrix(stem_docs)
dtm_docs
inspect(dtm_docs[340:345,1:10])
class(dtm_docs); dim(dtm_docs)

# Exploring the Document Term Matrix
freq <- colSums(as.matrix(dtm_docs))
length(freq)
ord <- order(freq)
freq[head(ord)] # Least frequent terms
freq[tail(ord)] # Most frequent terms

# Distribution of Term Frequencies
head(table(freq), 15)
tail(table(freq), 15)
# Plot of Frequencies

# Save as csv
output <- as.matrix(dtm_docs)
dim(output)
write.csv(output, file='en_US_blogs.csv')
save(output, 'en_US_blogs.RData')