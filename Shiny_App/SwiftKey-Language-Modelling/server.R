library(shiny)
source('Task_5.5_Predict_func.R')

shinyServer(function(input, output) {
  dataInput <- reactive(predictNgrams(input$entry))
  
  output$top1 <- renderText({
      paste("Top 1:", dataInput()[1])
  })
  output$top2 <- renderText({
      paste("Top 2:", dataInput()[2])
  })
  output$top3 <- renderText({
      paste("Top 3:", dataInput()[3])
  })
  output$top4 <- renderText({
      paste("Top 4:", dataInput()[4])
  })
  output$top5 <- renderText({
      paste("Top 5:", dataInput()[5])
  })
  
  output$text <- renderText({
      dataInput()
  })
  output$sent <- renderText({
      input$entry
  })
  
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
