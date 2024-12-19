# - INIT -----------------------------------------------------------------------
rm(list = ls())
source("prep/_shared.r", encoding = "UTF-8")
loadPackages(c(
    "jsonlite",
    "zoo"
))


# - LOAD -----------------------------------------------------------------------
d.sdg.raw = loadData(file.path(g$d$d, "others/SDG EGD.xlsx"), sheet = "SDG")
d.egd.raw = loadData(file.path(g$d$d, "others/SDG EGD.xlsx"), sheet = "EGD")


# - SDG ------------------------------------------------------------------------
c.sdgNo2Color = c(
    "1" = "#E5243B",
    "2" = "#DDA83A",
    "3" = "#4C9F38",
    "4" = "#C5192D",
    "5" = "#FF3A21",
    "6" = "#26BDE2",
    "7" = "#FCC30B",
    "8" = "#A21942",
    "9" = "#FD6925",
    "10" = "#DD1367",
    "11" = "#FD9D24",
    "12" = "#BF8B2E",
    "13" = "#3F7E44",
    "14" = "#0A97D9",
    "15" = "#56C02B",
    "16" = "#00689D",
    "17" = "#19486A"
)


d.sdg = d.sdg.raw[display == 1]
d.sdg[, display := NULL]
colnames(d.sdg) = substring(colnames(d.sdg), 5)

# areas = sort(unique(strsplit(paste(unlist(d.sdg$bereiche), collapse = ", "), ", ")[[1]]))
# areas = areas[areas != "NA"]

# areas = sapply(areas, function(a) integer(0))


# invisible(sapply(1:nrow(d.sdg), function(i) {
#     t = strsplit(d.sdg[i]$bereiche, ", ")[[1]]
#     t = t[!is.na(t)]
#     if (length(t) > 0) {
#         print(t)
#         for (j in t) {
#             areas[[j]] <<- c(areas[[j]], i)
#         }
#     }
#     NULL
# }))

# d.sdg[, id := 1:.N]


d.sdg[, bereiche := strsplit(bereiche, ", ")]
d.sdg = d.sdg[!is.na(d.sdg$bereiche)]

# jsonlite::prettify(toJSON(areas))
jsonlite::prettify(toJSON(d.sdg))

d.sdg[, color := c.sdgNo2Color[no]]

saveData(d.sdg, file.path(g$d$o, "sdg.json"))
#saveData(areas, file.path(g$d$o, "topic2sdg.json"))



# - EGD ------------------------------------------------------------------------
d.egd = d.egd.raw[display == 1]
d.egd[, display := NULL]
colnames(d.egd) = substring(colnames(d.egd), 5)


d.egd[, `:=`(
    goal = na.locf(goal),
    `goal-de` = na.locf(`goal-de`)
)]


# areas = sort(unique(strsplit(paste(unlist(d.sdg$bereiche), collapse = ", "), ", ")[[1]]))
# areas = areas[areas != "NA"]

# areas = sapply(areas, function(a) integer(0))


# invisible(sapply(1:nrow(d.egd), function(i) {
#     t = strsplit(d.egd[i]$bereiche, ", ")[[1]]
#     t = t[!is.na(t)]
#     if (length(t) > 0) {
#         print(t)
#         for (j in t) {
#             areas[[j]] <<- c(areas[[j]], i)
#         }
#     }
#     NULL
# }))

# d.egd[, id := 1:.N]

d.egd[, bereiche := strsplit(bereiche, ", ")]
d.egd = d.egd[!is.na(d.egd$bereiche)]

# d.egd[, bereiche := NULL]

# jsonlite::prettify(toJSON(areas))
jsonlite::prettify(toJSON(d.egd))


saveData(d.egd, file.path(g$d$o, "egd.json"))
# saveData(areas, file.path(g$d$o, "topic2egd.json"))
