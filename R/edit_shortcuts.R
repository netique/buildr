#' Show RStudio Keyboard Shortcuts Popup
#'
#' Shows popup window with RStudio keyboard shortcuts. Uses `rstudioapi`.
#' Applicable only in RStudio and in interactive session.
#'
#' You can quicky reach out solicited addin function by typing it in the
#' `Filter...` box in the very top of the popup window. Then double click at the
#' blank space just next to the addin function name and press down desired key
#' or key combination. Apply the changes and from now on, just call the function
#' with one keystroke.
#'
#' @return No return value. Called for side effect.
#'
#' @importFrom rstudioapi executeCommand isAvailable
#' @examples
#' \dontrun{
#' edit_schortcuts()
#' }
#' @export
edit_shortcuts <- function() {
  if (isAvailable()) {
    invisible(executeCommand("modifyKeyboardShortcuts"))
  }
}
