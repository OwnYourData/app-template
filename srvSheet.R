# show available data in an Excel like UI
# last update: 2016-10-10

values = reactiveValues()
setHot = function(x) values[["dataSheet"]] = x

preserveDate <- function(data, fieldTypes){
        d <- as.list(data)
        if('date' %in% fieldTypes){
                d[fieldTypes == 'date'] <- 
                        as.character(d[fieldTypes == 'date'][[1]])
        }
        d
}

preserveUTF8 <- function(data, fieldTypes){
        d <- as.list(data)
        if(length(all.equal(app, logical(0)))>1){
                for(i in 1:length(d)){
                        if(fieldTypes[i] == 'string'){
                                d[i] <- iconv(as.character(d[i][[1]]),
                                              from='latin1',
                                              to='UTF-8')
                        }
                }
        }
        d
}

bulkUpdateItems <- function(sheetData, repo, fields, fieldTypes){
        app <- currApp()
        if(length(all.equal(app, logical(0)))>1){
                piaData <- repoData(repo)
                repoUrl <- itemsUrl(app[['url']], repo)
                
                sheetDigest <- createDigest(sheetData, fields)
                piaDigest <- createDigest(piaData, fields)
                removePiaData <- 
                        piaData[!(piaDigest$digest %in% sheetDigest$digest), , 
                                drop=FALSE]
                createPiaData <- 
                        sheetData[!(sheetDigest$digest %in% piaDigest$digest), , 
                                  drop=FALSE]
                recCnt <- nrow(removePiaData) + nrow(createPiaData)
                if(recCnt > 0){
                        withProgress(message='Daten aktualisieren', 
                                     max=recCnt, {
                                             cnt <- 0
                                             if(nrow(removePiaData) > 0){
                                                     for(i in 1:nrow(removePiaData)){
                                                             cnt <- cnt + 1
                                                             id <- removePiaData[i, 'id']
                                                             deleteItem(app, repoUrl, id)
                                                             setProgress(value=cnt,
                                                                         detail=paste0(cnt, '/', recCnt,
                                                                                       ' Datensätze'))
                                                             
                                                     }
                                             }
                                             if(nrow(createPiaData) > 0){
                                                     for(i in 1:nrow(createPiaData)){
                                                             cnt <- cnt + 1
                                                             myTmp <- createPiaData[i, fields, drop=FALSE]
                                                             dataItem <- preserveUTF8(
                                                                     preserveDate(
                                                                             createPiaData[i, fields, drop=FALSE],
                                                                             fieldTypes),
                                                                     fieldTypes)
                                                             dataItem <- appData(dataItem)
                                                             writeItem(app, repoUrl, dataItem)
                                                             setProgress(value=cnt,
                                                                         detail=paste0(cnt, '/', recCnt,
                                                                                       ' Datensätze'))
                                                     }
                                             }
                                     }
                        )
                }
        }
}

rhotRender <- function(DF, fieldWidths){
        # write data to Hot
        setHot(DF)
        # nice formatting
        if(nrow(DF)>20) {
                rhandsontable(DF, useTypes=TRUE, height=400) %>%
                        hot_table(highlightCol=TRUE, highlightRow=TRUE,
                                  allowRowEdit=TRUE) %>%
                        hot_cols(colWidths=fieldWidths)
        } else {
                rhandsontable(DF, useTypes=TRUE) %>%
                        hot_table(highlightCol=TRUE, highlightRow=TRUE,
                                  allowRowEdit=TRUE) %>%
                        hot_cols(colWidths=fieldWidths)
        }
}

