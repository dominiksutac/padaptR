#' Convert a standard scientific name to PADAPT compatible names
#'
#' @param list A character vector of species names.
#' @param table A boolean operator which defines what the function returns, `FALSE` by default.
#' @description
#' Scientific names are typically made up from two parts. In PADAPT however, the species column also
#' contains the name of researcher who first described it. The `convert()` function takes
#' a vector of species names and tries to match them to the corresponding names used in PADAPT.
#'
#' First, it applies the [safe_search()] to identify names that already match entries in PADAPT. For
#' names that are not found it attempts to retrieve accepted synonyms for GBIF using [get_synonyms_backbone()]
#' and [get_synonyms_lookup()]. These candidates then are checked again against PADAPT to find valid
#' mathces.
#' @returns A named list with the following elements:
#' \describe{
#'   \item{correct}{A character vector of species names successfully matched to
#'   PADAPT, including author citations.}
#'   \item{errors}{A character vector of input names for which neither the original
#'   name nor any GBIF-derived synonym could be matched to the PADAPT database.}
#'   \item{df}{A dataframe in which you may inspect what your inputs have been converted into. The
#'   function only returns df if you specify `table = TRUE`}
#' }
#'
#' @seealso [safe_search()], [get_synonyms_backbone()], [get_synonyms_lookup()]
#' @export
convert = function(list, table = FALSE){
  list = stringr::str_trim(list)
  result = safe_search(list)

  # Separate the correct and incorrect names in the original input
  correct_original = result$df$correct
  errors_original = result$errors

  # Get synonyms for errors in the original input
  syn_table = get_synonyms_backbone(errors_original)
  backbone_result = safe_search(syn_table$syn)

  # Separate the identified, correct synonyms and the still missing ones
  correct_backbone = backbone_result$df$correct
  # Very important, that we combine the errors from the safe_search with the errors from getting
  # the synonyms. One are the names that we found but doesn't match with PADAPT, the other are the
  # names we didn't found a synonym for
  error_backbone = c(backbone_result$errors, syn_table$errors)

  # Try to find synonyms with name_lookup
  syn_table_lookup = get_synonyms_lookup(error_backbone)
  lookup_result = safe_search(syn_table_lookup$syn)

  correct_lookup = lookup_result$df$correct

  correct_final = c(correct_original, correct_backbone, correct_lookup)
  correct_unique = unique(correct_final)

  # Here we combine the errors from the lookup, meaning names we did not find a synonym for, and the
  # names for which we haven't found a synonym that would match with PADAPT
  error_final = c(syn_table_lookup$errors,syn_table_lookup$wrong_input)

  # if(length(correct_unique) != length(correct_final)){
  #   idx = which(table(correct_final) >= 2)
  #   warning(paste0('There were duplicates in your list, these have been removed. These are: ',
  #                  paste(sort(correct_unique)[idx], collapse = ', ')))
  # }

  if (length(error_final) > 0){
  warning(paste('In',length(error_final),'cases neither the name of the species nor
  a synonym was found which would match with the PADAPT database. I recommend
  manual lookup, you can access the problematic names by "$errors"'))}

  if(table){
    # Combine all the dataframes into one which will be returned, discard the duplicated values
    res_df = rbind(result$df, backbone_result$df, syn_table_lookup$df) %>%
      dplyr::distinct(correct, .keep_all = TRUE) %>%
      dplyr::arrange(input)

    return(list(df = res_df,
                correct = res_df$correct,
                errors = sort(error_final)))
  }

  else{
  return(list(correct = sort(correct_unique), errors = sort(error_final)))
  }
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
      list(success = TRUE, name = res, input = x)
    },
    error = function(e){
      list(success = FALSE, name = x, input = x)
      }
  )
  })

  correct = unlist(lapply(results, function(x){
    if (x$success == TRUE) return(x$name)
  }))

  errors = unlist(lapply(results, function(x){
    if (x$success == FALSE) return(x$name)
  }))

  input = unlist(lapply(results, function(x){
    if(x$success == TRUE) return(x$input)
  }))

  df = data.frame(input = input, correct = correct)

  return(list(df = df , errors = errors))
}

#' Get synonyms from GBIF with name_backbone()
#'
#' This function is based on [rgbif::name_backbone()]
#'
#' @param x The list of species you're trying to get a synonym for
#' @returns A list which contains the proper synonyms, which are in PADAPT, and the names of the
#' species that are still missing
get_synonyms_backbone = function(x){
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


#' Searching for synonyms with name_lookup()
#'
#'This function is based on [rgbif::name_lookup()]
#'
#' @param x Names of species you are trying to get synonyms for
#' @returns A list of four elements, these are:
#' \describe{
#'   \item{syn}{All synonyms that are also present in the PADAPT database.}
#'   \item{errors}{Input names for which no results were returned from GBIF.}
#'   \item{correct_input}{Input names for which at least one plausible synonym was found in PADAPT.}
#'   \item{wrong_input}{Input names for which synonyms were found, but none were present in PADAPT.}
#' }
get_synonyms_lookup = function(x){
  syn_found = c()
  errors = c()
  correct_input = c()
  wrong_input = c()
  df = data.frame(input = character(), correct = character())

  for (i in x){
    # Get the synonyms from GBIF
    rgbif_search = suppressWarnings(rgbif::name_lookup(i , limit = 10, status = 'SYNONYM')$data)

    # If there are no synonyms, mark the species as an error
    if (is.null(rgbif_search) || nrow(rgbif_search) == 0){
      errors = c(errors, i)
      next
    }

    # Collect all the unique synonyms, filter the NA-s
    candidates <- suppressWarnings(unique(rgbif_search$accepted))
    candidates <- candidates[!is.na(candidates)]

    if (length(candidates) == 0){
      errors = c(errors, i)
    } else {
      # If there are synonymns, append them to the array
      syn_found = c(syn_found, candidates)

      # If in PADAPT, save the name of the species, which we searched a synonym for
      if (length(safe_search(candidates)$df$correct) > 0){
        pr = data.frame(input = i, correct = safe_search(candidates)$df$correct)
        df = rbind(df, pr)

        correct_input = c(correct_input, i)
      } else {wrong_input = c(wrong_input,i)}
    }
  }
  return(list(syn = syn_found, errors = errors,
              correct_input = correct_input, wrong_input = wrong_input, df = df))
}

