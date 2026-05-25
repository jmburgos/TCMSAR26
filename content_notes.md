# Content Notes — TCMSAR26

Compiled from a full read of all `.qmd` files and participant registration data,
May 2026. For course authors: covers participant profile, schedule sequencing,
content gaps, cross-chapter overlap, and a full data usage tally.

---

## 0. Participant profile and course alignment

Source: `data-raw/TCMSAR26_Participants_info-for-instructors.xlsx` (n = 25).

### Who is in the room

| Status | n |
|---|---|
| Researcher | 7 |
| Practitioner | 6 |
| PhD student / researcher | 5 |
| Data analyst | 3 |
| Technical officer | 2 |
| MSc student | 2 |

Institutions span Ireland (Marine Institute, 6 participants), Poland (National
Marine Fisheries Research Institute, 4), Spain (IEO Santander, CETMAR, IMEDEA),
the Netherlands (Wageningen), Sweden (SLU), Finland (LUKE), Northern Ireland
(AFBI, 2), Latvia (BIOR, 2), Italy (Sicily Marine Centre, University of Bari),
Germany (Hamburg), and England (Natural England, 2).

Most participants have R experience and use it regularly; the course is not
starting from zero. Six participants currently use QGIS or ArcGIS as their
primary spatial tool and want to move workflows into R. One participant
explicitly still uses the legacy **sp** package.

### Primary use cases (non-exclusive)

| Use case | n | Key participants |
|---|---|---|
| Fisheries surveys, VMS, ICES data | 12 | DATRAS, SMB, OSPAR VMS data calls |
| Offshore renewable energy / MSP | 11 | ORE site selection, buffer/impact zones |
| Seabed habitat mapping | 7 | Multibeam rasters, benthic classification |
| Marine ecology / species distribution | 7 | SDMs, climate range shifts, biodiversity |

The two largest groups — fisheries and ORE/MSP — partially overlap: several
participants work on fishing footprint or trawling intensity in the context of
wind farm development.

### Alignment with current course content

**Well served:**

- *Fisheries/ICES cohort*: The course dataset is near-perfect for this group.
  DATRAS (spatial_ops.qmd), SMB survey data (sf, rasters, interpolation,
  interactive), and `small_vms.csv` map directly onto what these participants
  do daily. The ICES working group members (participants 9, 10, 13, 14, 15)
  will recognise the data immediately.
- *GIS-to-R transition*: The practical chapter-by-chapter approach, with code
  that runs on real data, is exactly what GIS practitioners need. The
  `input_output.qmd` chapter (file formats, GDAL) is specifically useful for
  people arriving from QGIS/ArcGIS.
- *sp-to-sf transition*: The "sp class (legacy)" section in `sf.qmd` with
  conversion code directly addresses the one participant still using sp — and
  likely others who have inherited sp-based code.
- *Interpolation / species distribution*: The kriging and IDW examples in
  `interpolation.qmd` are directly applicable to habitat and ecology
  participants building species distribution models.

**Underserved:**

- *ORE / MSP cohort (11 participants)*: This is the most significant gap.
  Nearly half the participants work in offshore wind or marine spatial planning,
  yet no chapter uses this framing. The operations they need — buffers around
  protected areas, intersection of proposed development zones with fishing
  intensity layers, suitability analysis — are all covered technically in
  `geometric.qmd` and `spatial_ops.qmd`, but the examples use fisheries survey
  data only. At minimum, the exercises in those two chapters could offer an
  ORE/MSP variant alongside the fisheries variant.

- *Large rasters from acoustic surveys (seabed mapping, 7 participants)*:
  `rasters.qmd` covers `terra` thoroughly but its examples use relatively small
  climatological rasters. Participants who will be processing multibeam DEMs
  would benefit from a note on handling large rasters (chunked reading,
  windowed writing, `terraOptions(memfrac = ...)`).

### The unused OSPAR dataset is the most direct missed opportunity

`OSPAR_intensity_Otter_2015.gpkg` (91,190 polygon features of otter trawl
fishing intensity, already in `data/`) is described in `data.qmd` but used
nowhere in the course. It is simultaneously the most relevant dataset for the
fisheries cohort (direct output of the ICES VMS Data Call workflow several
participants contribute to) and for the ORE/MSP cohort (trawling intensity is
a standard input to wind farm impact assessments). It is also large enough to
make a good performance example in `spatial_ops.qmd` or `interactive.qmd`.

Key columns: `FishingH` (fishing hours), `KWfishingH` (kW-fishing hours, a proxy
for effort), `SurfSAR` (surface swept area ratio), `totweight`, `totvalue`.

