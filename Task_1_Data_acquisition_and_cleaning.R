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


################
### Stemming ###
################
wordStem('runs')
getStemLanguages()
stem_docs <- tm_map(tokenized_docs, stemDocument, 'english') # SnowballStemmer
inspect(stem_docs)


############################
### Document Term Matrix ###
############################
dtm_docs <- DocumentTermMatrix(stem_docs) # tdm_docs <- TermDocumentMatrix(stem_docs)
dtm_docs
inspect(dtm_docs[1, 1])
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

