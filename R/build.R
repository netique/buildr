#' Run Selected Build Script
#'
#' \code{build()} is the final function in the workflow, as it instructs RStudio
#' Build pane to take the first rule in the \code{Makefile} (set previously with
#' \code{aim()}) and runs the respective recipe.
#'
#' The Rstudio BUild pane is not allways visible and set to take
#' \code{Makefiles}. However, the \code{build()} ensures that everything is set
#' properly and if not, it offers to edit essential settings automatically for
#' you. Note that this action requires RStudio user interface (UI) to reload and
#' you have to call \code{build()} again afterwards.
#'
#' @family functions from \code{buildr} trinity
#' @keywords file utilities misc
#'
#' @return No return value. Called for side effects.
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
  check_makefile()

  target <- read_lines("Makefile")[1] %>% str_extract(".*(?=:)")

  ui_done("Building {ui_value({target})} in RStudio's {ui_field('Build')} pane...")

  if (check_build_pane() == "success") {
    invisible(executeCommand("buildAll"))
  }
}
