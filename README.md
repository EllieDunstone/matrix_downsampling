# Matrix downsampling


## Introduction

This script is for adjusting a mutation matrix so that samples with unusually high numbers of mutation calls are downsampled, avoiding them from over-contributing to a signature extraction process. This is generally only required when you have a large amount of variation in mutation numbers between your samples - e.g. you have both normal samples and tumour samples; tumour samples including hypermutators; or a range of normal samples including highly-mutated tissues like the epidermis.

This is currently only implemented for an SBS96 matrix, but could easily be adapted for other mutation classes (e.g. ID83, DBS78).

The exact threshold over which samples will be downsampled is somewhat arbitary; a number of ways of deciding this threshold may work equally well, and the best method may depend on the specifics of your dataset.

It should be noted that changing the absolute number of mutation calls will mean that any statistics generated during your signature extraction process (number of mutations per signature, confidence intervals of signature extractions) will be with reference to your new downsampled input matrix, not the original data. For the number of mutations, this can be corrected using the original matrix counts (or burden estimates if using NanoSeq data). For signature extraction confidence intervals this is not as easy, but these intervals are not widely used and if anything the degree of error will be overestimated, which may not be an issue.


## Scripts

The matrix_downsampling_SBS96.Rmd script can be used to perform this analysis interactively on your own data, or as a vignette to demonstrate how the analysis works.

Example input data is provided in trint_subs_matrix_corrected.tsv.

The main functionality of the script is implemented as a function in matrix_downsampling_SBS96_function.R 

## Dependencies

The scripts load the following libraries, which will need to be installed prior to running:

* tidyverse
* patchwork

## Usage

See the matrix_downsampling_SBS96.Rmd script or its .html output for further documentation of usage.


## Acknowledgments

Thanks are given to Adrian Baez-Ortega for advice on implementation of downsampling.
