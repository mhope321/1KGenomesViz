library(jsonlite)
library(httr)

prefix_url = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=snp&id="
#snps = "200676709,200505207,140739101"
#snps = "200676709"
snps= "268,328"
suffix_url = "&rettype=json&retmode=text"
query = paste0(prefix_url,snps,suffix_url)

fromdbsnp = GET(url=query)
fromdbsnp_text = content(fromdbsnp, as="text", encoding="UTF-8")
#variant_json <- fromJSON(variant_text,flatten=TRUE)

library(stringr)

parse_json = function(x)
{
  #Get breaks in JSON that match "}{" 
  hits = str_locate_all(x,"\\}\\{")[[1]]
  #Number of records is number of breaks plus one; no breaks is one record
  n_records = nrow(hits)+1
  #The starts and ends of hits gives the index of where to break, but we need to add the start 
  #and stop index of x and shift things accordingly. It's as if we want to add 1 in position [1,1]
  #of hits, and then have everything shift down one position row-wise in the hits matrix. Then, the
  #last position of hits is filled with the length of x, and we have an object coords with all
  #our breaks.
  tmp = c(1)
  if(n_records!=1)
  {
    for (i in 1:nrow(hits)){
      tmp = c(tmp,hits[i,])
    }
  }
  tmp = c(tmp,nchar(x))
  coords =  matrix(tmp,nrow=n_records,ncol=2,byrow=T)
  colnames(coords) = c("start","end")
  
  #Append JSON objects to a list of lists
  result = list()
  for (i in 1:n_records)
  {
      text = str_sub(x,coords[i,1],coords[i,2])
      json = fromJSON(text,flatten=TRUE)
      result[[length(result)+1]] = json
  }
  return(result)
}

snps_json = parse_json(fromdbsnp_text)

clinical_info = function(x){
  result = list()
  for (i in 1:length(x))
  {
    snp_info = x[[i]]$refsnp_id
    clinical_info = x[[i]]$primary_snapshot_data$allele_annotations$clinical
    result = append(result,snp_info)
    result = append(result,clinical_info)
  }
  return(result)
}

snps_clin = clinical_info(snps_json)
