#' Set Makefile Target
#'
#' \code{aim} looks for an existing \code{Makefile}, reads its content, and
#' offers a list of discovered \code{Makefile} "targets" or "rules" (build
#' scripts, in our case) in an interactive way.
#'
#' @family functions from \code{buildr} trinity
#' @keywords file utilities misc
#'
#' @return No return value. Called for side effects.
#'
#' @author Jan Netik
#'
#' @importFrom rstudioapi executeCommand
#' @importFrom stringr str_trim str_subset str_remove
#' @importFrom magrittr %>%
#' @importFrom readr read_lines write_lines
#' @importFrom usethis ui_done ui_field ui_code ui_value ui_stop ui_oops
#'
#' @examples
#' \dontrun{
#' aim()
#' }
#' @export
aim <- function(target = NULL) {
  if (!interactive() & is.null(target)) {
    ui_stop(c(
      "{ui_field('aim()')} cannot run in noninteractive session and argument {ui_value('target')} is not specified.",
      "Please call {ui_code('aim(target = \"your_target_script\")')}, or use interactive session."
    ))
  }

  if (!file.exists("Makefile")) {
    ui_stop(c(
      "{ui_field('{buildr}')} seems uninitialized.",
      "Please, call {ui_code('init()')} first."
    ))
  }


  lines <- readr::read_lines("Makefile", skip_empty_rows = TRUE)
  n_lines <- length(lines)

  names_from_mkfl <- lines %>%
    str_subset(":$") %>%
    str_remove(":$") %>%
    str_trim()

  if (length(names_from_mkfl) == 0) {
    return(ui_oops(c(
      "{ui_field('{buildr}')} has not discovered any build scripts in {ui_path('Makefile')}.",
      "Try to call {ui_code('init()')} again with different {ui_field('prefix')} argument."
    )))
  }

  if (length(names_from_mkfl) == 1) {
    return(ui_oops("{ui_field('{buildr}')} has discovered only one build script {ui_field({names_from_mkfl})}.\nTry to call {ui_code('init()')} again with different {ui_value('prefix')} argument,\nor call {ui_code('build()')} to build {ui_value({names_from_mkfl})}."))
  }

  if (n_lines %% 2) {
    ui_oops("It seems that your {ui_path('Makefile')} contains odd number of lines,\nwhich should not be possible. Please check.")
    return(edit_makefile())
  }

  rules_split <- split(lines, f = names_from_mkfl %>% rep(each = 2))

  if (is.null(target)) {
    switch_to <- utils::menu(names_from_mkfl,
      title = ui_todo("Select the build script that will be used from now on.")
    )

    switch_to <- names_from_mkfl[switch_to]

    if (switch_to == 0) {
      return(
        ui_oops("You have not chosen any of the scripts.\nThere will be no changes.")
      )
    }
  } else {
    switch_to_trimmed <- target %>% str_remove("\\.[r|R]")
    if (switch_to_trimmed %in% names_from_mkfl) {
      switch_to <- switch_to_trimmed
    } else {
      ui_stop(c("{ui_value({switch_to_trimmed})} is not a valid target in {ui_path('Makefile')}.", "Pick from {ui_value({names_from_mkfl})}."))
    }
  }


  new_order <- c(switch_to, setdiff(names_from_mkfl, switch_to))

  rules_split[new_order] %>%
    unlist() %>%
    readr::write_lines("Makefile")

  ui_done("Set! Use {ui_code('build()')} to build {ui_value({switch_to})}.")
}
