# all tabs in section App-Status
# last update: 2016-10-06

appStatusItems <- function(){
        tabsetPanel(type='tabs',
                    tabPanel('Tab1', br(),
                             p('hello world')
                    )
        )
}
