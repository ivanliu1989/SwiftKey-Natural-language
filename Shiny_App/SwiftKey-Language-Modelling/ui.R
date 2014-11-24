library(shiny)

shinyUI(
    navbarPage("SwiftKey Language Modelling", inverse = FALSE, collapsable = FALSE,
                   tabPanel("Prediction",
                            fluidRow(
                                sidebarPanel(
                                    textInput("entry", 
                                              h5("What's the next word for my sentence? Input here:"),
                                              "How are you"),
                                    submitButton("SUBMIT"),
                                    br(),
                                    helpText("Help Instruction:"),
                                    helpText("To predict the next word, please type a sentence
                                             into the input box and then press SUBMIT button.
                                             Enjoy!", style="color:blue"),
                                    br(),
                                    helpText("Note:"),
                                    helpText("The App will be initialized at the first usage.
                                             After 100% loading, you will see the prediction
                                             for the default sentence example \"How are you?\"
                                             on the right side."),
                                    br(),
                                    h6("This App is built based on:"),
                                    a("Data Science Capstone", href="https://www.coursera.org/course/dsscapstone"),
                                    p("class started on 10-27-2014")
                                ),
                                mainPanel(
                                    
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
                                    helpText("Help Instruction:"),
                                    helpText("Please switch the panels on the right side to figure out:"),
                                    helpText("1. How this predictive model works?"),
                                    helpText("2. How this App works?"),
                                    br(),
                                    helpText("Note:"),
                                    helpText("Next, you can go to Documents on the navi bar to read relevant
                                             intrim report and final report of this data product."),
                                    br()
                                ),
                                mainPanel(
                                    tabsetPanel(
                                    )
                                )
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
