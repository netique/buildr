# buildr 0.1.1

-   fix documentation to be HTML5 compliant

# buildr 0.1.0

-   **complete reboot**, a whole new philosophy *built* around automatically generated, fully editable `Makefile` and prioritization of its "rules"

-   "trinity" of essential functions introduced:

    -   `init()` initializes a `Makefile` in project root with automatically discovered build scripts
    -   `aim()` sets one of the `Makefile` targets to be recognized by RStudio's *Build* pane (prioritization)
    -   `build()` builds the first `Makefile` entry (set by user or via `aim()`)

    ## Technicals

-   `pkgdown` is used to build package website, so you can read the news, vignettes and full documentation in a more pleasant, responsive way even outside `R`

-   partly covered with `testthat` tests

------------------------------------------------------------------------

# buildr 0.0.4

-   first CRAN release
-   package offers basic functionality
