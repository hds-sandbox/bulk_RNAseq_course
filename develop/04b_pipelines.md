---
title: nf-core pipelines
summary: In this lesson we explain a community curated pipeline for bulk RNAseq preprocessing
date: 2023-01-17
---

# Automating your workflow: nf-core pipelines


!!! note "Section Overview"

    &#128368; **Time Estimation:** X minutes  

    &#128172; **Learning Objectives:**    

    1. Understand what is a pipeline.
    2. Learn about existing automated workflows from the bioinformatics community.
    3. Learn how to use the nf-core pipeline for bulk RNAseq analysis.


The [nf-core project](https://nf-co.re/) is a community effort to collect a curated set of analysis pipelines built using [Nextflow] (<https://www.nextflow.io/>), an incredibly powerful and flexible workflow language. This means that all the tools and steps used in your RNAseq workflow can be automated and easily reproduced by other researchers if necessary. In addition, if you use any of the nf-core pipelines, you will be sure that all the necessary tools are available to you in any computer platform (Cloud computing, HPC or your personal computer).

<p align="center">

<img src="./img/04b_pipelines/nf-core_RNAseq.png" width="600"/>

</p>

The [RNAseq pipeline](https://nf-co.re/rnaseq) enables using many different tools, such as STAR, RSEM, HISAT2 or Salmon, and allows quantification of gene/isoform counts and provides extensive quality control checks at each step of the workflow. We encourage your to take a look at the pipeline and its documentation if you need to preprocess your RNAseq reads from stratch.
