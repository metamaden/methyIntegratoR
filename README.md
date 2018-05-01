# methyIntegratoR
R library for integrated analysis involving methylation arrays and other molecular data.

Download this library using the following in the R console: 
`require(devtools); install_github("metamaden/methyIntegratoR")`

# Overview
There are numerous recurring analysis strategies when working with Illumina methylation arrays. This package seeks to simplify some of these routine tasks which, though relatively straightforward, can consist in many steps. 

## Genomic Annotation Files
There are several pre-prepared genome annotation files, for convenience, which can be loaded using the 'data()' function as follows:
```r
library(methyIntegratoR)

# 1. Load Genomic Features prepared files

# 1A. CpG Island IDs
# load the hg19 CpG Islands in GenomicRanges format (derived from UCSC Table Browser bedfile)
data(cgislgr_ucsctb_hg19) 
data(cgislgr_ucsctb_hg19)
length(cgisl) # returns:
# [1] 28691

# 1B. Gene Promoter Coordinates
# load the gene promoter regions (permissive), compiled from 'TxDb.hg19' or 'EnsDb.Hsapiens.v75' packages
data(gene_promoters_grlist_hg19)

names(genepromoters.grlist) # returns:
#[1] "txdb19.promotersgr"  "ensdb37.promotersgr"

mcols(genepromoters.grlist$txdb19.promotersgr) # returns:
#DataFrame with 23056 rows and 2 columns
#          gene_id      symbol
#      <character> <character>
#1               1        A1BG
#2              10        NAT2
#3             100         ADA
#4            1000        CDH2
#5           10000        AKT3
#...           ...         ...
#23052        9991       PTBP3
#23053        9992       KCNE2
#23054        9993       DGCR2
#23055        9994    CASP8AP2
#23056        9997        SCO2

mcols(genepromoters.grlist$ensdb37.promotersgr) # returns: 
#DataFrame with 20314 rows and 6 columns
#              gene_id   gene_name                   entrezid   gene_biotype seq_coord_system      symbol
#          <character> <character>                <character>    <character>      <character> <character>
#1     ENSG00000186092       OR4F5                      79501 protein_coding       chromosome       OR4F5
#2     ENSG00000237683  AL627309.1 100996768;728728;101929819 protein_coding       chromosome  AL627309.1
#3     ENSG00000235249      OR4F29         26683;81399;729759 protein_coding       chromosome      OR4F29
#4     ENSG00000185097      OR4F16         81399;729759;26683 protein_coding       chromosome      OR4F16
#5     ENSG00000269831  AL669831.1                            protein_coding       chromosome  AL669831.1
#...               ...         ...                        ...            ...              ...         ...
#20310 ENSG00000187191        DAZ3                57054;57055 protein_coding       chromosome        DAZ3
#20311 ENSG00000205916        DAZ4           57055;57135;1617 protein_coding       chromosome        DAZ4
#20312 ENSG00000185894       BPY2C         9083;442867;442868 protein_coding       chromosome       BPY2C
#20313 ENSG00000172288        CDY1                253175;9085 protein_coding       chromosome        CDY1
#20314 ENSG00000269393  AC007965.1                            protein_coding       chromosome  AC007965.1

# 2. Load repman "repeated manifest" objects for HM450K and EPIC platforms
# Note: repeated manifests show only unique CpG-transcript interactions (by RefGene ID, NOT Genbank)
# Thus, CpGs not overlapping a transcript are omitted.

# 2A. HM450K platform
data(repman_hm450)
head(repman450) # returns
#     accession     name   group        cpg
#1 NM_001164471    TSPY4    Body cg00050873
#2    NR_001553 FAM197Y2 TSS1500 cg00050873
#3    NR_001543   TTTY14  TSS200 cg00212031
#4    NM_004202   TMSB4Y 1stExon cg00214611
#5    NM_004202   TMSB4Y   5'UTR cg00214611
#6    NM_134259    TBL1Y  TSS200 cg01707559

# 2B. EPIC platform
data(repman_epic)
head(repman.epic) # returns:
#     accession   name   group        cpg
#1    NM_017798 YTHDF1  TSS200 cg18478105
#2    NM_001415 EIF2S3 TSS1500 cg09835024
#3    NM_013355   PKN3 TSS1500 cg14361672
#4    NM_198082 CCDC57    Body cg01763666
#5    NM_022489   INF2    Body cg12950382
#6 NM_001031714   INF2    Body cg12950382

# To load complete annotation files/manifests, including gene- and non-gene-mapping CpGs, use the following Bioconductor packages:
# 1. IlluminaHumanMethylationEPICanno.ilm10b2.hg19 (EPIC platform)
# 2. IlluminaHumanMethylation450kanno.ilmn12.hg19 (HM450K platform)

```

## Region Methylation
In order to derive region methylation summaries from arrays, it is necessary to interpret the manifest documents provided by Illumina and distributed through libraries such as minfi. While ideal for certain purposes and constrained to one unique CpG per row, manifests accessed through the minfi R library can be tricky to use even to perform a simple task such as "find the promoter methylation of gene TP53." The difficulties, and the solutions provided in this package, are detailed in the "Example" subsection, below. In short, this package takes as input a RefSeq Accession or Gene Symbol/Name and returns region CpGs that map to the region of interest in the selected array platform.

