library(recount)
library(tidyverse)
project_info <- abstract_search("SRP008496")
download_study("SRP008496")
load(file.path("SRP008496", "rse_gene.Rdata"))

unlink("SRP008496", recursive = TRUE)
cell_metadata <- data.frame(colData(rse_gene))
gene_metadata <- rowData(rse_gene)


## Extract the sample characteristics
geochar <- lapply(split(colData(rse_gene), seq_len(nrow(colData(rse_gene)))), geo_characteristics)

geochar

## Note that the information for this study is a little inconsistent, so we
## have to fix it.
coldata <- do.call(rbind, lapply(geochar, function(x) {
  if ("tissue" %in% colnames(x)) {
    colnames(x)[colnames(x) == "tissue"] <- "group"
    return(x)
  } else {
    return(x)
  }
}))

coldata$group <- gsub(coldata$group, pattern = "-", replacement = "_")

cts <- data.frame(assay(rse_gene))
cts <- cts %>% rownames_to_column(var = "ensembl_id")

write.table(cts, file = "../data/SRP008496_cts.tsv", sep = "\t", col.names = T, row.names = F, quote = F)

rownames(coldata) <- rownames(cell_metadata)
coldata <- coldata %>% rownames_to_column(var = "ID")

write.table(coldata, file = "../data/SRP008496_metadata.tsv", sep = "\t", col.names = T, row.names = F, quote = F)
  