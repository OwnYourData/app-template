uiStatusItems <- function(){
        # source('uiStatusItemsFixed.R')
        # uiStatusItemsFixed()
        tagList(
                bsAlert('dataStatus'),
                uiOutput('desktopUiStatusItemsRender')
        )
}
