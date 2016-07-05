uiMobile <- function(){
        navbarPage("Christoph's PIA", collapsible = TRUE,
                   tabPanel("Wortwolke",
                            selectInput('dateSelect',
                                        label = 'Auswahl',
                                        choices = c('letzte Woche'='1',
                                                    'letztes Monat'='2',
                                                    'letzten 2 Monate'='3',
                                                    'letzten 6 Monate'='4',
                                                    'aktuelles Jahr'='5',
                                                    'letztes Jahr'='6',
                                                    'individuell'='7')),
                            plotOutput(outputId = 'plotCloudMobile', height = '300px')),
                   tabPanel("PIA Einrichtung",
                            h3('Authentifizierung'),
                            textInput('pia_urlMobile', 'Adresse:'),
                            textInput('app_keyMobile', 'Key:'),
                            textInput('app_secretMobile', 'Secret:'),
                            actionButton('localStoreMobile', 'Zugriffsinformationen speichern', icon('save')),
                            hr(),
                            htmlOutput('current_tokenMobile'),
                            htmlOutput('current_recordsMobile')
                   )
        )        
}