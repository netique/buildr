
<!-- README.md is generated from README.Rmd. Please edit that file -->

# buildr <a href='https://netique.github.io/buildr'><img src='man/figures/logo.png' align="right" height="180" /></a>

<!-- badges: start -->

[![version](https://www.r-pkg.org/badges/version/buildr)](https://CRAN.R-project.org/package=buildr)
[![GHversion](https://img.shields.io/github/v/release/netique/buildr?include_prereleases)](https://github.com/netique/buildr)
[![GitHub Workflow
Status](https://img.shields.io/github/workflow/status/netique/buildr/R-CMD-check)](https://github.com/netique/buildr/actions?query=workflow%3AR-CMD-check)
[![cranlogs](https://cranlogs.r-pkg.org/badges/grand-total/buildr)](https://cranlogs.r-pkg.org/)
[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
<!-- badges: end -->

> Organize & Run Build Scripts Comfortably

Warning! This development version is under construction, use the stable
CRAN release, or install this development release with caution.
Everything should work as intended if you see the green
![](https://img.shields.io/badge/build-passing-brightgreen) badge. Basic
documentation is provided as well.

<!-- Working with reproducible reports or any other similar projects often requires to run the script that "builds" the output file in a specified way. One can become tired from repeatedly switching to the build script and sourcing it. -->
<!-- The `buildr` package does this one simple thing via "RStudio addin" – user can set up the *keyboard shortcut* and run the build script with **one keystroke anywhere anytime.** The second way is to pass `buildr()` (don't forget the parentheses!) command to console which does the same thing. Both ways source the `build.R` (case *insensitive*) file present in the current working directory. -->

## Installation

You can install the stable version of `buildr` from
[CRAN](https://CRAN.R-project.org/package=buildr) with:

``` r
install.packages("buildr")
```

And the development version from
[GitHub](https://github.com/netique/buildr) with:

``` r
if (!require(rsdemotes)) {install.packages("remotes")}
remotes::install_github("netique/buildr")
```

## Basic usage

This is a basic example which shows you how to solve a common problem:

``` r
library(buildr)
```

However, much more feasible is to use RStudio’s addins and create
[keyboard
shorcut](http://rstudio.github.io/rstudioaddins/#keyboard-shorcuts)
(Tools &gt; Modify Keyboard Shorcuts… &gt; *here search for “Buildr”*):

## License

This program is free software and you can redistribute it and or modify
it under the terms of the [GNU GPL
3](https://www.gnu.org/licenses/gpl-3.0.en.html).
