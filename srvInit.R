observeEvent(input$p1next, ({
        updateCollapse(session, 'collapse', 
                       open = 'PIA',
                       style = list(
                               "Willkommen" = 'info',
                               'PIA' = 'primary',
                               'Fertig' = 'info'))
}))

observe({
        session$sendCustomMessage(type='setPiaUrl', 
                                  input$store$pia_url)
})

observeEvent(input$p2prev, ({
        updateCollapse(session, 'collapse', 
                       open = 'Willkommen',
                       style = list(
                               "Willkommen" = 'primary',
                               'PIA' = 'info',
                               'Fertig' = 'info'))
}))

observeEvent(input$p2next, ({
        updateStore(session, "pia_url", isolate(input$modalPiaUrl))
        updateStore(session, "app_key", isolate(input$modalPiaId))
        updateStore(session, "app_secret", isolate(input$modalPiaSecret))
        updateTextInput(session, "pia_url", value=isolate(input$modalPiaUrl))
        updateTextInput(session, "app_key", value=isolate(input$modalPiaId))
        updateTextInput(session, "app_secret", value=isolate(input$modalPiaSecret))
        updateCollapse(session, 'collapse', 
                       open = 'Fertig',
                       style = list(
                               "Willkommen" = 'info',
                               'PIA' = 'info',
                               'Fertig' = 'primary'))
}))

observeEvent(input$p3prev, ({
        updateCollapse(session, 'collapse', 
                       open = 'PIA',
                       style = list(
                               "Willkommen" = 'info',
                               'PIA' = 'primary',
                               'Fertig' = 'info'))
}))

observeEvent(input$p3close, ({
        toggleModal(session, 'startConfig', toggle = "toggle")
}))
