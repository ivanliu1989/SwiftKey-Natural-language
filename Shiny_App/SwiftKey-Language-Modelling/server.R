library(shiny)
library(wordcloud)
load('quatrgrams_model.RData',.GlobalEnv)
load('ngrams_model.RData',.GlobalEnv)
source('Predict_func.R')
source('Predict_func2.R')

shinyServer(function(input, output) {
  dataInput <- reactive(predictNgrams(input$entry))
  
  output$top1 <- renderText({
      paste("Top 1:", input$entry, dataInput()[1])
  })
  output$top2 <- renderText({
      paste("Top 2:", input$entry, dataInput()[2])
  })
  output$top3 <- renderText({
      paste("Top 3:", input$entry, dataInput()[3])
  })
  output$top4 <- renderText({
      paste("Top 4:", input$entry, dataInput()[4])
  })
  output$top5 <- renderText({
      paste("Top 5:", input$entry, dataInput()[5])
  })
  
  output$text <- renderText({
      dataInput()
  })
  output$sent <- renderText({
      input$entry
  })
  
  # Define a reactive expression for the document term matrix
  # terms <- reactive(predictWordcloud(input$entry))
  terms <- reactive({
      input$update
      isolate({predictWordcloud(input$entry)})
      })
  # Make the wordcloud drawing predictable during a session
  wordcloud_rep <- repeatable(wordcloud)
  output$wordCloud <- renderPlot({
      v <- terms()
      wordcloud_rep(v[,2], v[,1], max.words=input$max, scale=c(5,1.5),
                    colors=brewer.pal(4, "Dark2"))
  })
  
  output$modelTable = renderDataTable({
      Quatrgrams_models
  }, options = list(lengthMenu = c(5, 10, 20), pageLength = 5))
  
  withProgress(message = 'Loading Data ...', value = NULL, {
      Sys.sleep(0.25)
      dat <- data.frame(x = numeric(0), y = numeric(0))
      withProgress(message = 'App Initializing', detail = "part 0", value = 0, {
          for (i in 1:10) {
              dat <- rbind(dat, data.frame(x = rnorm(1), y = rnorm(1)))
              incProgress(0.1, detail = paste(":", i*10,"%"))
              Sys.sleep(0.5)
          }
      })
      
      # Increment the top-level progress indicator
      incProgress(0.5)
  })
})
