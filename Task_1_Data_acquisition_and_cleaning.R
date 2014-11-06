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

en_US <- file.path('.','final','en_US/')
dir(en_US)
con <- file(paste(en_US,dir(en_US)[3],sep = ""), "r")

length(readLines(con)) ## Read the first line of text
text.Length <- nchar(readLines(con), type='chars')
ltext.no <- which(text.Length == 40833)
max(nchar(readLines(con), type='chars'))
nchar(readLines(con, 1)) ## Read the next line of text 

love_length <- length(grep('love', readLines(con)))
hate_length <- length(grep('hate', readLines(con)))
lh_ratio <- love_length/hate_length

biostats_num <- grep('biostats', readLines(con))
biostats_text <- readLines(con)[biostats_num]

# A computer once beat me at chess, but it was no match for me at kickboxing
sum(grep('A computer once beat me at chess, but it was no match for me at kickboxing', readLines(con)))

close(con) ## It's important to close the connection when you are done
?readLines
