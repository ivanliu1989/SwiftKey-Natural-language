library(shiny)

shinyUI(
    navbarPage("SwiftKey Language Modelling", inverse = FALSE, collapsable = FALSE,
                   tabPanel("Prediction",
                            fluidRow(
                                sidebarPanel(
                                    helpText(h5("Help Instruction:")),
                                    helpText("Please have a try to make the prediction by using
                                             the dashboard on right side. Specifically, you can:"),
                                    helpText("1. Type your sentence in the text field", style="color:blue"),
                                    helpText("2. Click SUBMIT button to pass the value to the model.", style="color:blue"),
                                    helpText("3. Obtain predictions below.", style="color:blue"),
                                    br(),
                                    helpText(h5("Note:")),
                                    helpText("The App will be initialized at the first load.
                                             After 100% loading, you will see the prediction
                                             for the default sentence example \"How are you?\"
                                             on the right side."),
                                    br(),
                                    h6("This App is built based on:"),
                                    a("Data Science Capstone", href="https://www.coursera.org/course/dsscapstone"),
                                    p("class started on 10-27-2014")
                                ),
                                mainPanel(
                                    textInput("entry", 
                                              h5("What's the next word for my sentence? Input here:"),
                                              "How are you"),
                                    submitButton("SUBMIT"),
                                    br(),
## one                                    
                                    h3("Word Prediction"),
                                    h5('The sentence you just typed:'),                             
                                    span(h4(textOutput('sent')),style = "color:blue"),
                                    br(),
                                    h5('Single Word Prediction:'),
                                    span(h4(textOutput('top1')),style = "color:red"),
                                    br(),
                                    h5('Other Possible Single Word Prediction:'),
                                    span(h5(textOutput('top2')),style = "color:green"),
                                    span(h5(textOutput('top3')),style = "color:green"),
                                    span(h5(textOutput('top4')),style = "color:green"),
                                    span(h5(textOutput('top5')),style = "color:green"),
                                    br(),
                                    p('More details of the prediction algorithm and source codes', 
                                      code("Predict_func.R"), code("server.R"), code("ui.R"), 
                                      'cand be found in', a("SwiftKey-Natural-language.",href="https://github.com/ivanliu1989/SwiftKey-Natural-language"))
                                )
                            ),
                                fluidRow(
                                    p(em("Email:",a("ivan.liuyanfeng@gmail.com",href="mailto: ivan.liuyanfeng@gmail.com"))),
                                    p(em("Linkedin:",a("Tianxiang(Ivan) Liu",href="https://www.linkedin.com/in/ivanliu1989"))),
                                    p(em("Github Repository:",a("SwiftKey-Natural-language",href="https://github.com/ivanliu1989/SwiftKey-Natural-language")))
                                    )
                   ),
                   tabPanel("App Algorithm",
                            sidebarLayout(
                                sidebarPanel(
                                    helpText(h5("Help Instruction:")),
                                    helpText("Please switch the panels on the right side to figure out:"),
                                    helpText("1. How is the word being predicted?", style="color:blue"),
                                    helpText("2. How does this App work?", style="color:blue"),
                                    br(),
                                    helpText(h5("Note:")),
                                    helpText("For more information, you can go to Documents on the navi bar
                                             to read relevant intrim report and final report of this data product."),
                                    br()
                                    ),
                                mainPanel(
                                    tabsetPanel(type="tabs",
                                                tabPanel("Predictive Model",                                                      
                                                         h3("Predictive Model Establishment"),
                                                         h4("Clean the training dataset"),
                                                         p("The dataset was cleaned by ", code("tokenization()"), "and", code("ngramify()"),
                                                           "functions built by author in R. They are able to help users tokenize and ngramify
                                                           the text data in an automatic way and allow user to split large datasets into a bunch of
                                                           user defined number of small ones in order to reduce the", code("processing time"), "and avoid the 
                                                           ", code("memory limits"), "issues."),
                                                         p("The raw text datasets are about 580M in total-", code('en_US.blogs.txt-210M'),
                                                           code('en_US.news.txt-206M'),code('en_US.twitter.txt-167M')),
                                                         p("After the preprocessing to the datasets including cleaning, tokenizing and ngramifing, 
                                                           the three raw datasets are combined and then 1-4 grams frequency matrix are built. 
                                                           The total size of new dataset", code("ngrams_model.RData"), "is reduced to 36M."),
                                                         br(),
                                                         h4("Build the model"),
                                                         p(a("Simple Good-Turing", href = "https://class.coursera.org/nlp/lecture/32"),
                                                           'and Back off techniques were used for estimating the probabilities corresponding to the observed frequencies, 
                                   and the joint probability of all unobserved species. The last three words of users\' input sentence will be extracted first and used
                                                           for seach in 4-grams matrix. If none result is return, then we will move back to 3-grams, and then 2-grams and 1-gram.
                                                           the final predictions will be chosen accordingly by the frequency and n-grams of the model.' ),                                                         
                                                         br(),
                                                         br()
                                                         ),

                                                tabPanel("App Workflow",                                                       
                                                         h3("Shiny App Prediction Algorithm"),
                                                         h4("Preprocess"),
                                                         p("1. Obtain the data from the", code("input box.")),
                                                         p("2.", code("Cleaning"), "for the data sentence. Numbers, punctuations,
                                   extra spaces will be removed, and all words are converted to lowercase."),
                                                         br(),
                                                         h4("Tokenize"),
                                                         p("After preprocessing, the sentence will be truncated from the", code("last 3 words.")
                                   , "If there are less than 3 words, all the words will be used."),
                                                         br(),
                                                         h4("Search pattern"),
                                                         p("Search the pattern from the", code("n-gram model."), 
                                   "The algormithm will search the pattern from 
                                   the 3-grams frequency matrix, and then return the Top 5 frequent predictions.However, 
                                   if there is no result, it will automatically search the 2-grams, 
                                   and if it still no result, it will search the 1-gram matrix."),
                                                         br(),
                                                         h4("Predict the next single word"),
                                                         p("The next possible single word will be returned and displayed. 
                                   In addition, the top 5 possible words also could be found. The average predicting time for
                                                           one input is usually", code("0.000 ~ 0.003s"), "by using this model, which 
                                                           is pretty desent for a mobile predictive model based on such large datasets.")
                                                )
                                                )
                                    )
                            ),
                            fluidRow(
                                p(em("Email:",a("ivan.liuyanfeng@gmail.com",href="mailto: ivan.liuyanfeng@gmail.com"))),
                                p(em("Linkedin:",a("Tianxiang(Ivan) Liu",href="https://www.linkedin.com/in/ivanliu1989"))),
                                p(em("Github Repository:",a("SwiftKey-Natural-language",href="https://github.com/ivanliu1989/SwiftKey-Natural-language")))
                            )
                            ),
                   navbarMenu("Documents",
                              tabPanel("Interim Report",
                                       fluidPage(
                                           includeMarkdown('SwiftKey_NLP_Milestone_Report.md')
                                       )
                              ),
                              tabPanel("Final Report",
                                       fluidPage(
                                           includeMarkdown('SwiftKey_NLP_Milestone_Report.md')
                                           )  
                                       )
                              )
                   )
)
