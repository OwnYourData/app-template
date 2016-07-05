appStore <- function(){
        fluidRow(
                column(12,
                       bsAlert('topAlert'),
                       bsAlert('recordAlert'),
                       h3('Datenblatt'),
                       helpText('Änderungen an den Daten werden sofort übernommen'),
                       rHandsontableOutput('dataSheet'),
                       br(),
                       downloadButton('exportCSV', 'CSV Export'),
                       checkboxInput('showPiaSetup', 'PIA-Zugriff konfigurieren', FALSE),
                       conditionalPanel(
                                condition = 'input.showPiaSetup',
                                wellPanel(
                                        h3('Authentifizierung'),
                                        textInput('pia_url', 'Adresse:'),
                                        textInput('app_key', 'Key:'),
                                        textInput('app_secret', 'Secret:'),
                                        actionButton('localStore', 'Zugriffsinformationen speichern', icon('save')),
                                        hr(),
                                        htmlOutput('current_token'),
                                        htmlOutput('current_records')
                                )
                       )
                )
        )
}
