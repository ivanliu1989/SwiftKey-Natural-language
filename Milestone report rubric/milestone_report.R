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
require(scales); require(gridExtra)

## 1 ##
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

lengths <- c(length(en_US_blogs),length(en_US_news),length(en_US_twitter))
lengths <- data.frame(lengths)
lengths$names <- c("blogs","news","twitter")

ggplot(lengths,aes(x=names,y=lengths)) +
    geom_bar(stat='identity',fill='cornsilk',color='grey60') + 
    xlab('Source') + ylab('Total Lines') + coord_flip() + 
    geom_text(aes(label=format(lengths,big.mark=","),size=3),labels=comma,vjust=-0.2) +
    scale_y_continuous(limits=c(0,2600000),labels=comma) +
    theme(legend.position='none') + 
    ggtitle('Total Line Count by Text Source')

## 2 ##
en_US_blogs <- gsub("[^[:alpha:][:space:]']", " ", en_US_blogs)
en_US_blogs <- gsub("â ", "'", en_US_blogs)
en_US_blogs <- gsub("ã", "'", en_US_blogs)
en_US_blogs <- gsub("ð", "'", en_US_blogs)

en_US_news <- gsub("[^[:alpha:][:space:]']", " ", en_US_news)
en_US_news <- gsub("â ", "'", en_US_news)
en_US_news <- gsub("ã", "'", en_US_news)
en_US_news <- gsub("ð", "'", en_US_news)

en_US_twitter<- gsub("[^[:alpha:][:space:]']", " ", en_US_twitter)
en_US_twitter <- gsub("â ", "'", en_US_twitter)
en_US_twitter <- gsub("ã", "'", en_US_twitter)
en_US_twitter <- gsub("ð", "'", en_US_twitter)

en_US_blogs <- Trim(clean(en_US_blogs))
en_US_news <- Trim(clean(en_US_news))
en_US_twitter <- Trim(clean(en_US_twitter))

en_US_blogs <- tolower(en_US_blogs)
en_US_news <- tolower(en_US_news)
en_US_twitter <- tolower(en_US_twitter)