library(sf)
library(terra)
# Not the most efficent way:

read_csv("https://heima.hafro.is/~einarhj/data/datras_2018_haul.csv")    |> write_csv("data/datras_2018_haul.csv")
read_csv("https://heima.hafro.is/~einarhj/data/datras_2018_length.csv")  |> write_csv("data/datras_2018_length.csv")
read_csv("https://heima.hafro.is/~einarhj/data/small_vms.csv")           |> write_csv("data/small_vms.csv")
read_csv("https://heima.hafro.is/~einarhj/data/minke.csv")               |> write_csv("data/minke.csv")
read_csv("https://heima.hafro.is/~einarhj/data/is_smb_stations.csv")     |> write_csv("data/is_smb_stations.csv")
read_csv("https://heima.hafro.is/~einarhj/data/is_smb_biological.csv")   |> write_csv("data/is_smb_biological.csv")

read_sf("https://heima.hafro.is/~einarhj/data/helcom.gpkg")                     |> write_sf("data/helcom.gpkg")
read_sf("https://heima.hafro.is/~einarhj/data/ice_lines.gpkg")                  |> write_sf("data/ice_lines.gpkg")
read_sf("https://heima.hafro.is/~einarhj/data/ice_points.gpkg")                 |> write_sf("data/ice_points.gpkg")
read_sf("https://heima.hafro.is/~einarhj/data/ice_polygon.gpkg")                |> write_sf("data/ice_polygon.gpkg")
read_sf("https://heima.hafro.is/~einarhj/data/iceland_coastline.gpkg")          |> write_sf("data/iceland_coastline.gpkg")
read_sf("https://heima.hafro.is/~einarhj/data/iceland_contours.gpkg")           |> write_sf("data/iceland_contours.gpkg")
read_sf("https://heima.hafro.is/~einarhj/data/ices_ecoregions.gpkg")            |> write_sf("data/ices_ecoregions.gpkg")
read_sf("https://heima.hafro.is/~einarhj/data/ices_rectangles.gpkg")            |> write_sf("data/ices_rectangles.gpkg")
read_sf("https://heima.hafro.is/~einarhj/data/nephrops_fu.gpkg")                |> write_sf("data/nephrops_fu.gpkg")
read_sf("https://heima.hafro.is/~einarhj/data/OSPAR_intensity_Otter_2015.gpkg") |> write_sf("data/OSPAR_intensity_Otter_2015.gpkg")

rast("https://heima.hafro.is/~einarhj/data/Faroes_minbtemp.tif")    |> writeRaster("data/Faroes_minbtemp.tif")
rast("https://heima.hafro.is/~einarhj/data/Iceland_currentsp.tif")  |> writeRaster("data/Iceland_currentsp.tif")
rast("https://heima.hafro.is/~einarhj/data/Iceland_maxbtemp.tif")   |> writeRaster("data/Iceland_maxbtemp.tif")
rast("https://heima.hafro.is/~einarhj/data/Iceland_minbtemp.tif")   |> writeRaster("data/Iceland_minbtemp.tif")
rast("https://heima.hafro.is/~einarhj/data/nephrops.tif")           |> writeRaster("data/nephrops.tif")

