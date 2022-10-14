# create bunch of test files
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

# clean after all tests
withr::defer(
  unlink(
    c(
      "bui.R", "build with spaces.R", "build_.R",
      "build_2.R", "build_bar.r", "build_correct-script.R",
      "build_foo.R", "build_that.r", "build_this.R",
      "build.R", "builder.R", "Makefile"
    )
  ),
  teardown_env()
)
