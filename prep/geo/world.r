# - INIT -----------------------------------------------------------------------
rm(list = ls())
library(wifo.base)
loadPackages(c(
    # "wifo.spatial",
    "sf",
    "countrycode",
    "geojsonio",
    "ggplot2",
    "smoothr"
))

crs = 4326


# - LOAD -----------------------------------------------------------------------
s.world = st_read("data/geo/world50.json", layer = "countries")
st_crs(s.world) = crs


# - PREP -----------------------------------------------------------------------
c.remove = c(
    "ATA" # Antarctica
#    "GRL" # Greenland
)

s.world = s.world[!s.world$a3 %in% c.remove, ]

s.world$iso_a2 = countrycode(s.world$a3, "iso3c", "iso2c")
s.world$iso_a2[is.na(s.world$iso_a2)] = s.world$a3[is.na(s.world$iso_a2)]

s.world = s.world[, c("iso_a2", "geometry")]

s.final = drop_crumbs(s.world, 10*(10**4)**2)
plot(s.final)


c.eu28 = s.final$iso_a2[countrycode(s.final$iso_a2, "iso2c", "eu28") == "EU"]
c.eu28 = c.eu28[!is.na(c.eu28)]
c.eu27 = c.eu28[c.eu28 != "GB"]
length(c.eu27)

s.eu27 = st_combine(s.final[s.final$iso_a2 %in% c.eu27, ])
# s.eu27 = st_combine(s.final[s.final$iso_a2 %in% c("DE"), ])

# st_crs(s.eu27)
# st_crs(s.final)

s.final = rbind(
    s.final,
    st_as_sf(data.frame(iso_a2 = "EU27_2020", geometry = s.eu27))
    # st_as_sf(data.frame(iso_a2 = "DE2", geometry = s.final[s.final$iso_a2 %in% c("DE"), "geometry"]))
)

# plot(s.final[s.final$iso_a2 == "EU27", ])


# - SAVE -----------------------------------------------------------------------
# s.final = s.final[!s.final$iso_a2 %in% c("FR"), ]
# s.final = s.final[s.final$iso_a2 %in% c("EU27"), ]
topojson_write(
    s.final, file = "assets/geo/worldmap.json",
    object_name = "countries", quantization = 5e3
)
