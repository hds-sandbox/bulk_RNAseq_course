# Exploratory analysis

After running the `DESeq()` function, we can start our RNAseq analysis
by exploring the relationships between our samples. In principle, all
replicates for a specific condition should be similar to each other
after normalization. Should this not be the case, one might need to
remove outlier replicates. This is one of the reasons why RNAseq
experiments need at least 3 replicates per condition.

## Data transformations

For visualization and clustering (exploratory analyses) – it might be
useful to work with transformed versions of the count data. There are
two main methods used for this purpose: variance stabilizing
transformations (**VST**), and the regularized logarithm or **rlog**.
Both transformations produce transformed data on the log2 scale which
has been normalized with respect to library size or other normalization
factors.

    vsd <- vst(dds) #Variance Stabilizing Transformation, vst is faster with larger number of samples
    rld <- rlog(dds) #Regularized 

## Samples comparisons

We can do some sanity checks of the samples. We can see how they
correlate to each other in a heatmap or see their Principal Components
with a PCA plot.

### Heatmap of the sample-to-sample distances

This plot shows how far away are each sample from each other. The darker
the blue, the closer they are.

    sampleDists <- dist(t(assay(vsd)))
    sampleDistMatrix <- as.matrix(sampleDists)
    rownames(sampleDistMatrix) <- paste(vsd$condition, vsd$type, sep="-")
    colnames(sampleDistMatrix) <- NULL
    colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
    pheatmap(sampleDistMatrix,
             clustering_distance_rows=sampleDists,
             clustering_distance_cols=sampleDists,
             col=colors)

<img src="../exploratory_analysis.Rmd/sample_distances_heatmap-1.png" style="display: block; margin: auto;" />

### Principal component plot of the samples

PCA plot using the first two components

    pcaData <- plotPCA(vsd, intgroup=c("condition", "type"), returnData=TRUE)
    percentVar <- round(100 * attr(pcaData, "percentVar"))
    ggplot(pcaData, aes(PC1, PC2, color=condition, shape=type)) +
      geom_point(size=3) +
      xlab(paste0("PC1: ",percentVar[1],"% variance")) +
      ylab(paste0("PC2: ",percentVar[2],"% variance")) + 
      coord_fixed() + theme_bw()

<img src="../exploratory_analysis.Rmd/PCA_plot-1.png" style="display: block; margin: auto;" />
### Glimma plots Interactive visualizations of the DESeq results using
the **Glimma** package, which provides excellent options for MA, Volcano
and dimensionality reduction (like a PCA) plots. Use the *groups*
argument to provide the condition or factor of your experiment.
Unfortunately, the interactive plots created here are not fully
compatible when knitting this document. Feel free to explore them using
this [link](./mds-plot.html)!

    glimma_plot <- glimmaMDS(dds, groups = dds$condition)

Save your interactive plots using the **htmlwidgets** package,
specifically, the `saveWidget()`

    htmlwidgets::saveWidget(glimma_plot, "mds-plot.html")

## Plot counts

It can be useful to examine the counts of reads for a single gene across
the conditions. A simple function for making this plot is plotCounts,
which normalizes counts by the estimated size factors (or normalization
factors if these were used) and adds a pseudocount of 1/2 to allow for
log scale plotting. The counts are grouped by the variables in
*intgroup* argument, where more than one variable can be specified. You
can select the gene to plot by its name or by numeric index.

    d <- plotCounts(dds, gene= 1, intgroup="condition", 
                    returnData=TRUE)
    ggplot(d, aes(x=condition, y=count, color = condition)) + 
      geom_point(position=position_jitter(w=0.1,h=0)) + 
      scale_y_log10(breaks=c(25,100,400)) + theme_bw()

<img src="../exploratory_analysis.Rmd/plot_counts_example-1.png" style="display: block; margin: auto;" />

# Session info

