.onAttach <- function(libname, pkgname) {
  version <- utils::packageVersion(pkgname)
  packageStartupMessage(paste0(pkgname, " ", version, " loaded"))
}
