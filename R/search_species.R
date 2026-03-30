#' Tool for searching species names
#'
#' @param name The name of the species or a subset of character which are in the name
#'
#' @returns An array of names which contains the search characters of word.
#'
#' @examples
#' search_species('Stipa')
#'
#' # In case you are not sure about the whole name you can input even characters
#' search_species('albu')
#'
#' @export
search_species = function(name){
  if (!is.character(name)){stop('Names must be characters')}
  idx = which(!is.na(stringr::str_extract(padapt$species, pattern = name)))

  if (length(idx) == 0){stop('There is no data found!')}
  return(padapt$species[idx])
}
