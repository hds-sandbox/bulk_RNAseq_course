# bulk RNAseq workshop
Repository for bulk RNAseq course of the Danish National Sandbox project.
Created: November 2021

This workshop contains a basic tutorial on how to approach RNAseq experiments, starting from fastq files out of the sequencer. Thus, the workshop does not include any information of laboratory protocols. This workshop is based on a collection of modified tutorials from the [nf-core](https://nf-co.re/rnaseq) pipeline, the [DESeq2](https://www.bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html) and [gProfiler2](https://cran.r-project.org/web/packages/gprofiler2/vignettes/gprofiler2.html) vignettes.

## Syllabus:
- Preprocessing of RNAseq reads (fastq) 
	- Trimming and filtering (TrimGalore)
	- Alignment (STAR/Bowtie2)
	- Feature count (STAR/FeatureCounts)
	- QC (FastQC and MultiQC)

- Read normalization (DESeq2)
- Exploratory analysis (DESeq2)
- Differential Expression Analysis (DESeq2)
- Functional Analysis (gprofiler2)

## Workshop requirements:
- Knowledge of R, Rstudio and Rmarkdown
- Basic knowledge of RNAseq techonology
- Basic knowledge of data science and statistics such as PCA, clustering and statistical testing

## Acknowledgements:
- [Center for Health Data Science](https://heads.ku.dk/), University of Copenhagen.
- [Hugo Tavares](https://bioinfotraining.bio.cam.ac.uk/about), Bioinformatics Training Facility, University of Cambridge.
