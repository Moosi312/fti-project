# - INIT -----------------------------------------------------------------------
rm(list = ls())
source("prep/_shared.r", encoding = "UTF-8")
loadPackages(c(
    "countrycode"
))


# - LOAD -----------------------------------------------------------------------
d.base = loadData(file.path(g$d$de, "fti_monitor.xlsx"), sheet = "Map")

d.f = d.base[, .(
    id = substring(var, 3), iso2,
    rel.inno = Verh_IL,
    rel.eu = Verh_EU,
    rel.top3 = Verh_Top3,
    rel.cn = Verh_CN,
    rel.us = Verh_US,
    rel.kr = Verh_KR,
    rel.jp = Verh_JP
)]

# d.f[, n := .N, by = .(id, iso2)]

d.f[iso2 == "UK", iso2 := "GB"]
d.f[iso2 == "EL", iso2 := "GR"]


d.o = sapply(unique(d.f$id), function(id.sel) {
    d.f[id == id.sel, .(
        iso2,
        rel.inno = round(rel.inno, 2),
        rel.eu = round(rel.eu, 2),
        rel.top3 = round(rel.top3, 2),
        rel.cn = round(rel.cn, 2),
        rel.us = round(rel.us, 2),
        rel.kr = round(rel.kr, 2),
        rel.jp = round(rel.jp, 2)
    )]
}, simplify = FALSE)

# SAVE
# writeBin(charToRaw(toJSON(d.o, auto_unbox = TRUE)), file.path(g$d$o, "mapValues.json"), endian="little")
saveData(d.o, file.path(g$d$o, "mapValues.json"), auto_unbox = TRUE, pretty = TRUE)


invisible(
    sapply(
        setdiff(grep("rel.", colnames(d.f), fixed = TRUE, value = TRUE), "rel.inno"),
        function(c) { d.f[, (c) := NULL]; NULL}
    )
)

saveData(d.f, file.path(g$d$o, "international.csv"))




# - COUNTRY NAME DICT ----------------------------------------------------------
c.iso2 = unique(d.f$iso2)
c.iso2 = c.iso2[nchar(c.iso2) == 2]
d.countries = data.table(code = c.iso2, name = countrycode(c.iso2, "iso2c", "country.name.de"))

d.countries[code == "KR", name := "Südkorea"]
d.countries[code == "CZ", name := "Tschechien"]

d.countries = rbind(
    d.countries,
    data.table(code = "EU27_2020", name = "EU-27")
)


l.countries = as.list(d.countries$name)
names(l.countries) = d.countries$code

saveData(l.countries, file.path(g$d$o, "countries.json"), auto_unbox = TRUE, pretty = TRUE)
