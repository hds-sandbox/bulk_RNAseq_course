---
title: Exploratory analysis of bulk RNAseq
summary: In this lesson we explain how to explore the relationships between samples using PCA and heatmaps
knit: (function(inputFile, encoding) { 
      rmarkdown::render(inputFile,
                        encoding=encoding,
                        output_format='all',
                        output_dir='./develop/')})
output:
  github_document: 
     preserve_yaml: TRUE
     html_preview: FALSE
     pandoc_args: [
      "--wrap", "none" # this is needed to not break admonitions
    ]
---

Exploratory analysis of bulk RNAseq
================

# Exploratory Analysis and Quality Control

**Last updated:** *{{ git_revision_date_localized }}*

!!! note "Section Overview"

    &#128368; **Time Estimation:** 80 minutes  

    &#128172; **Learning Objectives:**    

    1. Recognize the importance of methods for count data transformation
    2. Describe the PCA (principal component analysis) technique
    3. Interpret different examples of PCA plots
    4. Evaluate sample quality using PCA and hierarchical clustering

The next step in the DESeq2 workflow is QC, which includes sample-level and gene-level steps to perform QC checks on the count data to help us ensure that the samples/replicates look good.

<img src="./img/06_exploratory_analysis/exploratory_analysis_workflow.png" width="1440" style="display: block; margin: auto;" />

## Sample-level QC

A useful initial step in an RNA-seq analysis is often to assess overall similarity between samples:

- Which samples are similar to each other, which are different?
- Does this fit to the expectation from the experiment's design?
- What are the major sources of variation in the dataset?

To explore the similarity of our samples, we will be performing sample-level QC using Principal Component Analysis (PCA) and hierarchical clustering methods. These methods/tools allow us to check **how similar the replicates are to each other** (clustering) and **to make sure that the experimental condition is the major source of variation** in the data. Sample-level QC can also help identify any samples behaving like outliers; we can further explore any potential outliers to determine whether they need to be removed prior to DE analysis.

<img src="./img/06_exploratory_analysis/sample_qc.png" width="1362" style="display: block; margin: auto;" />

These unsupervised clustering methods are run using **log2 transformed normalized counts**. The log2 transformation **improves the sample distances for clustering visualization**, i.e., it reduces the impact of large outlier counts. Instead of using a classical log2 transform, we will be using the **regularized log transform** (rlog). This type of transformation helps to avoid any bias from the abundance of low-count genes.

<img src="./img/06_exploratory_analysis/rlog_transformation_new.png" width="2699" style="display: block; margin: auto;" />

*Image adapted from "[Beginner's guide to using the DESeq2 package](https://bioc.ism.ac.jp/packages/2.14/bioc/vignettes/DESeq2/inst/doc/beginner.pdf)" by Love, Anders and Huber, 2014*

!!! note

    Many common statistical methods for exploratory analysis of multidimensional data, especially methods for clustering and ordination (e. g., principal-component analysis and the like), work best for (at least approximately) homoskedastic data; this means that the variance of an observable quantity (i.e., here, the expression strength of a gene) does not depend on the mean. In RNA-Seq data, however, variance grows with the mean. For example, if one performs PCA directly on a matrix of normalized read counts, the result typically depends only on the few most strongly expressed genes because they show the largest absolute differences between samples. A simple and often used strategy to avoid this is to take the logarithm of the normalized count values plus a small pseudocount; however, now the genes with low counts tend to dominate the results because, due to the strong Poisson noise inherent to small count values, they show the strongest relative differences between samples.

    *As a solution, DESeq2 offers the regularized-logarithm transformation, or rlog for short. For genes with high counts, the rlog transformation differs not much from an ordinary log2 transformation. For genes with lower counts, however, the values are shrunken towards the genes' averages across all samples. Using an empirical Bayesian prior in the form of a ridge penality, this is done such that the rlog-transformed data are approximately homoskedastic."* - From the "Beginner's guide to using the DESeq2 package" by Love, Anders and Huber, 2014 (the [DESeq2 vignette](http://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html) is the updated version of this doc).

