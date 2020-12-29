# buildr 0.1.0

-   **complete reboot**, a whole new philosophy *built* around automatically generated, fully editable `Makefile` and prioritization of its "rules" or "targets"

-   "trinity" of essential functions introduced:

    -   `init()` initializes a `Makefile` in project root with automatically discovered build scripts
    -   `aim()` sets one of the `Makefile` targets to be recognized by RStudio's *Build* pane (prioritization)
    -   `build()` builds the first `Makefile` entry (set by user or via `aim()`)

    ## Technicals

-   `pkgdown` is used to build package website with news, vignettes and documentation (see tab Reference)

-   partly covered with `testthat` tests

------------------------------------------------------------------------

# buildr 0.0.4

-   first CRAN release
-   package offers basic functionality
