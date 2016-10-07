# application specific logic
# last update: 2016-10-07

source('srvDateselect.R', local=TRUE)
source('srvEmail.R', local=TRUE)

# any record manipulations before storing a record
appData <- function(record){
        record
}
