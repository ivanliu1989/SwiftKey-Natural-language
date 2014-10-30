setwd('/Users/ivan/Work_directory/SwiftKey')
require(data.table)
en_US.blogs <- as.data.frame(fread('final/en_US/en_US.blogs.txt'))
en_US.news <- as.data.frame(fread('final/en_US/en_US.news.txt'))
en_US.twitter <- as.data.frame(fread('final/en_US/en_US.twitter.txt'))

en_US.blogs <- read.table('final/en_US/en_US.blogs.txt')
