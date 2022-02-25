# Introduction

This is a basic bulk RNAseq analysis using the package **DESeq2** and
**gprofiler2** for Differential Expression Analysis and Functional
Annotation. The code is a modified version of the
[DESeq2](https://www.bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html)
and
[gprofiler2](https://cran.r-project.org/web/packages/gprofiler2/vignettes/gprofiler2.html)
vignettes. The data used for this example below is the *pasilla*
dataset: an RNAseq experiment that studied the effect of RNAi knockdown
of Pasilla, the Drosophila melanogaster ortholog of mammalian NOVA1 and
NOVA2, on the transcriptome.

# Load libraries

``` r
library(tidyverse, quietly = T)
library(DESeq2, quietly = T)
library(RColorBrewer, quietly = T)
library(pheatmap, quietly = T)
library(gprofiler2, quietly = T)
library(Glimma, quietly = T)
```

# Load data

In order to proceed with the analysis we need two dataframes: - Count
matrix dataframe with gene names as rows (and rownames) and samples as
columns (and column names). - Sample metadata dataframe with samples as
rows (and rownames) and metadata variables as columns (and column
names).

Additionally, you can add information about your features (genes), with
genes as rows and gene metadata on columns.

Ideally, the sample metadata will contain information about the
conditions, treatments, replicates, etc.

The pasilla dataset contains a count matrix and the metadata, which is a
good example to use as a template. The count matrix looks like this:

``` r
cts <- data.frame(read.csv(file = "../Data/example_data/pasilla_cts.tsv", sep="\t", row.names="flybase_id"))
head(cts)
```

    ##             untreated1 untreated2 untreated3 untreated4 treated1 treated2
    ## FBgn0000003          0          0          0          0        0        0
    ## FBgn0000008         92        161         76         70      140       88
    ## FBgn0000014          5          1          0          0        4        0
    ## FBgn0000015          0          2          1          2        1        0
    ## FBgn0000017       4664       8714       3564       3150     6205     3072
    ## FBgn0000018        583        761        245        310      722      299
    ##             treated3
    ## FBgn0000003        1
    ## FBgn0000008       70
    ## FBgn0000014        0
    ## FBgn0000015        0
    ## FBgn0000017     3334
    ## FBgn0000018      308

While the sample metadata looks like this:

``` r
coldata <- read.csv(file = "../Data/example_data/pasilla_metadata.tsv", row.names=1, sep = "\t")
head(coldata)
```

    ##            condition        type
    ## untreated1 untreated single-read
    ## untreated2 untreated single-read
    ## untreated3 untreated  paired-end
    ## untreated4 untreated  paired-end
    ## treated1     treated single-read
    ## treated2     treated  paired-end

Making the metadata factors will establish the order of the metadata
variables. If you never tell the DESeq2 functions which level you want
to compare against (e.g. which level represents the control group), the
comparisons will be based on the alphabetical order of the levels. This
is important since the first level of the metadata will be the reference
sample/condition for the DE analysis.

``` r
coldata$condition <- factor(coldata$condition)
paste("The order of the conditions is:", paste(unique(coldata$condition), collapse=", "))
```

    ## [1] "The order of the conditions is: untreated, treated"

``` r
coldata$type <- factor(coldata$type)
paste("The order of the types is:", paste(unique(coldata$type), collapse=", "))
```

    ## [1] "The order of the types is: single-read, paired-end"

## Metadata factor levels

If you want to change the order of the factor levels you can use one of
these two. NOTE: this has to be done before running the `DESeq()`
function.

``` r
#coldata$condition <- factor(coldata$condition, levels = c("untreated","treated"))
coldata$condition <- relevel(coldata$condition, ref = "untreated") #Specifies "untreated" as the reference level
```

## Create DESeq object

We create the DESeq object from the count matrix and the metadata. We
specify that the analysis will be based on the design column.

``` r
dds <- DESeqDataSetFromMatrix(countData = cts,
                              colData = coldata, rowData = rownames(cts),
                              design = ~ condition)
dds
```

    ## class: DESeqDataSet 
    ## dim: 14599 7 
    ## metadata(1): version
    ## assays(1): counts
    ## rownames(14599): FBgn0000003 FBgn0000008 ... FBgn0261574 FBgn0261575
    ## rowData names(1): X
    ## colnames(7): untreated1 untreated2 ... treated2 treated3
    ## colData names(2): condition type

## Pre-filtering

We can reduce the computational resources of the analysis by removing
genes that are very hardly expressed. Additionally, you can collapse
technical replicates using the function `collapseReplicates()`.

``` r
keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep,]
```

## Normalization

Finally the `DESeq()` function will normalize your read counts and
estimate size factors per genes. This function is essential for the rest
of the analysis.

``` r
dds <- DESeq(dds)
```

# Session info

``` r
devtools::session_info()
```

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
    ##  hms                    1.1.1    2021-09-26 [1] CRAN (R 4.1.0)
    ##  htmltools              0.5.2    2021-08-25 [1] CRAN (R 4.1.0)
    ##  htmlwidgets            1.5.4    2021-09-08 [1] CRAN (R 4.1.0)
    ##  httr                   1.4.2    2020-07-20 [1] CRAN (R 4.1.0)
    ##  IRanges              * 2.28.0   2021-10-26 [1] Bioconductor
    ##  jsonlite               1.7.2    2020-12-09 [1] CRAN (R 4.1.0)
    ##  KEGGREST               1.34.0   2021-10-26 [1] Bioconductor
    ##  knitr                  1.36     2021-09-29 [1] CRAN (R 4.1.0)
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
