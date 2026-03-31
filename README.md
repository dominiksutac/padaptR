
<!-- README.md is generated from README.Rmd. Please edit that file -->

# padaptR

<!-- badges: start -->

<!-- badges: end -->

The reason for writing padaptR is to realize a tool which makes it
easier to work with data downloaded from PADAPT (Pannonian Database Of
Plant Traits). They also have a website: <https://padapt.eu/en>

The original authors of this database are Sonkoly et. al., their
manuscript is available at <https://doi.org/10.1038/s41597-023-02619-9>

## Overview

So far these are the available functions within this package:  
`padapt_query()` Searches the database and applies the filters you
need  
`search_species()` Returns all the species names which contains the
search string  
`check_typo()` Validate the species names, get recommendations in case
of error  
`rand_species() / rand_traits()` Get traits, and species names
randomly  
`convert()` Covert standard scientific names into the ones found in
PADAPT

## Installation

You can install the development version of padaptR from
[GitHub](https://github.com/dominiksutac/padaptR) with:

``` r
# install.packages("devtools")
devtools::install_github("dominiksutac/padaptR")
```

``` r
library(padaptR)
#> padaptR 0.0.0.9000 loaded
```

## Examples

In the following I am gonna demonstrate how all of these works currently

``` r
rand_species(2)
#> [1] "Phleum bertolonii DC."     "Scutellaria columnae All."
rand_traits(2)
#> [1] "TSM3"     "Flow_dur"
```

``` r
#We know there are a few Stipa species but we don't how to spell them exactly
search_species('Stipa')
#> [1] "Stipa borysthenica Klokov ex Prokudin"       
#> [2] "Stipa bromoides (L.) Dörfler"                
#> [3] "Stipa capillata L."                          
#> [4] "Stipa dasyphylla (Czern. ex Lindem.) Trautv."
#> [5] "Stipa eriocaulis Borbás"                     
#> [6] "Stipa pennata L."                            
#> [7] "Stipa pulcherrima K. Koch"                   
#> [8] "Stipa tirsa Steven em. Čelak."
```

``` r

# Let's have Stipa pennata L.
sp = 'Stipa pennata L.'
check_typo(sp)
#> All good! Ready for the next step!

#Now let's introduce a mistake
sp2 = 'Spita pennata L.'
check_typo(sp2)
#> Warning in check_typo(sp2): 
#> You've made a typo! Here are some suggestions you may wanted!
#>  Spita pennata L. → Stipa pennata L., Spiraea crenata L., Staphylea pinnata L.
```

``` r
species = c("Achillea collina ","Adonis vernalis","Agropyoron intermedium","Agrostis stolonifera","Agrostis tenuis")

convert(species)
#> [1] "Achillea nobilis L."              "Adonis vernalis L."              
#> [3] "Agropyron cristatum (L.) Gaertn." "Agrostis stolonifera agg."       
#> [5] "Agrostis canina L."
```

``` r
padapt_query(list_of_species = 'Stipa pennata L.', 
             preset = 'leaf_traits', means = T, just_means = T)
#>            species      LA   LDM   LDMC   LFM    SLA
#> 1 Stipa pennata L. 709.492 30.56 508.92 0.056 8.3745
padapt_query(list_of_species = c('Stipa pennata L.', 'Stipa capillata L.'), 
             preset = 'leaf_traits', means = T, just_means = T)
#>              species       LA   LDM     LDMC   LFM     SLA
#> 1 Stipa capillata L. 742.7137 49.80 566.5315 0.085 18.2515
#> 2   Stipa pennata L. 709.4920 30.56 508.9200 0.056  8.3745
```
