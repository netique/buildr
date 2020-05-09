#' Runs \code{build.R} script
#'
#' @aliases buildr
#'
#' @description Sources the \code{build.R} (case \strong{insensitive}) present in current working directory. Print \code{buildr()} in the console or click on 'Buildr' in addins menu in 'RStudio'.
#'
#' @usage buildr()
#'
#' @return No return value.
#'
#' @author
#' Jan Netik \cr
#'
#' Department of Psychology, \cr
#' Faculty of Arts, \cr
#' Charles University, \cr
#' Czech Republic \cr
#'
#' \email{netikja@@gmail.com} \cr
#'
#' @examples
#' \dontrun{buildr()}
#' @export
buildr <- function() {
  files <- list.files()
  build_name <- files[grep("build.r", files, TRUE)]

  if (length(build_name) != 0) {
    source("build.R")
  } else {
    warning("ERROR: There is no file called 'build.R' anywhere in working directory!")
  }
}
