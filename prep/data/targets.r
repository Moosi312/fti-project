# - INIT -----------------------------------------------------------------------
rm(list = ls())
source("prep/_shared.r", encoding = "UTF-8")
loadPackages(c(
))


# - LOAD -----------------------------------------------------------------------
d.base = loadData(file.path(g$d$de, "FTIZiele.dta"))
d.map = loadData(file.path(g$d$de, "fti_monitor.xlsx"), sheet = "ziele")
# View(unique(d.base[, .(var, labelname)]))


# - PREP -----------------------------------------------------------------------
#! Wert_aktuell -> value , Da Zeitreihe nun mit "echten" Jahren angezeigt werden soll und nicht Berichtsjahr
d = d.base[, .(year, id = var, value = value, target = Zielwert, per = Zielerreichung, projection)]
d = d[!is.na(value) & !is.na(per) & id %in% d.map$id]

d.f = merge(d, d.map[, .(id, id.new)], by = "id")
d.f[, `:=`(
    id = id.new,
    id.new = NULL,
    type = ifelse(projection == 0, "a", "p")
)]

d.o = sapply(unique(d.f$id), function(id.sel) {
    d.f[id == id.sel, .(
        year, target, type,
        value = round(value, 2),
        per = round(per, 2))]
}, simplify = FALSE)

unique(d.f$id)

# - SAVE -----------------------------------------------------------------------
# writeBin(charToRaw(toJSON(d.o, auto_unbox = TRUE)), file.path(g$d$o, "targetValues.json"), endian="little")
saveData(d.o, file.path(g$d$o, "targetValues.json"), auto_unbox = TRUE, pretty = TRUE)




d = unique(d.base[, .(id = var, name = labelname, source = Quelle, description = Beschreibung_Indikator)])
d.f = merge(d, d.map[, .(id, id.new)], by = "id")
d.f[, `:=`(
    id = id.new,
    id.new = NULL
)]