Suggested uses:

| Chapter | Exercise suggestion |
|---|---|
| `spatial_ops.qmd` | Spatial join with `ices_ecoregions.gpkg` → aggregate `FishingH` or `SurfSAR` by ecoregion; compare to a protected area polygon |
| `ggplot2.qmd` | Side-by-side maps of `SurfSAR` vs `KWfishingH` using `patchwork`; `geom_sf` with viridis fill and log transform |
| `interactive.qmd` | Leaflet choropleth of fishing intensity, giving participants a meaningful large-polygon interactive map exercise |

---

## 1. Schedule sequencing

### Current schedule

| Day | Time | Chapter | Content duration |
|---|---|---|---|
| Mon | 10:00–17:00 | intro → spatial_data → ggplot1 | 5h30m |
| Tue | 09:00–17:00 | sf → geometric → spatial_ops (start) | 6h30m |
| Wed | 09:00–17:00 | spatial_ops (cont.) → **crs** → rasters | 6h15m |
| Thu | 09:00–17:00 | rasters (cont.) → input_output → ggplot2 → interactive | 6h30m |
| Fri | 09:00–14:00 | interpolation → wrap-up | 3h45m |

### The core problem: `crs.qmd` is taught too late

`crs.qmd` (Wednesday, session 8) is a prerequisite for `geometric.qmd` (Tuesday,
session 5) and `spatial_ops.qmd` (sessions 6–7). Both chapters use `st_transform()`
with bare EPSG codes before students have been taught what an EPSG code is, what an
ellipsoid or datum is, or how to choose a projection:

- `geometric.qmd` opens with `nfu |> st_transform(3395)` inside a `callout-important`
  that says "always project your data before geometric operations" — but cannot explain
  *why 3395*, what World Mercator implies, or how a student would find an appropriate
  CRS for their own data.
- `spatial_ops.qmd` uses `st_transform(3035)` (ETRS89-LAEA) in the distance-based
  subsetting section and explains that "distances in degrees are meaningless" — the
  conceptual foundation for this statement arrives the next morning.
- The "CRS must match" callout in `spatial_ops.qmd` tells students to use
  `st_crs(a) == st_crs(b)` — a function not introduced until `crs.qmd`.

The effect is that students are told to use tools (`st_transform`, `st_crs`,
`st_is_longlat`) and accept specific projection choices on faith for an entire day
before the chapter that explains them.

### Secondary issue: `geom_sf()` used informally throughout before `ggplot2.qmd`

