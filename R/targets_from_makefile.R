
#' Read Targets from Makefile
#'
#' @noRd
#' @keywords internal
#' @importFrom usethis ui_stop ui_path ui_code ui_field ui_oops ui_value
#' @importFrom stringr str_subset str_remove str_trim
#'
targets_from_lines <- function(lines) {
  targets <- lines %>%
    str_subset(":$") %>%
    str_remove(":$") %>%
    str_trim()

  if (length(targets) == 0) {
    ui_stop(c(
      "{ui_field('{buildr}')} has not discovered any build scripts in {ui_path('Makefile')}.",
      "Try to call {ui_code('init()')} again with different {ui_field('prefix')} argument."
    ))
  }

  if (length(targets) == 1) {
    ui_stop(c(
      "{ui_field('{buildr}')} has discovered only one build script {ui_value({targets})}.",
      "You can run it directly with {ui_code('build()')}, there is no need to call {ui_code('aim()')}.",
      "If you think you have more build scripts in your project,",
      "try to call {ui_code('init()')} again with different {ui_value('prefix')} argument."
    ))
  }

  return(targets)
}


#' Check Makefile for problems
#'
#' @noRd
#' @keywords internal
#' @importFrom usethis ui_stop ui_path ui_code ui_field
#'
check_makefile <- function() {
  if (!file.exists("Makefile") || file.info("Makefile")$size == 0) {
    ui_stop(c(
      "{ui_field('{buildr}')} seems uninitialized, {ui_path('Makefile')} does not exist in your project root or is empty.",
      "Please, call {ui_code('init()')} first."
    ))
  }

  tryCatch(
    {
      invisible(read.dcf("Makefile"))
    },
    error = function(e) {
      ui_stop(c(
        "{ui_path('Makefile')} seems corrupted.",
        "Call {ui_code('init()')} again or inspect your {ui_path('Makefile')} with {ui_code('edit_makefile()')}"
      ))
    }
  )
}


