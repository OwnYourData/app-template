# UI Elements
buildStatTabUI <- function(defaultStatTabUI, extStatTabUI){
        customStatTabUi <- ','
        if(nrow(extStatTabUI)>0) {
                customStatTabUi <- paste(
                        apply(
                                extStatTabUI,
                                1,
                                function(x)
                                        paste(
                                                statTabUiItemHeader,
                                                x['name'],
                                                statTabUiItemInter,
                                                x['ui'],
                                                statTabUiItemFooter)
                        ),
                        collapse = ', '
                )
                customStatTabUi <- paste(',', customStatTabUi, ',')
        }
        paste(
                statTabUiHeader,
                defaultStatTabUI,
                customStatTabUi,
                statTabUiConfig,
                statTabUiFooter
        )
}

readExtItems <- function(currRepo){
        if(length(currRepo) > 0){
                extUrl <- itemsUrl(currRepo[['url']], 
                                   paste0(currRepo[['app_key']],'.extension'))
                extItems <- readItems(currRepo, extUrl)
        } else {
                extItems <- data.frame()
        }
        extItems
}

observe({
        repo <- currRepo()
        extItems <- readExtItems(repo)
        if(nrow(extItems) > 0){
                statTabUiList <<- extItems[extItems$type == 'status', 'name']
                statTabUI <- buildStatTabUI(
                        defaultStatTabUI,
                        extItems[extItems$type == 'status', c('name', 'ui')])
                statTabLogic <- paste(
                        defaultStatTabLogic, 
                        paste(extItems[extItems$type == 'status', 'logic']))
        } else {
                statTabUiList <<- vector()
                statTabUI <- buildStatTabUI(
                        defaultStatTabUI,
                        data.frame())
                statTabLogic <- defaultStatTabLogic
        }
        eval(parse(text = statTabLogic))
})

observe({
        if(!is.null(input$addExtStatusItem)){
                input$addExtStatusItem
                extName <- ''
                extUi <- ''
                extLogic <- ''
                isolate({
                        extName <- input$extStatusItemName
                        extUi <- input$extStatusItemUi
                        extLogic <- input$extStatusItemLogic })
                if(!is.null(extName)){
                        if(extName != ''){
                                extRepo <- getRepo(extensionUrl, extensionId, extensionSecret)
                                extUrl <- itemsUrl(extensionUrl, extensionId)
                                data <- list(app=repo_app, 
                                             type='status',
                                             name=extName,
                                             ui=extUi,
                                             logic=extLogic)
                                writeRecord(extRepo, extUrl, data)
                                extItems <- readExtItems(repo_app)
                                if(nrow(extItems) > 0){
                                        statTabUiList <<- extItems[extItems$type == 'status', 'name']
                                        statTabUI <<- buildStatTabUI(
                                                defaultStatTabUI,
                                                extItems[extItems$type == 'status', c('name', 'ui')])
                                        statTabLogic <<- paste(
                                                defaultStatTabLogic, 
                                                paste(extItems[extItems$type == 'status', 'logic']))
                                        
                                        output$statusItemsUI <- renderUI(
                                                eval(parse(text = paste0(
                                                        "tagList(",
                                                        statTabUI,
                                                        ")"))))
                                        eval(parse(text = extLogic))
                                }
                                
                        }
                }
        }
})

output$uiStatusItemsRender <- renderUI({
        repo <- currRepo()
        extItems <- readExtItems(repo)
        if(nrow(extItems) > 0){
                statTabUiList <<- extItems[extItems$type == 'status', 'name']
                statTabUI <- buildStatTabUI(
                        defaultStatTabUI,
                        extItems[extItems$type == 'status', c('name', 'ui')])
        } else {
                statTabUiList <<- vector()
                statTabUI <- buildStatTabUI(
                        defaultStatTabUI,
                        data.frame())
        }
        eval(parse(text = paste0(
                "tagList(",
                statTabUI,
                ")")))
})
