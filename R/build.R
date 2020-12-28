#' Run Selected Build Script
#'
#' @description Sbalbalbaab.
#'
#' @family functions from \code{buildr} trinity
#' @keywords file utilities misc
#'
#' @return Character string echoing the terminal.
#'
#' @author Jan Netik
#'
#' @importFrom rstudioapi executeCommand
#' @importFrom stringr str_extract
#' @importFrom readr read_lines
#' @importFrom magrittr %>%
#' @importFrom readr read_file read_lines
#' @importFrom usethis ui_done ui_field ui_code ui_value ui_stop
#'
#' @examples
#' \dontrun{
#' build()
#' }
#' @export
build <- function() {
  if (!file.exists("Makefile") || !nzchar(read_file("Makefile"))) {
    ui_stop(c(
      "{ui_value('{buildr}')} seems uninitialized.",
      "Please, call {ui_code('init()')} first."
    ))
  }

  target <- read_lines("Makefile")[1] %>% str_extract(".*(?=:)")

  ui_done("Building {ui_value({target})} in RStudio's {ui_field('Build')} pane...")

  invisible(executeCommand("buildAll"))
}
