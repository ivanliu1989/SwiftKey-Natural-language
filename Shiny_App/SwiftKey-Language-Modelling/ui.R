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
                                      code("prediction.R"), code("server.R"), code("ui.R"), 
                                      'cand be found in other Tags.')
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
## two                                                         
                                                         h4("Prediction Model Building"),
                                                         h5("Clean the training dataset"),
                                                         p("The dataset was cleaned by using linux bash scripts. It's a fast and convinent way to clean large dataset."),
                                                         p("The initial dataset is about 560M in total. 
                                   After cleaning the dataset, and disgrading the words with freqency less than 5,
                                   the size of 1-word frequncy list is 2M, 2-word frequency list is 26M, 
                                   and 3-word frequency list is 36M, and 4-word frequency list is 20M"),
                                                         h5("Build the model"),
                                                         p(a("Simple Good-Turing", href = "https://class.coursera.org/nlp/lecture/32"),
                                                           'technique was used for estimating the probabilities corresponding to the observed frequencies, 
                                   and the joint probability of all unobserved species.' ),
                                                         h5("About the Final model"),
                                                         p("The final smoothed model are saved into RData file. The size is about 22M. 
                                   It need to be loaded for the single word prediction."),
                                                         br(),
                                                         br()
                                                         ),
                                                tabPanel("App Workflow",
## three                                                         
                                                         h4("Shiny App Prediction Algorithm"),
                                                         
                                                         h4("Preprocess"),
                                                         p("1. Obtain the data from the input box."),
                                                         p("2. Clean the data sentence. Numbers, punctuations,
                                   extra spaces will be removed, and all words are converted to lowercase."),
                                                         h4("Tokenize"),
                                                         p("After preprocessing, the sentence will be truncated from the last 3 words.
                                   If there are less than 3 words, all the words will be used."),
                                                         h4("Search pattern"),
                                                         p("Search the pattern from the n-gram model. 
                                   The algormithm will search the pattern from 
                                   the 3-gram dataframe, and then return the Top 5 hits.However, 
                                   if there is no hit, it will automatically search the 2-gram, 
                                   and if it still no hit, it will search the 1-gram dataframe."),
                                                         h4("Predict the next single word"),
                                                         p("The next possible single word will be returned and displayed. 
                                   Besides, the top 5 possible words also could be found.")
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
