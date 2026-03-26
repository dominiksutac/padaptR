#' Get N number of species from the table
#'
#' @param n The number of species you want to get
#' @return A character vector
#' @examples
#' rand_species(10)
#' @export
rand_species = function(n){
  return(sample(padapt$species, n, replace = F))
}

#' Get N number of traits from the table
#'
#' @param n The number of traits you want to get
#' @return A character vector
#' @examples
#' rand_species(10)
#' @export
rand_traits = function(n){
  return(sample(colnames(padapt)[-1], n, replace = F))
}
