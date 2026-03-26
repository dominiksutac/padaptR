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

padapt_query = function(list_of_species, list_of_traits = NULL, preset = 'All'){

  traits_on_demand = c()
  traits_preset = c()
  presets = c('All', unique(categorized_traits$category))

  if (is.null(list_of_traits) && !all(preset %in% presets)){
    stop('You must give either a trait or a valid preset!')
  }

  if (!is.null(list_of_traits)) {
    if (!check_typo_trait(list_of_traits, verbose = FALSE)) {
      stop('Trait not found!')
    }
    traits_on_demand = list_of_traits
  }

  if ('All' %in% preset){
    traits_preset = categorized_traits$traits
  }
  else if ('None' %in% preset){
    traits_preset = c()
  }

  else if (any(preset %in% categorized_traits$category)){
    traits_preset = categorized_traits %>%
      filter(category %in% preset) %>%
      pull(traits)
  }

  traits = unique(c(traits_preset,traits_on_demand))
  toexport <- padapt %>%
    select(species, all_of(traits)) %>%
    filter(species %in% list_of_species)

  return(toexport)
}
