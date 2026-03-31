#' Check if you've made a typo in your list of species names
#'
#' @param species A list of character, the species names
#' @param to_return TRUE in case you want the function to return the array of recommendation
#' @param suppress_warning Logical, if `TRUE` the function will not pop up it's warning message
#' @return If everything is correct, you'll get a message which means you can go ahead to next step.
#' In case of having something wrong, a warning pops up. In the warning there will be highlighted
#' all the names which was miss typed, and there will be 3 recommendation for each and every one
#' of the names
#' @examples
#' # It looks like this, when there are no mistakes
#' species_list <- c( "Sternbergia colchiciflora Waldst. et Kit.","Scorzonera humilis L.",
#' "Ceratophyllum demersum L.","Lathyrus sylvestris L.","Sedum sexangulare L.")
#' check_typo(species_list)
#'
#' # Now let's take the same species_list as above, but let's introduce some mistakes. I am gonna
#' #change the first and last names.
#' species_list <- c( "Stenrbegria colchiciflra Waldst. et Kit.","Scorzonera humilis L.",
#' "Ceratophyllum demersum L.","Lathyrus sylvestris L.","Sedum sektangulare")
#' check_typo(species_list)
#' @export
check_typo = function(species, to_return = FALSE, suppress_warning = FALSE){
  # If there is no mistake in the names, it just confirms that everything is all right.
  if (all(species %in% padapt$species)){
    message('All good! Ready for the next step!')
  }
  # On the other hand...
  else {
    #First, we collect the indeces of the misswritten names
    misstyped = which(!species %in% padapt$species)
    # We search the ID-s of the correct names.
    correct_idx = get_suggestions(species[misstyped])
    #Replacing the ID-s with it's corresponding names.
    suggestions = sapply(correct_idx, function(x){padapt$species[x]})
    #Some formatting to make the warning message more readable.
    formatted <- sapply(seq_along(misstyped), function(i) {
      paste0(species[misstyped][i], " → ",
             paste(suggestions[, i], collapse = ", ")
      )
    })

    if(!suppress_warning)
    warning(paste("\nYou've made a typo! Here are some suggestions you may wanted!\n",
                  paste(formatted, collapse = "\n")
    ))
    if(to_return == TRUE){
    return(suggestions)
    }
  }
}

#' Spell checks the traits
#'
#' @param traits A list of character, the trait names
#' @param verbose If TRUE you'll get any message when run. It is set to FALSE when is called by
#' another function
#'
#' @returns `TRUE` or `FALSE`
check_typo_trait = function(traits, verbose = TRUE){
  if (all(traits %in% categorized_traits$traits)){
    if (verbose == TRUE){
    message('All good! Ready for the next step!')
    }
    return(TRUE)
  }
  else {
    misstyped = which(!traits %in% categorized_traits$traits)

    warning(paste("\nYou've made a typo!\nIt appears to be:",
                  paste(traits[misstyped], collapse = ', ')))
    return(FALSE)
  }
}
