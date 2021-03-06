#' timeline UI Function
#'
#' @description A shiny Module.
#'
#' @param id xxx.
#'
#' @importFrom shiny NS tagList 
#' 
#' @return xxx
#' 
#' @noRd
#' 
mod_timeline_h_ui <- function(id){
  ns <- NS(id)
  fpath <- system.file("app/www/sass", 
                       "h_timeline.sass", 
                       package="Magellan")
    tagList(
      shinyjs::useShinyjs(),
      
      tags$div(
    shinyjs::inlineCSS(sass::sass(sass::sass_file(fpath))),
    uiOutput(ns('show_h_TL'))
  )
    )
}
    
#' timeline Server Function
#' 
#' @param id xxx
#' @param config xxx
#' @param status xxx
#' @param position xxx
#' @param enabled xxx
#' @export
#' 
#' @return xxx
#' @noRd
mod_timeline_h_server <- function(id, 
                               config, 
                               status, 
                               position, 
                               enabled) {
    
  rv.tl <- reactiveValues(
    length = NULL
  )
  
  global <- list(
    VALIDATED = 1,
    UNDONE = 0,
    SKIPPED = -1
  )
    moduleServer(id, function(input, output, session) {
      ns <- session$ns
      
      observe({
        req(config)
        rv.tl$length <- length(config$steps)
      })
      
      UpdateTags <- reactive({
        #browser()
        tl_status <- rep('undone', rv.tl$length)
        tl_status[which(config$mandatory)] <- 'mandatory'
        tl_status[which(unlist(status()) == global$VALIDATED)] <- 'completed'
        tl_status[which(unlist(status()) == global$SKIPPED)] <- 'skipped'
    
        for (i in seq_len(length(enabled())))
          if (!enabled()[i])
            tl_status[i] <- paste0(tl_status[i], 'Disabled')
        
        tl_status[position()] <- paste0(tl_status[position()], ' active')
        tl_status
        })
      

      output$show_h_TL <- renderUI  ({
       # browser()
          
        #tags$div(style="border: 1px solid black;", 
         # tags$ul(style="border: 1px solid black;",
            tags$div(class='timeline',
                     id='timeline',
                     lapply(seq_len(rv.tl$length), function(x){
                       tags$li(class = paste0('li ', UpdateTags()[x]),
                              # tags$div(class='timestamp'),
                               tags$div(class='timestamp status',
                                        tags$h4(config$steps[x])
                                        )
                       )
                       })
                     )
          #  )
       # )
        })

      
})
}

    
## To be copied in the UI
# mod_timeline_ui("timeline_ui_1")
    
## To be copied in the server
# callModule(mod_timeline_server, "timeline_ui_1")
 
