library(shiny)
library(ggplot2)
library(dplyr)
library(readr)
library(DT)
library(tidyr)
library(data.table)
library(RColorBrewer)
library(TxDb.Hsapiens.UCSC.hg38.knownGene)
library(Gviz)
library(GenomicRanges)

setwd("~/Desktop/NYCDSA/10KGen/10KGen")

vars = fread(file="./data/ExonVariants.csv",header=T)
vars = vars %>% mutate(AF=as.numeric(AF),AF_AFR=as.numeric(AF_AFR),
                       AF_AMR=as.numeric(AF_AMR),AF_EAS=as.numeric(AF_EAS),
                       AF_EUR=as.numeric(AF_EUR),AF_SAS=as.numeric(AF_SAS))

pallete_blue = rev(brewer.pal(9,"Blues"))[1:6]
pallete_green = rev(brewer.pal(9,"Greens"))[1:6]

compare_af_maxes = function(x)
{
  y=max(x$AF_AFR,x$AF_AMR,x$AF_EAS,x$AF_EUR,x$AF_SAS)
  return(y)
}

txdb = TxDb.Hsapiens.UCSC.hg38.knownGene
grtrack = GeneRegionTrack(range=txdb,name="Gene Model")
