#' Discover Build Script(s) & Create Makefile
#'
#'
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
#' @importFrom readr write_lines
#' @importFrom stringr str_extract str_trim
#' @importFrom tibble tibble
#' @importFrom magrittr %>%
#' @importFrom glue glue glue_data
#' @importFrom usethis ui_done ui_field ui_code ui_value ui_oops ui_path
#'
#' @examples
#'
#' \dontrun{
#' init()
#' }
#' @export
init <- function(prefix = "build", path = ".", sep = "_", command_args = "") {
  pattern <- paste0("^", prefix, sep, ".*\\.R$")

  build_scripts <- list.files(path, pattern, ignore.case = TRUE)

  if (length(build_scripts) == 0) {
    return(ui_oops(c(
      "{ui_field('{buildr}')} has not discovered any build scripts. Have you created them yet?",
      "If so, try to call {ui_code('init()')} again with different {ui_field('prefix')} argument."
    )))
  }

  build_scripts_trimmed <- str_extract(
    build_scripts,
    paste0("(?<=", prefix, sep, ").*(?=\\.[R|r]$)")
  ) %>% str_trim()

  if (any(is.na(build_scripts_trimmed)) | any(!nzchar(build_scripts_trimmed))) {
    ui_info(c(
      "At least one {ui_path('Makefile')} target has unusable name.",
      "Names were automatically repaired, check them carefully."
    ))

    build_scripts_trimmed[is.na(build_scripts_trimmed) | !nzchar(build_scripts_trimmed)] <- "unnamed"
  }

  if (any(duplicated(build_scripts_trimmed))) {
    ui_info(c(
      "There are duplicates among {ui_path('Makefile')} targets.",
      "Names were automatically repaired, check them carefully."
    ))
    build_scripts_trimmed <- make.unique(build_scripts_trimmed, sep = "_")
  }

  rules <- tibble(
    rule = build_scripts_trimmed,
    code = glue("@Rscript -e 'source(\"{target}\")'",
      target = build_scripts
    ),
    command_args = ifelse(nzchar(command_args),
      paste0(" ", command_args),
      command_args
    )
  )

  rules %>%
    glue_data("{rule}:\n\t{code}{command_args}", .trim = FALSE) %>%
    write_lines("Makefile")

  ui_done(c(
    "{ui_field('{buildr}')} has discovered following build script(s):",
    "{ui_value({build_scripts_trimmed})}. Proceed with {ui_code('aim()')}."
  ))
}
