# Introduction to bulk RNAseq analysis workshop

Repository for bulk RNAseq course of the Danish Health Data Science Sandbox project.

This workshop material includes a tutorial on how to approach RNAseq data, starting from your sequencing reads (fastq files). Thus, the workshop only briefly touches upon laboratory protocols, library preparation, and experimental design of RNA sequencing experiments, mainly for the purpose of outlining considerations in the downstream bioinformatic analysis. This workshop is based on the materials developed by members of the teaching team at the [Harvard Chan Bioinformatics Core (HBC)](http://bioinformatics.sph.harvard.edu/), a collection of modified tutorials from the [DESeq2](https://www.bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html), R language vignettes and the [nf-core rnaseq pipeline](https://nf-co.re/rnaseq).

## Goals

By the end of this workshop, you should be able to analyse your own bulk RNAseq data:

-   Preprocess your reads into a count matrix.
-   Normalize your data.
-   Explore your samples with PCAs and heatmaps.
-   Perform Differential Expression Analysis.
-   Annotate your results.

## Syllabus

1.  Course Introduction
2.  Experimental planning
3.  Data Explanation
4.  Preprocessing and preprocessing pipelines
5.  RNAseq counts
6.  Exploratory analysis
7.  Differential Expression Analysis
8.  Functional Analysis
9.  Summarized workflow

## Workshop prerequisites

-   Knowledge of R, Rstudio and Rmarkdown. It is recommended that you have at least followed our workshop [From Excel to R](https://github.com/Center-for-Health-Data-Science/FromExceltoR_2022)
-   Basic knowledge of RNAseq technology
-   Basic knowledge of data science and statistics such as PCA, clustering and statistical testing

## Intended use

The aim of this repository is to run a comprehensive but introductory workshop on bulk-RNAseq bioinformatic analyses. Each of the modules of this workshop is accompanied by a powerpoint slideshow explaining the steps and the theory behind a typical bioinformatics analysis (ideally with a teacher). Many of the slides are annotated with extra information and/or point to original sources for extra reading material.

## Acknowledgements

-   [Center for Health Data Science](https://heads.ku.dk/), University of Copenhagen.
-   [Hugo Tavares](https://bioinfotraining.bio.cam.ac.uk/about), Bioinformatics Training Facility, University of Cambridge.
-   [Silvia Raineri](https://danstem.ku.dk/people/serup_staff/), Center for Stem Cell Medicine (reNew), University of Copenhagen.
-   [Harvard Chan Bioinformatics Core (HBC)](http://bioinformatics.sph.harvard.edu/), check out their [github repo](https://github.com/hbctraining/DGE_workshop_salmon_online)
