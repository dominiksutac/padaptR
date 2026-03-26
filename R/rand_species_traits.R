#' Get random number of species from the table
#'
#' @param n The number of species you want to get
#' @return A character vector
#' @examples
#' rand_species(10)
#' @export
rand_species = function(n){
  return(sample(data$species, n, replace = F))
}

#' Get random number of traits from the table
#'
#' @param n The number of traits you want to get
#' @return A character vector
#' @examples
#' rand_species(10)
#' @export
rand_traits = function(n){
  return(sample(colnames(data)[-1], n, replace = F))
}
