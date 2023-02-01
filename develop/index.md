---
title: Introduction to bulk RNAseq analysis workshop
summary: Index page, intro to course
date: 2023-02-01
hide:
  - navigation
  - toc
---

<!--
# Put above to hide navigation (left), toc (right) or footer (bottom)

hide:
  - navigation 
  - toc
  - footer 

# You should hide the navigation if there are no subsections
# You should hide the Table of Contents if there are no important titles
-->

<center>
# Introduction to bulk RNAseq analysis
</center>

**Updated:** 17/01/2023

This workshop material includes a tutorial on how to approach RNAseq data, starting from your sequencing reads (fastq files). Thus, the workshop only briefly touches upon laboratory protocols, library preparation, and experimental design of RNA sequencing experiments, mainly for the purpose of outlining considerations in the downstream bioinformatic analysis. This workshop is based on the materials developed by members of the teaching team at the [Harvard Chan Bioinformatics Core (HBC)](http://bioinformatics.sph.harvard.edu/), a collection of modified tutorials from the [DESeq2](https://www.bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html), R language vignettes and the [nf-core rnaseq pipeline](https://nf-co.re/rnaseq).

<br>

<!-- AUTHORS -->
<!-- Format: [author name](link to author page){ .md-button } -->
<h4>Authors</h4>

[José Alejandro Romero Herrera](https://www.linkedin.com/in/jose-alejandro-romero-herrera/){ .md-button }
[Adrija Kalvisa](https://www.linkedin.com/in/adrija-kalvisa/){ .md-button }
[Diana Andrejeva](https://www.linkedin.com/in/diana-andrejeva-766058155/){ .md-button }
[Henrike Zschach](https://www.linkedin.com/in/henrikezschach/){ .md-button }
[Jennifer Bartell](https://www.linkedin.com/in/jagbartell/){ .md-button }
[Samuele Soraggi](https://www.linkedin.com/in/samuelesoraggi/){ .md-button }

<hr>

<!-- OVERVIEW OF COURSE -->
!!! abstract "Overview"
    &#128172; **Syllabus:**   

    1.  Course introduction  
    2.  Experimental planning   
    3.  Data explanation    
    4.  Read reprocessing and preprocessing pipelines   
    5.  Analysing RNAseq data   
        1.  RNAseq counts   
        2.  Exploratory analysis    
        3.  Differential Expression Analysis    
        4.  Functional analysis 
    6.  Summarized workflow  

    &#128368; **Total Time Estimation:** 8 hours  

    &#128193; **Supporting Materials:**  
    Workshop slides with theory on bulk RNAseq can be found in this [zenodo repository](https://zenodo.org/record/7565963).


    &#128203; **License:** [Tutorial Content is licensed under Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/)
   
!!! warning "Course Requirements"
    - Knowledge of R, Rstudio and Rmarkdown. It is recommended that you have at least followed our workshop [R basics](https://github.com/Center-for-Health-Data-Science/FromExceltoR_2022)
    - Basic knowledge of RNAseq technology
    - Basic knowledge of data science and statistics such as PCA, clustering and statistical testing

This workshop material includes a tutorial on how to approach RNAseq data, starting from your sequencing reads (fastq files). Thus, the workshop only briefly touches upon laboratory protocols, library preparation, and experimental design of RNA sequencing experiments, mainly for the purpose of outlining considerations in the downstream bioinformatic analysis. This workshop is based on the materials developed by members of the teaching team at the [Harvard Chan Bioinformatics Core (HBC)](http://bioinformatics.sph.harvard.edu/), a collection of modified tutorials from the [DESeq2](https://www.bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html), R language vignettes and the [nf-core rnaseq pipeline](https://nf-co.re/rnaseq).

The aim of this repository is to run a comprehensive but introductory workshop on bulk-RNAseq bioinformatic analyses. Each of the modules of this workshop is accompanied by a powerpoint slideshow explaining the steps and the theory behind a typical bioinformatics analysis (ideally with a teacher). Many of the slides are annotated with extra information and/or point to original sources for extra reading material.

!!! info "Goals"
    By the end of this workshop, you should be able to analyse your own bulk RNAseq data:

    -   Preprocess your reads into a count matrix.
    -   Normalize your data.
    -   Explore your samples with PCAs and heatmaps.
    -   Perform Differential Expression Analysis.
    -   Annotate your results.

### Acknowledgements

- [Center for Health Data Science](https://heads.ku.dk/), University of Copenhagen.
- [Hugo Tavares](https://bioinfotraining.bio.cam.ac.uk/about), Bioinformatics Training Facility, University of Cambridge.
- [Silvia Raineri](https://renew.ku.dk/research/reseach-groups/serup-group/), Center for Stem Cell Medicine (reNew), University of Copenhagen.
- [Harvard Chan Bioinformatics Core (HBC)](http://bioinformatics.sph.harvard.edu/), check out their [github repo](https://github.com/hbctraining/DGE_workshop_salmon_online)
- [nf-core community](https://nf-co.re/)
