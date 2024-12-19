# - INIT -----------------------------------------------------------------------
rm(list = ls())
source("prep/_shared.r", encoding = "UTF-8")
loadPackages(c(
))

t0 = 2024 # current year of monitor


# - LOAD -----------------------------------------------------------------------
# d.base = loadData(file.path(g$d$de, "Rohdaten_AT.csv"))
# d.vj = loadData(file.path(g$d$de, "Synthese_VJ.csv"))
d.base = loadData(file.path(g$d$de, "fti_monitor.xlsx"), sheet = "Rohdaten_AT")
d.vj = loadData(file.path(g$d$de, "fti_monitor.xlsx"), sheet = "Synthese_VJ")
d.struc = loadData(file.path(g$d$de, "fti_monitor.xlsx"), sheet = "Hierarchie")


# - CREATE DT FOR ALL INDICATOR VALUES -----------------------------------------
d.values = unique(d.base[, .(
    id = var, year, value,
    rel.eu = Verh_EU,
    rel.inno = Verh_IL,
    rel.top3 = Verh_Top3,
    rel.cn = Verh_CN,
    rel.us = Verh_US,
    rel.kr = Verh_KR,
    rel.jp = Verh_JP
)])
# nrow(d.values) == length(unique(d.values$id))

d.values.p = unique(d.vj[, .(
    id = var, year.p = t0-1, rel.inno.p = `VerhältnisVorjahr`
)])

d.values = merge(d.values, d.values.p, by = "id", all.x = TRUE)

# View(d.values)
d.values[grep("^B_..$", id), `:=`(
    id = substring(id, 3),
    head = TRUE
)]
d.values[is.na(head), head := FALSE]

# d.values[head == TRUE, year := t0]
d.values[, head := NULL]

saveData(d.values, file.path(g$d$o, "values.json"), pretty = TRUE)


# - HIERARCHY ------------------------------------------------------------------
d.t = data.table(n = colnames(d.struc))
d.t[, i := seq_len(.N)]

#d.str = unique(d.base[d.ind$.rowid, -c(".rowid"), with = FALSE])
#! Achte penibel darauf, dass keine anderen Variablen mit TB_ anfangen
d.str = d.struc[, c(1:2, grep("^B_..$", names(d.struc)), grep("^TB_", names(d.struc))), with = FALSE]
# d.str = d.str[, c(1, 17:75), with = FALSE]
#! ich musste dat.table definieren (no plan)

# cols without values
c.withoutValues = Filter(function(col) {
    all(is.na(d.str[[col]]))
}, colnames(d.str))

invisible(sapply(c.withoutValues, function(col) d.str[, (col) := NULL]))

d.str.m = data.table(melt(d.str, id.vars = c("var", "order"), variable.factor = FALSE))[!is.na(value)]

d.str.m = unique(d.str.m[, .(id = var, group = variable, order)]) #! order muss mit

# correct bereiche
d.str.m[grep("^B_..$", group), `:=`(
    group = substring(group, 3)
)]

setorder(d.str.m, -group, order) #! hinzugefügt

# setdiff(unique(d.str$var), d.ind$id)
c.h1 = setdiff(d.values$id, unique(d.str.m$id))
c.h3 = setdiff(unique(d.values$id), d.str.m$group)
c.h2 = setdiff(unique(d.values$id), union(c.h1, c.h3))

d.str.h3 = d.str.m[id %in% c.h3]
d.str.h2 = d.str.m[id %in% c.h2]

length(unique(d.str.h2$id)) == nrow(d.str.h2)


d.str.h3.h1 = d.str.h3[group %in% c.h1]
d.str.h3.h1[, n := .N, by = id]

d.str.h2.h1 = d.str.h2[group %in% c.h1]
d.str.h2.h1[, n := .N, by = id]

d.str.h3.h2 = d.str.h3[group %in% c.h2]
d.str.h3.h2[, n := .N, by = id]


#h1.sel = "A2"
l.str = sapply(c.h1, function(h1.sel) {
    l("- ", h1.sel)


    # # OLD
    # h2 = d.str.h2.h1[group == h1.sel, id]
    # h3 = d.str.h3.h1[group == h1.sel, id]
    # o = list(
    #     i = h3,
    #         wt = sapply(h2, function(h2.sel) {
    #             unique(d.str.h3.h2[group == h2.sel, id])
    #     }, simplify = FALSE)
    # )
    # o$iw = setdiff(o$i, unlist(o$wt))

    # NEW
    h2 = d.str.h2.h1[group == h1.sel]
    h3 = d.str.h3.h1[group == h1.sel]

    h3.with.h2 = d.str.h3.h2[group %in% h2$id]
    h3.without.h2 = setdiff(h3$id, h3.with.h2$id)

    d.t = rbind(
        d.str.h3.h2[group %in% h2$id, .(id, group, order)],
        d.str.m[id %in% h3.without.h2 & group == h1.sel, .(id = NA, group = id, order)]
    )[order(order)]

    h2 = unique(d.t$group)


    o = list(
        i = h3$id,
        wt = sapply(h2, function(h2.sel) {
            unique(d.str.h3.h2[group == h2.sel, id])
        }, simplify = FALSE)
    )
    # o$iw = c()

    o
}, simplify = FALSE)

saveData(l.str, file.path(g$d$o, "str.json"), pretty = TRUE)





# - LABELS ---------------------------------------------------------------------
d.labels = loadData(file.path(g$d$de, "fti_monitor.xlsx"), sheet = "Indikatoren")[, .(
    id = var,
    short = label,
    source = Quelle,
    # short2 = Kurzbezeichnung,
    # name = Indikator,
    text = `Erklärung`,
    io = Input_Output,
    unit,
    unit_short,
    name_a = Indikator
)]

d.labels[io == "Input", io := "i"]
d.labels[io == "Output", io := "o"]
d.labels[io == "-", io := ""]
unique(d.labels$io)

d.labels[io == ""]

d.labels[grep("^B_..$", id), `:=`(
    id = substring(id, 3)
)]

nrow(d.labels) == length(unique(d.labels$id))

d.labels = merge(unique(d.values[, .(id)]), d.labels, by = "id", all.x = TRUE)
#d.labels = d.labels[!id %in% c.h1]

d.labels[is.na(short)]

l.labels = sapply(d.labels$id, function(id.sel) {
    as.list(d.labels[id == id.sel, -c("id"), with = FALSE])
}, simplify = FALSE)
saveData(l.labels, file.path(g$d$o, "labels.json"), auto_unbox = TRUE, pretty = TRUE)


# - NATIONAL -------------------------------------------------------------------
d.t = merge(d.values, d.labels[, .(id, short, name_a, source)], by = "id")
d.t[, id := NULL]
setcolorder(d.t, c("short"))

invisible(
    sapply(
        setdiff(grep("rel.", colnames(d.t), fixed = TRUE, value = TRUE), "rel.inno"),
        function(c) { d.t[, (c) := NULL]; NULL}
    )
)

saveData(d.t, file.path(g$d$o, "national.csv"))
