# - INIT -----------------------------------------------------------------------
rm(list = ls())
library(wifo.base)
loadPackages(c(
    "data.table",
    "glue",
    "jsonlite"
))



# - LOAD -----------------------------------------------------------------------
d.base = loadData(file.path("data", "others", "Quellen Bericht 2023.xlsx"), colNames = FALSE)

l = trimws(d.base$X2)
names(l) = trimws(d.base$X1)


md.folder = "assets/docs/md-pre"
md.folder.final = "assets/docs/md"

c.md.files = list.files(md.folder)

c.md.text = sapply(c.md.files, function(f) {
    paste(readLines(file.path(md.folder, f)), collapse = " ")
})


c.keywords = trimws(d.base$X1)

m.o = sapply(c.keywords, function(k) {
    grepl(k, c.md.text, fixed = TRUE)
})

c.used = sapply(1:length(c.md.files), function(i) names(which(m.o[i, ])))

# l[c.used[[1]]]


for (i in 1:length(c.md.files)) {
    file = c.md.files[i]
    l(file)
    c.content = readLines(file.path(md.folder, file))
    c.lit = c.used[[i]]
    if (length(c.lit) > 0) {
        l("LIT:", paste(c.lit, collapse = ' | '), iL = 1)
        c.content = c(c.content,
            "",
            "## Literaturverzeichnis:",
            ""
        )

        for (lit in c.lit) {
            c.content = c(c.content,
                # glue("**{lit}** {l[lit]}"),
                glue("{l[lit]}"),
                ""
            )
        }
    } else {
        l("NO LIT", iL = 1)
    }
    writeLines(c.content, file.path(md.folder.final, file))
}
