#' Convert a standard scientific name to the ones found in PADAPT
#'
#' @param list Your list of species
#'
#' @description
#' A standard scientific name is usually made up from two words. In PADAPT, the species column also
#' contains the name of researcher who first described it. So this function, `convert()` takes
#' your list of standard names, applies the `safe_search()` function to find the your species
#' which are also within PADAPT. It also saves all the wrong ones, and by running `get_synonyms()`
#' it tries to find a synonym from GBIF which might be found in PADAPT also.
#' @returns A list. By calling `$correct`, you can inspect all the correct names, and by calling
#' `$errors` you will see all the names which is neither in our database, nor a synonym for one.
#' @export
convert = function(list){
  result = safe_search(list)
  correct = result$correct; errors = result$errors

  syn_table = get_synonyms(errors)

  check_if_correct = safe_search(syn_table$syn)

  correct = unique(c(correct, check_if_correct$correct))
  errors = c(syn_table$errors, check_if_correct$errors)

  if(length(correct) != length(c(correct, check_if_correct$correct))){
    message('There were duplicates in your list, these have been removed')
  }
  if (length(errors) > 0){
  warning(paste('In',length(errors),'cases neither the name of the species nor
  a synonym was found which would match with the PADAPT database. I recommend
  manual lookup,you can access the problematic names by "$errors"'))}

  return(list(correct = correct, errors = errors))
}


#' A search method built upon tryCatch
#'
#' @param x A list of names
#'
#' @returns A list of 2 parts. The first part collects all the proper names, already found in the
#' database, while the second part collects all those missing.
safe_search = function(x){
  # In the results we have a list of lists. For each name we're gonna gave a value
  # for whether search_species was successful or not, and a name which is either the correct
  # name or the name of the species not found
  results = lapply(x, function(x){
    tryCatch(
    {
      res = search_species(x)[1]
      list(success = TRUE, name = res)
    },
    error = function(e){
      list(success = FALSE, name = x)
      }
  )
  })

  correct = unlist(lapply(results, function(x){
    if (x$success == TRUE) return(x$name)
  }))

  errors = unlist(lapply(results, function(x){
    if (x$success == FALSE) return(x$name)
  }))

  return(list(correct = correct, errors = errors))
}

#' Get synonyms from GBIF
#'
#' @param x The list of species you're trying to get a synonym for
#'
#' @returns A list which contains the proper synonyms, which are in PADAPT, and the names of the
#' species that are still missing
get_synonyms = function(x){
  errors = c()
  syn_found = c()

  for (i in x){
    search = suppressWarnings(rgbif::name_backbone(i)$species)

    if (is.null(search)){
      errors = c(errors, i)
    } else {
      syn_found = c(syn_found, search)
    }
  }
  return(list(syn = syn_found, errors = errors))
}
