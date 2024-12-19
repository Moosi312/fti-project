# - INIT -----------------------------------------------------------------------
rm(list = ls())
source("prep/_shared.r", encoding = "UTF-8")
loadPackages(c(
    "stringi",
    "jsonlite"
))
options(warn = 1)


# - LOAD -----------------------------------------------------------------------
file.name = file.path(g$d$d, "FTI-Monitor-Ressourcen.xlsx")
l = sapply(openxlsx::getSheetNames(file.name), function(s.sel) loadData(file.name, sheet = s.sel))

csl2ids = function(s) as.integer(trimws(unlist(strsplit(s, ","))))

# - DOCS -----------------------------------------------------------------------
l.docs = lapply(seq_len(nrow(l$dokumente)), function(r.sel) {
# l.docs = lapply(1:2, function(r.sel) {
    e = as.list(l$dokumente[r.sel, ])
    #l(e$doc_author)
    c.authorIds = csl2ids(e$doc_author)
    #l(c.authorIds)
    d.authors = l$dokumente_authors[author_id %in% c.authorIds]

    c.ftiIds = csl2ids(e$doc_fti_bereiche)

    l(e$doc_fti_bereiche, " => ", paste(c.ftiIds, collapse = ", "))
    c.ftiIds = c.ftiIds[!is.na(c.ftiIds)]

    list(
        file = unbox(e$doc_file),
        type = unbox(l$dokument_typen[id == e$doc_type, type]),
        name = unbox(e$doc_name),
        year = unbox(e$doc_year),
        topicIds = gsub(".", "", l$fti_bereiche[fti_bereiche_id %in% c.ftiIds, fti_bereiche_nr], fixed = TRUE),
        authors = d.authors[, .(
            name = author_name,
            short = author_short,
            city = author_city,
            country = author_country
        )]
    )
})

# toJSON(l.docs)

saveData(l.docs, file.path(g$d$o, "docs.json"))

# - WIRKUNGSZIELE --------------------------------------------------------------
l.wz = lapply(seq_len(nrow(l$wirkungsziele)), function(r.sel) {
    e = as.list(l$wirkungsziele[r.sel, ])

    e_ug = l$wirkungsziele_ug[ug_id == e$wirkungsziel_ug]
    e_org = l$wirkungsziele_org[org_id == e$wirkungsziel_org]

    e_rel = l$wirkungsziele_relation[wirkungsziel_id == e$wirkungsziel_id]
    c.ftiIds = csl2ids(e_rel$wirkungsziel_fti_system_rel)

    list(
        nr = unbox(e$wirkungsziel_nr),
        name = unbox(e$wirkungsziel_name),
        topicIds = gsub(".", "", l$fti_bereiche[fti_bereiche_id %in% c.ftiIds, fti_bereiche_nr], fixed = TRUE),
        ug = list(
            nr = unbox(e_ug$ug_nr),
            name = unbox(e_ug$ug_name)
        ),
        org = list(
            name = unbox(e_org$org_name),
            short = unbox(e_org$org_kurz)
        )
    )
})

jsonlite::prettify(toJSON(l.wz))
saveData(l.wz, file.path(g$d$o, "wirkungsziele.json"))
