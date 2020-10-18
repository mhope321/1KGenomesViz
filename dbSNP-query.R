library(jsonlite)
library(httr)
library(stringr)

# test_url = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=snp&term=%28FLT3%5BGene%20Name%5D%29%20AND%20%22pathogenic%22%5BClinical%20Significance%5D%20"
# test_db = GET(url=test_url)
# test_text = content(test_db, as="text", encoding="UTF-8")

notch_vars_refs = str_replace(notch_vars_refs,"rs","")
notch_vars_refs = str_c(notch_vars_refs,collapse=",")
snps = notch_vars_refs
#snps = "200676709,200505207,140739101"
#snps = "200676709"
#snps= "268,328"

prefix_url = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=snp&id="
suffix_url = "&rettype=json&retmode=text"
query = paste0(prefix_url,snps,suffix_url)

fromdbsnp = GET(url=query)
fromdbsnp_text = content(fromdbsnp, as="text", encoding="UTF-8")

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
    clinical_frame = x[[i]]$primary_snapshot_data$allele_annotations$clinical
    clinical_info = data.frame()
    for (j in 1:length(clinical_frame))
    {
      if(dim(clinical_frame[[j]])[1]==0)
        next
      clinical_info_tmp = data.frame("allele_id"=clinical_frame[[j]]$allele_id,"disease_names"=unlist(clinical_frame[[j]]$disease_names),"clinical_significance"=unlist(clinical_frame[[j]]$clinical_significance))   
      clinical_info = rbind(clinical_info,clinical_info_tmp)
    }
    full_list = append(snp_info,clinical_info)
    result[[length(result)+1]] = full_list
  }
  return(result)
}

snps_clin = clinical_info(snps_json)
