# Bulk RNAseq workshop

Repository for bulk RNAseq course of the Danish Health Data Science Sandbox project.

This course is an introduction to how to approach bulk RNAseq data, starting from the sequencing reads. It will provide an overview of the fundamentals of RNAseq analysis, including read preprocessing, data normalization, data exploration with PCAs and heatmaps, performing differential expression analysis, and annotation of the differentially expressed genes. Participants will also learn how to evaluate confounding and batch effects in the data. The course will further touch upon laboratory protocols, library preparation, and experimental design of RNA sequencing experiments, especially about how they influence downstream bioinformatic analysis. 

This workshop is based on the materials developed by members of the teaching team at the [Harvard Chan Bioinformatics Core (HBC)](http://bioinformatics.sph.harvard.edu/), a collection of modified tutorials from the [DESeq2](https://www.bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html), R language vignettes and the [nf-core pipeline for bulk RNAseq](https://nf-co.re/rnaseq/3.6).

## Goals

By the end of this workshop, you should be able to analyse your own bulk RNAseq count matrix:
  - Preprocess your reads.
  - Normalize your data.
  - Explore your samples with PCAs and heatmaps.
  - Perform Differential Expression Analysis.
  - Annotate your results.

## Syllabus

1. Introduction to bulk-RNASeq
2. Experimental planning
3. Intro to the data
4. Preprocessing your reads
5. RNAseq data
6. Exploratory analysis
7. Differential Expression Analysis
8. Functional Analysis
9. Summarized workflow

## Workshop requirements

- Knowledge of R, Rstudio, and Rmarkdown. It is recommended that you have at least followed our workshop [R basics](https://github.com/Center-for-Health-Data-Science/FromExceltoR_2022)
- Basic knowledge of RNAseq technology
- Basic knowledge of data science and statistics such as PCA, clustering and statistical testing

## Intended use

The aim of this repository is to run a comprehensive but introductory workshop on bulk-RNAseq bioinformatic analyses. Each of the modules of this workshop is accompanied by a powerpoint slideshow explaining the steps and the theory behind a typical bioinformatics analysis (ideally with a teacher). Many of the slides are annotated with extra information and/or point to original sources for additional reading material. 

A version of the slides from 2024 can be found in this [zenodo repository](https://zenodo.org/records/12090853).

## Acknowledgements

- [Center for Health Data Science](https://heads.ku.dk/), University of Copenhagen.
- [Hugo Tavares](https://bioinfotraining.bio.cam.ac.uk/about), Bioinformatics Training Facility, University of Cambridge.
- [Silvia Raineri](https://renew.ku.dk/research/reseach-groups/serup-group/), Center for Stem Cell Medicine (reNew), University of Copenhagen.
- [Harvard Chan Bioinformatics Core (HBC)](http://bioinformatics.sph.harvard.edu/), check out their [github repo](https://github.com/hbctraining/DGE_workshop_salmon_online)
- [Adrija Kalvisa](https://renew.ku.dk/people/?id=645384&vis=medarbejder)
- [nf-core community](https://nf-co.re/)
