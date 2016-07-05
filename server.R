# OYD: Template - last update:2016-06-18
shinyServer(function(input, output, session) {
        source('srvBase.R', local=TRUE)
        source('srvInit.R', local=TRUE)
        source('srvUi.R', local=TRUE)
        source('srvExtension.R', local=TRUE)
        source('srvSource.R', local=TRUE)
        source('srvStore.R', local=TRUE)
        source('appLogic.R', local=TRUE)

})
