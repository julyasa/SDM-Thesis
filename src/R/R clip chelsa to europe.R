setwd("C:/Users/Julia/Documents/2 - UNIPD Sustainable Agriculture/5th Thesis/Github/SDM-Thesis/SDM-Thesis")

install.packages(c("raster", "sf"))
library(raster)
library(sf)


europe <- st_read("area_mask/area_of_interest.gpkg")
raster_files <- list.files("data_env/chelsa/bio", pattern = "\\.tif$", full.names = TRUE)


# Define the output directory for clipped rasters
output_directory <- "data_env/chelsa/bio_clipped/"


# Iterate over each raster file
for (file in raster_files) {
  # Load the raster
  raster_data <- raster(file)
  
  # Transform Europe shapefile to raster CRS
  europe_transformed <- st_transform(europe, crs(raster_data))
  
  # Mask the raster using Europe shapefile
  masked_raster <- mask(raster_data, europe_transformed)
  
  # Generate the output filename
  output_filename <- paste0(output_directory, "clipped_", basename(file))
  
  # Save the masked raster to the specified output folder
  writeRaster(masked_raster, output_filename, format = "GTiff")
}

plot(masked_raster)
