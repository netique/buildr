#' Read Targets from Makefile
#'
#' @noRd
#' @keywords internal
#' @importFrom usethis ui_stop ui_path ui_code ui_field ui_oops ui_value
#' @importFrom stringr str_subset str_remove str_trim
#'
targets_from_lines <- function(lines) {
  targets <- lines %>%
    str_subset(":$") %>%
    str_remove(":$") %>%
    str_trim()

  if (length(targets) == 0) {
    ui_stop(c(
      "{ui_field('{buildr}')} has not discovered any build scripts in {ui_path('Makefile')}.",
      "Try to call {ui_code('init()')} again with different {ui_field('prefix')} argument."
    ))
  }

  if (length(targets) == 1) {
    ui_stop(c(
      "{ui_field('{buildr}')} has discovered only one build script {ui_value({targets})}.",
      "You can run it directly with {ui_code('build()')}, there is no need to call {ui_code('aim()')}.",
      "If you think you have more build scripts in your project,",
      "try to call {ui_code('init()')} again with different {ui_value('prefix')} argument."
    ))
  }

  return(targets)
}


#' Check Makefile for problems
#'
#' @noRd
#' @keywords internal
#' @importFrom usethis ui_stop ui_path ui_code ui_field
#'
check_makefile <- function() {
  if (!file.exists("Makefile") || file.info("Makefile")$size == 0) {
    ui_stop(c(
      "{ui_field('{buildr}')} seems uninitialized, {ui_path('Makefile')} does not exist in your project root or is empty.",
      "Please, call {ui_code('init()')} first."
    ))
  }

  tryCatch(
    {
      invisible(read.dcf("Makefile"))
    },
    error = function(e) {
      ui_stop(c(
        "{ui_path('Makefile')} seems corrupted.",
        "Call {ui_code('init()')} again or inspect your {ui_path('Makefile')} with {ui_code('edit_makefile()')}"
      ))
    }
  )
}


#' Check if build pane is set-up
#'
#' @keywords internal
#' @noRd
#' @importFrom stringr str_detect
#' @importFrom rstudioapi executeCommand sendToConsole
#' @importFrom readr read_lines write_lines
#' @importFrom usethis ui_oops ui_field ui_path ui_yeah ui_stop
check_build_pane <- function() {
  rproj_file <- list.files(".", pattern = "\\.Rproj$")
  rproj_config <- read_lines(rproj_file)

  if (!"BuildType: Makefile" %in% rproj_config) {
    ui_oops("{ui_field('{buildr}')} discovered that your RStudio Build pane is not set to build from {ui_path('Makefile')}.")
    granted <- ui_yeah(c(
      "Do you want to set everything up and reload RStudio UI?",
      "After the reload, you'll have to call {ui_code('build()')} again.",
      "The action {ui_field('will not')} restart your session."
    ))

    if (granted) {
      if (!any(str_detect(rproj_config, "BuildType"))) {
        rproj_config <- c(rproj_config, "BuildType: Makefile")
      } else {
        rproj_config[str_detect(rproj_config, "BuildType")] <- "BuildType: Makefile"
      }

      write_lines(rproj_config, rproj_file)

      executeCommand("reloadUi")
      return("reloaded")
    } else {
      ui_oops("RStudio Build pane was not set. Build terminated.")
      return("fail")
    }
  }

  return("success")
}

#' Aim Addin wrapper
#'
#' wrapping inside try defuses RStudio warnings about code execution
#'
#' @noRd
#' @keywords internal
aim_addin <- function() {
  try({
    aim()
  })
}

#' Build Addin wrapper
#'
#' wrapping inside try defuses RStudio warnings about code execution
#'
#' @noRd
#' @keywords internal
build_addin <- function() {
  try({
    build()
  })
}


#' Init Addin wrapper
#'
#' wrapping inside try defuses RStudio warnings about code execution
#'
#' @noRd
#' @keywords internal
init_addin <- function() {
  try({
    init()
  })
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
