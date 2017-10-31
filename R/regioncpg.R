regioncpg <- function(goi,region,arraytype="HM450K"){
  # Notes:
  # goi is character string for gene of interest (RefSeq Name or Accession)
  # region is gene region (valid entries: "gene.body","gene.promoter","1stExon","3'UTR","5'UTR","Body","TSS1500","TSS200")
  # arraytype options are "HM450K" or "EPIC"
  
  if(!arraytype %in% c("HM450K","EPIC")){
    return(message("ERROR: Please enter a valid array type (either 'HM450K' or 'EPIC'). Returning.."))
  } else{
    if(arraytype=="HM450K"){
      message("Loading integratoR HM450K CpG annotations..")
      data(repman_hm450)
      repman <- repman450
    } else{
      message("Loading integratoR EPIC CpG annotations..")
      data(repman_epic)
      repman <- repman.epic
    }
    }
    
  if(!goi %in% c(repman$accession,repman$name)){
    return(message("ERROR: Gene of interest not a valid RefSeq Accession or Name, returning..."))
  } else{
    repman.goi <- repman[repman$accession==goi | repman$name==goi,]
    
  }
  
  if(region %in% c("gene.body","gene.promoter","1stExon","3'UTR","5'UTR","Body","TSS1500","TSS200")){
    if(region %in% c("gene.body")){
      repman.goi.region <- repman.goi[repman.goi$group %in% c("1stExon","Body"),]
      message("Identified ",nrow(repman.goi.region)," CpGs in the Gene Body of ",goi,". Returning..")
      return(repman.goi.region$cpg)
      
    }
    if(region %in% c("gene.promoter")){
      repman.goi.region <- repman.goi[repman.goi$group %in% c("5'UTR","TSS1500","TSS200"),]
      message("Identified ",nrow(repman.goi.region)," CpGs in the Gene Promoter of ",goi,". Returning..")
      return(repman.goi.region$cpg)
      
    }
    if(region %in% c("1stExon","3'UTR","5'UTR","Body","TSS1500","TSS200")){
      repman.goi.region <- repman.goi[repman.goi$group %in% region,]
      message("Identified ",nrow(repman.goi.region)," CpGs in the Gene region(s) ",region," of ", goi,". Returning..")
      return(repman.goi.region$cpg)
      
    }
    
  } else{
    return(message("ERROR: Please enter a valid region identified (either: 'gene.body','gene.promoter','1stExon','3'UTR','5'UTR','Body','TSS1500', or 'TSS200')"))
  }
  
}
