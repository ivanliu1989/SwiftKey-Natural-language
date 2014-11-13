###########################
### Tasks to accomplish ###
###########################
# 1. Exploratory analysis - perform a thorough exploratory analysis of the data, 
# understanding the distribution of words and relationship between the words in the corpora.
# 2. Understand frequencies of words and word pairs - build figures and tables 
# to understand variation in the frequencies of words and word pairs in the data.

#############################
### Questions to consider ###
#############################
# 1. Some words are more frequent than others - what are the distributions of word frequencies? 
# 2. What are the frequencies of 2-grams and 3-grams in the dataset? 
# 3. How many unique words do you need in a frequency sorted dictionary 
# to cover 50% of all word instances in the language? 90%? 
# 4. How do you evaluate how many of the words come from foreign languages? 
# 5. Can you think of a way to increase the coverage -- identifying words that 
# may not be in the corpora or using a smaller number of words in the dictionary 
# to cover the same number of phrases?

##############
### Script ###
##############
setwd('H:/Machine Learning/SwiftKey/')
setwd('C:\\Users\\Ivan.Liuyanfeng\\Desktop\\Data_Mining_Work_Space\\SwiftKey')
setwd('/Users/ivan/Work_directory/SwiftKey')
Sys.setenv(JAVA_HOME="C:\\Program Files\\Java\\jre7\\")
rm(list=ls(all=TRUE));gc(reset=TRUE);par(mfrow=c(1,1))
require(tm); require(SnowballC); require(data.table)
require(ggplot2); require(RWeka); require(qdap);
require(scales); require(gridExtra); require(wordcloud); require(reshape2)
source('SwiftKey-Natural-language/Task_1.5_Tokenization_func.R')

######################
### Basic Analysis ###
######################
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

# Lines
lengths <- c(length(en_US_blogs),length(en_US_news),length(en_US_twitter))
lengths <- data.frame(lengths)
lengths$names <- c("blogs","news","twitter")

# Blogs
word_count_blogs <- lapply(en_US_blogs, function (z) length(unlist(strsplit(z," "))))
word_count_blogs <- data.frame(do.call("rbind", word_count_blogs))
names(word_count_blogs) <- "Word Count"
# News
word_count_news <- lapply(en_US_news, function (z) length(unlist(strsplit(z," "))))
word_count_news <- data.frame(do.call("rbind", word_count_news))
names(word_count_news) <- "Word Count"
# Twitter
word_count_twitter <- lapply(en_US_twitter, function (z) length(unlist(strsplit(z," "))))
word_count_twitter <- data.frame(do.call("rbind", word_count_twitter))
names(word_count_twitter) <- "Word Count"
# Combine the three text sources together
word_counts <- c(sum(word_count_blogs),sum(word_count_news),sum(word_count_twitter))
word_counts <- data.frame(word_counts)
word_counts$names <- c("blogs","news","twitter")

basic_summary <- merge.data.frame(lengths, word_counts, by = 'names')
melt_df <- melt(basic_summary)

# barplot of total word counts
ggplot(melt_df,aes(x=names,y=value)) + 
    geom_bar(stat='identity',fill='cornsilk',color='grey60') + facet_wrap(~variable, scales = "free") + 
    xlab('Source')+ylab('Word Count/Lines') + 
    theme(legend.position='none')+
    geom_text(aes(label=format(word_counts,big.mark=","),size=3),labels=comma,vjust=-0.2) +
    ggtitle('Total Word Count by Text Source')

#################################
### Transform into Data Frame ###
#################################

# ngrams_test <- NGramTokenizer(stem_docs, Weka_control(min = 3, max = 3, delimiters = " \\r\\n\\t.,;:\"()?!"))
BigramTokenizer <- function(x) 
    NGramTokenizer(x, Weka_control(min = 2, max = 2))
TrigramTokenizer <- function(x) 
    NGramTokenizer(x, Weka_control(min = 3, max = 3))

############################
### Document Term Matrix ###
############################
load('data/en_US.blogs.txt_stem.RData') # stem_docs
class(stem_docs)

dtm_docs <- DocumentTermMatrix(stem_docs, control = list(tokenize = TrigramTokenizer))
dtm_docs <- DocumentTermMatrix(stem_docs) # No ngrams
# tdm_docs <- TermDocumentMatrix(stem_docs)
dtm_docs
inspect(dtm_docs[340:345,1:10])
class(dtm_docs); dim(dtm_docs)

############################
### Exploration Analysis ###
############################
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