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
            radioButtons("MAF", label = h3("Minor allele frequency cutoff"),
                         choices = list(">10%" = 1, ">1%" = 2, ">0.1%" = 3), 
                         selected = 1),
        ),
        mainPanel(
            tabsetPanel(
                # tabPanel("Plots", 
                #          fluidRow(
                #              column(5, plotOutput("count")),
                #              column(7, plotOutput("delay"))
                #          )), 
                tabPanel("Table", dataTableOutput("table")),
                tabPanel("Clinical",),
                tabPanel("Genome Distribution"),
                tabPanel("Allele Frequency by Race",plotOutput("AF_race"))
            )
        )
    ),
    hr(),
)

# Define server logic required to draw a histogram
server <- function(input, output,session) {
    
    gene_variant_input=reactive(
        vars %>% 
            filter(name==input$gene_choice) %>%
            filter(case_when(input$MAF==1 ~ AF>=.1,input$MAF==2 ~ AF>=.01,input$MAF==3 ~ AF>=.001)) %>%
            arrange(desc(AF))
    )
    
    output$table = renderDataTable(
        datatable(gene_variant_input())
    )
    
    output$AF_race = renderPlot(
        gene_variant_input() %>% gather(key="AF",value="freq",AF,AF_AFR,AF_AMR,AF_EAS,AF_EUR,AF_SAS) %>%
            ggplot(aes(x=AF,y=freq,fill=AF))+geom_boxplot()
    )
}

# Run the application 
shinyApp(ui = ui, server = server)
