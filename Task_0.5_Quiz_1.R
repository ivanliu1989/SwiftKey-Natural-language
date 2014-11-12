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

biostats_num <- grep('a case of', readLines(con))
biostats_text <- readLines(con)[biostats_num]

length(grep('A computer once beat me at chess, but it was no match for me at kickboxing', readLines(con)))

close(con) ## It's important to close the connection when you are done

Q1 <- c()
for i in 1:length(biostats_num){
    con <- file(paste(en_US,dir(en_US)[3],sep = ""), "r")
    Q1 <- c(Q1, readLines(con, biostats_num[i]))
    close(con)
}
