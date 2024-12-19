# - INIT -----------------------------------------------------------------------
rm(list = ls())
source("prep/_shared.r", encoding = "UTF-8")
loadPackages(c(
    "stringr"
))


# - LOAD -----------------------------------------------------------------------
d.base = loadData(file.path(g$d$de, "fti_monitor.xlsx"), sheet = "Rohdaten_AT")
# View(d.base)


# - PREP -----------------------------------------------------------------------
d.t = unique(d.base[,
    c("var", grep("Diff_Ver", colnames(d.base), value = TRUE))
, with = FALSE])

d.values = melt(d.t, id.vars = "var")

m.t = str_match(d.values$variable, "Diff_Verh_(.*)_tminus([0-9]*)")
d.values = d.values[, .(
    id = var,
    group = m.t[, 2],
    t = m.t[, 3],
    value
)]

d.values = d.values[!is.na(value)]

d.values[, group := tolower(group)]
d.values[group == "il", group := "inno"]

d.values = dcast(d.values, id + t ~ group)


# - SAVE -----------------------------------------------------------------------
saveData(split(d.values, by = "t", keep.by = FALSE), file.path(g$d$o, "minus.json"), pretty = TRUE)
