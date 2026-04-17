
<!-- README.md is generated from README.Rmd. Please edit that file -->

# padaptR

<!-- badges: start -->

<!-- badges: end -->

padaptR is a tool which makes it easier to work with data downloaded
from PADAPT (Pannonian Database Of Plant Traits). They also have a
website: <https://padapt.eu/en>

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
`convert()` Convert standard scientific names into the ones found in
PADAPT, also searches for synonyms from GBIF

## Bug reports:

If you ever came across a bug, either:

- open an issue on github  
- contact me on this e-mail address: <sutacdominik@gmail.com>

## Installation

You can install the development version of padaptR from
[GitHub](https://github.com/dominiksutac/padaptR) with:

``` r
# install.packages("devtools")
devtools::install_github("dominiksutac/padaptR")
```

``` r
library(padaptR)
#> padaptR 1.0.0.0 loaded
```

## Examples

In the following I am gonna demonstrate how all of these works currently

``` r
set.seed(42)
rand_species(2)
#> [1] "Vaccinium myrtillus L."         "Silene otites (L.) Wibel s. l."
rand_traits(2)
#> [1] "disp_strat" "LFM1"
```

``` r
#We know there are a few Stipa species but let's inspect them
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
species = c("Achillea collina ","Adonis vernalis","Agropyoron intermedium","Agrostis stolonifera","Agrostis tenuis","Koeleria gracilis" )

# We can specify the output, by default we'll only get the names we managed to match, and the ones
# we did not found a match for
convert(species) 
#> Warning in convert(species): In 1 cases neither the name of the species nor
#>   a synonym was found which would match with the PADAPT database. I recommend
#>   manual lookup, you can access the problematic names by "$errors"
#> $correct
#> [1] "Achillea collina Becker ex Rchb." "Adonis vernalis L."              
#> [3] "Agrostis capillaris L."           "Agrostis stolonifera agg."       
#> [5] "Elymus hispidus (Opiz) Melderis" 
#> 
#> $errors
#> [1] "Koeleria gracilis"

# We also have an option to inspect what our input has been matched to

convert(species, table = T)
#> Warning in convert(species, table = T): In 1 cases neither the name of the species nor
#>   a synonym was found which would match with the PADAPT database. I recommend
#>   manual lookup, you can access the problematic names by "$errors"
#> $df
#>                   input                          correct
#> 1      Achillea collina Achillea collina Becker ex Rchb.
#> 2       Adonis vernalis               Adonis vernalis L.
#> 3 Agropyron intermedium  Elymus hispidus (Opiz) Melderis
#> 4  Agrostis stolonifera        Agrostis stolonifera agg.
#> 5       Agrostis tenuis           Agrostis capillaris L.
#> 
#> $correct
#> [1] "Achillea collina Becker ex Rchb." "Adonis vernalis L."              
#> [3] "Elymus hispidus (Opiz) Melderis"  "Agrostis stolonifera agg."       
#> [5] "Agrostis capillaris L."          
#> 
#> $errors
#> [1] "Koeleria gracilis"
```

``` r
padapt_query(list_of_species = 'Stipa pennata L.', 
             preset = 'leaf_traits', means = T, just_means = F)
#>            species LA1    LA2      LA3 LA4 LDMC1   LDMC2   LDMC3 LDMC4 SLA1
#> 1 Stipa pennata L.  NA 177.62 1241.364  NA    NA 531.322 486.518    NA   NA
#>    SLA2   SLA3 SLA4  LFM1 LFM2  LDM1 LDM2      LA   LDM   LDMC   LFM    SLA
#> 1 5.984 10.765   NA 0.056   NA 30.56   NA 709.492 30.56 508.92 0.056 8.3745
padapt_query(list_of_species = c('Stipa pennata L.', 'Stipa capillata L.'), 
             preset = 'leaf_traits', means = T, just_means = T)
#>              species       LA   LDM     LDMC   LFM     SLA
#> 1 Stipa capillata L. 742.7137 49.80 566.5315 0.085 18.2515
#> 2   Stipa pennata L. 709.4920 30.56 508.9200 0.056  8.3745
```
