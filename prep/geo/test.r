# - INIT -----------------------------------------------------------------------
rm(list = ls())
library(wifo.base)
loadPackages(c(
    # "wifo.spatial",
    "sf",
    "countrycode",
    "geojsonio",
    "ggplot2"
))


crs = 4326

s.world = st_read("data/geo/world50.json", layer = "countries")
st_crs(s.world) = crs


c.remove = c(
    "ATA" # Antarctica
#    "GRL" # Greenland
)


# s.world[grep('green', s.world$name, ignore.case = TRUE), ]

s.world = s.world[!s.world$a3 %in% c.remove, ]

s.world$iso_a2 = countrycode(s.world$a3, "iso3c", "iso2c")
s.world$iso_a2[is.na(s.world$iso_a2)] = s.world$a3[is.na(s.world$iso_a2)]



s.world = s.world[, c("iso_a2", "geometry")]

length(unique(s.world$iso_a2))
nrow(s.world)


# View(s.world)

# plot(s.world[s.world$iso_a2 == "DE", ])
# s.de = s.world[s.world$iso_a2 == "FJ", ]
# file.remove("assets/geo/worldmap.json")
# st_write(s.world, "assets/geo/worldmap.json", driver = "GEOJSON")

s.final = s.world[!s.world$iso_a2 %in% c("PF"), ]
# s.final = s.world
# plot(s.final)

topojson_write(s.final, file = "assets/geo/worldmap.json", object_name = "countries", quantization = 3e4)





s.europe = st_read("data/geo/world50.json", layer = "countries")
st_crs(s.europe) = crs
#s.europe = st_transform(s.europe, "EPSG:4326")

s.europe = st_crop(s.europe, c(xmin = -31.170273, ymin = 25.806073, xmax = 53.732071, ymax = 72.397782))
st_crs(s.europe) = crs

s.europe$iso_a2 = countrycode(s.europe$a3, "iso3c", "iso2c")
s.europe$iso_a2[is.na(s.europe$iso_a2)] = "__"

s.europe = s.europe[, c("iso_a2", "geometry")]

plot(s.europe)

st_is_valid(s.europe)


topojson_write(s.europe, file = "assets/geo/europemaptopo.json", object_name = "countries", quantization = 1e4)



# s.europe = st_make_valid(s.europe)

# file.remove("assets/geo/europemap.json")
# st_write(s.europe, "assets/geo/europemap.json", driver = "GEOJSON")




# s.test = st_read("assets/geo/worldmap.json")


# plot(s.test)





# plot(s.world[s.world$iso_a2 == "BR", ])

# # s.world = st_make_valid(s.world)

# st_crs(s.world)



# l.date = st_linestring(x = matrix(c(180, 180, -90, 90), 2, 2), dim = "XY")
# s.date = st_sfc(l.date, crs = crs)




# c.countries.date = st_intersection(s.world, s.date)$iso_a2
# s.world = s.world[!s.world$iso_a2 %in% c.countries.date, ]







# s.countries.date = subset(s.world, a3 %in% c.countries.date)

# s.countries.date.shifted = st_shift_longitude(s.countries.date)
# # plot(s.countries.date.shifted)

# s.world.shifted = rbind(
#     subset(s.world, !a3 %in% c.countries.date),
#     s.countries.date.shifted
# )


# #ggplot() + geom_sf(data = s.countries.date.shifted, aes(fill = a3)) + geom_sf(data = s.date)
# ggplot() + geom_sf(data = s.world.shifted) + theme_void()



# # topojson_write(f, file = "assets/geo/world.json")
# file.remove("assets/geo/worldmap.json")
# st_write(f, "assets/geo/worldmap.json", driver = "GEOJSON")

# ggplot() + geom_sf(data = f) + theme_void()

# t_crs = "ESRI:54030"
# s.world.shifted.r = st_transform(s.world.shifted, t_crs)

# ggplot() + geom_sf(data = s.world.shifted.r) + theme_void()
