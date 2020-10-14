#!/bin/sh

#Preprocessing script to get all gene names and positions in the human genome

gzip -cd Homo_sapiens.GRCh38.101.chr.gtf.gz | 
awk 'BEGIN {OFS=","}
	{
	if($3=="CDS")
	{
	print $1, $4, $5, $20
	}
     }' | 
sort | 
uniq > exons.csv
