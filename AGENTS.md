# TCMSAR26 — Project Memory

## What this project is

A 5-day course on **mapping and spatial analysis with R**, aimed at fisheries and marine science researchers. The course is taught by Julian M. Burgos and Einar Hjörleifsson (Marine and Freshwater Research Institute, Iceland).

- **Course website (rendered):** https://heima.hafro.is/~julian/TCMSAR26/index.html
- **GitHub repository:** https://github.com/jmburgos/TCMSAR26

## Project structure

The project is a **Quarto website** (`_quarto.yml`, `output-dir: _site/`), using the `cosmo` theme with a docked sidebar.

### Source files (`.qmd`)

| File | Sidebar title |
|---|---|
| `index.qmd` | Home (course schedule and contact) |
| `intro.qmd` | Introduction |
| `spatial_data.qmd` | Spatial data |
| `ggplot1.qmd` | Mapping with ggplot — part 1 |
| `sf.qmd` | Simple features |
| `geometric.qmd` | Working with geometries in sf objects |
| `spatial_ops.qmd` | Spatial operations |
| `crs.qmd` | Coordinate reference systems |
| `rasters.qmd` | Rasters |
| `input_output.qmd` | Reading and writing spatial data |
| `ggplot2.qmd` | Mapping with ggplot — part 2 (not yet created) |
| `interactive.qmd` | Interactive maps |
| `interpolation.qmd` | Interpolation |
| `data.qmd` | Data (dataset descriptions + download script) |
| `ggplot.qmd` | *(legacy file, superseded by ggplot1/2, not in nav)* |

### Other directories

| Path | Contents |
|---|---|
| `data/` | All course datasets (CSV, GeoPackage, GeoTIFF) |
| `data-raw/` | `DATASETS_recovery.R` — script used to fetch and prepare datasets |
| `img/` | Images used in the course pages |
| `site/` | Rendered HTML output (Quarto output-dir) |

## Data

All datasets live in `data/`. They are available for download from:
`https://raw.githubusercontent.com/jmburgos/TCMSAR26/main/data/<filename>`

Full descriptions of every dataset are in `data.qmd`.

### Tabular (CSV) — read with `read_csv()`

| File | Rows | Key content |
|---|---|---|
| `datras_2018_haul.csv` | 3,145 | DATRAS 2018 haul-level survey metadata (62 cols) |
| `datras_2018_length.csv` | 490,564 | DATRAS 2018 species length-frequency data; joins to haul via `id` |
| `minke.csv` | 190 | Minke whale biological samples (morphometrics, age, stomach contents) |
| `small_vms.csv` | 1,070 | Vessel Monitoring System positions (id, lon, lat) |
| `is_smb_stations.csv` | 19,846 | Icelandic SMB spring survey station metadata (1990–); joins to biological via `id` |
| `is_smb_biological.csv` | 68,834 | Icelandic SMB catch by species, in long format; links to stations via `id` |
| `smb_utbrteg.csv` | ~21k | Raw SMB data with Icelandic variable names |
| `smb_summary.csv` | 21,582 | Processed SMB tow-level catch totals (cod, saithe, haddock, lumpfish); English names |

### Spatial vector (GeoPackage) — read with `read_sf()`

| File | Features | Geometry | CRS |
|---|---|---|---|
| `helcom.gpkg` | 17 | MULTIPOLYGON | WGS 84 (4326) |
| `ice_lines.gpkg` | 3 | LINESTRING | Projected (unnamed, m) |
| `ice_points.gpkg` | 5 | POINT | Projected (unnamed, m) |
| `ice_polygon.gpkg` | 2 | POLYGON | Projected (unnamed, m) |
| `iceland_coastline.gpkg` | 1 | MULTIPOLYGON | Projected (LAEA, m) |
| `iceland_contours.gpkg` | 6 | MULTILINESTRING | WGS 84 (4326) |
| `ices_ecoregions.gpkg` | 17 | MULTIPOLYGON | WGS 84 (4326) |
| `ices_rectangles.gpkg` | 6,758 | POLYGON | WGS 84 (4326) |
| `nephrops_fu.gpkg` | 30 | POLYGON | WGS 84 (4326) |
| `OSPAR_intensity_Otter_2015.gpkg` | 91,190 | POLYGON | WGS 84 (4326) |

### Rasters (GeoTIFF) — read with `rast()` (terra)

