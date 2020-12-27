#' Set Makefile target
#'
#' \code{aim} looks for an existing \code{Makefile}, reads its content, and
#' offers a list of discovered \code{Makefile} "rules" or "targets" (build
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
    usethis::ui_stop(c("{usethis::ui_field('aim()')} cannot run in noninteractive session and argument {usethis::ui_value('target')} is not specified.", "Please call {usethis::ui_code('aim(target = \"your_target_script\")')}, or use interactive session."))
  }

  if (!file.exists("Makefile")) {
    usethis::ui_stop(c("{usethis::ui_field('{buildr}')} seems uninitialized.", "Please, call {usethis::ui_code('init()')} first."))
  }


  lines <- readr::read_lines("Makefile", skip_empty_rows = TRUE)
  n_lines <- length(lines)

  names_from_mkfl <- lines %>%
    stringr::str_subset(":$") %>%
    stringr::str_remove(":$") %>%
    stringr::str_trim()

  if (length(names_from_mkfl) == 0) {
    return(usethis::ui_oops("{usethis::ui_field('{buildr}')} has not discovered any build scripts in {usethis::ui_path('Makefile')}.\nTry to call {usethis::ui_code('init()')} again with different {usethis::ui_field('prefix')} argument."))
  }

  if (length(names_from_mkfl) == 1) {
    return(usethis::ui_oops("{usethis::ui_field('{buildr}')} has discovered only one build script {usethis::ui_field({names_from_mkfl})}.\nTry to call {usethis::ui_code('init()')} again with different {usethis::ui_value('prefix')} argument,\nor call {usethis::ui_code('build()')} to build {usethis::ui_value({names_from_mkfl})}."))
  }

  if (n_lines %% 2) {
    usethis::ui_oops("It seems that your {usethis::ui_path('Makefile')} contains odd number of lines,\nwhich should not be possible. Please check.")
    return(buildr::edit_makefile())
  }

  rules_split <- split(lines, f = names_from_mkfl %>% rep(each = 2))

  if (is.null(target)) {
    switch_to <- utils::menu(names_from_mkfl,
      title = usethis::ui_todo("Select the build script that will be used from now on.")
    )

    switch_to <- names_from_mkfl[switch_to]

    if (switch_to == 0) {
      return(
        usethis::ui_oops("You have not chosen any of the scripts.\nThere will be no changes.")
      )
    }
  } else {
    switch_to_trimmed <- target %>% str_remove("\\.[r|R]")
    if (switch_to_trimmed %in% names_from_mkfl) {
      switch_to <- switch_to_trimmed
    } else {
      usethis::ui_stop(c("{usethis::ui_value({switch_to_trimmed})} is not a valid target in {usethis::ui_path('Makefile')}.", "Pick from {usethis::ui_value({names_from_mkfl})}."))
    }
  }


  new_order <- c(switch_to, setdiff(names_from_mkfl, switch_to))

  rules_split[new_order] %>%
    unlist() %>%
    readr::write_lines("Makefile")

  usethis::ui_done("Set! Use {usethis::ui_code('build()')} to build {usethis::ui_value({switch_to})}.")
}
