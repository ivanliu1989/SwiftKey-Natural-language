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
setwd('C:\\Users\\Ivan.Liuyanfeng\\Desktop\\Data_Mining_Work_Space\\SwiftKey')
setwd('/Users/ivan/Work_directory/SwiftKey')
rm(list=ls(all=TRUE));gc(reset=TRUE);par(mfrow=c(1,1))
require(tm); require(SnowballC)

# getSources();getReaders();getTransformations()
en_US <- file.path('.','final','en_US')
length(dir(en_US))
en_US.document <- Corpus(DirSource(en_US), 
                         readerControl = list(reader = readPlain,language = "en_US",load = TRUE))
en_US.document
class(en_US.document)
class(en_US.document[[1]])

# exploring the Corpus
inspect(en_US.document[1])

####################
### Tokenization ###
####################
# Simple Transformation
toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x)) 
docs <- tm_map(en_US.document[1], toSpace, "/")
docs <- tm_map(en_US.document[1], toSpace, "@")
docs <- tm_map(en_US.document[1], toSpace, "\\|")
docs <- tm_map(en_US.document[1], toSpace, "/|@|\\|")
inspect(en_US.document[1])

# Lowercase
en_US.document[1] <- tm_map(en_US.document[1], content_transformer(tolower))
inspect(en_US.document[1])

# Remove Numbers
# Remove Punctuations
# Remove English Stop Words
# Remove Own Stop Words
# Strip Whitespace
# Specific Transformations
# Profanity filtering

################
### Stemming ###
################
