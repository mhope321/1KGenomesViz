library(jsonlite)
library(httr)

prefix_url = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=snp&id="
snps = "200676709,200505207,140739101"
#snps = "200676709"
suffix_url = "&rettype=json&retmode=text"
query = paste0(prefix_url,snps,suffix_url)

fromdbsnp = GET(url=query)
fromdbsnp_text = content(fromdbsnp, as="text", encoding="UTF-8")
#variant_json <- fromJSON(variant_text,flatten=TRUE)

library(stringr)

parse_json = function(x)
{
  result = list()
  coords = str_locate_all(x,"refsnp_id")[[1]][,1]
  n_records = length(coords)
  #result = vector(mode="list",length=n_records)
  for (i in 1:n_records)
  {
    if (i==n_records)
    {
      text = str_sub(x,(coords[i]-2),(nchar(x)))
      json = fromJSON(text,flatten=TRUE)
      result[[length(result)+1]] = json
    } else {
      text = str_sub(x,(coords[i]-2),(coords[i+1]-3))
      json = fromJSON(text,flatten=TRUE)
      result[[length(result)+1]] = json
    }
  }
  return(result)
}

snps_json = parse_json(fromdbsnp_text)