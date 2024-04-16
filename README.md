# Master Thesis project - Assessment of suitability shift of important grains in Europe


## How to use the repository


### Clip raster data

To clip raster data, use the jupyter notebook `clip_raster`, available in `src/jupyter`.

- Add environmental tif layers to the folder `data_env`, in the subfolder `chelsa/bio`
- Clipped rasters will be added to subfolder `chelsa/bio_clipped`

The mask layer is a vectorial layer with the name `aoi_extracted`, that is inside the
geopackage `/area_mask/area_of_interest.gpkg`.

Alternatively, use the jupyter notebook `clip_raster_parallel`, in `src/jupyter`, to clip in parallel processing.
