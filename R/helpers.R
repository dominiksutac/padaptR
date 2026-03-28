#' Gives suggestions based on the misstyped species names
#'
#' @param names An array with the misstyped names
#'
#' @returns A data frame, built from the ID-s of the recommended species.
#' With there ID-s we can extract the name of the correct species names.
#' @description
#' It uses the `stringdist::stringsim()` function for computing similarity scores. By ordering
#' these scores we select three options with the highest scores for each of the species
get_suggestions = function(names){
  res_vec = sapply(names, function(x) {order(stringdist::stringsim(x,padapt$species),
                                             decreasing = T)[1:3]})

  sugg_mat = matrix(as.numeric(res_vec), ncol = length(names), nrow = 3)
  return(as.data.frame(sugg_mat))
}


#' Get means of traits which are collected from multiple sources
#'
#' @param df Data already selected from the database, look up `padapt_query()` to understand more
#' @param traits The list of traits requested by the used in `padapt_query()`
#'
#' @description
#' In this dataset all those traits which are collected from multiple sources are marked with
#' a number, such as SLA1, SLA2, SLA3.... . This makes it easy to distinguish all the traits
#' for which we need to calculate the mean value. This is achieved by `grep()`, and to collapse
#' the names `gsub()` is the chosen tool. The mean itself is calculated by `rowMeans()`.
#'
#' @returns A data frame which contains only the means of the specific traits
get_means = function(df, traits){
  trait_eligible <- grep("\\d+$", traits, value = TRUE)
  trait_mean_name = gsub("\\d+$", "", trait_eligible)

  result= sapply(split(trait_eligible, trait_mean_name), function(x){
    rowMeans(df[,x, drop = FALSE], na.rm = TRUE)
  })

  return(as.data.frame(result))
}
