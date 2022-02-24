# bulk RNAseq workshop
Repository for bulk RNAseq course of the Danish Health Data Science Sandbox project.

Created: November 2021

This workshop contains a basic tutorial on how to approach RNAseq experiments, starting from fastq files out of the sequencer. Thus, the workshop does not include any information about laboratory protocols, library preparation or any wet-lab related procedures. This workshop is based on a collection of modified tutorials from the [nf-core RNASeq](https://nf-co.re/rnaseq) pipeline, the [DESeq2](https://www.bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html) and [gProfiler2](https://cran.r-project.org/web/packages/gprofiler2/vignettes/gprofiler2.html) R language vignettes.

## Syllabus:
1. Introduction to bulk-RNASeq
2. Preprocessing of RNAseq reads (fastq) 
	- Trimming and filtering (TrimGalore)
	- Alignment (STAR/Bowtie2)
	- Feature count (STAR/FeatureCounts)
	- QC (FastQC and MultiQC)

3. Read normalization (DESeq2)
4. Exploratory analysis (DESeq2)
5. Differential Expression Analysis (DESeq2)
6. Functional Analysis (gprofiler2)

## Workshop requirements:
- Knowledge of R, Rstudio and Rmarkdown
- Basic knowledge of RNAseq techonology
- Basic knowledge of data science and statistics such as PCA, clustering and statistical testing

## Intended use
The aim of this repository is to run a comprehensive but introductory workshop on bulk-RNAseq bioinformatic analyses. Each of the modules of this workshop is accompanied by a powerpoint slideshow explaining the steps and the theory behind a typical bioinformatics analysis (ideally with a teacher). Many of the slides are annotated with extra information and/or point to original sources for extra reading material. The [example Rmarkdown](./Notebooks/slides/RNAseq_analysis_basics.Rmd) compiles modules 3-6 and can be used as a stand-alone template for a standard RNA-Seq analysis.

## Acknowledgements:
- [Center for Health Data Science](https://heads.ku.dk/), University of Copenhagen.
- [Hugo Tavares](https://bioinfotraining.bio.cam.ac.uk/about), Bioinformatics Training Facility, University of Cambridge.
- [Silvia Raineri](https://danstem.ku.dk/people/serup_staff/), Center for Stem Cell Biology (Danstem), University of Copenhagen.
