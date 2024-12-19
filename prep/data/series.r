# - INIT -----------------------------------------------------------------------
rm(list = ls())
source("prep/_shared.r", encoding = "UTF-8")
loadPackages(c(
))


# - LOAD -----------------------------------------------------------------------
d.raw = loadData(file.path(g$d$de, "fti_monitor.xlsx"), sheet = "Zeitreihen")
# View(d.raw)


d.base = unique(d.raw[, .(
    id = var, year, value, type = "v",
    value.eu = EU_MW,
    value.top3 = Top3_MW,
    value.inno = IL_MW,
    value.us = US_MW,
    value.cn = CN_MW,
    value.jp = JP_MW,
    value.kr = KR_MW
)])[!is.na(value)]


d.agg = unique(d.raw[grep("^(B_..|TB_.*)$", var), .(
    id = var, year, value = 100, type = "a",
    value.eu = Verh_EU,
    value.top3 = Verh_Top3,
    value.inno = Verh_IL,
    value.us = Verh_US,
    value.cn = Verh_CN,
    value.jp = Verh_JP,
    value.kr = Verh_KR
)])

for (col in grep("^value", colnames(d.agg), value = TRUE)) {
    d.agg[, (col) := 1 / get(col) * 100]
}

d.comb = rbind(d.base, d.agg)

# - ROUND ----------------------------------------------------------------------
for (col in grep("^value", colnames(d.comb), value = TRUE)) {
    d.comb[, (col) := signif(get(col), 5)]
}

d.comb[grep("^B_..$", id), `:=`(
    id = substring(id, 3)
)]

# - SAVE -----------------------------------------------------------------------
# saveData(d.comb, file.path(g$d$o, "series.json"), pretty = TRUE)
saveData(d.comb, file.path(g$d$o, "series.csv"))

# - Composites -----------------------------------------------------------------
#Notiz (Tim): Da Mittelwerte über Indikatoren keinen Sinn ergeben, Verhältniswerte in Liniengrafiken.
# d.comp = unique(d.raw[grep("^(B_..|TB_.*)$", var), .(
#     id = var, year,
#     rel.eu = Verh_EU,
#     rel.top3 = Verh_Top3,
#     rel.inno = Verh_IL,
#     rel.us = Verh_US,
#     rel.cn = Verh_CN,
#     rel.jp = Verh_JP,
#     rel.kr = Verh_KR
#     # rel.il.old = IL_old
# )])

# for (col in grep("^rel", colnames(d.comp), value = TRUE)) {
#     d.comp[, (col) := signif(get(col), 2)] # Isn't 2 enough?
# }

# @Peter weiß nicht wie du Composites einbetten willst

