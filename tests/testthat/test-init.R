test_that("init recognizes all build scripts with 'build_' prefix", {
  writeLines("print('build.R')", con = "build.R")
  writeLines("print('build_.R')", con = "build_.R")
  writeLines("print('build_.R')", con = "build_.R")
  writeLines("print('build with spaces.R')", con = "build with spaces.R")
  writeLines("print('build_correct-script.R')", con = "build_correct-script.R")
  writeLines("print('build_2.R')", con = "build_2.R")
  writeLines("print('build_this.R')", con = "build_this.R")
  writeLines("print('build_that.r')", con = "build_that.r")
  writeLines("print('build_foo.R')", con = "build_foo.R")
  writeLines("print('build_bar.r')", con = "build_bar.r")

  writeLines("print('bui.R')", con = "bui.R")
  writeLines("print('builder.R')", con = "builder.R")

  buildr::init()

  expect_true(file.exists("______Makefile"))
  content <- readr::read_lines("Makefile", skip_empty_rows = TRUE)

  n_lines <- length(content)

  expect_equal(n_lines %% 2, 0)
})

test_that("aim throws error if not interactive and target is NULL", {
  expect_error(buildr::aim(), "cannot run in noninteractive session and argument")
})

test_that("aim does'n throw error if not interactive and target is set", {
  expect_message(buildr::aim(target = "foo"), "Set!")
})

test_that("aim throw error if not interactive and target is set wrong", {
  expect_error(buildr::aim(target = "builddsfvgsfg"), "is not a valid target")
})