In the current schedule, `geom_sf()` and `coord_sf()` are used as visualisation
tools in `sf.qmd`, `geometric.qmd`, `spatial_ops.qmd`, and `crs.qmd` (sessions 4–8)
before `ggplot2.qmd` (session 11, Thursday) formally introduces them. `sf.qmd`
acknowledges this with a brief note ("see the CRS chapter for details on
`coord_sf()`"). The proposed schedule below resolves this almost entirely by
moving `ggplot2.qmd` to Tuesday.

### Secondary issue: `input_output.qmd` is late, but defensibly so

`read_sf()`, `rast()`, and `read_csv()` are used throughout the course from Tuesday
onwards, but the formal treatment of file formats, GDAL, and format choices
(`input_output.qmd`) is placed on Thursday morning. This "learn by doing first, then
understand the infrastructure" ordering is deliberate and defensible. Students can
read files without knowing about GDAL; knowing they are using GeoPackages rather
than shapefiles, and why that matters, can wait.

---

### Proposed alternative schedule

Two changes resolve the main sequencing problems: move `crs.qmd` to Tuesday
afternoon and place `ggplot2.qmd` immediately after it — still on Tuesday. This
creates a tight conceptual sequence on day 2: the sf class → CRS → drawing sf
maps with proper projections. `geometric.qmd` and `spatial_ops.qmd` then follow
on Wednesday with full knowledge of CRS, projection choices, and how to visualise
their outputs with `geom_sf()`. The Thursday slot freed by moving `ggplot2.qmd`
is absorbed by `interactive.qmd`, which benefits from the extra time.

| Day | Time | Chapter | Duration |
|---|---|---|---|
| Mon | 10:00–13:00 | intro + spatial_data | unchanged |
| Mon | 14:00–17:00 | ggplot1 | unchanged |
| **Tue** | 09:00–12:00 | sf | 2h45m (unchanged) |
| **Tue** | 13:00–15:15 | **crs** | 2h15m (moved from Wed) |
| **Tue** | 15:30–17:00 | **ggplot2** | 1h30m (moved from Thu) |
| **Wed** | 09:00–10:45 | geometric — generators | sampling, centroids, buffers, hulls, grids, simplification |
| **Wed** | 11:00–12:00 | geometric — measurements | area, length, distance, aggregation, AGR |
| **Wed** | 13:00–14:30 | spatial_ops | 1h30m |
| **Wed** | 14:45–17:00 | rasters (start) | 2h15m |
| Thu | 09:00–09:30 | rasters (cont.) | unchanged |
| Thu | 09:30–10:30 | input_output | unchanged |
| Thu | 10:45–12:00 | **interactive (start)** | 1h15m earlier start |
| Thu | 13:00–17:00 | interactive (cont.) | unchanged |
| Fri | 09:00–14:00 | interpolation + wrap-up | unchanged |

The learning arc for Tuesday becomes coherent end to end: "here is the sf class"
→ "here is what CRS means" → "here is how to draw sf maps with the right
projection." `geometric.qmd` and `spatial_ops.qmd` on Wednesday no longer need
to ask students to take projection choices on faith, and every `geom_sf()` call
in those chapters is backed by formal knowledge from the evening before.

`ggplot2.qmd` gets 1h30m — compact but workable given its content (see §2).
The only unavoidable forward reference that remains is `sf.qmd`'s brief use of
`geom_sf()` on Tuesday morning, before the formal introduction in Tuesday evening's
`ggplot2.qmd`. This is minor: `sf.qmd` needs to show how sf objects look, and
telling students "this is `geom_sf()`, we cover it fully after lunch on Thursday"
→ "we cover it fully later today" is a much shorter gap.

---

## 2. `ggplot2.qmd` — content structure and raster split

### Content structure

`ggplot2.qmd` (`execute: enabled: false`) covers sf-native vector mapping only.
Raster visualisation has been split out and lives in `rasters.qmd` (see below).

| Section | Content |
|---|---|
| Setup | Libraries: `sf`, `rnaturalearth`, `rnaturalearthdata`, `ggspatial`, `patchwork`; data: `minke_sf`, `iceland_sf`, `world_sf`, `nfu`, `coast`, `contours`, `smb`, `smb2019` |
| From ggplot1 to `geom_sf()` | Side-by-side: `maps`/`geom_polygon` (ggplot1 approach) vs `rnaturalearth`/`geom_sf` (modern approach) |
| Basemaps with rnaturalearth | `ne_countries()`, adding sf point layers, zooming with `coord_sf(xlim, ylim)` |
| Projections with `coord_sf()` | WGS84 / LAEA / Stereographic comparison; mixing layers with different CRS — cross-reference to `crs.qmd` |
| Labels | `geom_sf_label()` with centroid positions; brief note on `geom_sf_text()` |
| Facetting | `facet_wrap()` (cod by year); `facet_grid()` (cod vs haddock × year, via `pivot_longer` on `smb_summary.csv`) |
| Axis formatting | `scale_longitude()` / `scale_latitude()` helpers; ICES rectangle labels (requires `hafro/geo`) |
| Map embellishments | `annotation_scale()`, `annotation_north_arrow()` (ggspatial); `theme_void()`; `inset_element()` |
| Gridding | `grade()` function; `st_make_grid()` + `st_join()` |
| Final exercise | Join `is_smb_biological.csv` to `is_smb_stations.csv`, facetted map + time series |

No raster-specific libraries (`terra`, `tidyterra`, `marmap`) are loaded.

### Raster visualisation lives in `rasters.qmd`

`rasters.qmd` already has a "Rasters and ggplot" section covering `geom_spatraster()`
and `geom_raster()`. This is the appropriate home: students see terra's data model
first, then immediately see how to visualise it with ggplot. With `rasters.qmd` on
Wednesday afternoon (after `ggplot2.qmd` on Tuesday), students arrive already knowing
`geom_sf()` and `coord_sf()`, so the `geom_spatraster()` section in `rasters.qmd`
only needs to introduce the tidyterra layer — the ggplot grammar around it is already
familiar.

`interpolation.qmd` also uses `geom_spatraster()` on Friday, by which point students
have seen it twice (rasters.qmd Wednesday, repeated use in any rasters exercises).
No redundancy problem there.

**Remaining issue:** `execute: enabled: false`. The file should render cleanly once
enabled. The `getNOAA.bathy()` call (used in `ggplot1.qmd`) is not present in
`ggplot2.qmd`, so no internet dependency here. The `coord_sf` example reads
`iceland_coastline.gpkg` and `iceland_contours.gpkg` from local `data/` — both
available via the download script.

---

## 3. Cross-document content overlap

### `geom_sf()` / `coord_sf()` — resolved by proposed schedule

Under the current schedule, `geom_sf()` is used in `sf.qmd`, `geometric.qmd`, and
`spatial_ops.qmd` with no prior formal introduction. Under the proposed schedule,
`ggplot2.qmd` (Tuesday evening) is the formal introduction, and `geometric.qmd`
and `spatial_ops.qmd` follow on Wednesday — so the forward-reference problem is
eliminated for those chapters.

`crs.qmd` has a dedicated "Projections in ggplot2" section covering `coord_sf()`'s
CRS-handling behaviour. With `ggplot2.qmd` immediately following `crs.qmd` in the
proposed schedule, this section serves as a direct preview that students act on
minutes later. The two treatments are complementary: `crs.qmd` explains *why* to
set a CRS; `ggplot2.qmd` shows *how* to use it for maps. No editing needed.

### `geom_spatraster()` — resolved by raster split

`rasters.qmd` is now the canonical home. `interpolation.qmd` uses it on Friday after
students have already seen it on Wednesday. The old `ggplot.qmd` is superseded.
No remaining redundancy.

### Raster data model — `spatial_data.qmd` ↔ `rasters.qmd`

Both files embed the same two images (`img/raster1.png`, `img/raster2.png`) and
independently explain cells, extent, resolution, and origin with near-identical prose.
`spatial_data.qmd` introduces the concept on Monday; `rasters.qmd` re-introduces it
from scratch on Wednesday without referring back. A one-line forward reference in
`spatial_data.qmd` and a one-line back-reference in `rasters.qmd` would resolve this.

### R ecosystem history (sp → sf, raster → terra) — five files

The transition is restated independently in: `spatial_data.qmd` (full history),
`intro.qmd` (package list), `sf.qmd` (sp legacy section with conversion code),
`rasters.qmd` (callout), and `input_output.qmd` (rgdal retirement callout).
The `spatial_data.qmd` treatment is authoritative; the others are restatements that
could be replaced with a cross-reference.

### "Always project before geometric operations" — three independent callouts

`geometric.qmd`, `spatial_ops.qmd`, and `interpolation.qmd` each contain a
`callout-important` making the same point without cross-referencing `crs.qmd`.
Under the proposed schedule, `crs.qmd` precedes both `geometric.qmd` and
`spatial_ops.qmd`, so these callouts can be simplified to a one-line reference
("as covered in the [CRS chapter](crs.qmd)") rather than restating the concept.
`interpolation.qmd` is further downstream and can do the same.

### `read_sf()` vs `st_read()` — explained twice

Both `sf.qmd` (callout note) and `input_output.qmd` explain the difference
independently. The note in `sf.qmd` is appropriate as a brief practical aside;
the paragraph in `input_output.qmd` is redundant and can be removed.

### Datasets used as primary examples in multiple chapters

| Dataset | Chapters |
|---|---|
| `nephrops_fu.gpkg` | sf, geometric, spatial_ops, **ggplot2**, interactive |
| `ices_ecoregions.gpkg` | sf, geometric, spatial_ops, interactive |
| `is_smb_stations.csv` | sf, rasters, interactive, interpolation |
| `smb_summary.csv` | ggplot1, **ggplot2**, interactive |
| `minke.csv` | ggplot1, **ggplot2**, interactive, input_output |
| `datras_2018_haul.csv` | spatial_ops, interactive (exercise) |
| `Iceland_minbtemp.tif` | rasters, interactive, input_output |
| `iceland_coastline.gpkg` | **ggplot2**, crs, rasters, interpolation |

Reuse is generally good. `nephrops_fu.gpkg` now appears in five chapters; by the
time students reach `interactive.qmd` they know the dataset well, so the loading
boilerplate in that chapter could be collapsed to a brief reminder.

---

## 4. Full data usage tally

`(ex)` = exercise/callout only &nbsp;`(ftp)` = read via FTP URL not local `data/` &nbsp;`(cmtd)` = commented out

### Tabular (CSV)

| File | ggplot1 | ggplot2 | sf | spatial_ops | rasters | input_output | interactive | interpolation | **n** |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| `minke.csv` | ✓ | ✓ | | | | ✓(ftp) | ✓ | | **4** |
| `smb_summary.csv` | ✓ | ✓ | | | | | ✓ | | **3** |
| `is_smb_stations.csv` | | | ✓ | | ✓(ftp) | | ✓ | ✓(ftp) | **4** |
| `is_smb_biological.csv` | | | ✓ | | | | | ✓(ftp) | **2** |
| `small_vms.csv` | ✓(cmtd) | | ✓ | | | | | | **1** |
| `datras_2018_haul.csv` | | | | ✓ | | | ✓(ex) | | **2** |
| `datras_2018_length.csv` | | | | ✓ | | | | | **1** |
| `smb_utbrteg.csv` | | | | | | | | | **0** |

### Spatial vector (GeoPackage)

| File | ggplot2 | sf | geometric | spatial_ops | crs | rasters | input_output | interactive | **n** |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| `nephrops_fu.gpkg` | ✓ | ✓ | ✓ | ✓ | | | | ✓ | **5** |
| `ices_ecoregions.gpkg` | | ✓ | ✓ | ✓ | | | | ✓ | **4** |
| `iceland_coastline.gpkg` | ✓ | | | | ✓(ftp) | ✓(ftp) | | | ✓(ftp) | **4** |
| `helcom.gpkg` | | ✓(ex) | ✓(ftp) | | | | | | **2** |
| `iceland_contours.gpkg` | ✓ | | | | ✓(ftp) | | | | **2** |
| `ice_points.gpkg` | | | | | | ✓(ftp) | | | **1** |
| `ice_lines.gpkg` | | | | | | ✓(ftp) | | | **1** |
| `ice_polygon.gpkg` | | | | | | ✓(ftp) | | | **1** |
| `ices_rectangles.gpkg` | | | | | | | | | **0** |
| `OSPAR_intensity_Otter_2015.gpkg` | | | | | | | | | **0** |

### Rasters (GeoTIFF)

| File | rasters | input_output | interactive | **n** |
|---|:---:|:---:|:---:|:---:|
| `Iceland_minbtemp.tif` | ✓(ftp)† | ✓(ftp) | ✓ | **3** |
| `Iceland_maxbtemp.tif` | ✓(ftp) | ✓(ftp) | | **2** |
| `Iceland_currentsp.tif` | ✓(ftp) | | | **1** |
| `Faroes_minbtemp.tif` | ✓(ftp) | | | **1** |
| `nephrops.tif` | | | | **0** |

† `rasters.qmd` line 66 reads `"./data/Iceland_btemp.tif"` — wrong filename,
will fail when `execute: enabled` is turned on. Correct name: `Iceland_minbtemp.tif`.

### Package / web data

| Source | Used in |
|---|---|
| `map_data("world", "Iceland")` [maps package] | ggplot1 |
| `getNOAA.bathy()` [marmap] | ggplot1, rasters |
| `ne_countries()` [rnaturalearth] | ggplot2, crs, interactive |

### Files used in chapters but absent from `data.qmd` download script

| File | Used in | Nature of use |
|---|---|---|
| `ospar.gpkg` | `spatial_ops.qmd` (polygon join, main example); `sf.qmd` (exercise) | Active code — will fail |
| `bormicon.gpkg` | `rasters.qmd` (rasterization example, via ftp) | Active code |
| `is_smb.csv` | `interactive.qmd` (Shiny example, via ftp) | Active code |
| `is_smb_vms2019.csv` | `ggplot1.qmd` (commented out) | Commented out only |

### Files in `data.qmd` but unused in any chapter

| File | Note |
|---|---|
| `smb_utbrteg.csv` | Described as the raw source for `smb_summary.csv`; no exercise uses it |
| `ices_rectangles.gpkg` | Listed; not used in any chapter |
| `OSPAR_intensity_Otter_2015.gpkg` | Listed; not used in any chapter |
| `nephrops.tif` | Listed; not used in any chapter |

### FTP vs local `data/` inconsistency

Several files that exist in `data/` are still read via `ftp://ftp.hafro.is/...`
in some chapters. Those chapters will fail offline even though the files are
available locally via the download script.

| File | Chapters reading via FTP |
|---|---|
| `iceland_coastline.gpkg` | crs, rasters, interpolation |
| `helcom.gpkg` | geometric |
| `Iceland_minbtemp.tif` | rasters, input_output |
| `Iceland_maxbtemp.tif` | rasters, input_output |
| `Iceland_currentsp.tif` | rasters |
| `Faroes_minbtemp.tif` | rasters |
| `ice_points/lines/polygon.gpkg` | rasters |
| `is_smb_stations.csv` | rasters, interpolation |
| `is_smb_biological.csv` | interpolation |
| `minke.csv` | input_output |
