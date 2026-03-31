#' Covert a standard scientific name to the ones found in PADAPT
#'
#' @param list Your list of species
#'
#' @description
#' A standard scientific name is usually made up from two words. In PADAPT, a species column also
#' contains the name of researcher who first described it. So this function, `convert()` takes
#' your list of standard names, applies the `check_typo()` function and returns a list of correct
#' names which you can use instantly for the query.
#' @returns Characters, a list of the species names
#' @export
convert = function(list){
  correct_list = check_typo(list, to_return = TRUE, suppress_warning = TRUE)

  result = correct_list[1,]

  return(as.character(result))
}
