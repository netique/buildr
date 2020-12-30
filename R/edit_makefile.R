#' Edit Makefile
#'
#' Opens `Makefile`, if present in the project root.
#'
#' @return No return value. Called for side effect.
#'
#' @seealso The [documentation for GNU
#'   Make](https://www.gnu.org/software/make/manual/html_node/).
#'
#' @importFrom rstudioapi executeCommand navigateToFile hasFun isAvailable
#' @importFrom usethis ui_info ui_oops ui_todo
#'
#' @export
edit_makefile <- function() {
  if (!file.exists("Makefile")) {
    ui_oops("{ui_value('Makefile')} does not exist in project root.")
    return(ui_todo("Call {ui_code('buildr::init()')} to create it."))
  }

  ui_info("{ui_path('Makefile')} opened.")

  if (isAvailable() && hasFun("navigateToFile")) {
    navigateToFile("Makefile")
  }
  else {
    utils::file.edit("Makefile")
  }

  invisible("Makefile")
}
