#' Initialize
#'
#' @description Sbalbalbaab.
#'
#'
#' @family functions from \code{buildr} trinity
#' @keywords file utilities misc
#'
#' @return Character string echoing the terminal.
#'
#' @author Jan Netik
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
  pattern <- paste0("^", prefix, sep, ".*\\.R$")

  build_scripts <- list.files(path, pattern, ignore.case = TRUE)

  if (length(build_scripts) == 0) {
    return(usethis::ui_oops("{usethis::ui_field('{buildr}')} has not discovered any build scripts. Have you created them yet?\nIf so, try to call {usethis::ui_code('init()')} again with different {usethis::ui_field('prefix')} argument."))
  }

  build_scripts_trimmed <- stringr::str_extract(
    build_scripts,
    paste0("(?<=", prefix, sep, ").*(?=\\.[R|r]$)")
  ) %>% stringr::str_trim()

  if (any(is.na(build_scripts_trimmed)) | any(!nzchar(build_scripts_trimmed))) {
    usethis::ui_info(c("At least one {usethis::ui_path('Makefile')} target has unusable name.", "Names were automatically repaired, check them carefully."))
  build_scripts_trimmed[is.na(build_scripts_trimmed) | !nzchar(build_scripts_trimmed)] <- "unnamed"
  }

  if (any(duplicated(build_scripts_trimmed))) {
    usethis::ui_info(c("There are duplicates among {usethis::ui_path('Makefile')} targets.", "Names were automatically repaired, check them carefully."))
  build_scripts_trimmed <- make.unique(build_scripts_trimmed, sep = "_")
  }

  rules <- tibble(
    rule = build_scripts_trimmed,
    code = glue::glue("@Rscript -e 'source(\"{target}\")'",
      target = build_scripts
    ),
    command_args = ifelse(nzchar(command_args), paste0(" ", command_args), command_args)
  )

  rules %>%
    glue::glue_data("{rule}:\n\t{code}{command_args}", .trim = FALSE) %>%
    readr::write_lines("Makefile")

  usethis::ui_done("{usethis::ui_field('{buildr}')} has discovered following build script(s):\n{usethis::ui_value({build_scripts_trimmed})}. Proceed with {usethis::ui_code('aim()')}.")
}
