#' Queries the database
#'
#' @param list_of_species A list which contains the names of the species
#' @param list_of_traits A list which contains the names of the traits
#'
#' @returns The subset of the database you are interested in.
#'
#' @examples
#'
#' #First, we deifne a list of species, and a list of traits
#' species = c("Acorus calamus L.", "Ambrosia artemisiifolia L." )
#' traits = c("sla1","sla2","sla3","sla4")
#' padapt_query(species, traits)
#' @export
#' @import dplyr

padapt_query = function(list_of_species, list_of_traits){
  toexport = padapt %>%
    select(species, all_of(list_of_traits)) %>%
    filter(species %in% list_of_species)

  return(toexport)
}
