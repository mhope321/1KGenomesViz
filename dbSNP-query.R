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

parse_json = function(x)
{
  result = list()
  coords = str_locate_all(x,"refsnp_id")[[1]][,1]
  n_records = length(coords)
  for (i in 1:n_records)
  {
    if (i==n_records)
    {
      json = str_sub(x,(coords[i]-2),(nchar(x)))
      result = append(result,json)
    } else {
      json = str_sub(x,(coords[i]-2),(coords[i+1]-2))
      result = append(result,json)
    }
  }
  return(result)
}

variant_json <- fromJSON(json3,flatten=TRUE)
json1 = str_sub(variant_text,1,17921)
json2 = str_sub(variant_text,17922,34696)
json3 = str_sub(variant_text,34697,51692)

coords = str_locate_all(variant_text,"refsnp_id")
