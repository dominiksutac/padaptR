#' Check if you've made a typo in your list of species names
#'
#' @param species The list of names
#' @return A message if the names are correct and a warning if there is a mistake. Also returns the wrong names.
#' @examples
#' # generate a random list of species first
#' species_list <- c( "Sternbergia colchiciflora Waldst. et Kit.","Scorzonera humilis L.",
#' "Ceratophyllum demersum L.","Lathyrus sylvestris L.","Sedum sexangulare L.")
#' check_typo(species_list)
#' @export
check_typo = function(species){
  if (all(species %in% padapt$species)){
    message('All good! Ready for the next step!')
  }
  else {
    misstyped = which(!species %in% padapt$species)
    warning(paste("\nYou've made a typo!\nIt appears to be:",
                  paste(species[misstyped], collapse = ', ')))
  }
}
