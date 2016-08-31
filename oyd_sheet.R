# show available data in an Excel like UI
# last update:2016-07-28

values = reactiveValues()
setHot = function(x) values[["dataSheet"]] = x

observe({
        if(!is.null(input$dataSheet))
                values[["dataSheet"]] <- hot_to_r(input$dataSheet)
})

# !!! fix_me: dynamische Datenstruktur notwendig
observe({
        newRecords <- values[["dataSheet"]]
        if (!is.null(newRecords)) {
                oldRecords <- currData()
                if(nrow(oldRecords)>0) {
                        oldRecords <- oldRecords[,c('date', 'value')]
                } else {
                        oldRecords <- as.data.frame(matrix(NA, ncol=2, nrow=1))
                }
                colnames(oldRecords) <- c('Datum', 'Ziel')
                oldRecords$Datum <- as.Date(oldRecords$Datum)
                oldRecords$Ziel <- as.character(oldRecords$Ziel)
                
                # check new and updated records
                app <- currApp()
                if(length(all.equal(app, logical(0)))>1){
                        updatedRecords <- sqldf('SELECT * FROM newRecords EXCEPT SELECT * FROM oldRecords')
                        if(nrow(updatedRecords)>0){
                                for(i in 1:nrow(updatedRecords)){
                                        rec <- updatedRecords[i,]
                                        if(!is.na(rec[1])){
                                                if(!(is.na(rec$Datum) | (as.character(rec$Datum) == ''))) {
                                                        if(is.na(rec$Ziel)) {
                                                                saveDateItem(app,
                                                                         itemsUrl(app, app[['app_key']]),
                                                                         as.Date(rec$Datum),
                                                                         NA)
                                                        } else {
                                                                saveDateItem(app, 
                                                                         itemsUrl(app, app[['app_key']]),
                                                                         as.Date(rec$Datum),
                                                                         rec$Ziel)
                                                        }
                                                }
                                        }
                                }
                        }
                
                        # check for deleted records
                        deletedRecords <- sqldf('SELECT * FROM oldRecords EXCEPT SELECT * FROM newRecords')
                        if(nrow(deletedRecords) > 0) {
                                for(i in 1:nrow(deletedRecords)){
                                        rec <- deletedRecords[i,]
                                        saveDateItem(app, 
                                                     itemsUrl(app, app[['app_key']]),
                                                     rec$Datum, 
                                                     NA)
                                }
                        }
                }
        }
})

# !!! fix_me: dynamische Datenstruktur notwendig
output$dataSheet = renderRHandsontable({
        if (!is.null(input$dataSheet)) {
                DF = hot_to_r(input$dataSheet)
                DF <- DF[!is.na(DF$Datum),]
                if(nrow(DF) == 0){
                        DF <- data.frame(
                                Datum = as.Date(Sys.Date()),
                                Ziel = '')
                } else {
                        DF <- rbind(DF, c(NA, NA))       
                }
                colnames(DF) <- c('Datum', 'Ziel')
        } else {
                DF <- currData()
                if(nrow(DF)>0){
                        DF <- DF[,c('date', 'value')]
                        DF <- DF[!is.na(DF$date),]
                        DF <- rbind(DF, c(NA, NA))
                } else {
                        DF <- data.frame(
                                Datum = as.Date(Sys.Date()),
                                Ziel = '')
                }
                colnames(DF) <- c('Datum', 'Ziel')
                DF$Datum <- as.Date(DF$Datum)
                DF$Ziel <- as.character(DF$Ziel)
        }
        setHot(DF)
        if(nrow(DF)>20) {
                rhandsontable(DF, useTypes=TRUE, height=400) %>%
                        hot_table(highlightCol=TRUE, highlightRow=TRUE,
                                  allowRowEdit=TRUE)
        } else {
                rhandsontable(DF, useTypes=TRUE) %>%
                        hot_table(highlightCol=TRUE, highlightRow=TRUE,
                                  allowRowEdit=TRUE)
        }
})

output$exportCSV <- downloadHandler(
        filename = paste0(appName, '.csv'),
        content = function(file) {
                write.csv(values[["dataSheet"]], file)
        }
)
