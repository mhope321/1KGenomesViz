#!/bin/sh

#Pre-processing script to get all variants and associated allele frequencies for a single chromosome from the 1KGenome Project
#Matt Hope
#October 10th, 2020

address="ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/"
prefix="ALL.chr"
chrom="Y"
suffix=".phase3_integrated_v2a.20130502.genotypes.vcf.gz"
cat(address,prefix,chrom,suffix)

