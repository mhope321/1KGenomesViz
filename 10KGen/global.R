library(dplyr)
library(readr)
setwd("~/Desktop/NYCDSA/10KGen/10KGen")

vars = fread(file="./data/ExonVariants.csv",header=F)
