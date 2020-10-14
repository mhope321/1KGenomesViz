setwd("~/Desktop/NYCDSA/10KGen")
library(data.table)
library(dplyr)
library(GenomicRanges)
library(stringr)

exons = fread(file="./exons.csv",sep=",",header=F,quote="")
exons$V4 = str_sub(exons$V4,2,-3)
var_final = data.frame()

for (chr in 1:22){
  var= fread(file=paste0("Var-",chr,".txt"),header=F)
  exons_subset = exons %>% filter(V1==chr)
  colnames(exons_subset) = c("chr","start","stop","name")
  exons_irange=IRanges(start=exons_subset$start,end=exons_subset$stop)
  exons_grange = GRanges(seqnames=exons_subset$chr,ranges=exons_irange,strand=NULL)
  mcols(exons_grange)$genename = exons_subset$name
  var_irange=IRanges(start=var$V2,end=var$V2)
  var_grange = GRanges(seqnames=var$V1,ranges=var_irange,strand=NULL)
  result = as.matrix(findOverlaps(var_grange,exons_grange))
  result_genenames=exons_grange[result[,2]]$genename
  result_starts=start(var_grange[result[,1]])
  result = distinct(data.frame(result_starts,result_genenames))
  result = result %>% select(begin=result_starts,names=result_genenames)
  var = var %>% select(V1,begin=V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12)
  var_result = inner_join(result,var,by="begin")
  var_final = rbind(var_final,var_result)
}

fwrite(var_final,file="ExonVariants.csv",sep=",")

