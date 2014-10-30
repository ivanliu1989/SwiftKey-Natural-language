setwd('/Users/ivan/Work_directory/SwiftKey')
require(tm)
require(Rstem)
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
install.packages('SnowballC')
