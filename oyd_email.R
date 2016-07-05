# Email reminders =========================================        
getLocalEmailConfig <- reactive({
        validEmailConfig <- FALSE
        server <- input$mailer_address
        port <- input$mailer_port
        user <- input$mailer_user
        pwd <- input$mailer_password
        if((nchar(server) > 0) & 
           (nchar(port) > 0) & 
           (nchar(user) > 0) & 
           (nchar(pwd) > 0)) {
                validEmailConfig <- TRUE
        }
        c('valid'=validEmailConfig,
          'server'=server,
          'port'=port,
          'user'=user,
          'pwd'=pwd)
})

emailConfigStatus <- function(repo){
        localMailConfig <- getLocalEmailConfig()
        piaMailConfig <- getPiaEmailConfig(repo)
        if (localMailConfig[['valid']]) {
                # is there already a config in PIA?
                if (length(piaMailConfig) > 0) {
                        # is it different?
                        if((localMailConfig[['server']] == piaMailConfig[['server']]) &
                           (localMailConfig[['port']] == piaMailConfig[['port']]) &
                           (localMailConfig[['user']] == piaMailConfig[['user']]) &
                           (localMailConfig[['pwd']] == piaMailConfig[['pwd']])) {
                                'config in sync'
                        } else {
                                updateEmailConfig(repo, 
                                                  localMailConfig, 
                                                  piaMailConfig[['id']])
                                'config updated'
                        }
                } else {
                        writeEmailConfig(repo, localMailConfig)
                        'config saved'
                }
        } else {
                # is there already a config in PIA?
                if (length(piaMailConfig) > 0) {
                        setEmailConfig(session, piaMailConfig)
                        'config loaded' # Mailkonfiguration von PIA gelesen
                } else {
                        'not configured' # keine Mailkonfiguration vorhanden
                }
        }
}

emailReminderStatus <- reactive({
        repo <- currRepo()
        if(length(repo) > 0){
                piaMailConfig <- getPiaEmailConfig(repo)
                piaSchedulerEmail <- getPiaSchedulerEmail(repo)
                piaEmail <- ''
                piaEmailId <- NA
                if (length(piaMailConfig) == 0) {
                        'no mail config'
                } else {
                        if (length(piaSchedulerEmail) > 0) {
                                piaEmail <- piaSchedulerEmail[['email']]
                                piaEmailId <-  piaSchedulerEmail[['id']]
                        }
                        localEmail <- as.character(input$email)
                        if(validEmail(localEmail)) {
                                if (localEmail == piaEmail) {
                                        'email in sync'
                                } else {
                                        goal_fields <- list(
                                                date='Date.now',
                                                value='line_1'
                                        )
                                        goal_structure <- list(
                                                repo=repo_app,
                                                fields=goal_fields
                                        )
                                        response_structure <- list(
                                                goal_structure
                                        )
                                        content <- 'Was ist dein heutiges Ziel?'
                                        timePattern <- '0 7 * * *'
                                        if (piaEmail == '') {
                                                writeSchedulerEmail(
                                                        repo,
                                                        localEmail,
                                                        content,
                                                        timePattern,
                                                        response_structure)
                                                'email saved'
                                        } else {
                                                updateSchedulerEmail(
                                                        repo,
                                                        localEmail,
                                                        content,
                                                        timePattern,
                                                        response_structure,
                                                        piaEmailId)
                                                'email updated'
                                        }
                                }
                        } else {
                                if (nchar(localEmail) == 0) {
                                        if (piaEmail == '') {
                                                'missing email'
                                        } else {
                                                setSchedulerEmail(session, piaEmail)
                                                'email loaded'
                                        }
                                } else {
                                        'invalid email'
                                }
                        }
                }
        } else {
                'no Pia'
        }
        
})

output$mail_config <- renderText({
        repo <- currRepo()
        if(length(repo) > 0){
                retVal <- emailConfigStatus(repo)
                switch(retVal,
                       'config in sync' = 'Benachrichtigungen via Email sind eingerichtet',
                       'not configured' = 'Benachrichtigungen via Email sind noch nicht konfiguiert',
                       'config saved'   = 'Emailkonfiguration in PIA gespeichert',
                       'config updated' = 'Emailkonfiguration in PIA aktualisiert',
                       'config loaded'  = 'Emailkonfiguration aus PIA geladen')
        } else {
                'keine Verbindung zu PIA'
        }
})

output$email_status <- renderText({
        retVal <- emailReminderStatus()
        paste('<strong>Status:</strong>',
              switch(retVal,
                     'no Pia'         = 'keine Verbindung zu PIA',
                     'no mail config' = 'Emailkonfiguration noch nicht vorhanden',
                     'missing email'  = 'fehlende Emailadresse',
                     'invalid email'  = 'ungültige Emailadresse',
                     'email loaded'   = 'Emailadresse aus PIA geladen',
                     'email in sync'  = 'periodische Email-Benachrichtigungen werden versandt',
                     'email saved'    = 'Emailadresse in PIA gespeichert',
                     'email updated'  = 'Emailadresse in PIA aktualisiert'))
})
