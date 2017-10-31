# methyIntegratoR
R library for integrated analysis involving methylation arrays and other molecular data.

Download this library using the following in the R console: 
`require(devtools); install_github("metamaden/methyIntegratoR")`

# Overview
There are numerous recurring analysis strategies when working with Illumina methylation arrays. This package seeks to simplify some of these routine tasks which, though relatively straightforward, can consist in many steps. 

## Region Methylation
In order to derive region methylation summaries from arrays, it is necessary to interpret the manifest documents provided by Illumina and distributed through libraries such as minfi. While ideal for certain purposes and constrained to one unique CpG per row, manifests accessed through the minfi R library can be tricky to use even to perform a simple task such as "find the promoter methylation of gene TP53." The difficulties, and the solutions provided in this package, are detailed in the "Example" subsection, below. In short, this package takes as input a RefSeq Accession or Gene Symbol/Name and returns region CpGs that map to the region of interest in the selected array platform.

## Integrated Analysis
To study methylation and gene expression together, it is often necessary to correlate the two data types and apply extensive filters on magnitude of either methylation or expression in the tissue type of interest, in subsets of the tissue type, or in comparable normal tissues. Each step in this process requires multiple objects be stored and handled. For this reason, this package simplifies integrated analysis of methylation and expression by streamlining routine analysis steps such as genome-wide correlation analysis and data visualization such as overlay plotting. The useR is therefore only required to provide the experimental design and ordered methylation and expression data. 

## Example
