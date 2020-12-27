
<!-- README.md is generated from README.Rmd. Please edit that file -->

# buildr <img src="man/figures/logo.png" align="right" width=180/>

Comfort way to run build scripts

<!-- badges: start -->

[![GitHub Workflow
Status](https://img.shields.io/github/workflow/status/netique/buildr/R-CMD-check)](https://github.com/netique/buildr/actions?query=workflow%3AR-CMD-check)
[![version](https://www.r-pkg.org/badges/version/buildr)](https://CRAN.R-project.org/package=buildr)
![GHversion](https://img.shields.io/github/release/netique/buildr.svg)
[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
![cranlogs](https://cranlogs.r-pkg.org/badges/grand-total/buildr)
<!-- badges: end -->

## WARNING: DEVELOPMENT VERSION UNDER CONSTRUCTION!

To use previous, stable release, see CRAN version (below) or use:

``` r
remotes::install_github("netique/buildr", ref = "v0.0.4")
```

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
## basic example code
```

However, much more feasible is to use RStudio’s addins and create
[keyboard
shorcut](http://rstudio.github.io/rstudioaddins/#keyboard-shorcuts)
(Tools &gt; Modify Keyboard Shorcuts… &gt; *here search for “Buildr”*):

<img src="man/figures/addins_showcase.gif" width="100%" />

## License

This program is free software and you can redistribute it and or modify
it under the terms of the [GNU GPL
3](https://www.gnu.org/licenses/gpl-3.0.en.html).
