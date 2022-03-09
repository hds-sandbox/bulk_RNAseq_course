# Log Fold Shrinkage and DEA visualizations

Approximate time: 75 minutes

## Learning Objectives 

* Explain log fold change shrinkage
* Setup results data for application of visualization techniques
* Describe different data visualization useful for exploring results from a DGE analysis
* Create a volcano plot and MA plot to evaluate relationship among DGE statistics
* Create a heatmap to illustrate expression changes of differentially expressed genes

## More accurate LFC estimates

In the previous lessons, we learned about how to generate a table with Differentially Expressed genes

``` R
## DO NOT RUN
# res_tableOE <- results(dds, contrast=contrast_oe, alpha = 0.05)

# head(res_tableOE)
```
The problem with these fold change estimates is that they not entirely accurate as they do not account for the large dispersion we observe with low read counts. To address this, the **log2 fold changes need to be adjusted**. 

To generate more accurate log2 foldchange (LFC) estimates, DESeq2 allows for the **shrinkage of the LFC estimates toward zero** when the information for a gene is low, which could include:

- Low counts
- High dispersion values

LFC shrinkage uses **information from all genes** to generate more accurate estimates. Specifically, the distribution of LFC estimates for all genes is used (as a prior) to shrink the LFC estimates of genes with little information or high dispersion toward more likely (lower) LFC estimates. 

<p align="center">
<img src="./img/08d_DEA_visualization/deseq2_shrunken_lfc.png" width="500">
</p>

*Illustration taken from the [DESeq2 paper](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-014-0550-8).*

In the figure above, we have an example using two genes green gene and purple gene. For each gene the expression values are plotted for each sample in the two different mouse strains (C57BL/6J and DBA/2J). Both genes have the same mean values for the two sample groups, but the green gene has little variation within group while the purple gene has high levels of variation. For the green gene with low within group variation, the **unshrunken LFC estimate** (vertex of the green **solid line**) is very similar to the shrunken LFC estimate (vertex of the green dotted line). However, LFC estimates for the purple gene are quite different due to the high dispersion. So even though two genes can have similar normalized count values, they can have differing degrees of LFC shrinkage. Notice the **LFC estimates are shrunken toward the prior (black solid line)**.

**Shrinking the log2 fold changes will not change the total number of genes that are identified as significantly differentially expressed.** The shrinkage of fold change is to help with downstream assessment of results. For example, if you wanted to subset your significant genes based on fold change for further evaluation, you may want to use shruken values. Additionally, for functional analysis tools such as GSEA which require fold change values as input you would want to provide shrunken values.

To generate the shrunken log2 fold change estimates, you have to run an additional step on your results object (that we will create below) with the function `lfcShrink()`.

```r
## Save the unshrunken results to compare
res_tableOE_unshrunken <- res_tableOE

# Apply fold change shrinkage
res_tableOE <- lfcShrink(dds, coef="sampletype_MOV10_overexpression_vs_control", type="apeglm")
```

