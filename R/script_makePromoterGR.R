library(EnsDb.Hsapiens.v75)
library(org.Hs.eg.db)

edb <- EnsDb.Hsapiens.v75

pe <- promoters(edb); pe <- pe[mcols(pe)$tx_biotype=="protein_coding"]
# length(unique(mcols(pe)$gene_id)) # [1] 22642

uglist <- unique(mcols(pe)$gene_id)
pe.grdf <- data.frame(gene_id=uglist,
                      chr=rep("NA",length(uglist)),
                      start=rep("NA",length(uglist)),
                      end=rep("NA",length(uglist)),
                      stringsAsFactors = F)
                      
for(i in 1:length(uglist)){

  pe.i <- pe[mcols(pe)$gene_id==uglist[i]]
  pe.grdf[i,] <- c(uglist[i],paste0("chr",unique(seqnames(pe.i))),min(start(pe.i)),max(end(pe.i)))

}; 

sydf <- select(org.Hs.eg.db, pe.grdf$gene_id, c("SYMBOL"), "ENSEMBL")
sydf <- sydf[!duplicated(sydf$ENSEMBL),]
pe.grdf$symbol <- sydf$SYMBOL

pgr <- makeGRangesFromDataFrame(pe.grdf,keep.extra.columns = T)
save(pgr,file="promotersgr_ensdbgene_hg19.rda")
