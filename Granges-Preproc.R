library(data.table)
setwd("~/Desktop/NYCDSA/10KGen")
genes = fread(file="./genes.csv",sep=",",header=F)
genes[1,4]

library(dplyr)

var1= fread(file="Var-1.txt",header=F)

test_vars = var1 %>% filter(V2<100000)
test_genes = genes[1:11,]

genes_ch1 = genes %>% filter(V1==1)
colnames(genes_ch1) = c("chr","start","stop","name")

check_vars = function(x){
  var_position = as.numeric(x[2])
  tmp = genes_ch1 %>% filter(start<=var_position) %>% filter(stop>=var_position)
  if(nrow(tmp)==0)
    return("")
  else
    return(tmp$name)
}

gene_vector = apply(var1,1,check_vars)


library(GenomicRanges)
chr1_irange=IRanges(start=genes_ch1$start,end=genes_ch1$stop)
test_grange = GRanges(seqnames=genes_ch1$chr,ranges=chr1_irange,strand=NULL)
mcols(test_grange)$genename = genes_ch1$name

var1_irange=IRanges(start=var1$V2,end=var1$V2)
var_grange = GRanges(seqnames=var1$V1,ranges=var1_irange,strand=NULL)
result = intersect(var_grange,test_grange)
ch1_starts = start(result)
var1_result = var1 %>% filter(V2 %in% ch1_starts)

exons = fread(file="./exons.csv",sep=",",header=F)
exons1 = exons %>% filter(V1==1)
colnames(exons1) = c("chr","start","stop","name")

chr1_irange=IRanges(start=exons1$start,end=exons1$stop)
test_grange = GRanges(seqnames=exons1$chr,ranges=chr1_irange,strand=NULL)
mcols(test_grange)$genename = exons1$name
result = intersect(var_grange,test_grange)
ch1_starts = start(result)
var1_result2 = var1 %>% filter(V2 %in% ch1_starts)

