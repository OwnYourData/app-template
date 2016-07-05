observe({
        if(!is.null(input$dateSelect)){
                switch(input$dateSelect,
                       '1'={ updateDateRangeInput(session, 'dateRange',
                                                  start = as.Date(Sys.Date()-7),
                                                  end = as.Date(Sys.Date())) },
                       '2'={ updateDateRangeInput(session, 'dateRange',
                                                  start = as.Date(Sys.Date() - months(1)),
                                                  end = as.Date(Sys.Date())) },
                       '3'={ updateDateRangeInput(session, 'dateRange',
                                                  start = as.Date(Sys.Date() - months(2)),
                                                  end = as.Date(Sys.Date())) },
                       '4'={ updateDateRangeInput(session, 'dateRange',
                                                  start = as.Date(Sys.Date() - months(6)),
                                                  end = as.Date(Sys.Date())) },
                       '5'={ updateDateRangeInput(session, 'dateRange',
                                                  start = as.Date(paste(year(Sys.Date()),'1','1',sep='-')),
                                                  end = as.Date(paste(year(Sys.Date()),'12','31',sep='-'))) },
                       '6'={ updateDateRangeInput(session, 'dateRange',
                                                  start = as.Date(Sys.Date() - months(12)),
                                                  end = as.Date(Sys.Date())) },
                       {})
        }
})

currDataSelect <- function(){
        data <- currData()
        if(nrow(data) == 0) {
                data.frame()
        } else {
                data$dat <- as.POSIXct(data$date, 
                                       format='%Y-%m-%d')
                dataMin <- min(data$dat, na.rm=TRUE)
                dataMax <- max(data$dat, na.rm=TRUE)
                curMin <- as.Date(input$dateRange[1], '%d.%m.%Y')
                curMax <- as.Date(input$dateRange[2], '%d.%m.%Y')
                daterange <- seq(curMin, curMax, 'days')
                data[as.Date(data$dat) %in% daterange, ]
        }
}
