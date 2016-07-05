# Accessing a Repo ========================================
defaultHeaders <- function(token) {
        c('Accept'        = '*/*',
          'Content-Type'  = 'application/json',
          'Authorization' = paste('Bearer', token))
}

itemsUrl <- function(url, app_key) {
        paste0(url, '/api/repos/', app_key, '/items')
}

getToken <- function(url, app_key, app_secret) {
        url_auth <- paste0(url, '/oauth/token')
        response <- tryCatch(
                postForm(url_auth,
                         client_id=app_key,
                         client_secret=app_secret,
                         grant_type='client_credentials'),
                error = function(e) { return(NA) })
        if (is.na(response)) {
                return(NA)
        } else {
                return(fromJSON(response[1])$access_token)
        }
}

getRepo <- function(url, key, secret) {
        c('url'        = url,
          'app_key'    = key,
          'app_secret' = secret,
          'token'      = getToken(url, 
                                  key, 
                                  secret))
}

writeRecord <- function(repo, url, record) {
        headers <- defaultHeaders(repo[['token']])
        data <- gsub("^\\[|\\]$", '', 
                     toJSON(record, auto_unbox = TRUE))
        response <- tryCatch(
                postForm(url,
                         .opts=list(httpheader = headers,
                                    postfields = data)),
                error = function(e) { return(NA) })
        response
}

updateRecord <- function(repo, url, record, id) {
        headers <- defaultHeaders(repo[['token']])
        record$id <- as.numeric(id)
        data <- gsub("^\\[|\\]$", '', 
                     toJSON(record, auto_unbox = TRUE))
        response <- tryCatch(
                postForm(url,
                         .opts=list(httpheader = headers,
                                    postfields = data)),
                error = function(e) { return(NA) })
        response
}

deleteRecord <- function(repo, url, id){
        headers <- defaultHeaders(repo[['token']])
        url <- paste0(url, '/', id)
        response <- tryCatch(
                DELETE(url, add_headers(headers)),
                error = function(e) { return(NA) })
        response
}

readItems <- function(repo, url) {
        if (length(repo) == 0) {
                data.frame()
        } else {
                headers <- defaultHeaders(repo[['token']])
                url_data <- paste0(url, '?size=2000')
                response <- tryCatch(
                        getURL(url_data,
                               .opts=list(httpheader = headers)),
                        error = function(e) { return(NA) })
                if (is.na(response)) {
                        data.frame()
                } else {
                        if (nchar(response) > 0) {
                                retVal <- fromJSON(response)
                                if(length(retVal) == 0) {
                                        data.frame()
                                } else {
                                        if ('error' %in% names(retVal)) {
                                                data.frame()
                                        } else {
                                                if (!is.null(retVal$message)) {
                                                        if (retVal$message == 'error.accessDenied') {
                                                                data.frame()
                                                        } else {
                                                                retVal
                                                        }
                                                } else {
                                                        retVal
                                                }
                                        }
                                }
                        } else {
                                data.frame()
                        }
                }
        }
}

currRepo <- reactive({
        url <- input$pia_url
        app_key <- input$app_key
        app_secret <- input$app_secret
        if(is.null(url) |
           is.null(app_key) | 
           is.null(app_secret)) {
                vector()
        } else {
                if((nchar(url) > 0) & 
                   (nchar(app_key) > 0) & 
                   (nchar(app_secret) > 0)) {
                        getRepo(url, app_key, app_secret)
                } else {
                        url <- input$store$pia_url
                        app_key <- input$store$app_key
                        app_secret <- input$store$app_secret
                        if(is.null(url) |
                           is.null(app_key) | 
                           is.null(app_secret)) {
                                vector()
                        } else {
                                if((nchar(url) > 0) & 
                                   (nchar(app_key) > 0) & 
                                   (nchar(app_secret) > 0)) {
                                        getRepo(url, app_key, app_secret)
                                } else {
                                        vector()
                                }
                        }
                }
        }
})

currData <- function(){
        repo <- currRepo()
        if(length(repo) > 0) {
                url <- itemsUrl(repo[['url']], 
                                paste0(repo[['app_key']]))
                piaData <- readItems(repo, url)
        } else {
                piaData <- data.frame()
        }
        piaData
}

saveData <- function(repo, date, value){
        if(!is.null(date) & length(all.equal(repo, logical(0)))>1){
                piaData <- currData()
                existData <- piaData[piaData$date == date, ]
                existData <- existData[complete.cases(existData), ]
                data <- list(date=date, 
                             value=value)
                url <- itemsUrl(repo[['url']], 
                                paste0(repo[['app_key']]))
                if (nrow(existData) > 0) {
                        if(is.na(value) | is.null(value) | value == 'NA'){
                                deleteRecord(repo, url, existData$id)
                        } else {
                                updateRecord(repo, url, data, existData$id)
                        }
                } else {
                        if(!is.na(value) & !is.null(value) & value != 'NA' & nchar(as.character(value))>2){
                                writeRecord(repo, url, data)
                        }
                }
        }                
}