Depending on the version of DESeq2 you are using the default **method for shrinkage estimation** will differ. The defaults can be changed by adding the argument `type` in the `lfcShrink()` function as we have above. For most recent versions of DESeq2, `type="normal"` is the default and was the only method in earlier versions. It has been shown that in most situations there are alternative methods that have [less bias than the 'normal` method](https://bioconductor.org/packages/devel/bioc/vignettes/apeglm/inst/doc/apeglm.html), and therefore **we chose to use apeglm**. 

> For more information on shrinkage, the DESeq2 vignette has an [Extended section on shrinkage estimators](http://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html#extended-section-on-shrinkage-estimators) that is quite useful.


> #### `contrast` vs `coef`
> When using the alternative methods, rather than using the `contrast` argument you will be required to specify `coef`. Using contrast forms an expanded model matrix, treating all factor levels equally, and averages over all distances between all pairs of factor levels to estimate the prior. Using coef, means looking only at that column of the model matrix (so usually that would be one level against the reference level) and estimates the prior for that coefficient from the distribution of those MLE of coefficients. When using coef, the shrinkage depends on which level is chosen as reference.

> #### How do I know what to value to provide to the `coef` argument?
> The value you provide here needs to match identically to what is stored in the column header of the coefficients table. To see what values you have to work with you can use `resultsNames(dds)`.

## Visualizing the results

### MA plot

A plot that can be useful to exploring our results is the MA plot. The MA plot shows the **mean of the normalized counts versus the log2 foldchanges for all genes tested**. The genes that are significantly DE are colored to be easily identified. This is also a great way to illustrate the effect of LFC shrinkage. The DESeq2 package offers a simple function to generate an MA plot. 

**Let's start with the unshrunken results:**

```r
# MA plot using unshrunken fold changes
plotMA(res_tableOE_unshrunken, ylim=c(-2,2))
```

**And now the shrunken results:**

```r
# MA plot using shrunken fold changes
plotMA(res_tableOE, ylim=c(-2,2))
```

On the left you have the unshrunken fold change values plotted and you can see the abundance of scatter for the the lowly expressed genes. That is, many of the low expressors exhibit very high fold changes. After shrinkage, we see the fold changes are much smaller estimates.

<p float="left">
  <img src="./img/08d_DEA_visualization/maplot_unshrunken.png" width="400">
  <img src="./img/08d_DEA_visualization/MA_plot.png" width="400">
</p>


In addition to the comparison described above, this plot allows us to evaluate the magnitude of fold changes and how they are distributed relative to mean expression. Generally, we would expect to see significant genes across the full range of expression levels. 


## Advanced visualizations

When we are working with large amounts of data it can be useful to display that information graphically to gain more insight. During this lesson, we will get you started with some basic and more advanced plots commonly used when exploring differential gene expression data, however, many of these plots can be helpful in visualizing other types of data as well.

We will be working with three different data objects we have already created in earlier lessons:

- Metadata for our samples (a dataframe): `meta`
- Normalized expression data for every gene in each of our samples (a matrix): `normalized_counts`
- Tibble versions of the DESeq2 results we generated in the last lesson: `res_tableOE_tb` and `res_tableKD_tb`

First, let's create a metadata tibble from the data frame (don't lose the row names!)

```r
mov10_meta <- meta %>% 
              rownames_to_column(var="samplename") %>% 
              as_tibble()
```

Next, let's bring in a column with gene symbols to the `normalized_counts` object, so we can use them to label our plots. Ensembl IDs are great for many things, but the gene symbols are much more recognizable to us, as biologists. 

```r
# DESeq2 creates a matrix when you use the counts() function
## First convert normalized_counts to a data frame and transfer the row names to a new column called "gene"
normalized_counts <- counts(dds, normalized=T) %>% 
                     data.frame() %>%
                     rownames_to_column(var="gene") 
  
# Next, merge together (ensembl IDs) the normalized counts data frame with a subset of the annotations in the tx2gene data frame (only the columns for ensembl gene IDs and gene symbols)
grch38annot <- tx2gene %>% 
               dplyr::select(ensgene, symbol) %>% 
               dplyr::distinct()

## This will bring in a column of gene symbols
normalized_counts <- merge(normalized_counts, grch38annot, by.x="gene", by.y="ensgene")

# Now create a tibble for the normalized counts
normalized_counts <- normalized_counts %>%
                     as_tibble()
  
normalized_counts 
```

>**NOTE:** A possible alternative to the above:
> 
> ``` R
> normalized_counts <- counts(dds, normalized=T) %>% 
>                      data.frame() %>%
>                      rownames_to_column(var="gene") %>%
>                      as_tibble() %>%
>                      left_join(grch38annot, by=c("gene" = "ensgene"))
> ```

### Plotting significant DE genes

One way to visualize results would be to simply plot the expression data for a handful of genes. We could do that by picking out specific genes of interest or selecting a range of genes.

**Using DESeq2 `plotCounts()` to plot expression of a single gene**

To pick out a specific gene of interest to plot, for example MOV10, we can use the `plotCounts()` from DESeq2. `plotCounts()` requires that the gene specified matches the original input to DESeq2, which in our case was Ensembl IDs.

```r
# Find the Ensembl ID of MOV10
grch38annot[grch38annot$symbol == "MOV10", "ensgene"]

# Plot expression for single gene
plotCounts(dds, gene="ENSG00000155363", intgroup="sampletype") 
```

<p align="center">
<img src="./img/08d_DEA_visualization/topgen_plot.png" width="600">
</p>

> This DESeq2 function only allows for plotting the counts of a single gene at a time, and is not flexible regarding the appearance.

**Using ggplot2 to plot expression of a single gene**

If you wish to change the appearance of this plot, we can save the output of `plotCounts()` to a variable specifying the `returnData=TRUE` argument, then use `ggplot()`:

```r
# Save plotcounts to a data frame object
d <- plotCounts(dds, gene="ENSG00000155363", intgroup="sampletype", returnData=TRUE)

# What is the data output of plotCounts()?
d %>% View()

# Plot the MOV10 normalized counts, using the samplenames (rownames(d) as labels)
ggplot(d, aes(x = sampletype, y = count, color = sampletype)) + 
    geom_point(position=position_jitter(w = 0.1,h = 0)) +
    geom_text_repel(aes(label = rownames(d))) + 
    theme_bw() +
    ggtitle("MOV10") +
    theme(plot.title = element_text(hjust = 0.5))
```

> Note that in the plot below (code above), we are using `geom_text_repel()` from the `ggrepel` package to label our individual points on the plot.

<p float="left">
<img src="./img/08d_DEA_visualization/plotCounts_ggrepel.png" width="700">
</p>

### Heatmap

In addition to plotting subsets, we could also extract the normalized values of *all* the significant genes and plot a heatmap of their expression using `pheatmap()`.

```r
### Extract normalized expression for significant genes from the OE and control samples (2:4 and 7:9)
norm_OEsig <- normalized_counts[,c(1:4,7:9)] %>% 
              filter(gene %in% sigOE$gene)  
```

Now let's draw the heatmap using `pheatmap`:

```r
### Set a color palette
heat_colors <- brewer.pal(6, "YlOrRd")

### Run pheatmap using the metadata data frame for the annotation
pheatmap(norm_OEsig[2:7], 
    color = heat_colors, 
    cluster_rows = T, 
    show_rownames = F,
    annotation = meta, 
    border_color = NA, 
    fontsize = 10, 
    scale = "row", 
    fontsize_row = 10, 
    height = 20)
```
         
<p float="left">
<img src="./img/08d_DEA_visualization/pheatmap_aug2020.png" width="600">   
</p>

> *NOTE:* There are several additional arguments we have included in the function for aesthetics. One important one is `scale="row"`, in which Z-scores are plotted, rather than the actual normalized count value. 
>
> Z-scores are computed on a gene-by-gene basis by subtracting the mean and then dividing by the standard deviation. The Z-scores are computed **after the clustering**, so that it only affects the graphical aesthetics and the color visualization is improved.

### Volcano plot

The above plot would be great to look at the expression levels of a good number of genes, but for more of a global view there are other plots we can draw. A commonly used one is a volcano plot; in which you have the log transformed adjusted p-values plotted on the y-axis and log2 fold change values on the x-axis. 

To generate a volcano plot, we first need to have a column in our results data indicating whether or not the gene is considered differentially expressed based on p-adjusted values and we will include a log2fold change here.

```r
## Obtain logical vector where TRUE values denote padj values < 0.05 and fold change > 1.5 in either direction

res_tableOE_tb <- res_tableOE_tb %>% 
                  mutate(threshold_OE = padj < 0.05 & abs(log2FoldChange) >= 0.58)
```

Now we can start plotting. The `geom_point` object is most applicable, as this is essentially a scatter plot:

```r
## Volcano plot
ggplot(res_tableOE_tb) +
    geom_point(aes(x = log2FoldChange, y = -log10(padj), colour = threshold_OE)) +
    ggtitle("Mov10 overexpression") +
    xlab("log2 fold change") + 
    ylab("-log10 adjusted p-value") +
    #scale_y_continuous(limits = c(0,50)) +
    theme(legend.position = "none",
          plot.title = element_text(size = rel(1.5), hjust = 0.5),
          axis.title = element_text(size = rel(1.25)))  
```

<p float="left">
<img src="./img/08d_DEA_visualization/volcano_plot_1.png" width="500"> 
</p>

This is a great way to get an overall picture of what is going on, but what if we also wanted to know where the top 10 genes (lowest padj) in our DE list are located on this plot? We could label those dots with the gene name on the Volcano plot using `geom_text_repel()`.

First, we need to order the res_tableOE tibble by `padj`, and add an additional column to it, to include on those gene names we want to use to label the plot.
 
```r
## Add all the gene symbols as a column from the grch38 table using bind_cols()
res_tableOE_tb <- bind_cols(res_tableOE_tb, symbol=grch38annot$symbol[match(res_tableOE_tb$gene, grch38annot$ensgene)])

## Create an empty column to indicate which genes to label
res_tableOE_tb <- res_tableOE_tb %>% mutate(genelabels = "")

## Sort by padj values 
res_tableOE_tb <- res_tableOE_tb %>% arrange(padj)

## Populate the genelabels column with contents of the gene symbols column for the first 10 rows, i.e. the top 10 most significantly expressed genes
res_tableOE_tb$genelabels[1:10] <- as.character(res_tableOE_tb$symbol[1:10])

View(res_tableOE_tb)
```

Next, we plot it as before with an additional layer for `geom_text_repel()` wherein we can specify the column of gene labels we just created. 

```r
ggplot(res_tableOE_tb, aes(x = log2FoldChange, y = -log10(padj))) +
    geom_point(aes(colour = threshold_OE)) +
    geom_text_repel(aes(label = genelabels)) +
    ggtitle("Mov10 overexpression") +
    xlab("log2 fold change") + 
    ylab("-log10 adjusted p-value") +
    theme(legend.position = "none",
          plot.title = element_text(size = rel(1.5), hjust = 0.5),
          axis.title = element_text(size = rel(1.25))) 
```

<p float="left">
<img src="./img/08d_DEA_visualization/volcano_plot_2.png" width="500"> 
</p>

***

> ***NOTE:** If using the DESeq2 tool for differential expression analysis, the package 'DEGreport' can use the DESeq2 results output to make the top20 genes and the volcano plots generated above by writing a few lines of simple code. While you can customize the plots above, you may be interested in using the easier code. Below are examples of the code to create these plots:*

> ```r
> DEGreport::degPlot(dds = dds, res = res, n = 20, xs = "type", group = "condition") # dds object is output from DESeq2
> 
> DEGreport::degVolcano(
>     data.frame(res[,c("log2FoldChange","padj")]), # table - 2 columns
>     plot_text = data.frame(res[1:10,c("log2FoldChange","padj","id")])) # table to add names
>     
> # Available in the newer version for R 3.4
> DEGreport::degPlotWide(dds = dds, genes = row.names(res)[1:5], group = "condition")
> ```

***

*This lesson was originally developed by members of the teaching team (Mary Piper, Meeta Mistry, Radhika Khetani) at the [Harvard Chan Bioinformatics Core (HBC)](http://bioinformatics.sph.harvard.edu/).*

*Materials and hands-on activities were adapted from [RNA-seq workflow](http://www.bioconductor.org/help/workflows/rnaseqGene/#de) on the Bioconductor website*
