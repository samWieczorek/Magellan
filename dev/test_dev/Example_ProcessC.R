#Timeline_R6.R
Example_ProcessC = R6Class(
  "Example_ProcessC",
  inherit = Process,
  private = list(
    .config = list(name = 'ProcessC',
                   steps = c('Description', 'Step1', 'Step2', 'Step3'),
                   mandatory = c(TRUE, FALSE, TRUE, FALSE)
    )
  ),
  
  public = list(
    
    Global_server = function(session, input){},
    
    Description_server = function(session, input, output){
      observeEvent(input$btn_validate_Description, ignoreInit = TRUE, ignoreNULL = TRUE, {
        cat(paste0(class(self)[1], "::observeEvent(input$btn_validate_Description from - ", self$id, '\n'))
        private$InitializeDataIn()
        self$ValidateCurrentPos()
      })
      
      output$datasetDescription <- renderUI({
        tagList(
          p(paste0('Dataset description: ', paste0(names(self$rv$temp.dataIn), collapse=", ")))
        )
      })
    },
    
    
    Description_ui = function(){
      
      wellPanel(
        tagList(
          includeMarkdown( system.file("app/md", paste0(self$config$name, ".md"), package="Magellan")),
          uiOutput(self$ns('datasetDescription')),
          actionButton(self$ns('btn_validate_Description'), 
                       paste0('Start ', self$config$name),
                       class = btn_success_color)
        )
      )
    },
    
    ############### SCREEN 2 ######################################
    
    Step1_server = function(session, input, output){
      observeEvent(input$btn_validate_Step1, ignoreInit = TRUE, {
        
        # Add your stuff code here
        
        
        self$ValidateCurrentPos()
      })
    },
    
    Step1_ui = function(){
      name <- 'Step1'
      wellPanel(
        tagList(
          div(id=self$ns(name),
              div(style="display:inline-block; vertical-align: middle;padding-right: 20px;",
                  tags$h2(name)),
              div(style="display:inline-block; vertical-align: middle; padding-right: 40px;",
                  selectInput(self$ns('select1'), 'Select step 1', 
                              choices = seq_len(5), 
                              selected = 1,
                              width = '150px')
              ),
              div(style="display:inline-block; vertical-align: middle;padding-right: 20px;",
                  actionButton(self$ns(paste0('btn_validate_', name)), 
                               'Perform',
                               class = btn_success_color))
          )
        )
      )
    },
    
    Step2_server = function(session, input, output){
      ## Logics to implement: here, we must take the last data not null
      # in previous datas. The objective is to take account
      # of skipped steps
      observeEvent(input$btn_validate_Step2, ignoreInit = TRUE, {
        self$ValidateCurrentPos()
      })
    },
    
    Step2_ui = function(){
      name <- 'Step2'
      wellPanel(
        tagList(
          div(id=self$ns(name),
              div(style="display:inline-block; vertical-align: middle;padding-right: 20px;",
                  tags$h3(name)),
              div(style="display:inline-block; vertical-align: middle;padding-right: 40px;",
                  selectInput(self$ns('select2'), 'Select step 2',
                              choices = seq_len(5),
                              selected = 1,
                              width = '150px')),
              div(style="display:inline-block; vertical-align: middle;padding-right: 20px;",
                  actionButton(self$ns(paste0('btn_validate_', name)), 
                               'Perform',
                               class = btn_success_color))
          )
        )
      )
    },
    
    Step3_server = function(session, input, output){
      
      observeEvent(input$btn_validate_Step3, ignoreInit = TRUE, {
        self$rv$dataIn <- AddItemToDataset(self$rv$dataIn, self$config$name)
        self$ValidateCurrentPos()
      })
    },
    
    Step3_ui = function(){
      name <- 'Step3'
      wellPanel(
        tagList(
          div(id = self$ns(name),
              div(style="display:inline-block; vertical-align: middle;padding-right: 20px;",
                  tags$h3(name)),
              div(style="display:inline-block; vertical-align: middle;padding-right: 20px;",
                  actionButton(self$ns(paste0('btn_validate_', name)), 
                               'Validate',
                               class = btn_success_color))
          )
        )
      )
    }
  )
)