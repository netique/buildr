#' Edit Makefile
#'
#' Opens \code{Makefile}, if present in the project root.
#'
#' @return No return value. Called for side effect.
#'
#' @seealso The [documentation for GNU
#'   Make](https://www.gnu.org/software/make/manual/html_node/).
#'
#' @export
edit_makefile <- function() {
  if (!file.exists("Makefile")) {
    usethis::ui_oops("{usethis::ui_value('Makefile')} does not exist in project root.")
    return(usethis::ui_todo("Call {usethis::ui_code('buildr::init()')} to create it."))
  }
  usethis::ui_info("{usethis::ui_path('Makefile')} opened.")
  if (rstudioapi::isAvailable() && rstudioapi::hasFun("navigateToFile")) {
    rstudioapi::navigateToFile("Makefile")
  }
  else {
    utils::file.edit("Makefile")
  }
  invisible("Makefile")
}
