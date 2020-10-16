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
                        selected = NULL),
            selectInput("variant_choice", label = h3("Type/Select Variant"), 
                        choices = unique(vars$chr), 
                        selected = NULL),
            checkboxGroupInput("MAF", label = h3("Minor allele frequency cutoff"), 
                               choices = list(">10%" = 1, ">1%" = 2, ">0.1%" = 3, ">0.01%" = 4),
                               selected = 1)
        ),
        mainPanel(
            tabsetPanel(
                # tabPanel("Plots", 
                #          fluidRow(
                #              column(5, plotOutput("count")),
                #              column(7, plotOutput("delay"))
                #          )), 
                tabPanel("Table", dataTableOutput("table"))
            )
        )
    ),
    hr(),
)

# Define server logic required to draw a histogram
server <- function(input, output,session) {
    observe(
        updateSelectizeInput(session,'variant_choice',
                             choices=vars[vars$name==input$gene_selection,"id"])
    )
    
    gene_variant_input=reactive(
        vars %>% 
            filter(name==input$gene_choice) %>%
            filter(case_when(input$MAF==1 ~ AF>=.1,input$MAF==2 ~ AF>=.01,
                             input$MAF==3 ~ AF>=.001,input$MAF==4 ~ AF>=.0001,)) %>%
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