## Integrated Analysis
To study methylation and gene expression together, it is often necessary to correlate the two data types and apply extensive filters on magnitude of either methylation or expression in the tissue type of interest, in subsets of the tissue type, or in comparable normal tissues. Each step in this process requires multiple objects be stored and handled. For this reason, this package simplifies integrated analysis of methylation and expression by streamlining routine analysis steps such as genome-wide correlation analysis and data visualization such as overlay plotting. The useR is therefore only required to provide the experimental design and ordered methylation and expression data. 

## Example
This package includes a dataset transformed from the official Illumina annotation for methylation arrays. Every row in this dataframe corresponds to a unique transcript overlap with a CpG position, and as a result the cpg and gene identifiers are repeated, though each overlap is unique. The utility of this reformatted dataset and the problems it addresses are detailed below. In short, intuitive querying of CpG genomic regions is enabled and can be seamlessly integrated with workflows using the original manifest format.

In a typical workflow with minfi objects, a common mistake is to query the CpG probe-level annotation for gene or region names. For example, to identify promoter methylation at the gene TP53 on the HM450K BeadChip, it is necessary to first identify available CpGs mapping to the desired region. 

Many straightforward query strategies will fail with the minfi annotation. For instance, to identify CpGs mapping to the gene region of TP53 from the manifest, the following pitfalls are readily encountered:
1. `anno[anno$UCSC_RefGene_Name=="TP53",]`
This will fail because many CpGs map to multiple transcripts, which is reflected in the manifest as a string of gene names separated by ";" such as: "TP53;TP53;TP53" for the variable UCSC_RefGene_Name. 
2. `anno[grepl("TP53",anno$UCSC_RefGene_Name),]` 
This will return CpGs mapping to multiple gene regions, because the string 'TP53' is attributable to multiple full RefSeq gene names (eg. TP53RK and TP53BP2).

One correct way to identify the CpG probes mapping to a certain gene is by intersect with the chromosome coordinates of the gene region of interest, and there are resources readily available to streamline the process of working with genome coordinates (see Bioconductor's GenomicRanges library). 

Perhaps the simplest way to identify the CpGs mapping to a gene of interest is to leverage the semantic nature of the manifest entries using RegularExpressions. In this example we do this with the grepl() R function, though others are available. One solution is thus:
```r
anno.tp53.cpg <- anno[grepl("(^|;)TP53($|;)",anno$UCSC_RefGene_Name),]
```
This correctly returns annotation for CpGs mapping to any region of the TP53 gene. One sanity check is to make sure all the CpGs are located relatively close to one another, and not on separate chromosomes. 

Regular expressions are handy, but it's likely not necessary to obtain a comprehensive knowledge for the handful of data manipulation tasks mentioned here. Suffice it to note the following about the pattern used: The parentheses and "|" symbols delineate optional conditions to the left and right of the character string of the gene name we care about; the symbols "^" and "$" are special characters in RegEx syntax denoting beginning and end of string, respectively; and ";" is not a special character, but in the annotation it delineates entries for separate transcripts. These conditions eliminate the possibility of a gene with the embedded string "TP53" being erroneously returned.

One further complication is with correctly mapping gene IDs, Names, or Accessions to the corresponding region (eg. "Body", "1stExon", "TSS200", etc.) in the variable UCSC_RefGene_Group. The following strategy would fail here:
```r
anno.promoter <- anno[anno$UCSC_RefGene_Group %in% c("TSS200","TSS1500","5'UTR"),]; 
anno.tp53.promoter <- anno[grepl("(^|;)TP53($|;)",anno$UCSC_RefGene_Name),]
```
This fails because the entries in UCSC_RefGene_Name correspond to each entry in UCSC_RefGene_Group in a position-dependant manner, meaning that a CpG with a promoter region entry in a string of transcript regions for UCSC_RefGene_Group will not necessarily map to the promoter region of a transcript for the gene of interest (remember there are polycistronic regions where a CpG can map to transcripts from multiple genes!). 

One correct way to identify CpGs mapping to the TP53 gene would be the following:
```r
cpg.list <- c();
for(i in 1:nrow(anno.tp53.cpg)){
  idi <- unlist(strsplit(anno.tp53.cpg$UCSC_RefGene_Name,";"))
  grpi <- unlist(strsplit(anno.tp53.cpg$UCSC_RefGene_Group,";"))

  patterni <- c("TSS200:TP53","TSS1500:TP53","5'UTR:TP53")
  
  for(j in 1:length(idi)){
    pasti <- paste(grpi,":",idi,collapse=";",sep="")
    
    if(grepl(patterni,pasti)){
      cpg.list <- c(cpg.list,anno.tp53.cpg$Name[i])
    }
  }
}
```

However, this approach taxes computer resources and is frankly awkward to write. 

The above issues are assuaged in methyIntegratoR. Separate, custom annotations for HM450K and EPIC arrays have been provided that allow fast and accurate CpG region lists to be generated with simple commands. 

## NEWS/TODO
### 1/20/18
Planned Improvements. Methy Integrator should empower arbitrary overlays between CpGs and genomic objects. Consider defining a wrapper function that enables quick and intuitive cross-checking of overlap between CpGs and genomic features (promoters, enhancers, quenchers, etc.). 
