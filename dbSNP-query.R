library(jsonlite)
library(httr)

prefix_url = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=snp&id="
snps = "200676709,200505207,140739101"
#snps = "200676709"
suffix_url = "&rettype=json&retmode=text"
query = paste0(prefix_url,snps,suffix_url)

test <- GET(url=query)
variant_text <- content(test, as="text", encoding="UTF-8")
variant_json <- fromJSON(variant_text,flatten=TRUE)

library(stringr)

variant_json <- fromJSON(json3,flatten=TRUE)
json1 = str_sub(variant_text,1,17921)
json2 = str_sub(variant_text,17922,34696)
json3 = str_sub(variant_text,34697,51692)