Finally, we create a `session_info()` table that will allow anyone to
check what versions of R and packages are we using for reproducibility
purposes.

    devtools::session_info()

    ## ─ Session info ───────────────────────────────────────────────────────────────
    ##  setting  value
    ##  version  R version 4.1.0 (2021-05-18)
    ##  os       macOS Big Sur 10.16
    ##  system   x86_64, darwin17.0
    ##  ui       X11
    ##  language (EN)
    ##  collate  en_US.UTF-8
    ##  ctype    en_US.UTF-8
    ##  tz       Europe/Copenhagen
    ##  date     2022-02-25
    ##  pandoc   2.14.0.1 @ /usr/local/bin/ (via rmarkdown)
    ## 
    ## ─ Packages ───────────────────────────────────────────────────────────────────
    ##  package              * version  date (UTC) lib source
    ##  annotate               1.72.0   2021-10-26 [1] Bioconductor
    ##  AnnotationDbi          1.56.2   2021-11-09 [1] Bioconductor
    ##  assertthat             0.2.1    2019-03-21 [1] CRAN (R 4.1.0)
    ##  backports              1.4.1    2021-12-13 [1] CRAN (R 4.1.0)
    ##  Biobase              * 2.54.0   2021-10-26 [1] Bioconductor
    ##  BiocGenerics         * 0.40.0   2021-10-26 [1] Bioconductor
    ##  BiocParallel           1.28.3   2021-12-09 [1] Bioconductor
    ##  Biostrings             2.62.0   2021-10-26 [1] Bioconductor
    ##  bit                    4.0.4    2020-08-04 [1] CRAN (R 4.1.0)
    ##  bit64                  4.0.5    2020-08-30 [1] CRAN (R 4.1.0)
    ##  bitops                 1.0-7    2021-04-24 [1] CRAN (R 4.1.0)
    ##  blob                   1.2.2    2021-07-23 [1] CRAN (R 4.1.0)
    ##  broom                  0.7.10   2021-10-31 [1] CRAN (R 4.1.0)
    ##  cachem                 1.0.6    2021-08-19 [1] CRAN (R 4.1.0)
    ##  callr                  3.7.0    2021-04-20 [1] CRAN (R 4.1.0)
    ##  cellranger             1.1.0    2016-07-27 [1] CRAN (R 4.1.0)
    ##  cli                    3.1.0    2021-10-27 [1] CRAN (R 4.1.0)
    ##  colorspace             2.0-2    2021-06-24 [1] CRAN (R 4.1.0)
    ##  crayon                 1.4.2    2021-10-29 [1] CRAN (R 4.1.0)
    ##  data.table             1.14.2   2021-09-27 [1] CRAN (R 4.1.0)
    ##  DBI                    1.1.1    2021-01-15 [1] CRAN (R 4.1.0)
    ##  dbplyr                 2.1.1    2021-04-06 [1] CRAN (R 4.1.0)
    ##  DelayedArray           0.20.0   2021-10-26 [1] Bioconductor
    ##  desc                   1.4.0    2021-09-28 [1] CRAN (R 4.1.0)
    ##  DESeq2               * 1.34.0   2021-10-26 [1] Bioconductor
    ##  devtools               2.4.3    2021-11-30 [1] CRAN (R 4.1.0)
    ##  digest                 0.6.29   2021-12-01 [1] CRAN (R 4.1.0)
    ##  dplyr                * 1.0.7    2021-06-18 [1] CRAN (R 4.1.0)
    ##  edgeR                  3.36.0   2021-10-26 [1] Bioconductor
    ##  ellipsis               0.3.2    2021-04-29 [1] CRAN (R 4.1.0)
    ##  evaluate               0.14     2019-05-28 [1] CRAN (R 4.1.0)
    ##  fansi                  0.5.0    2021-05-25 [1] CRAN (R 4.1.0)
    ##  farver                 2.1.0    2021-02-28 [1] CRAN (R 4.1.0)
    ##  fastmap                1.1.0    2021-01-25 [1] CRAN (R 4.1.0)
    ##  forcats              * 0.5.1    2021-01-27 [1] CRAN (R 4.1.0)
    ##  fs                     1.5.2    2021-12-08 [1] CRAN (R 4.1.0)
    ##  genefilter             1.76.0   2021-10-26 [1] Bioconductor
    ##  geneplotter            1.72.0   2021-10-26 [1] Bioconductor
    ##  generics               0.1.1    2021-10-25 [1] CRAN (R 4.1.0)
    ##  GenomeInfoDb         * 1.30.0   2021-10-26 [1] Bioconductor
    ##  GenomeInfoDbData       1.2.7    2021-11-16 [1] Bioconductor
    ##  GenomicRanges        * 1.46.1   2021-11-18 [1] Bioconductor
    ##  ggplot2              * 3.3.5    2021-06-25 [1] CRAN (R 4.1.0)
    ##  Glimma               * 2.4.0    2021-10-26 [1] Bioconductor
    ##  glue                   1.5.1    2021-11-30 [1] CRAN (R 4.1.0)
    ##  gprofiler2           * 0.2.1    2021-08-23 [1] CRAN (R 4.1.0)
    ##  gtable                 0.3.0    2019-03-25 [1] CRAN (R 4.1.0)
    ##  haven                  2.4.3    2021-08-04 [1] CRAN (R 4.1.0)
    ##  highr                  0.9      2021-04-16 [1] CRAN (R 4.1.0)
    ##  hms                    1.1.1    2021-09-26 [1] CRAN (R 4.1.0)
    ##  htmltools              0.5.2    2021-08-25 [1] CRAN (R 4.1.0)
    ##  htmlwidgets            1.5.4    2021-09-08 [1] CRAN (R 4.1.0)
    ##  httr                   1.4.2    2020-07-20 [1] CRAN (R 4.1.0)
    ##  IRanges              * 2.28.0   2021-10-26 [1] Bioconductor
    ##  jsonlite               1.7.2    2020-12-09 [1] CRAN (R 4.1.0)
    ##  KEGGREST               1.34.0   2021-10-26 [1] Bioconductor
    ##  knitr                  1.36     2021-09-29 [1] CRAN (R 4.1.0)
    ##  labeling               0.4.2    2020-10-20 [1] CRAN (R 4.1.0)
    ##  lattice                0.20-45  2021-09-22 [1] CRAN (R 4.1.0)
    ##  lazyeval               0.2.2    2019-03-15 [1] CRAN (R 4.1.0)
    ##  lifecycle              1.0.1    2021-09-24 [1] CRAN (R 4.1.0)
    ##  limma                  3.50.0   2021-10-26 [1] Bioconductor
    ##  locfit                 1.5-9.4  2020-03-25 [1] CRAN (R 4.1.0)
    ##  lubridate              1.8.0    2021-10-07 [1] CRAN (R 4.1.0)
    ##  magrittr               2.0.1    2020-11-17 [1] CRAN (R 4.1.0)
    ##  Matrix                 1.4-0    2021-12-08 [1] CRAN (R 4.1.0)
    ##  MatrixGenerics       * 1.6.0    2021-10-26 [1] Bioconductor
    ##  matrixStats          * 0.61.0   2021-09-17 [1] CRAN (R 4.1.0)
    ##  memoise                2.0.1    2021-11-26 [1] CRAN (R 4.1.0)
    ##  modelr                 0.1.8    2020-05-19 [1] CRAN (R 4.1.0)
    ##  munsell                0.5.0    2018-06-12 [1] CRAN (R 4.1.0)
    ##  pheatmap             * 1.0.12   2019-01-04 [1] CRAN (R 4.1.0)
    ##  pillar                 1.6.4    2021-10-18 [1] CRAN (R 4.1.0)
    ##  pkgbuild               1.3.0    2021-12-09 [1] CRAN (R 4.1.0)
    ##  pkgconfig              2.0.3    2019-09-22 [1] CRAN (R 4.1.0)
    ##  pkgload                1.2.4    2021-11-30 [1] CRAN (R 4.1.0)
    ##  plotly                 4.10.0   2021-10-09 [1] CRAN (R 4.1.0)
    ##  png                    0.1-7    2013-12-03 [1] CRAN (R 4.1.0)
    ##  prettyunits            1.1.1    2020-01-24 [1] CRAN (R 4.1.0)
    ##  processx               3.5.2    2021-04-30 [1] CRAN (R 4.1.0)
    ##  ps                     1.6.0    2021-02-28 [1] CRAN (R 4.1.0)
    ##  purrr                * 0.3.4    2020-04-17 [1] CRAN (R 4.1.0)
    ##  R6                     2.5.1    2021-08-19 [1] CRAN (R 4.1.0)
    ##  RColorBrewer         * 1.1-2    2014-12-07 [1] CRAN (R 4.1.0)
    ##  Rcpp                   1.0.7    2021-07-07 [1] CRAN (R 4.1.0)
    ##  RCurl                  1.98-1.5 2021-09-17 [1] CRAN (R 4.1.0)
    ##  readr                * 2.1.1    2021-11-30 [1] CRAN (R 4.1.0)
    ##  readxl                 1.3.1    2019-03-13 [1] CRAN (R 4.1.0)
    ##  remotes                2.4.2    2021-11-30 [1] CRAN (R 4.1.0)
    ##  reprex                 2.0.1    2021-08-05 [1] CRAN (R 4.1.0)
    ##  rlang                  0.4.12   2021-10-18 [1] CRAN (R 4.1.0)
    ##  rmarkdown              2.11     2021-09-14 [1] CRAN (R 4.1.0)
    ##  rprojroot              2.0.2    2020-11-15 [1] CRAN (R 4.1.0)
    ##  RSQLite                2.2.9    2021-12-06 [1] CRAN (R 4.1.0)
    ##  rstudioapi             0.13     2020-11-12 [1] CRAN (R 4.1.0)
    ##  rvest                  1.0.2    2021-10-16 [1] CRAN (R 4.1.0)
    ##  S4Vectors            * 0.32.3   2021-11-21 [1] Bioconductor
    ##  scales                 1.1.1    2020-05-11 [1] CRAN (R 4.1.0)
    ##  sessioninfo            1.2.2    2021-12-06 [1] CRAN (R 4.1.0)
    ##  stringi                1.7.6    2021-11-29 [1] CRAN (R 4.1.0)
    ##  stringr              * 1.4.0    2019-02-10 [1] CRAN (R 4.1.0)
    ##  SummarizedExperiment * 1.24.0   2021-10-26 [1] Bioconductor
    ##  survival               3.2-13   2021-08-24 [1] CRAN (R 4.1.0)
    ##  testthat               3.1.1    2021-12-03 [1] CRAN (R 4.1.0)
    ##  tibble               * 3.1.6    2021-11-07 [1] CRAN (R 4.1.0)
    ##  tidyr                * 1.1.4    2021-09-27 [1] CRAN (R 4.1.0)
    ##  tidyselect             1.1.1    2021-04-30 [1] CRAN (R 4.1.0)
    ##  tidyverse            * 1.3.1    2021-04-15 [1] CRAN (R 4.1.0)
    ##  tzdb                   0.2.0    2021-10-27 [1] CRAN (R 4.1.0)
    ##  usethis                2.1.5    2021-12-09 [1] CRAN (R 4.1.0)
    ##  utf8                   1.2.2    2021-07-24 [1] CRAN (R 4.1.0)
    ##  vctrs                  0.3.8    2021-04-29 [1] CRAN (R 4.1.0)
    ##  viridisLite            0.4.0    2021-04-13 [1] CRAN (R 4.1.0)
    ##  withr                  2.4.3    2021-11-30 [1] CRAN (R 4.1.0)
    ##  xfun                   0.28     2021-11-04 [1] CRAN (R 4.1.0)
    ##  XML                    3.99-0.8 2021-09-17 [1] CRAN (R 4.1.0)
    ##  xml2                   1.3.3    2021-11-30 [1] CRAN (R 4.1.0)
    ##  xtable                 1.8-4    2019-04-21 [1] CRAN (R 4.1.0)
    ##  XVector                0.34.0   2021-10-26 [1] Bioconductor
    ##  yaml                   2.2.1    2020-02-01 [1] CRAN (R 4.1.0)
    ##  zlibbioc               1.40.0   2021-10-26 [1] Bioconductor
    ## 
    ##  [1] /Library/Frameworks/R.framework/Versions/4.1/Resources/library
    ## 
    ## ──────────────────────────────────────────────────────────────────────────────
