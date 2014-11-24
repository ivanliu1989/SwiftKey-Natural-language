library(shiny)
require(markdown)

shinyUI(
    navbarPage("SwiftKey Natural Language Prediction", inverse = FALSE, collapsable = FALSE, 
                   tabPanel("Prediction",
                            fluidRow(
                                sidebarPanel(width=3,
                                             h5("Text Input:"),
                                             textInput("entry", 
                                                       "The app will predict your next possible word you want to type. Now, please type your input here:",
                                                       "Nice to meet you"),
                                             # submitButton('Predict'),
                                             sliderInput("max", 
                                                         h5("Maximum Number of Words:"), 
                                                         min = 10,  max = 200,  value = 100),
                                             br(),
                                             actionButton("update", "Update Word Cloud"),
                                             hr(),
                                    helpText(h5("Help Instruction:")),
                                    helpText("Please have a try to make the prediction by using
                                             the dashboard on right side. Specifically, you can:"),
                                    helpText("1. Type your sentence in the text field", style="color:blue"),
                                    helpText("2. The value will be passed to the model while you are typing.", style="color:blue"),
                                    helpText("3. Obtain the instant predictions below.", style="color:blue"),
                                    hr(),
                                    helpText(h5("Note:")),
                                    helpText("The App will be initialized at the first load.
                                             After", code("100% loading"), ", you will see the prediction
                                             for the default sentence example \"Nice to meet you\"
                                             on the right side."),
                                    hr(),
                                    h6("This App is built for:"),
                                    a("Data Science Capstone (SwiftKey)", href="https://www.coursera.org/course/dsscapstone"),
                                    p("class started on 10-27-2014"),
                                    hr(),
                                    h6("For more information about Ivan Liu:"),
                                    a(img(src = "GitHub-Mark.png", height = 30, width = 30),href="https://github.com/ivanliu1989/SwiftKey-Natural-language"),
                                    a(img(src = "linkedin.png", height = 26, width = 26),href="https://www.linkedin.com/in/ivanliu1989"),
                                    a(img(src = "gmail.jpeg", height = 30, width = 30),href="mailto: ivan.liuyanfeng@gmail.com"),
                                    br()
                                ),
                                mainPanel(
                                    column(5,
                                    
                                    h3("Word Prediction"),
                                    h5('The sentence you just typed:'),                             
                                    span(h4(textOutput('sent')),style = "color:blue"),
                                    br(),
                                    h5('Single Word Prediction:'),
                                    span(h4(textOutput('top1')),style = "color:red"),
                                    br(),
                                    h5('Other Possible Single Word Predictions:'),
                                    span(h5(textOutput('top2')),style = "color:green"),
                                    span(h5(textOutput('top3')),style = "color:green"),
                                    span(h5(textOutput('top4')),style = "color:green"),
                                    span(h5(textOutput('top5')),style = "color:green"),
                                    br(),
                                    
                                    p('More details of the prediction algorithm and source codes', 
                                      code("server.R"), code("ui.R"), code("Predict_func.R"), code("Tokenization_func.R"), code("ngramify_func.R"), 
                                      'can be found at', a("SwiftKey-Natural-language.",href="https://github.com/ivanliu1989/SwiftKey-Natural-language"))
                                    ),
                                    column(5,
                                           h3("Word Cloud Diagram"),
                                           h5("A", code("word cloud"), "or data cloud is a data display which uses font size and/
                                              or color to indicate numerical values like frequency of words. Please click", code("Update Word Cloud"), 
                                              "button and", code("Slide Input"), "in the side bar to update the plot for relevant prediction."),
                                           plotOutput("wordCloud"), # wordcloud
                                           br()
                                           )
                                )
                            )
                   ),
                   tabPanel("Model/Algorithm",
                            sidebarLayout(
                                sidebarPanel(width=3,
                                    helpText(h5("Help Instruction:")),
                                    helpText("Please switch the panels on the right side to figure out:"),
                                    helpText("1. How is the word being predicted?", style="color:blue"),
                                    helpText("2. How does this App work?", style="color:blue"),
                                    helpText("3. Key concepts / techniques implemented in model", style="color:blue"),
                                    hr(),
                                    helpText(h5("Note:")),
                                    helpText("For more information, you can go to", code("Documents tab"), "in the navi bar
                                             to read relevant intrim report and final report of this data product."),
                                    hr(),
                                    h6("This App is built for:"),
                                    a("Data Science Capstone (SwiftKey)", href="https://www.coursera.org/course/dsscapstone"),
                                    p("class started on 10-27-2014"),
                                    hr(),
                                    h6("For more information about Ivan Liu:"),
                                    a(img(src = "GitHub-Mark.png", height = 30, width = 30),href="https://github.com/ivanliu1989/SwiftKey-Natural-language"),
                                    a(img(src = "linkedin.png", height = 26, width = 26),href="https://www.linkedin.com/in/ivanliu1989"),
                                    a(img(src = "gmail.jpeg", height = 30, width = 30),href="mailto: ivan.liuyanfeng@gmail.com"),
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
                                                         
                                                         h4("Build the model"),
                                                         p(a("Simple Good-Turing", href = "https://class.coursera.org/nlp/lecture/32"),
                                                           'and Back off techniques were used for estimating the probabilities corresponding to the observed frequencies, 
                                   and the joint probability of all unobserved species. The last three words of users\' input sentence will be extracted first and used
                                                           for seach in 4-grams matrix. If none result is return, then we will move back to 3-grams, and then 2-grams and 1-gram.
                                                           the final predictions will be chosen accordingly by the frequency and n-grams of the model.' ),                                                         
                                                        
                                                         h4("A glance of model table"),
                                                         dataTableOutput('modelTable'),
                                                         br(),
                                                         br()
                                                         ),

                                                tabPanel("App Workflow",                                                       
                                                         h3("Shiny App Prediction Algorithm"),
                                                         img(src="work_flow_shiny.png", height = 262, width = 800),
                                                         br(),br(),
                                                         h4("Preprocess"),
                                                         p("1. Obtain the data from the", code("input box.")),
                                                         p("2.", code("Cleaning"), "for the data sentence. Numbers, punctuations,
                                   extra spaces will be removed, and all words are converted to lowercase."),
                                                         
                                                         h4("Tokenize"),
                                                         p("After preprocessing, the sentence will be truncated from the", code("last 3 words.")
                                   , "If there are less than 3 words, all the words will be used."),
                                                         
                                                         h4("Search pattern"),
                                                         p("Search the pattern from the", code("n-gram model."), 
                                   "The algormithm will search the pattern from 
                                   the 3-grams frequency matrix, and then return the Top 5 frequent predictions.However, 
                                   if there is no result, it will automatically search the 2-grams, 
                                   and if it still no result, it will search the 1-gram matrix."),
                                                         
                                                         h4("Predict the next single word"),
                                                         p("The next possible single word will be returned and displayed. 
                                   In addition, the top 5 possible words also could be found. The average predicting time for
                                                           one input is usually", code("0.000 ~ 0.003s"), "by using this model, which 
                                                           is pretty desent for a mobile predictive model based on such large datasets.")
                                                ),
                                   
                                               tabPanel("Key Concepts",                                                      
                                                        h3("Key Concepts/Terminology"),
                                                        
                                                        br()
                                                        )
                                                )
                                    )
                            )
                            ),
                   navbarMenu("Documents",
                              tabPanel("Interim Report", 
                                       sidebarLayout(
                                           sidebarPanel(width=3,
                                                        helpText(h5("Note:")),
                                                        helpText("This document is concise and explain the", code("major features"), "of the data that has been identified 
                                                                 and briefly summarize the plans for creating the prediction algorithm and Shiny app in a way that
                                                                 would be understandable to a non-data scientist manager. It includes:"),
                                                        helpText("1. A basic report of summary statistics about the data sets.", style="color:blue"),
                                                        helpText("2. Interesting findings that author amassed so far.", style="color:blue"),
                                                        helpText("3. Plans for creating a prediction algorithm and Shiny app", style="color:blue"),
                                                        hr(),
                                                        h6("This App is built for:"),
                                                        a("Data Science Capstone (SwiftKey)", href="https://www.coursera.org/course/dsscapstone"),
                                                        p("class started on 10-27-2014"),
                                                        hr(),
                                                        h6("For more information about Ivan Liu:"),
                                                        a(img(src = "GitHub-Mark.png", height = 30, width = 30),href="https://github.com/ivanliu1989/SwiftKey-Natural-language"),
                                                        a(img(src = "linkedin.png", height = 26, width = 26),href="https://www.linkedin.com/in/ivanliu1989"),
                                                        a(img(src = "gmail.jpeg", height = 30, width = 30),href="mailto: ivan.liuyanfeng@gmail.com"),
                                                        br()),
                                           mainPanel(
                                               includeMarkdown('SwiftKey_NLP_Milestone_Report.md')
                                           )
                                       )
                              ),
                              tabPanel("Final Report",
                                       sidebarLayout(
                                           sidebarPanel(width=3,
                                                        helpText(h5("Note:")),
                                                        helpText("This document is a slide deck consisting of 5 slides created with", 
                                                                 a("R Studio Presenter", href="https://support.rstudio.com/hc/en-us/articles/200486468-Authoring-R-Presentations"),
                                                                 "pitching the algorithm and app for the sake of presenting to management or an investor. It includes:"),
                                                        helpText("1. A description of the algorithm used to make the prediction", style="color:blue"),
                                                        helpText("2. Description of app and instructions of how it functions", style="color:blue"),
                                                        helpText("3. Description of the experience of using this app", style="color:blue"),
                                                        hr(),
                                                        h6("This App is built for:"),
                                                        a("Data Science Capstone (SwiftKey)", href="https://www.coursera.org/course/dsscapstone"),
                                                        p("class started on 10-27-2014"),
                                                        hr(),
                                                        h6("For more information about Ivan Liu:"),
                                                        a(img(src = "GitHub-Mark.png", height = 30, width = 30),href="https://github.com/ivanliu1989/SwiftKey-Natural-language"),
                                                        a(img(src = "linkedin.png", height = 26, width = 26),href="https://www.linkedin.com/in/ivanliu1989"),
                                                        a(img(src = "gmail.jpeg", height = 30, width = 30),href="mailto: ivan.liuyanfeng@gmail.com"),
                                                        br()),
                                           mainPanel(
                                               h5("coming soon...")
                                           )
                                       )
                              )
                   )
                   )
)
