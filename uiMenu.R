uiMenu <- function(){

           tabPanel(HTML(paste0("Version</a></li><li><a href=\"https://github.com/OwnYourData/app-",
                                appName,
                                "/blob/master/README.md\">Dokumentation")),
                    fluidRow(
                            column(1),
                            column(10,
                                   sidebarLayout(
                                           sidebarPanel(
                                                   p('Support: ',
                                                     a(href='mailto:support@ownyourdata.eu',
                                                       'support@ownyourdata.eu')),
                                                   p('Bugtracking: ',
                                                     a(href=paste0('https://github.com/OwnYourData/app-',
                                                                   appName,
                                                                   '/issues'),
                                                       'Github')),
                                                   hr(),
                                                   p('entwickelt von ',
                                                     a(href='https://www.ownyourdata.eu',
                                                       'https://OwnYourData.eu')),
                                                   p('MIT Lizenz, 2016')),
                                           mainPanel(
                                                   h2('akutelle Version: 0.3.0'),
                                                   htmlOutput('upgradeLink'),
                                                   hr(),
                                                   h3('Versionsverlauf'),
                                                   p(strong('Version 0.3.0')),
                                                   p('erstes Release')))
                            )))
}