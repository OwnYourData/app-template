source("appStatusItemDefault.R")
source("uiStatusItemConfig.R")

uiStatusItemsFixed <- function(){
        tabsetPanel(type='tabs',
                appStatusItemDefault(),
                uiStatusItemConfig()
        )
}
