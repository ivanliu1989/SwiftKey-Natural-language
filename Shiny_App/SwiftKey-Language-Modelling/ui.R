library(shiny)

shinyUI(
    navbarPage("SwiftKey Language Modelling", inverse = FALSE, collapsable = FALSE,
                   tabPanel("Prediction",
                            fluidRow(
                                sidebarPanel(
                                    helpText("Tips:"),
                                    helpText("This is a summary re all diamonds information in our diamonds dataset. It has been visualized by a point plot on the right side. You are able to customize your own summary by selecting different variables you want to explore on x or y axis. You can also choose the categories of diamonds to reflect them on the diagram. Please make the adjustments below."),
                                    selectInput(inputId = "x",
                                                label = "Choose X",
                                                choices = c('clarity', 'depth', 'price', 'carat'),
                                                selected = "price"),
                                    selectInput(inputId = "y",
                                                label = "Choose Y",
                                                choices = c('clarity', 'depth', 'price', 'carat'),
                                                selected = "caret"),
                                    selectInput(inputId= "z",
                                                label = "Choose Category",
                                                choices = c('cut','color','clarity'),
                                                selected = 'cut')
                                ),
                                mainPanel(
                                    
                                )
                            )
                   ),
                   tabPanel("App Algorithm",
                            sidebarLayout(
                                sidebarPanel(
                                    helpText("Tips:")
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
