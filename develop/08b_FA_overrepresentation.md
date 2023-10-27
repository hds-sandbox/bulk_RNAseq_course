---
title: Functional Analysis for RNA-seq
summary: In this lesson we explain how to run functional analysis on your results using overrepresentation analysis
---

# Functional analysis

!!! note "Section Overview"

    &#128368; **Time Estimation:** 120 minutes  

    &#128172; **Learning Objectives:**    

    1.  Determine how functions are attributed to genes using Gene Ontology terms
    2.  Describe the theory of how functional enrichment tools yield statistically enriched functions or interactions
    3.  Discuss functional analysis using over-representation analysis, functional class scoring, and pathway topology methods
    4.  Identify popular functional analysis tools for over-representation analysis

The output of RNA-seq differential expression analysis is a list of significant differentially expressed genes (DEGs). To gain greater biological insight on the differentially expressed genes there are various analyses that can be done:

- determine whether there is enrichment of known biological functions, interactions, or pathways
- identify genes’ involvement in novel pathways or networks by grouping genes together based on similar trends
- use global changes in gene expression by visualizing all genes being significantly up- or down-regulated in the context of external interaction data

Generally for any differential expression analysis, it is useful to interpret the resulting gene lists using freely available web- and R-based tools. While tools for functional analysis span a wide variety of techniques, they can loosely be categorized into three main types: over-representation analysis, functional class scoring, and pathway topology. See more [here](https://github.com/hbctraining/In-depth-NGS-Data-Analysis-Course/raw/master/resources/pathway_tools.pdf).

<img src="./img/08b_FA_overrepresentation/pathway_analysis.png" width="500" style="display: block; margin: auto;" />

The goal of functional analysis is to provide biological insight, so it’s necessary to analyze our results in the context of our experimental hypothesis: **FMRP and MOV10 associate and regulate the translation of a subset of RNAs**. Therefore, based on the authors’ hypothesis, we may expect the enrichment of processes/pathways related to **translation, splicing, and the regulation of mRNAs**, which we would need to validate experimentally.

!!! note

    All tools described below are great tools to validate experimental results and to make hypotheses. These tools suggest genes/pathways that may be involved with your condition of interest; however, you should NOT use these tools to make conclusions about the pathways involved in your experimental process. You will need to perform experimental validation of any suggested pathways.

## Over-representation analysis

There are a plethora of functional enrichment tools that perform some type of "over-representation" analysis by querying databases containing information about gene function and interactions.

These databases typically **categorize genes into groups (gene sets)** based on shared function, or involvement in a pathway, or presence in a specific cellular location, or other categorizations, e.g. functional pathways, etc. Essentially, known genes are binned into categories that have been consistently named (controlled vocabulary) based on how the gene has been annotated functionally. These categories are independent of any organism, however each organism has distinct categorizations available.

To determine whether any categories are over-represented, you can determine the probability of having the observed proportion of genes associated with a specific category in your gene list based on the proportion of genes associated with the same category in the background set (gene categorizations for the appropriate organism).

<img src="./img/08b_FA_overrepresentation/gene_sets.png" style="display: block; margin: auto;" />

<img src="./img/08b_FA_overrepresentation/overrepresentation_sets.png" style="display: block; margin: auto;" />

The statistical test that will determine whether something is actually over-represented is the *Hypergeometric test*.

### Hypergeometric testing

Using the example of the first functional category above, hypergeometric distribution is a probability distribution that describes the probability of 25 genes (k) being associated with "Functional category 1", for all genes in our gene list (n=1000), from a population of all of the genes in entire genome (N=23,000) which contains 35 genes (K) associated with "Functional category 1" [[4](https://en.wikipedia.org/wiki/Hypergeometric_distribution)].

<img src="./img/08b_FA_overrepresentation/overrepresentation_tables/Slide2.png" style="display: block; margin: auto;" />

The calculation of probability of k successes follows the formula:

$$\Pr(X = k) = \frac{\binom{K}{k} \binom{N - K}{n-k}}{\binom{N}{n}}$$

<img src="./img/08b_FA_overrepresentation/overrepresentation_tables/Slide1.png" style="display: block; margin: auto;" />

This test will result in an adjusted p-value (after multiple test correction) for each category tested. 

## Gene Ontology project

One of the most widely-used categorizations is the **Gene Ontology (GO)** established by the [Gene Ontology project](http://geneontology.org/page/introduction-go-resource).

!!! quote

    "The Gene Ontology project is a collaborative effort to address the need for consistent descriptions of gene products across databases". 

The [Gene Ontology Consortium](http://geneontology.org/page/go-consortium-contributors-list) maintains the GO terms, and these GO terms are incorporated into gene annotations in many of the popular repositories for animal, plant, and microbial genomes.

Tools that investigate enrichment of biological functions or interactions often use the Gene Ontology (GO) categorizations, i.e. the GO terms to determine whether any have significantly modified representation in a given list of genes. Therefore, to best use and interpret the results from these functional analysis tools, it is helpful to have a good understanding of the GO terms themselves and their organization.

### GO Ontologies

To describe the roles of genes and gene products, GO terms are organized into three independent controlled vocabularies (ontologies) in a species-independent manner:

- **Biological process:** refers to the biological role involving the gene or gene product, and could include "transcription", "signal transduction", and "apoptosis". A biological process generally involves a chemical or physical change of the starting material or input.
- **Molecular function:** represents the biochemical activity of the gene product, such activities could include "ligand", "GTPase", and "transporter".
- **Cellular component:** refers to the location in the cell of the gene product. Cellular components could include "nucleus", "lysosome", and "plasma membrane".

Each GO term has a term name (e.g. **DNA repair**) and a unique term accession number (**<GO:0005125>**), and a single gene product can be associated with many GO terms, since a single gene product "may function in several processes, contain domains that carry out diverse molecular functions, and participate in multiple alternative interactions with other proteins, organelles or locations in the cell". See more [here](https://github.com/hbctraining/In-depth-NGS-Data-Analysis-Course/raw/master/resources/go_terms.pdf).

### GO term hierarchy

Some gene products are well-researched, with vast quantities of data available regarding their biological processes and functions. However, other gene products have very little data available about their roles in the cell.

For example, the protein, "p53", would contain a wealth of information on it’s roles in the cell, whereas another protein might only be known as a "membrane-bound protein" with no other information available.

The GO ontologies were developed to describe and query biological knowledge with differing levels of information available. To do this, GO ontologies are loosely hierarchical, ranging from general, ‘parent’, terms to more specific, ‘child’ terms. The GO ontologies are "loosely" hierarchical since ‘child’ terms can have multiple ‘parent’ terms.

Some genes with less information may only be associated with general ‘parent’ terms or no terms at all, while other genes with a lot of information be associated with many terms.

![Nature Reviews Cancer 7, 23-34 (January 2007)](./img/08b_FA_overrepresentation/go_heirarchy.jpg)

!!! tip

    More tips for working with GO can be found [here](http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1003343)

## clusterProfiler

We will be using [clusterProfiler](http://bioconductor.org/packages/release/bioc/html/clusterProfiler.html) to perform over-representation analysis on GO terms associated with our list of significant genes. The tool takes as input a significant gene list and a background gene list and performs statistical enrichment analysis using hypergeometric testing. The basic arguments allow the user to select the appropriate organism and GO ontology (BP, CC, MF) to test.

### Running clusterProfiler

To run clusterProfiler GO over-representation analysis, we will change our gene names into Ensembl IDs, since the tool works a bit easier with the Ensembl IDs. Then load the following libraries:

``` r
# Load libraries
library(DOSE)
library(pathview)
library(clusterProfiler)
library(org.Hs.eg.db)
```

To perform the over-representation analysis, we need a list of background genes and a list of significant genes. For our background dataset we will use all genes tested for differential expression (all genes in our results table). For our significant gene list we will use genes with p-adjusted values less than 0.05 (we could include a fold change threshold too if we have many DE genes).

``` r
## Create background dataset for hypergeometric testing using all genes tested for significance in the results
allOE_genes <- dplyr::filter(res_ids, !is.na(gene)) %>% 
  pull(gene) %>% 
  as.character()

## Extract significant results
sigOE <- dplyr::filter(res_ids, padj < 0.05 & !is.na(gene))

sigOE_genes <- sigOE %>% 
  pull(gene) %>% 
  as.character()
```

Now we can perform the GO enrichment analysis and save the results:

``` r
## Run GO enrichment analysis 
ego <- enrichGO(gene = sigOE_genes, 
                universe = allOE_genes,
                keyType = "ENSEMBL",
                OrgDb = org.Hs.eg.db, 
                ont = "BP", 
                pAdjustMethod = "BH", 
                qvalueCutoff = 0.05, 
                readable = TRUE)
```

!!! note

    The different organisms with annotation databases available to use with for the `OrgDb` argument can be found [here](./img/08b_FA_overrepresentation/orgdb_annotation_databases.png).

    Also, the `keyType` argument may be coded as `keytype` in different versions of clusterProfiler.

    Finally, the `ont` argument can accept either "BP" (Biological Process), "MF" (Molecular Function), and "CC" (Cellular Component) subontologies, or "ALL" for all three.

``` r
## Output results from GO analysis to a table
cluster_summary <- data.frame(ego)
cluster_summary

write.csv(cluster_summary, "../Results/clusterProfiler_Mov10oe.csv")
```

<img src="./img/08b_FA_overrepresentation/cluster_summary.png" width="600" style="display: block; margin: auto;" />

!!! tip

    Instead of saving just the results summary from the `ego` object, it might also be beneficial to save the object itself. The `save()` function enables you to save it as a `.rda` file, e.g. `save(ego, file="results/ego.rda")`. 
    The complementary function to `save()` is the function `load()`, e.g. 

    `ego <- load(file="results/ego.rda")`.

    This is a useful set of functions to know, since it enables one to preserve analyses at specific stages and reload them when needed. More information about these functions can be found [here](https://www.r-bloggers.com/load-save-and-rda-files/) & [here](http://rpubs.com/euclid/387778).

!!! tip

    You can also perform GO enrichment analysis with only the up or down regulated genes** in addition to performing it for the full list of significant genes. This can be useful to identify GO terms impacted in one direction and not the other. If very few genes are in any of these lists (< 50, roughly) it may not be possible to get any significant GO terms.

!!! question "**Exercise 1**"

    Create two new GO enrichment analyses one with UP and another for DOWN regulated genes for MOV10 overexpression.

??? question "**Solution to Exercise 1**"

    1. Separate results into UP and DOWN regulated:


    ```r
    sigOE_UP <- sigOE %>% filter(log2FoldChange > 0)
    sigOE_DOWN <- sigOE %>% filter(log2FoldChange < 0)
    ```

    2. Run overrepresentation:

    UP regulated genes

    ```r
    ego_UP <- enrichGO(gene = sigOE_UP$gene, 
                    universe = allOE_genes,
                    keyType = "ENSEMBL",
                    OrgDb = org.Hs.eg.db, 
                    ont = "BP", 
                    pAdjustMethod = "BH", 
                    qvalueCutoff = 0.05, 
                    readable = TRUE)
    ```

    DOWN regulated genes


    ```r
    ego_DOWN <- enrichGO(gene = sigOE_DOWN$gene, 
                    universe = allOE_genes,
                    keyType = "ENSEMBL",
                    OrgDb = org.Hs.eg.db, 
                    ont = "BP", 
                    pAdjustMethod = "BH", 
                    qvalueCutoff = 0.05, 
                    readable = TRUE)
    ```

    3. Check results:


    ```r
    head(ego_UP)
    ```


    ```r
    head(ego_DOWN)
    ```

### Visualizing clusterProfiler results

clusterProfiler has a variety of options for viewing the over-represented GO terms. We will explore the dotplot, enrichment plot, and the category netplot.

The **dotplot** shows the number of genes associated with the first 50 terms (size) and the p-adjusted values for these terms (color). This plot displays the top 50 GO terms by gene ratio (# genes related to GO term / total number of sig genes), not p-adjusted value.

``` r
## Dotplot 
dotplot(ego, showCategory=50)
```

<img src="./img/08b_FA_overrepresentation/mov10oe_dotplot.png" width="1200" style="display: block; margin: auto;" />

The next plot is the **enrichment GO plot**, which shows the relationship between the top 50 most significantly enriched GO terms (padj.), by grouping similar terms together. Before creating the plot, we will need to obtain the similarity between terms using the `pairwise_termsim()` function [instructions for emapplot](https://rdrr.io/github/GuangchuangYu/enrichplot/man/emapplot.html). In the enrichment plot, the color represents the p-values relative to the other displayed terms (brighter red is more significant), and the size of the terms represents the number of genes that are significant from our list.

``` r
# Add similarity matrix to the termsim slot of enrichment result
ego <- enrichplot::pairwise_termsim(ego)
```

``` r
# Enrichmap clusters the 50 most significant (by padj) GO terms to visualize relationships between terms
emapplot(ego, showCategory = 50)
```

<img src="./img/08b_FA_overrepresentation/emapplot.png" width="1479" style="display: block; margin: auto;" />

Finally, the **category netplot** shows the relationships between the genes associated with the top five most significant GO terms and the fold changes of the significant genes associated with these terms (color). The size of the GO terms reflects the pvalues of the terms, with the more significant terms being larger. This plot is particularly useful for hypothesis generation in identifying genes that may be important to several of the most affected processes.

!!! warning

    You may need to install the `ggnewscale` package using `install.packages("ggnewscale")` for the `cnetplot()` function to work.

``` r
# To color genes by log2 fold changes, we need to extract the log2 fold changes from our results table creating a named vector
OE_foldchanges <- sigOE$log2FoldChange

names(OE_foldchanges) <- sigOE$gene
```

``` r
# Cnetplot details the genes associated with one or more terms - by default gives the top 5 significant terms (by padj)
cnetplot(ego, 
         categorySize="pvalue", 
         showCategory = 5, 
         foldChange=OE_foldchanges, 
         vertex.label.font=6)
```

!!! tip

    If some of the high fold changes are getting drowned out due to a large range, you could set a maximum fold change value


    ```r
    OE_foldchanges <- ifelse(OE_foldchanges > 2, 2, OE_foldchanges)
    OE_foldchanges <- ifelse(OE_foldchanges < -2, -2, OE_foldchanges)
    ```


    ```r
    cnetplot(ego, 
         categorySize="pvalue", 
         showCategory = 5, 
         foldChange=OE_foldchanges, 
         vertex.label.font=6)
    ```

<img src="./img/08b_FA_overrepresentation/cnetplot1.png" width="1800" style="display: block; margin: auto;" />

!!! tip

    If you are interested in significant processes that are **not** among the top five, you can subset your `ego` dataset to only display these processes:


    ```r
    # Subsetting the ego results without overwriting original `ego` variable
    ego2 <- ego

    ego2@result <- ego@result[c(1,3,4,8,9),]

    # Plotting terms of interest
    cnetplot(ego2, 
         categorySize="pvalue", 
         foldChange=OE_foldchanges, 
         showCategory = 5, 
         vertex.label.font=6)
    ```

    <img src="./img/08b_FA_overrepresentation/cnetplot-2.png" width="1800" style="display: block; margin: auto;" />

!!! question "**Exercise 2**"

    Run a Disease Ontology (DO) overrepresentation analysis using the `enrichDO()` function. **NOTE** the arguments are very similar to the previous examples. 

    - Do you find anything interesting?

??? question "**Solution to Exercise 2**"

    For the DO, we need to use entrez IDs, instead of gene IDs

    All significantly regulated genes.


    ```r
    edo <- enrichDO(sigOE$entrez, qvalueCutoff = 1)
    head(edo)
    ```

    UP significantly regulated genes


    ```r
    edo_UP <- enrichDO(sigOE_UP$entrez)
    head(edo_UP)
    ```

    DOWN significantly regulated genes


    ```r
    edo_DOWN <- enrichDO(sigOE_DOWN$entrez)
    head(edo_DOWN)
    ```

    Based on these results, we see that we cannot find Fragile X syndrome between the significant ones. However, if we dig a bit deeper, we find that many of these diseases overlap with the symptoms of Fragile X syndrome, such as muscular atrophia, physical disorders, intelectual disabilities, etc.

!!! question "**Exercise 3**"

    Run an enrichment analysis on the results of the DEA for knockdown vs control samples. Remember to use the annotated results!

??? question "**Solution to Exercise 3**"

    Let's do a simple analysis as an example:


    ```r
    ## Create background dataset for hypergeometric testing using all genes tested for significance in the results
    allKD_genes <- dplyr::filter(res_ids_KD, !is.na(gene)) %>% 
      pull(gene) %>% 
      as.character()

    ## Extract significant results
    sigKD <- dplyr::filter(res_ids_KD, padj < 0.05 & !is.na(gene))

    sigKD_genes <- sigKD %>% 
      pull(gene) %>% 
      as.character()
    ```

    Now we can perform the GO enrichment analysis and save the results:


    ```r
    ## Run GO enrichment analysis 
    ego <- enrichGO(gene = sigKD_genes, 
                    universe = allKD_genes,
                    keyType = "ENSEMBL",
                    OrgDb = org.Hs.eg.db, 
                    ont = "BP", 
                    pAdjustMethod = "BH", 
                    qvalueCutoff = 0.05, 
                    readable = TRUE)
    ```



    ```r
    ## Output results from GO analysis to a table
    cluster_summary <- data.frame(ego)
    cluster_summary

    write.csv(cluster_summary, "../Results/clusterProfiler_Mov10kd.csv")
    ```

------------------------------------------------------------------------

*This lesson was originally developed by members of the teaching team (Mary Piper, Radhika Khetani) at the [Harvard Chan Bioinformatics Core (HBC)](http://bioinformatics.sph.harvard.edu/).*
