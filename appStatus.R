source("uiStatusDateSelect.R")
source("uiStatusItems.R")

appStatus <- function(){
        fluidRow(
                column(12,
                       uiStatusDateSelect(),
                       bsAlert('noData'),
                       uiStatusItems(),
                       bsAlert("noPIA")
                )
        )
}