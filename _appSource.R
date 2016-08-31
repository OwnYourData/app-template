source("uiSourceItemConfig.R")

appSource <- function(){
        uiOutput('desktopUiSourceItemsRender')
}

defaultSrcTabsName <- c('SrcTab1', 'SrcTab2')

defaultSrcTabsUI <- c(
        "
        tabPanel('SrcTab1',
                textInput(inputId=ns('defaultSourceInput1'), 
                        'Eingabe1:'),
                htmlOutput(outputId = ns('defaultSourceItem1'))
        )
        ",
        "
        tabPanel('SrcTab2',
                textInput(inputId=ns('defaultSourceInput2'), 
                        'Eingabe2:'),
                htmlOutput(outputId = ns('defaultSourceItem2'))
        )
        "
)

defaultSrcTabsLogic <- c(
        "
        output$defaultSourceItem1 <- renderUI({
                input$defaultSourceInput1
        })
        ",
        "
        output$defaultSourceItem2 <- renderUI({
                input$defaultSourceInput2
        })
        "
)


#         fluidRow(
#                 column(12,
#                        tabsetPanel(
#                                type="tabs",
#                                tabPanel("Email-Benachrichtigungen",
#                                         fluidRow(
#                                                 column(2,
#                                                        img(src='email.png',width='100px')),
#                                                 column(10,
#                                                        helpText('Wenn du hier deine Emailadresse eingibst, erhältst du jeden Morgen eine Email mit der Frage nach deiner aktuellen Top-Prioriät.'),
#                                                        textInput('email', 'Emailadresse:'),
#                                                        htmlOutput('email_status'),
#                                                        checkboxInput('showEmailsetup', 'Emailsetup konfigurieren', FALSE),
#                                                        conditionalPanel(condition = 'input.showEmailsetup',
#                                                                         wellPanel(
#                                                                                 h3('Email Konfiguration'),
#                                                                                 htmlOutput('mail_config'),
#                                                                                 textInput('mailer_address', 'Mail Server:'),
#                                                                                 numericInput('mailer_port', 'Port:', 0),
#                                                                                 textInput('mailer_user', 'Benutzer:'),
#                                                                                 passwordInput('mailer_password', 'Passwort')
#                                                                         )
#                                                        )
#                                                 )
#                                         )
#                                 )
#                        )
#                 )
#         )
# }