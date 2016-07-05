source('uiStart.R')
source('uiApp.R')
source('uiMenu.R')
source('uiFooter.R')

uiDesktop <- function(){
        tagList(
                uiStart(),
                navbarPage(
                        uiOutput('hdrImageLink'),
                                id='page', 
                                collapsible=TRUE, 
                                inverse=FALSE,
                                windowTitle=paste0(appTitle, ' | OwnYourData'),
                        tabPanel(HTML(paste0(appTitle, '</a></li>',
                                             '<li><a id="returnPIAlink" href="#">zurück zur PIA')),
                                 uiApp()
                        ),
                        navbarMenu(icon('wrench'),
                                   uiMenu()
                        ),
                        footer=uiFooter()
                )
        )
}