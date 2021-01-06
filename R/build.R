#' Run Selected Build Script
#'
#' `build()` is the final function in the workflow, as it instructs 'RStudio'
#' Build pane to take the first rule in the `Makefile` (set previously with
#' `aim()`) and runs the respective recipe.
#'
#' The 'Rstudio' Build pane is not allways visible and set to take `Makefiles`.
#' However, the `build()` ensures that everything is set properly and if not, it
#' offers you to automatically edit necessary settings automatically for you.
#' Note that this action forces 'RStudio' user interface (UI) to reload and you
#' have to call `build()` again afterwards.
#'
#' @family functions from buildr trinity
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
