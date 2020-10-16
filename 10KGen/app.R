#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#



# Define UI for application that draws a histogram
ui <- fluidPage(
    tags$h1("1000 Genomes Visualization"),
    sidebarLayout(
        sidebarPanel(
            selectInput("gene_choice", label = h3("Type/Select Gene"), 
                        choices = unique(vars$name), 
                        selected = "ETS1"),
            selectInput("variant_choice", label = h3("Type/Select Variant"), 
                        choices = unique(vars$name), 
                        selected = "ETS1"),
            checkboxGroupInput("MAF", label = h3("Minor allele frequency cutoff"), 
                               choices = list(">10%" = 1, ">1%" = 2, ">0.1%" = 3, ">0.01%" = 4),
                               selected = 1)
        ),
    dataTableOutput("table"),
    hr(),
    fluidRow(
        column(6,
               h4("Diamonds Explorer"),
               br(),
               selectInput("gene_choice", label = h3("Type/Select Gene"), 
                           choices = unique(vars$name), 
                           selected = "ETS1"),
               # #sliderInput('sampleSize', 'Sample Size', 
               #             min=1, max=nrow(dataset), value=min(1000, nrow(dataset)), 
               #             step=500, round=0),
               # br(),
               # checkboxInput('jitter', 'Jitter'),
               # checkboxInput('smooth', 'Smooth')
        ),
        # column(4, offset = 1,
        #        h4("New Column"),
        #        # selectInput('x', 'X', names(dataset)),
        #        # selectInput('y', 'Y', names(dataset), names(dataset)[[2]]),
        #        # selectInput('color', 'Color', c('None', names(dataset)))
        # ),
        column(6,
               h4("New Column"),
               # selectInput('facet_row', 'Facet Row', c(None='.', names(dataset))),
               # selectInput('facet_col', 'Facet Column', c(None='.', names(dataset)))
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output,session) {
    observe(
        updateSelectizeInput(session,'variant_choice',
                             choices=unique(vars[vars$name==input$gene_selection,"id"]))
    )
    
    gene_variant_input=reactive(
        vars %>% 
            filter(name==input$gene_choice) %>%
            arrange(desc(AF))
    )
    
    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
    
    output$table = renderDataTable(
        datatable(gene_variant_input())
    )
}

# Run the application 
shinyApp(ui = ui, server = server)
