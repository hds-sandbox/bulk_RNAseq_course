install.packages(c("BiocManager", "tidyverse", "RColorBrewer", "pheatmap", "ggrepel", "cowplot"))
BiocManager::install(c("DESeq2", "clusterProfiler", "DOSE", "org.Hs.eg.db", "pathview", "DEGreport", "tximport", "AnnotationHub", "ensembldb","apeglm"))


renv::install(c("BiocManager", "tidyverse", "RColorBrewer", "pheatmap", "ggrepel", "cowplot"))
renv::install(c("bioc::DESeq2", "bioc::clusterProfiler", "bioc::DOSE", "bioc::org.Hs.eg.db", 
                "bioc::pathview", "bioc::DEGreport", "bioc::tximport", "bioc::AnnotationHub", "bioc::ensembldb", "bioc::apeglm"))
