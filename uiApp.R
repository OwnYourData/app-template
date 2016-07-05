source('appStatus.R', local=TRUE)
source('appSource.R', local=TRUE)
source('appStore.R', local=TRUE)

uiApp <- function(){
         fluidRow(
                 column(1),
                 column(10,
                        tags$div(class='panel panel-default',
                                 tags$div(class='panel-heading',
                                          tags$h3(class='panel-title pull-left', appTitle,
                                                  style='font-size:200%'),
                                          tags$button(id='buttonStore', type='button',
                                                      class='btn btn-default action-button pull-right',
                                                      style='margin-left:5px',
                                                      icon('table'), 'Gesammelte Daten'),
                                          tags$button(id='buttonSource', type='button',
                                                      class='btn btn-default action-button pull-right',
                                                      style='margin-left:5px',
                                                      icon('cloud-download'), 'Datenquellen'),
                                          tags$button(id='buttonVisual', type='button',
                                                      class='btn btn-default action-button pull-right',
                                                      icon('line-chart'), 'Auswertungen'),
                                          tags$div(class='clearfix')
                                          
                                 ),
                                 tags$div(class='panel-body',
                                          conditionalPanel(
                                                  condition = "output.displayVisual != ''",
                                                  appStatus()
                                          ),
                                          conditionalPanel(
                                                  condition = "output.displaySource != ''",
                                                  appSource()
                                          ),
                                          conditionalPanel(
                                                  condition = "output.displayStore != ''",
                                                  appStore()
                                          )
                                 )
                        )
                 )
         )
}