library(shiny)
library(ggplot2)
library(dplyr)
library(readr)
library(DT)
setwd("~/Desktop/NYCDSA/10KGen/10KGen")

vars = fread(file="./data/ExonVariants.csv",header=T)