| File | Resolution | CRS | Value range |
|---|---|---|---|
| `Faroes_minbtemp.tif` | 2000 m | LAEA | -1.23 to 8.91 °C |
| `Iceland_currentsp.tif` | ~0.017° | WGS 84 (4326) | 0.002 to 0.291 m/s |
| `Iceland_maxbtemp.tif` | 2000 m | LAEA | -0.99 to 9.82 °C |
| `Iceland_minbtemp.tif` | 2000 m | LAEA | -1.00 to 8.60 °C |
| `nephrops.tif` | ~0.001° | WGS 84 (4326) | 1–40 (integer index) |

## Key packages used

- **`sf`** — vector spatial data (reading, writing, operations)
- **`terra`** — raster data
- **`tidyverse`** (incl. `ggplot2`, `dplyr`, `readr`) — data wrangling and plotting
- **`leaflet`** — interactive maps
- **`tidyterra`** — ggplot2 integration for terra SpatRaster objects (`geom_spatraster()`)
- **`patchwork`** — combining ggplot figures
- **`ggspatial`** — scale bars, north arrows (`annotation_scale()`, `annotation_north_arrow()`)
- **`gstat`** + **`automap`** — interpolation (IDW, kriging, variograms)
- **`mgcv`** — GAMs with spatial smooths
- **`marmap`** — NOAA bathymetry download (`getNOAA.bathy()`)
- **`rnaturalearth`** / **`rnaturalearthdata`** — country polygons as sf objects
- **`crsuggest`** — CRS selection helper
- **`mapview`**, **`tmap`**, **`ggiraph`** — interactive / quick-look maps

## Document status (`execute: enabled`)

Tracks whether each `.qmd` renders its code chunks. Files with no `execute:` block in their YAML default to `enabled: true` (the Quarto default); ✅ covers both cases.

| File | Status | Note |
|---|---|---|
| `index.qmd` | — | no code |
| `intro.qmd` | — | no code |
| `spatial_data.qmd` | — | no code |
| `data.qmd` | ✅ | `enabled: true` |
| `ggplot1.qmd` | ✅ | `enabled: true` |
| `sf.qmd` | ✅ | no execute block (default) |
| `geometric.qmd` | ✅ | no execute block (default) |
| `spatial_ops.qmd` | ✅ | no execute block (default) |
| `crs.qmd` | ✅ | no execute block (default) |
| `interactive.qmd` | ✅ | `enabled: true` |
| `rasters.qmd` | ❌ | `enabled: false` |
| `input_output.qmd` | ❌ | `enabled: false` |
| `ggplot2.qmd` | ❌ | `enabled: false`; content complete but not yet tested |
| `interpolation.qmd` | ❌ | `enabled: false` |
| `ggplot.qmd` | *(legacy)* | superseded by ggplot1/2 |
| `ospar_intensity.qmd` | ❌ | `enabled: false`; standalone OSPAR fishing intensity chapter; not yet in nav |

## Known bugs and missing files

### Broken file path
- **`rasters.qmd` line 66**: reads `"./data/Iceland_btemp.tif"` — file does not exist.
  Correct path is `"./data/Iceland_minbtemp.tif"`. Will cause a render error when
  `execute: enabled` is turned on for that file.

### Files used in chapters but missing from the `data.qmd` download script
These will cause failures when students run the affected chapters:

| File | Used actively in |
|---|---|
| `ospar.gpkg` | `spatial_ops.qmd` (polygon join example), `sf.qmd` (exercise) |
| `bormicon.gpkg` | `rasters.qmd` (rasterization, via ftp URL) |
| `is_smb.csv` | `interactive.qmd` (Shiny example, via ftp URL) |

### Files in `data.qmd` but never used in any chapter
`smb_utbrteg.csv`, `ices_rectangles.gpkg`, `OSPAR_intensity_Otter_2015.gpkg`, `nephrops.tif`

### FTP vs local path inconsistency
Several files that exist in `data/` are still read via `ftp://ftp.hafro.is/...`
in some chapters (`iceland_coastline.gpkg`, `helcom.gpkg`, all raster TIFFs in
`rasters.qmd`, `is_smb_stations.csv` in `rasters.qmd` and `interpolation.qmd`,
`is_smb_biological.csv` in `interpolation.qmd`). These chapters will fail offline
even though the files are in `data/`.

## Content audit

See [`content_notes.md`](content_notes.md) for:
- Schedule sequencing issues (`crs.qmd` taught after chapters that require it) and a proposed alternative schedule (CRS + ggplot2 on Tuesday, geometric moves to Wednesday)
- `ggplot2.qmd` content structure: sf-only vector mapping; raster visualisation split to `rasters.qmd` ("Rasters and ggplot" section already present)
- Full content overlap analysis across chapters
- Complete data usage tally (which dataset appears in which chapter)

## Rendering

```r
quarto::quarto_render()   # renders to site/
```
