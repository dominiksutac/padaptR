#' Tool for searching species names
#'
#' @param name A species name of a character string contained within the species name.
#'
#' @returns A character vector of species names containing the search string.
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
  idx = which(!is.na(stringr::str_extract(padapt$species,
                                          pattern = stringr::fixed(name))))

  if (length(idx) == 0){stop('There is no data found!')}
  return(padapt$species[idx])
}
