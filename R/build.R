#' Build
#'
#' @description Sbalbalbaab.
#'
#' @family functions from \code{buildr} trinity
#' @keywords file utilities misc
#'
#' @return Character string echoing the terminal.
#'
#' @author Jan Netik \cr
#'
#' Department of Psychology, \cr Faculty of Arts, \cr
#' Charles University, \cr Czech Republic \cr
#'
#' \email{netikja@@gmail.com} \cr
#'
#' @importFrom rstudioapi executeCommand
#' @importFrom stringr str_extract
#' @importFrom readr read_file read_lines
#' @importFrom usethis ui_done ui_field ui_code ui_value ui_stop
#'
#' @examples
#' \dontrun{
#' build()
#' }
#' @export
build <- function() {
  if (!file.exists("Makefile") || !nzchar(readr::read_file("Makefile"))) {
    usethis::ui_stop("{usethis::ui_value('{buildr}')} seems uninitialized.\nPlease, call {usethis::ui_code('init()')} first.")
  }

  target <- readr::read_lines("Makefile")[1] %>% str_extract(".*(?=:)")

  usethis::ui_done("Building {usethis::ui_value({target})} in RStudio's {usethis::ui_field('Build')} pane...")
  invisible(rstudioapi::executeCommand("buildAll"))
}

