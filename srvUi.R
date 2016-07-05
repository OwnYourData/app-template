output$upgradeLink <- renderText({
        renderUpgrade(session)
})

output$hdrImageLink <- renderUI({
        tags$div(
                tags$a(href=input$store$pia_url, 
                       tags$img(height="25px", 
                                src=oydLogo)),
                tags$a(href=input$store$pia_url, "Christoph's PIA")
        )
})

observeEvent(input$buttonVisual, {
        output$displayVisual <- renderText('.')
        output$displaySource <- renderText('')
        output$displaySource <- renderText('')
})

observeEvent(input$buttonSource, {
        output$displayVisual <- renderText('')
        output$displaySource <- renderText('.')
        output$displayStore <- renderText('')
})

observeEvent(input$buttonStore, {
        output$displayVisual <- renderText('')
        output$displaySource <- renderText('')
        output$displayStore <- renderText('.')
})

output$displayVisual <- reactive({
        output$displayVisual <- renderText('.')
        output$displaySource <- renderText('')
        output$displayStore <- renderText('')
})
