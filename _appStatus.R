source("uiStatusDateSelect.R")
source("uiStatusItems.R")
source("uiStatusItemConfig.R")

appStatus <- function(){
        fluidRow(
                column(12,
                       uiStatusDateSelect(),
                       bsAlert('noData'),
                       uiStatusItems()
                )
        )
}

defaultStatTabsName <- c('Tab1', 'Tab2')

defaultStatTabsUI <- c(
        "
        tabPanel('Tab1',
                 textInput(inputId=ns('defaultInput1'), 
                           'Eingabe1:'),
                 htmlOutput(outputId = ns('defaultStatusItem1'))
        )
        ",
        "
        tabPanel('Tab2',
                 textInput(inputId=ns('defaultInput2'), 
                           'Eingabe2:'),
                 htmlOutput(outputId = ns('defaultStatusItem2'))
        )
        "
)

defaultStatTabsLogic <- c(
        "
        output$defaultStatusItem1 <- renderUI({
                input$defaultInput1
        })
        ",
        "
        output$defaultStatusItem2 <- renderUI({
                input$defaultInput2
        })
        "
)
