library(recount)
library(tidyverse)
project_info <- abstract_search("SRP051765")
download_study("SRP051765")
load(file.path("SRP051765", "rse_gene.Rdata"))

unlink("SRP051765", recursive = TRUE)
cell_metadata <- data.frame(colData(rse_gene))
gene_metadata <- rowData(rse_gene)


## Extract the sample characteristics
geochar <- lapply(split(colData(rse_gene), seq_len(nrow(colData(rse_gene)))), geo_characteristics)

geochar

coldata <- do.call(rbind, geochar)

rownames(coldata) <- rownames(cell_metadata)
coldata <- coldata %>% rownames_to_column(var = "ID")

coldata$drug.treatment <-  c("control", paste0("treat", 1:5),  coldata$drug.treatment)[match(coldata$drug.treatment, c(unique(coldata$drug.treatment), coldata$drug.treatment))]
colnames(coldata) <- gsub(colnames(coldata), pattern = ".", replacement = "_", fixed = T)

cts <- data.frame(assay(rse_gene))
cts <- cts %>% rownames_to_column(var = "ensembl_id")

write.table(cts, file = "../data/SRP051765_cts.tsv", sep = "\t", col.names = T, row.names = F, quote = F)

write.table(coldata, file = "../data/SRP051765_metadata.tsv", sep = "\t", col.names = T, row.names = F, quote = F)
