#!/bin/sh

#Pre-processing script to get all variants and associated allele frequencies for a single chromosome from the 1KGenome Project
#Matt Hope
#October 10th, 2020

address="ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/"
prefix="ALL.chr"
chrom="Y"
suffix=".phase3_integrated_v2a.20130502.genotypes.vcf.gz"
file=$prefix$chrom$suffix
link=$address$prefix$chrom$suffix
wget $link 
gzip -cd $file |
awk -F "\t|;|=" 'NR> 126 {
if ($11=="CNV")
        {
        if ($18=="EX_TARGET")
                {
                print $1, $2, $3, $4, $5, $17, $24, $22, $26, $28, $30, $32
                next
                }
        print $1, $2, $3, $4, $5, $17, $23, $21, $25, $27, $29, $31
        next
        }
if ($20=="EX_TARGET")
        {
        print $1, $2, $3, $4, $5, $19, $24, $22, $26, $28, $30, $32
        next
        }
else
        {
        print $1, $2, $3, $4, $5, $19, $23, $21, $25, $27, $29, $31
        }
}' > Var-$chrom.txt
rm $file

