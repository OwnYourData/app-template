source("appStatusItemDefault.R")

uiStatusItemsFixed <- function(){
        tabsetPanel(type='tabs',
                    appStatusItemDefaultUI('desktopStatusItems'),
#                appStatusItemDefault(),
                uiStatusItemConfig()
        )
}
