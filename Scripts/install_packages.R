# Run these two lines for your local computer
install.packages(c("BiocManager", "tidyverse", "RColorBrewer", "pheatmap", "ggrepel", "cowplot"))
BiocManager::install(c("DESeq2", "clusterProfiler", "DOSE", "org.Hs.eg.db", "pathview", "DEGreport", 
                       "tximport", "AnnotationHub", "ensembldb","apeglm","ggnewscale"))

## Run this to install in an renv environment (ucloud)
#renv::install(c("BiocManager", "tidyverse", "RColorBrewer", "pheatmap", "ggrepel", "cowplot"))
#renv::install(c("bioc::DESeq2", "bioc::clusterProfiler", "bioc::DOSE", "bioc::org.Hs.eg.db", 
#                "bioc::pathview", "bioc::DEGreport", "bioc::tximport", "bioc::AnnotationHub", 
#                "bioc::ensembldb", "bioc::apeglm", "bioc::ggnewscale"))
