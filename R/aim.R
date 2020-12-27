#' Aim
#'
#' @description Sbalbalbaab.
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
#' @importFrom stringr str_trim str_subset str_remove
#' @importFrom readr read_lines write_lines
#' @importFrom usethis ui_done ui_field ui_code ui_value ui_stop ui_oops
#'
#' @examples
#' \dontrun{
#' aim()
#' }
#' @export
aim <- function() {
  if (!file.exists("Makefile")) {
    usethis::ui_stop("{usethis::ui_value('{buildr}')} seems uninitialized.\nPlease, call {usethis::ui_code('buildr::init()')} first.")
  }

  lines <- readr::read_lines("Makefile")

  names_from_mkfl <- lines %>%
    stringr::str_subset(":$") %>%
    stringr::str_remove(":$") %>%
    stringr::str_trim()

  if (length(names_from_mkfl) == 0) {
    return(usethis::ui_oops("{usethis::ui_field('{buildr}')} has not discovered any build scripts.\nTry to call {usethis::ui_code('buildr::init()')} again with different {usethis::ui_field('prefix')} argument."))
  }

  if (length(names_from_mkfl) == 1) {
    return(usethis::ui_oops("{usethis::ui_field('{buildr}')} has discovered only one build script {usethis::ui_field({names_from_mkfl})}.\nTry to call {usethis::ui_code('buildr::init()')} again with different {usethis::ui_value('prefix')} argument,\nor call {usethis::ui_code('buildr::build()')} to build {usethis::ui_value({names_from_mkfl})}."))
  }

  rules_split <- split(lines, f = names_from_mkfl %>% rep(each = 2))

  switch_to <- utils::menu(names_from_mkfl, title = usethis::ui_todo("Select the build script that will be used from now on."))

  if (switch_to == 0) {
    return(
      usethis::ui_oops("You have not chosen any of the scripts.\nThere will be no changes.")
    )
  }

  switch_to <- names_from_mkfl[switch_to]

  new_order <- c(switch_to, setdiff(names_from_mkfl, switch_to))

  rules_split[new_order] %>%
    unlist() %>%
    readr::write_lines("Makefile")

  usethis::ui_done("Set! Use {usethis::ui_code('buildr::build()')} to build {usethis::ui_value({switch_to})}.")
}
