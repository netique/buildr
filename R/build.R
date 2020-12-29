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


#' Build Addin wrapper
#'
#' wrapping inside try defuses RStudio warnings about code execution
#'
#' @noRd
#' @keywords internal
build_addin <- function() {
  try({build()})
}




#' Check if build pane is set-up
#'
#' @keywords internal
#' @noRd
#' @importFrom stringr str_detect
#' @importFrom rstudioapi executeCommand
#' @importFrom readr read_lines write_lines
#' @importFrom usethis ui_oops ui_field ui_path ui_yeah ui_stop
check_build_pane <- function() {
  rproj_file <- list.files(".", pattern = "\\.Rproj$")
  rproj_config <- read_lines(rproj_file)

  if (!"BuildType: Makefile" %in% rproj_config) {
    ui_oops("{ui_field('{buildr}')} discovered that your RStudio Build pane is not set to build from {ui_path('Makefile')}.")
    granted <- ui_yeah(c(
      "Do you want to set everything up and reload RStudio UI?",
      "After the reload, you'll have to call {ui_code('build()')} again.",
      "The action {ui_field('will not')} restart your session."
    ))

    if (granted) {
      rproj_config[str_detect(rproj_config, "BuildType")] <- "BuildType: Makefile"

      write_lines(rproj_config, rproj_file)

      executeCommand("reloadUi")
      return("reloaded")
    } else {
      ui_oops("RStudio Build pane was not set. Build terminated.")
      return("fail")
    }
  }

  return("success")
}
