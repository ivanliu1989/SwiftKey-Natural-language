###########################
### Tasks to accomplish ###
###########################
# 1. Explore new models and data to improve your predictive model.
# 2. Evaluate your new predictions on both accuracy and efficiency. 

#############################
### Questions to consider ###
#############################
# 1. What are some alternative data sets you could consider using? 
# 2. What are ways in which the n-gram model may be inefficient?
# 3. What are the most commonly missed n-grams? Can you think of a reason why they would be missed and fix that? 
# 4. What are some other things that other people have tried to improve their model? 
# 5. Can you estimate how uncertain you are about the words you are predicting? 

##############
### Script ###
##############
setwd('H:/Machine_Learning/SwiftKey/')
setwd('C:\\Users\\Ivan.Liuyanfeng\\Desktop\\Data_Mining_Work_Space\\SwiftKey')
setwd('/Users/ivan/Work_directory/SwiftKey')
Sys.setenv(JAVA_HOME="C:\\Program Files\\Java\\jre7\\")

rm(list=ls(all=TRUE));gc(reset=TRUE);par(mfrow=c(1,1))
require(tm); require(SnowballC); require(stringr);require(RWeka); 
require(qdap); require(scales); require(gridExtra); require(data.table)

load('completed/ngrams_model.RData') 
source('Swiftkey-Natural-language/func/Task_5.5_Predict_func.R')

## make prediction
input <- 'could you'
system.time(result <- predictNgrams(input))
result
