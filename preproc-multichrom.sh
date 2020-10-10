#!/bin/sh

#Pre-processing script to get all variants and associated allele frequencies for all chromosomes from the 1KGenome Project
#Matt Hope
#October 10th, 2020

address="ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/"
prefix="ALL.chr"
suffix_auto=".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz"
suffix_x=".phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.vcf.gz"
suffix_y=".phase3_integrated_v2a.20130502.genotypes.vcf.gz"
suffix_mt=".phase3_callmom-v0_4.20130502.genotypes.vcf.gz"

for chrom in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22
do
	file=$prefix$chrom$suffix_auto
	link=$address$prefix$chrom$suffix_auto
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
done

for chrom in X
do
        file=$prefix$chrom$suffix_x
        link=$address$prefix$chrom$suffix_x
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
done


for chrom in Y
do
        file=$prefix$chrom$suffix_y
        link=$address$prefix$chrom$suffix_y
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
done

for chrom in MT
do
        file=$prefix$chrom$suffix_mt
        link=$address$prefix$chrom$suffix_mt
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
done

<<"COMMENTBLOCK"
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
COMMENTBLOCK

