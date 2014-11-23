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
                                    showOutput("myChart1", "polycharts")
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
                              tabPanel("Inter",
                                       sidebarLayout(
                                           sidebarPanel(
                                               helpText("Tips:"),
                                               helpText("You can download the table for diamonds information here. Please select a type of diamonds that you are interested first and ensure the right table is the one you are willing to download. Then click the download button below. It will be a .csv format file on your drive."),
                                               selectInput("datasetD", "Choose a dataset:", 
                                                           choices = c("Fair Cut", "Good Cut", 
                                                                       "Very Good Cut", "Premium Cut", 
                                                                       "Ideal Cut", "All"), 'All'),
                                               downloadButton('downloadData', 'Download')
                                           ),
                                           mainPanel(
                                               tableOutput('table_download')
                                           )
                                       )),
                              tabPanel("Exchange Rate", 
                                       sidebarLayout(
                                           sidebarPanel(
                                               helpText("Tips:"),
                                               helpText("You can obtain the latest exchange rate regarding your selected currency from the right chart. Please select a currency type first. Information will be collected from yahoo finance."),
                                               textInput("symb", "Symbol", "AUD"),
                                               dateRangeInput("dates", "Date range", 
                                                              start = "2014-01-01", 
                                                              end = as.character(Sys.Date())),
                                               actionButton("get", "Get Exchange Rate"),
                                               br(),br(),
                                               checkboxInput("log", "Plot y axis on log scale", value = FALSE),
                                               checkboxInput("adjust", "Adjust prices for inflation", value = FALSE)
                                           ),
                                           mainPanel(plotOutput("plot"))
                                       )
                              )
                   )
        )
)
