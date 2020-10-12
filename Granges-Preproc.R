setwd("~/Desktop/NYCDSA/10KGen")
library(data.table)
library(dplyr)
library(GenomicRanges)

exons = fread(file="./exons.csv",sep=",",header=F)
var_final = data.frame()

for (chr in 1:22){
  var= fread(file=paste0("Var-",chr,".txt"),header=F)
  exons_subset = exons %>% filter(V1==chr)
  colnames(exons_subset) = c("chr","start","stop","name")
  exons_irange=IRanges(start=exons_subset$start,end=exons_subset$stop)
  exons_grange = GRanges(seqnames=exons_subset$chr,ranges=exons_irange,strand=NULL)
  #mcols(exons_grange)$genename = exons_subset$name
  var_irange=IRanges(start=var$V2,end=var$V2)
  var_grange = GRanges(seqnames=var$V1,ranges=var_irange,strand=NULL)
  result = intersect(var_grange,exons_grange)
  result_query = start(result)
  var_result = var %>% filter(V2 %in% result_query)
  var_final = rbind(var_final,var_result)
}

fwrite(var_final,file="ExonVariants.csv",sep=",")

