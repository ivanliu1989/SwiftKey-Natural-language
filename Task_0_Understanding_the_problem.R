###########################
### Tasks to accomplish ###
###########################
# 1.Obtaining the data - Can you download the data and load/manipulate it in R?
# 2. Familiarizing yourself with NLP and text mining - Learn about the basics of natural language processing 
# and how it relates to the data science process you have learned in the Data Science Specialization.

#############################
### Questions to consider ###
#############################
# 1. What do the data look like?
# 2. Where do the data come from?
# 3. Can you think of any other data sources that might help you in this project?
# 4. What are the common steps in natural language processing?
# 5. What are some common issues in the analysis of text data?
# 6. What is the relationship between NLP and the concepts you have learned in the Specialization?

##############
### Script ###
##############
setwd('C:\\Users\\Ivan.Liuyanfeng\\Desktop\\Data_Mining_Work_Space\\SwiftKey')
setwd('/Users/ivan/Work_directory/SwiftKey')
require(tm)
require(SnowballC)
en_US <- 'final/en_US'
(en_US.document <- Corpus(DirSource(en_US),
                          readerControl = list(reader = readPlain,
                                               language = "en_US",
                                               load = TRUE)))
meta(en_US.document[[1]]) # To see all available metadata for a text document
en_US.document[[1]]
length(en_US.document) # Returns the number of text documents in the collection.
c(en_US.document[1:3]) #Concatenates several text collections to a single one.

# Data inspect
show(en_US.document)
summary(en_US.document)
inspect(en_US.document)

# transformation
getTransformations()
en_US.document[[1]]
stemDocument(en_US.document[[1]])
