# - INIT -----------------------------------------------------------------------
library(wifo.base)
loadPackages(c(
    "data.table",
    "glue"
))


# - GLOBALS --------------------------------------------------------------------
g = list(
    d = list(
        d = "data",
        o = "assets/data",
        t = "tmp"
    )
)

# g$d$de = file.path(g$d$d, "23-spring")
# g$d$de = file.path(g$d$d, "23-autumn")
g$d$de = file.path(g$d$d, "24-spring")
