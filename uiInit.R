uiInit <- function(){
        tagList(
                initStore("store", "oydStore"),
                tags$script('setInterval(avoidIdle, 5000);
                            function avoidIdle() 
                                { Shiny.onInputChange("myData", 0) }'
                ),
                tags$script("$(window).load(function(){
                                if (localStorage['oydStore\\\\pia_url'] === undefined) {
                                        $('#startConfig').modal('show');
                                        $('button:contains(\"Close\")').html('Schließen');
                                }
                             });"),
                tags$script(
                        'Shiny.addCustomMessageHandler("setPiaUrl", function(x) {      
                                $("#returnPIAlink").attr("href", x);
                        })'
                ),
                tags$head(
                        tags$style(HTML(".navbar .navbar-nav {float: right}"))
                )
        )
}