test_that("init recognizes all build scripts with 'build_' prefix", {
  buildr::init()

  expect_true(file.exists("Makefile"))
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
