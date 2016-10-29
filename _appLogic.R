# application specific logic
# last update: 2016-10-07

source('srvDateselect.R', local=TRUE)
source('srvEmail.R', local=TRUE)

# any record manipulations before storing a record
appData <- function(record){
        record
}

getRepoStruct <- function(repo){
        appStruct[[repo]]
}

repoData <- function(repo){
        data <- data.frame()
        app <- currApp()
        if(length(app) > 0){
                url <- itemsUrl(app[['url']],
                                repo)
                data <- readItems(app, url)
        }
        data
}

currData <- reactive({
        # list any input controls that effect currData
        app <- currApp()
        if(length(app) > 0) {
                url <- itemsUrl(app[['url']], 
                                paste0(app[['app_key']]))
                piaData <- readItems(app, url)
        } else {
                piaData <- data.frame()
        }
        piaData
})
