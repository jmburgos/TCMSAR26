library(tidyverse)
library(sf)

sa <- read_sf("/Local_Nature_Recovery_Strategy_Areas_England.gpkg") |>
  select(name)

sab <- sa |>
  st_union()

b1 <- sab |> st_buffer(dist = 500)
b2 <- sab |> st_buffer(dist = -500)

bf <- st_difference(b1, b2)

sal <- sa |>
  st_cast("MULTILINESTRING") |>
  st_cast("LINESTRING") |>
  st_intersection(bf) |>
  st_cast("MULTILINESTRING") |>
  st_cast("LINESTRING") |>
  mutate(length = st_length(shape), length = units::set_units(length, km)) |>
  st_drop_geometry() |>
  group_by(name) |>
  summarise(length = sum(length))
