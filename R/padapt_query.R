#' Search the database
#'
#' @param list_of_species A list which contains the names of the species
#' @param list_of_traits A list which contains the names of the traits
#' @param means Boolean operator. `FALSE` by default, if `TRUE` the mean will be calculated for
#' traits with multiple sources, for example the leaf traits. There is 5 options to choose from:
#' `'all','none','hab_str','repr','kary','dist_cons','ecol_ind','leaf_traits'`. The traits has
#' been categorized by this table: <https://padapt.eu/info.html>
#' @param just_means Boolean operator. `FALSE` by default, if `TRUE` only the mean trait values
#' will be included in the results in case of a trait having multiple sources
#'
#' @returns The subset of the database you are interested in.
#' @description
#'
#' Searches the database by the species you are interested in, extracting all the traits you
#' might need for your analysis.
#'
#' @examples
#'
#' #First, we define a list of species, and a list of traits
#' species = c("Acorus calamus L.", "Ambrosia artemisiifolia L." )
#' traits = c("sla1","sla2","sla3","sla4")
#' padapt_query(species, traits)
#' @export
#' @import dplyr

padapt_query = function(list_of_species, list_of_traits = NULL,
                        preset = 'all', means = FALSE, just_means = FALSE){
  # 2 arrays initialized, for traits
  traits_on_demand = c()
  traits_preset = c()
  presets = c('all', 'none', unique(categorized_traits$category))

  # Stop if neither traits nor a preset are specified
  if (is.null(list_of_traits) && !all(preset %in% presets) || preset == 'none'){
    stop('You must give either a trait or a valid preset!')
  }

  # Stop if specified trait not found, whether it is misstyped or just missing
  if (!is.null(list_of_traits)) {
    if (!check_typo_trait(list_of_traits, verbose = FALSE)) {
      stop('Trait not found!')
    }
    traits_on_demand = list_of_traits
  }

  if ('all' %in% preset){
    traits_preset = categorized_traits$traits
  }
  else if ('none' %in% preset){
    traits_preset = c()
  }

  else if (any(preset %in% categorized_traits$category)){
    traits_preset = categorized_traits %>%
      filter(category %in% preset) %>%
      pull(traits)
  }

  # combine the 2 arrays of traits
  traits = unique(c(traits_preset,traits_on_demand))

  # Apply the filters
  toexport <- padapt %>%
    select(species, all_of(traits)) %>%
    filter(species %in% list_of_species)

  # If the user also requires means of traits, calculate it
  if(means || just_means){
    mean_df = get_means(toexport, traits) %>%
      dplyr::mutate(species = toexport$species, .before = 1)

    # If the user specifies the need for only the means, that's all he gets, otherwise
    # join the two together
    if(just_means){
      toexport = mean_df
      } else {
        toexport = dplyr::left_join(toexport, mean_df, by = 'species')
    }
  }
  return(toexport)
}
