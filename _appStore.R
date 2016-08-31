appStore <- function(){
        fluidRow(
                column(12,
                       bsAlert('topAlert'),
                       bsAlert('recordAlert'),
                       h3('Datenblatt'),
                       helpText('Änderungen an den Daten werden sofort übernommen'),
                       rHandsontableOutput('dataSheet'),
                       br(),
                       downloadButton('exportCSV', 'CSV Export')
                )
        )
}
