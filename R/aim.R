#' Set Makefile Target
#'
#' `aim()` looks for an existing `Makefile`, reads its content, and offers a
#' list of discovered `Makefile` targets (denoting build scripts, in our case),
#' all in an interactive way. When the session is not interactive, or you know
#' the name of the desired target, you can declare it directly in the `target`
#' argument.
#'
#'
#' @param target *Character*. The name of the Makefile target to set.
#'
#' @family functions from buildr trinity
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
#' # We have several build scripts in our project root
#' # and we want to select script called "build_all.R":
#'
#' aim(target = "all") # note that "build_" is stripped out by default
#' }
#' @export
aim <- function(target = NULL) {
  if (!interactive() & is.null(target)) {
    ui_stop(c(
      "{ui_field('aim()')} cannot run in noninteractive session and argument {ui_value('target')} is not specified.",
      "Please call {ui_code('aim(target = \"your_target_script\")')}, or use interactive session."
    ))
  }

  check_makefile()

  lines <- read_lines("Makefile", skip_empty_rows = TRUE)


  if (length(lines) %% 2) {
    ui_oops(c(
      "It seems that your {ui_path('Makefile')} contains odd number of lines.",
      "This should not be possible and probably will cause trouble.",
      "Please check the {ui_path('Makefile')} with {ui_code('edit_makefile()')}."
    ))
  }

  targets <- targets_from_lines(lines)


  rules_split <- split(lines, f = targets %>% rep(each = 2))

  if (is.null(target)) {
    switch_to <- utils::menu(targets,
      title = ui_todo("Select the build script that will be used from now on.")
    )

    switch_to <- targets[switch_to]

    if (switch_to == 0) {
      return(
        ui_oops(c(
          "You have not chosen any of the scripts.",
          "There will be no changes."
        ))
      )
    }
  } else {
    switch_to_trimmed <- target %>% str_remove("\\.[r|R]")

    if (switch_to_trimmed %in% targets) {
      switch_to <- switch_to_trimmed
    } else {
      ui_stop(c(
        "{ui_value({switch_to_trimmed})} is not a valid target in {ui_path('Makefile')}.",
        "Pick from {ui_value({targets})}."
      ))
    }
  }


  new_order <- c(switch_to, setdiff(targets, switch_to))

  rules_split[new_order] %>%
    unlist() %>%
    write_lines("Makefile")

  ui_done("Set! Use {ui_code('build()')} to build {ui_value({switch_to})}.")
}
