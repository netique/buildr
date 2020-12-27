#' Initialize
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
#' @importFrom stringr str_extract str_trim
#' @importFrom tibble tibble
#' @importFrom usethis ui_done ui_field ui_code ui_value
#'
#' @examples
#' \dontrun{
#' init()
#' }
#' @export
init <- function(prefix = "build", path = ".", sep = "_", command_args = "") {
  pattern <- paste0("^(", prefix, sep, ").*\\.R$")

  build_scripts <- list.files(path, pattern)

  if (length(build_scripts) == 0) {
    return(usethis::ui_oops("{usethis::ui_field('{buildr}')} has not discovered any build scripts.\nTry to call {usethis::ui_code('buildr::init()')} again with different {usethis::ui_field('prefix')} argument."))
  }

  build_scripts_trimmed <- stringr::str_extract(
    build_scripts,
    paste0("(?<=", prefix, sep, ").*(?=\\.R$)")
  ) %>% stringr::str_trim()

  r_script_skeleton <- "@Rscript -e 'source(\"{target}\")'"

  rules <- tibble(
    rule = build_scripts_trimmed,
    code = glue::glue(r_script_skeleton,
      target = build_scripts
    ),
    command_args = ifelse(nzchar(command_args), paste0(" ", command_args), command_args)
  )

  rules %>%
    glue::glue_data("{rule}:\n\t{code}{command_args}", .trim = FALSE) %>%
    readr::write_lines("Makefile")

  usethis::ui_done("{usethis::ui_field('{buildr}')} has discovered following build script(s):\n{usethis::ui_value({build_scripts_trimmed})}. Proceed with {usethis::ui_code('buildr::aim()')}.")
}
