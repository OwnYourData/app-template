appSource <- function(){
        fluidRow(
                column(12,
                       tabsetPanel(
                               type="tabs",
                               tabPanel("Email-Benachrichtigungen",
                                        fluidRow(
                                                column(2,
                                                       img(src='email.png',width='100px')),
                                                column(10,
                                                       helpText('Wenn du hier deine Emailadresse eingibst, erhältst du jeden Morgen eine Email mit der Frage nach deiner aktuellen Top-Prioriät.'),
                                                       textInput('email', 'Emailadresse:'),
                                                       htmlOutput('email_status'),
                                                       checkboxInput('showEmailsetup', 'Emailsetup konfigurieren', FALSE),
                                                       conditionalPanel(condition = 'input.showEmailsetup',
                                                                        wellPanel(
                                                                                h3('Email Konfiguration'),
                                                                                htmlOutput('mail_config'),
                                                                                textInput('mailer_address', 'Mail Server:'),
                                                                                numericInput('mailer_port', 'Port:', 0),
                                                                                textInput('mailer_user', 'Benutzer:'),
                                                                                passwordInput('mailer_password', 'Passwort')
                                                                        )
                                                       )
                                                )
                                        )
                                )
                       )
                )
        )
}