!!! note

    The [DESeq2 vignette](http://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html) suggests large datasets (100s of samples) to use the variance-stabilizing transformation (vst) instead of rlog for transformation of the counts, since the rlog function might take too long to run and the `vst()` function is faster with similar properties to rlog.

## Principal Component Analysis (PCA)

Principal Component Analysis (PCA) is a technique used to represent and visualize the variation in a dataset of high dimensionality. **The number of dimensions, d**, in a dataset may be thought of **as the number of variables** it has, e.g., for an RNA-seq dataset with 20.000 different transcripts, d is 20.000. Principally, this means we would need a dimensional space of size **d** to fully represent that dataset. However, as we are only able to view and comprehend things in 1,2 or 3 dimensions, we would like to project this dataset into a lower dimensional space, a process called **dimensionality reduction**. This makes PCA is a very important technique used in the QC and analysis of both bulk and single-cell RNAseq data, specially because many their dimensions (transcripts) do not contain any information.

To better understand how it works, **please go through [this YouTube video from StatQuest](https://youtu.be/FgakZw6K1QQ) that explains PCA)**. After you have gone through the video, please proceed with the interpretation section below.

### Interpreting PCA plots

**Essentially, if two samples have similar levels of expression for the genes that contribute significantly to the variation represented by a given PC (Principal Component), they will be plotted close together on the axis that represents that PC.** Therefore, we would expect that biological replicates to have similar scores (because our expectation is that the same genes are changing) and cluster together. This is easiest to understand by visualizing some example PCA plots.

We have an example dataset and a few associated PCA plots below to get a feel for how to interpret them. The metadata for the experiment is displayed below. The main condition of interest is `treatment`.

<img src="./img/06_exploratory_analysis/example_metadata.png" width="802" style="display: block; margin: auto;" />

When visualizing on PC1 and PC2, we don't see the samples separate by `treatment`, so we decide to explore other sources of variation present in the data. We hope that we have included all possible known sources of variation in our metadata table, and we can use these factors to color the PCA plot.

<img src="./img/06_exploratory_analysis/example_PCA_treatmentPC1.png" width="547" style="display: block; margin: auto;" />

We start with the factor `cage`, but the `cage` factor does not seem to explain the variation on PC1 or PC2.

<img src="./img/06_exploratory_analysis/example_PCA_cage.png" width="547" style="display: block; margin: auto;" />

Then, we color by the `sex` factor, which appears to separate samples on PC2. This is good information to take note of, as we can use it downstream to account for the variation due to sex in the model and regress it out.

<img src="./img/06_exploratory_analysis/example_PCA_sex.png" width="547" style="display: block; margin: auto;" />

Next we explore the `strain` factor and find that it explains the variation on PC1.

<img src="./img/06_exploratory_analysis/example_PCA_strain.png" width="547" style="display: block; margin: auto;" />

It's great that we have been able to identify the sources of variation for both PC1 and PC2. By accounting for it in our model, we should be able to detect more genes differentially expressed due to `treatment`.

Something worrisome about this plot is that we see two samples that do not cluster with the correct strain. This would indicate a likely **sample swap** and should be investigated to determine whether these samples are indeed the labeled strains. If we found there was a switch, we could swap the samples in the metadata. However, if we think they are labeled correctly or are unsure, we could just remove the samples from the dataset.

Still we haven't found if `treatment` is a major source of variation after `strain` and `sex`. So, we explore PC3 and PC4 to see if `treatment` is driving the variation represented by either of these PCs.

<img src="./img/06_exploratory_analysis/example_PCA_treatmentPC3.png" width="547" style="display: block; margin: auto;" />

We find that the samples separate by `treatment` on PC3, and are optimistic about our DE analysis since our condition of interest, `treatment`, is separating on PC3 and we can regress out the variation driving PC1 and PC2.

Depending on how much variation is explained by the first few principal components, you **may want to explore more (i.e consider more components and plot pairwise combinations)**. Even if your samples do not separate clearly by the experimental variable, you may still get biologically relevant results from the DE analysis. If you are expecting very small effect sizes, then it's possible the signal is drowned out by extraneous sources of variation. In situations **where you can identify those sources, it is important to account for these in your model**, as it provides more power to the tool for detecting DE genes.

## Hierarchical Clustering Heatmap

Hierarchical clustering is another method for identifying correlation patterns in a dataset and potential sample outliers. A heatmap displays **the correlation of gene expression for all pairwise combinations of samples** in the dataset. The hierarchical tree along the axes indicates which samples are more similar to each other, i.e. cluster together. The color blocks at the top indicate substructure in the data, and you would expect to see your replicates cluster together as a block for each sample group. Our expectation would be that the samples cluster together similar to the groupings we've observed in the PCA plot.

<img src="./img/06_exploratory_analysis/heatmap_example.png" width="707" style="display: block; margin: auto;" />

!!! note

    In the example above, we see a clustering of wild-type (Wt) and knock-down (KD) cell line samples and we **would be quite concerned** that the 'Wt_3' and 'KD_3' samples are not clustering with the other replicates. Furthermore, since the majority of genes are not differentially expressed, we observe that the samples generally have high correlations with each other (values higher than 0.80). In this case, samples with correlations below 0.80 may indicate an outlier in your data and/or sample contamination. N.B It is important to stress that these is no universal cut-off for what is a good/bad correlation/distance score, it depends on the particular dataset.

## Mov10 quality assessment and exploratory analysis using DESeq2

Now that we have a good understanding of the QC steps normally employed for RNA-seq, let's implement them for the Mov10 dataset we are going to be working with.

### Transform normalized counts for the MOV10 dataset

**To improve the distances/clustering for the PCA and hierarchical clustering visualization methods**, we need to moderate the variance across the mean by applying the rlog transformation to the normalized counts.

!!! warning "Note on transformed normalized counts"

    The rlog transformation of the normalized counts is only necessary for these visualization methods during this quality assessment. **We will not be using these transformed counts for determining differential expression**.

``` r
### Transform counts for data visualization
rld <- rlog(dds, blind=TRUE)
```

The `blind=TRUE` argument is to make sure that the `rlog()` function does not take our sample groups into account - i.e. does the transformation in an unbiased manner. When performing quality assessment, it is important to include this option. The [DESeq2 vignette](http://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html#blind-dispersion-estimation) has more details about this.

The `rlog()` function returns a `DESeqTransform` object, another type of DESeq-specific object. The reason you don't just get a matrix of transformed values is because all of the parameters (i.e. size factors) that went into computing the rlog transform are stored in that object. We use this object to plot the PCA and hierarchical clustering figures for quality assessment.

!!! note "Performance of rlog vs vst"

    The `rlog()` function can be a bit slow when you have e.g. > 20 samples. In these situations the `vst()` function is much faster and performs a similar transformation appropriate for use with `plotPCA()`. It's typically just a few seconds with `vst()` due to optimizations and the nature of the transformation.


    ```r
    ### Transform counts for data visualization
    vsd <- vst(dds, blind = TRUE)
    ```

### Principal component analysis (PCA) for the MOV10 dataset

We are now ready for the QC steps, let's start with PCA!

DESeq2 has a built-in function for generating PCA plots using `ggplot2` under the hood. This is great because it saves us having to type out lines of code and having to fiddle with the different ggplot2 layers. In addition, it takes the `rlog` object as an input directly, hence saving us the trouble of extracting the relevant information from it.

The function `plotPCA()` requires two arguments as input: a `DESeqTransform` object and the "intgroup" (interesting group), i.e. the name of the column in our metadata that has information about the experimental sample groups.

``` r
### Plot PCA 
plotPCA(rld, intgroup="condition")
```

<img src="./img/06_exploratory_analysis/pca_500.png" width="413" style="display: block; margin: auto;" />

!!! question "**Exercise 1**"

    By default `plotPCA()` uses the *top 500 most variable genes*. You can change this by adding the `ntop=` argument and specifying how many of the genes you want the function to consider. For example, try 1000 genes. Did the plot change a lot?

??? question "**Solution to Exercise 1**"

    Using the 1000 most variable genes, the plot does not change a lot:


    ```r
    plotPCA(rld, intgroup="condition", ntop = 1000)
    ```

    What about 2000 genes? It seems that the PCs have a bit different % variance explained:


    ```r
    plotPCA(rld, intgroup="condition", ntop = 2000)
    ```

    What about all genes? Not much change either!


    ```r
    plotPCA(rld, intgroup="condition", ntop = nrow(rld)) #nrow is number of rows and it equals to all genes!
    ```

    As you can see, most of the info comes from the top most variable genes. Since PCs are capturing the variation of our data, adding genes that are hardly variable makes any difference to the plot.

!!! question "**Exercise 2**"

    1. What does the above plot tell you about the similarity of samples?
    2. Does it fit the expectation from the experimental design?
    3. What do you think the %variance information (in the axes titles) tell you about the data in the context of the PCA?

??? question "**Solutions to Exercise 2**"

    1. It shows that our replicates are very close to each other, and each group far from each other!
    2. Yes, which is great!
    3. It tells us how much is captured by each PC. In our case, PC1 already captures the differences between our conditions!

#### Custom PCA plot

The `plotPCA()` function will only return the values for PC1 and PC2. If you would like to explore the additional PCs in your data or if you would like to identify genes that contribute most to the PCs, you can use the `prcomp()` function. For example, to plot any of the PCs we could run the following code:

``` r
# Input is a matrix of log transformed values
rld_mat <- assay(rld) # extract rlog count matrix
pca <- prcomp(t(rld_mat)) # perform PCA on the transposed (t) matrix of data 
```

To see what the PCA object contains we can use again the `attributes()` function.

``` r
attributes(pca)
```

You can check the `?prcomp()` for more information. The most important variables are: - sdev: standard deviation explained by each PC. - rotation: contribution of each gene to each PC. - x: PC values for each sample (we use this values for our plots).

We can create a new object that contains all our metadata information and the PC values.

``` r
df <- cbind(meta, pca$x) # Create data frame with metadata and PC3 and PC4 values for input to ggplot
```

``` r
# ggplot with info for all PCAs
ggplot(df) + geom_point(aes(x=PC3, y=PC4, color = condition))
```

If you want to add PC variation information to the plot we can fetch it using the `summary()` function and take the second row:

``` r
summary(pca)
pca_var <- summary(pca)$importance[2,] # second row is stored in the object "importance"
pca_var <- round(pca_var * 100, digits = 2) # make it percentage and round to 2 digits
```

Finally, we can add it to our plot

``` r
ggplot(df) + geom_point(aes(x=PC3, y=PC4, color = condition)) + 
  xlab(paste0("PC3: ",pca_var["PC3"], "% variance")) + 
  ylab(paste0("PC4: ",pca_var["PC4"], "% variance")) 
```

### Hierarchical Clustering for the MOV10 dataset

There is no built-in function in DESeq2 for plotting the heatmap for displaying the pairwise correlation or distances between all the samples and the hierarchical clustering information; we will use the `pheatmap()` function from the `pheatmap` package. This function cannot use the `DESeqTransform` object as input, but requires a matrix or dataframe. So, the first thing to do is retrieve that information from the `rld` object using a function called `assay()`.

``` r
# Extract the rlog matrix from the object
rld_mat <- assay(rld)    
```

Next, we need to compute the distances values for all the samples. We can do this using the `dist` function:

``` r
sampleDists <- dist(t(rld_mat)) # Distances are computed by rows, so we need to transpose (t) the matrix
sampleDistMatrix <- as.matrix(sampleDists)
```

Let's take a look at the column and row names of the correlation matrix.

``` r
# Check the output of sampleDistMatrix, make note of the row names and column names
head(sampleDistMatrix)

head(meta)
```

You will notice that they match the names we have given our samples in the metadata data frame we started with. It is important that these match, so we can use the `annotation` argument below to plot a color block across the top. This block enables easy visualization of the hierarchical clustering.

Now, let's plot the heatmap!

``` r
# Load pheatmap package
library(pheatmap)

pheatmap(sampleDistMatrix, annotation_col = meta %>% column_to_rownames("sample") %>% 
           select(condition)) # we only want to use the condition column as an annotation
```

When you plot using `pheatmap()` the hierarchical clustering information is used to place similar samples together and this information is represented by the tree structure along the axes. The `annotation` argument accepts a dataframe as input, in our case it is the `meta` data frame.

<img src="./img/06_exploratory_analysis/pheatmap_salmon.png" width="832" style="display: block; margin: auto;" />

Overall, we observe pretty high correlations across the board (\> 0.999) suggesting no outlying sample(s). Also, similar to the PCA plot you see the samples clustering together by sample group. Together, these plots suggest to us that the data are of good quality and we have the green light to proceed to differential expression analysis.

!!! question "**Exercise 3**"

    Instead of using distances between expression patterns, check the Pearson correlation between samples using `cor()`. Use your rlog count matrix as an input.

??? question "**Solution to Exercise 3**"

    First, we get pearson correlations between our samples:


    ```r
    pearson <- cor(rld_mat) 
    pearson
    ```

    As you can see, the result of cor for a matrix like `rld_mat` is a square matrix (rows are the same as columns). Each value is the Pearson correlation between a row and a column.

    Then, we create the plot:


    ```r
    pheatmap(pearson, annotation_col = meta %>% column_to_rownames("sample") %>% 
               dplyr::select(condition)) # we only want to use the condition column as an annotation
    ```

#### Custom heatmap

There are many arguments and options for the `pheatmap()` function. You could, for example, change the color scale used, remove the dendograms, avoid clustering or even scale the values per row or per column.

``` r
library(RColorBrewer)
heat.colors <- brewer.pal(6, "Blues") # Colors from the RColorBrewer package (only 6)
heat.colors <- colorRampPalette(heat.colors)(100) # Interpolate 100 colors
```

``` r
pheatmap(sampleDistMatrix, annotation = meta %>% column_to_rownames("sample") %>% select("condition"), 
         color = heat.colors, border_color=NA, fontsize = 10, 
         fontsize_row = 10, height=20)
```

You can check all the colors that RColorBrewer offers by using the following command: `display.brewer.all()`

``` r
display.brewer.all()
```

``` r
knitr::include_graphics("./img/06_exploratory_analysis/rcolor_brewer_all.png")
```

------------------------------------------------------------------------

*This lesson was originally developed by members of the teaching team (Mary Piper, Meeta Mistry, Radhika Khetani) at the [Harvard Chan Bioinformatics Core (HBC)](http://bioinformatics.sph.harvard.edu/).*