hot_dat2DF <- function(data, repoStruct, orderDecreasing){
        DF <- data.frame()
        fields <- repoStruct[['fields']] 
        fieldKey <- repoStruct[['fieldKey']] 
        fieldTypes <- repoStruct[['fieldTypes']] 
        fieldInits <- repoStruct[['fieldInits']] 
        fieldTitles <- repoStruct[['fieldTitles']] 
        if(nrow(data) > 0){
                data <- data[, fields, drop=FALSE]
                data <- data[!is.na(data[fieldKey]), , drop=FALSE]
                data <- data[data[fieldKey] != '', , drop=FALSE]
                data <- data[data[fieldKey] != 'NA', , drop=FALSE]
                DF <- rbind(data, rep(NA, length(fields)))
        }
        if(nrow(data) == 0){
                initVal <- vector()
                for(i in 1:length(fields)){
                        switch(fieldInits[i],
                               today = {
                                       initVal <- c(initVal, 
                                                    as.character(as.Date(Sys.Date())))
                               },
                               zero = {
                                       initVal <- c(initVal, 
                                                    0)
                               }, 
                               empty = {
                                       initVal <- c(initVal, 
                                                    '')
                               }
                        )
                }
                names(initVal) <- fields
                DF <- data.frame(lapply(initVal, type.convert), 
                                 stringsAsFactors=FALSE)
        }
        for(i in 1:length(fields)){
                switch(fieldTypes[i],
                       date = {
                               DF[, fields[i]] <-
                                       as.Date(DF[, fields[i]], 
                                               origin="1970-01-01")
                       },
                       timestamp = {
                               DF[, fields[i]] <- 
                                       as.integer(DF[, fields[i]])
                               
                       },
                       double = {
                               DF[, fields[i]] <-
                                       as.double(DF[, fields[i]])
                       }, 
                       string = {
                               DF[, fields[i]] <-
                                       as.character(DF[, fields[i]])
                       }
                )
        }
        if(!missing(orderDecreasing)) {
                if(nrow(DF) > 1){
                        DF <- DF[order(DF[, fieldKey, drop=FALSE], 
                                       decreasing = orderDecreasing), , 
                                 drop=FALSE]
                }
                if(!is.null(nrow(DF))){
                        rownames(DF) <- 1:nrow(DF)
                }
        }
        if(!is.null(nrow(DF))){
                colnames(DF) <- fieldTitles
        }
        DF
}

observe({
        if(!is.null(input$dataSheet)){
                suppressWarnings(
                        values[["dataSheet"]] <- hot_to_r(input$dataSheet))
                output$dataSheetDirty <- renderUI('Daten wurden geändert')
        }
})

observeEvent(input$saveSheet, {
        sheetRecords <- values[["dataSheet"]]
        repo <- input$repoSelect
        repoStruct <- getRepoStruct(repo)
        fields <- repoStruct[['fields']] 
        fieldKey <- repoStruct[['fieldKey']]
        fieldTypes <- repoStruct[['fieldTypes']]
        fieldTitles <- repoStruct[['fieldTitles']]
        fieldWidths <- repoStruct[['fieldWidths']]
        
        if (!is.null(sheetRecords)) {
                colnames(sheetRecords) <- fields
                sheetRecords <- 
                        sheetRecords[!is.na(sheetRecords[fieldKey]), , 
                                     drop=FALSE]
                data <- bulkUpdateItems(sheetRecords,
                                        repo,
                                        fields,
                                        fieldTypes)
                output$dataSheet <- renderRHandsontable({
                        suppressWarnings(
                                DF <- hot_dat2DF(sheetRecords, repoStruct, TRUE))
                        rhotRender(DF, fieldWidths)
                })  
        }
        output$dataSheetDirty <- renderText('')
})

# render Excel View UI
output$dataSheet <- renderRHandsontable({
        DF <- data.frame()
        repo <- getSheetRepo()
        repoStruct <- getRepoStruct(repo)
        fieldKey <- repoStruct[['fieldKey']]
        fieldWidths <- repoStruct[['fieldWidths']]
        if (is.null(input$dataSheet)) {
                if(repo == 'Temperatur'){
                        repo <- 'eu.ownyourdata.room.temp1'
                } else {
                        repo <- 'eu.ownyourdata.room.hum1'
                }
                data <- repoData(repo)
                if(is.null(data[[fieldKey]])){
                        data <- data.frame()
                } else {
                        if(nrow(data) > 0){
                                data <- data[!(is.na(data[[fieldKey]]) | 
                                                       data[[fieldKey]] == 'NA'), ]
                        }
                }
                suppressWarnings(DF <- hot_dat2DF(data, repoStruct, TRUE))
        } else {
                suppressWarnings(data <- hot_to_r(input$dataSheet))
                colnames(data) <- appFields
                suppressWarnings(DF <- hot_dat2DF(data, repoStruct, TRUE))
        }
        rhotRender(DF, fieldWidths)
})

output$exportCSV <- downloadHandler(
        filename = paste0(appName, '.csv'),
        content = function(file) {
                write.csv(values[["dataSheet"]], file)
        }
)
