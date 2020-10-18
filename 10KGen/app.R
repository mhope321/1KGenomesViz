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
    #tags$h1("1000 Genomes Visualization"),
    sidebarLayout(
        sidebarPanel(
            selectInput("gene_choice", label = h3("Type/Select Gene"), 
                        choices = sort(unique(vars$name)), 
                        selected = "ETS1"),
            radioButtons("MAF", label = h3("Minor allele frequency cutoff"),
                         choices = list(">10%" = 1, ">1%" = 2, ">0.1%" = 3, "No Cutoff" = 4), 
                         selected = 4),
        ),
        mainPanel(
            tabsetPanel(
                tabPanel("Table", dataTableOutput("table")),
                tabPanel("Genome Distribution",plotOutput("genome")),
                tabPanel("Allele Frequency by Population",plotOutput("AF_race_rel"),plotOutput("AF_race_abs")),
                tabPanel("Top Divergent Alleles by Population",plotOutput("enriched_vars"))
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
            filter(case_when(input$MAF==1 ~ AF>=.1,input$MAF==2 ~ AF>=.01,input$MAF==3 ~ AF>=.001,input$MAF==4 ~ TRUE)) %>%
            arrange(desc(AF))
    )
    
    output$table = renderDataTable(
        datatable(gene_variant_input())
    )
    
    output$genome = renderPlot({
        tmp = gene_variant_input()
        var_irange=IRanges(start=tmp$pos,end=tmp$pos)
        var_grange = GRanges(seqnames=paste0("chr",tmp$chr),ranges=var_irange,strand=NULL)
        atrack = AnnotationTrack(var_grange, name = paste0(input$gene_choice," Varaints"))
        gtrack = GenomeAxisTrack()
        plotTracks(list(gtrack, atrack, grtrack),from=start(range(var_grange)),to=end(range(var_grange)))
    })
    
    allele_freq=reactive(
        gene_variant_input() %>% gather(key="AF",value="freq",AF,AF_AFR,AF_AMR,AF_EAS,AF_EUR,AF_SAS) %>% 
            group_by(AF) %>% summarise(freq=mean(freq))
    )
    
    output$AF_race_abs = renderPlot(
        allele_freq() %>%
            ggplot(aes(x=AF,y=freq,fill=AF))+geom_col()+ggtitle(paste0(input$gene_choice," Mean Allele Frequencies, Un-Normalized"))
            + scale_fill_manual(values=pallete_blue) + xlab("Populations") +ylab("Mean Allele Frequency")+coord_cartesian(ylim=c(0,0.25))
    )
    output$AF_race_rel = renderPlot(
        allele_freq() %>% mutate(freq = freq/dplyr::first(freq)) %>%
            ggplot(aes(x=AF,y=freq,fill=AF))+geom_col()+ggtitle(paste0(input$gene_choice," Mean Allele Frequencies, Normalized to Global Allele Frequency"))
        + scale_fill_manual(values=pallete_green) + xlab("Populations") +ylab("Relative Mean Allele Frequency")
    )  
    output$enriched_vars = renderPlot(
        gene_variant_input() %>% mutate(AF_AFR=AF_AFR/AF,AF_AMR=AF_AMR/AF,AF_EAS=AF_EAS/AF,AF_EUR=AF_EUR/AF,AF_SAS=AF_SAS/AF) %>%
            mutate(max=pmax(AF_AFR,AF_AMR,AF_EAS,AF_EUR,AF_SAS)) %>% filter(max>1) %>% arrange(desc(max)) %>% top_n(.,10) %>%
            gather(key="AF",value="freq",AF_AFR,AF_AMR,AF_EAS,AF_EUR,AF_SAS) %>% ggplot(aes(x=freq,y=id))+geom_col(aes(fill=AF),position="dodge")
    )
}

# Run the application 
shinyApp(ui = ui, server = server)
