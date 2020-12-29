#' Discover Build Scripts & Create Makefile
#'
#' \code{init()} looks for \code{.R} scripts in a project root (current working
#' directory) that contain a specified prefix and separator. Then, it creates a
#' \code{Makefile} with rules describing how to run discovered scripts.
#'
#' The build script names should all follow a common pattern that is both human
#' and machine readable. Filename should incorporate a prefix ("build" by
#' default) and the "body" describing what the given script builds. Those two
#' essential parts are separated by underscore ("\code{_}") by default as it
#' helps with the readibility. Both parts are configurable (see below), but we
#' encourage you not to make any changes. Do not forget that build scripts are
#' matched for a prefix and separator concatenated together, so the script named
#' "build.R" won't be recognized, as it doesn't begin with "build_".
#'
#' @param prefix \emph{character}. Prefix that solicited build scripts have in
#'   common. It is trimmed and stripped in the list of Makefile targets because
#'   of redundancy. Default to "\code{build}".
#' @param sep \emph{character}. Separator between \code{prefix} and "body" of a
#'   build script filename. It is also stripped in the list of Makefile targets
#'   because of redundancy. Default to underscore ("\code{_}").
#' @param path \emph{character}. Path being searched. Default to the project
#'   root (current working directory). If \code{recursive} is TRUE (default),
#'   all subdirectories are searched as well. See \code{\link{list.files}} for
#'   more details on the topic.
#' @param ignore_case \emph{logical}. Should the search be case-sensitive?
#' @param command_args \emph{single character}. Command argument(s) to include
#'   after the recipe call. Not used by default (empty string, see the Usage
#'   section above).
#'
#' @family functions from \code{buildr} trinity
#' @keywords file utilities misc
#'
#' @return No return value. Called for side effects.
#'
#' @author Jan Netik
#'
#' @importFrom rstudioapi executeCommand
#' @importFrom readr write_lines
#' @importFrom stringr str_extract str_trim
#' @importFrom tibble tibble
#' @importFrom magrittr %>%
#' @importFrom glue glue glue_data
#' @importFrom usethis ui_done ui_field ui_code ui_value ui_stop ui_path
#'
#' @examples
#' \dontrun{
#' init()
#' }
#' @export
init <- function(prefix = "build", sep = "_", path = ".", ignore_case = TRUE, command_args = "") {
  pattern <- paste0("^", prefix, sep, ".*\\.R$")

  files <- list.files(path, pattern, ignore.case = ignore_case)

  if (length(files) == 0) {
    ui_stop(c(
      "{ui_field('{buildr}')} has not discovered any build scripts. Have you created them yet?",
      "If so, try to call {ui_code('init()')} again with different {ui_field('prefix')} and/or {ui_field('sep')} arguments."
    ))
  }

  rules <- tibble(
    rule = file_to_target(files, prefix, sep),
    recipe = glue("@Rscript -e 'source(\"{recipe_core}\")'",
      recipe_core = files
    ),
    command_args = ifelse(nzchar(command_args),
      paste0(" ", command_args),
      command_args
    )
  )

  rules %>%
    glue_data("{rule}:\n\t{recipe}{command_args}", .trim = FALSE) %>%
    write_lines("Makefile")

  ui_done(c(
    "{ui_field('{buildr}')} has discovered following build script(s):",
    "{ui_value({rules$rule})}. Proceed with {ui_code('aim()')}."
  ))
}



#' Create Makefile target from list of files
#'
#' @noRd
#'
#' @keywords internal
#'
#' @importFrom stringr str_extract str_trim
#' @importFrom magrittr %>%
#' @importFrom usethis ui_path ui_info
#'
file_to_target <- function(file, prefix, sep, noname = "noname") {
  pattern <- paste0("(?<=", prefix, sep, ").*(?=\\.[R|r]$)")

  target_core <- str_extract(file, pattern) %>% str_trim()

  if (any(is.na(target_core)) | any(!nzchar(target_core))) {
    ui_info(c(
      "At least one {ui_path('Makefile')} target has unusable name.",
      "Names were automatically repaired, check them carefully."
    ))

    target_core[is.na(target_core) | !nzchar(target_core)] <- noname
  }

  if (any(duplicated(target_core))) {
    ui_info(c(
      "There are duplicates among {ui_path('Makefile')} targets.",
      "Names were automatically repaired, check them carefully."
    ))

    target_core <- make.unique(target_core, sep = "_")
  }

  return(target_core)
}
