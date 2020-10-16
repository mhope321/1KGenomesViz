#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),
    tags$h1("1000 Genomes Visualization"),

    hr(),
    fluidRow(
        column(6,
               h4("Diamonds Explorer"),
               br(),
               selectInput("gene_choice", label = h3("Choose Gene"), 
                           choices = list("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3), 
                           selected = 1),
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
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
