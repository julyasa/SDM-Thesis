#SDM

setwd("C:/Users/Julia/Documents/2 - UNIPD Sustainable Agriculture/5th Thesis/Data")


##environmental data

# Set the directory containing your raster files
dir_path <- "Environmental data/Chelsa"

# List all files in the directory
all_files <- list.files(dir_path, full.names = TRUE)

# Filter the list to include only raster files
raster_files <- all_files[grep(".tif$", all_files, ignore.case = TRUE)]
print(raster_files)

# Load the raster package
library(raster)

# Stack the raster files
raster_stack <- stack(raster_files)

# Print information about the raster stack
print(raster_stack)

plot(raster_stack)




##open occurrence data

triticum <- read.csv("Crop data/Final occurrance data/combined-triticumaestivum-addpresence.csv")
View(triticum)
str(triticum)
# Keep only the desired columns
triticum_essential <- triticum[, c("presence", "Latitude", "Longitude")]

# View the structure of the subsetted dataframe
str(triticum_essential)


#turn csv into spatial df
library(sf)
triticum_spatial <- st_as_sf(triticum_essential, coords = c("Longitude", "Latitude"), crs = 4326)
plot(triticum_spatial)
head(triticum_spatial)
class(triticum_spatial)

#create a subset by random sampling
# Specify the desired sample size
sample_size <- 1000  # Adjust this value to desired sample size

# Perform random sampling
set.seed(123)  # Set a seed for reproducibility
sample_indices <- sample(nrow(triticum_spatial), size = sample_size, replace = FALSE)

# Create a subset of the original dataset using the sampled indices
sampled_triticum_spatial <- triticum_spatial[sample_indices, ]
plot(sampled_triticum_spatial)
triticum_spatial <- sampled_triticum_spatial

#turn into shapefile
st_write(triticum_spatial, "Crop data/Final occurrance data/combined_triticumaestivum.shp")
triticum_shapefile <- shapefile("Crop data/Final occurrance data/combined_triticumaestivum.shp")
class(triticum_shapefile)
plot(triticum_shapefile)
head(triticum_shapefile)



# Convert occurrence data to sdmData format
# option to generate background data within sdmData formula: bg = list(n=1000,method = 'gRandom')
library(sdm)
sdm_data <- sdmData(formula=presence~.,
                    train=triticum_shapefile,
                    predictors=raster_stack,
                    bg = list(n=1000,method = 'gRandom'))
str(sdm_data)
sdm_data



#create models

library(rJava)

m1 <- sdm(presence ~ ., data=sdm_data, methods=c('glm', 'rf'),replication='sub',test.percent=30,n=10
         )
          #other model methods: 'rf', 'bioclim', 'brt', 'gam', 'gbm', 'svm','maxent', 'glm'
m1

getModelInfo(m1)
# roc curves of all model methods, the plots can be smoothed:
roc(m1,smooth=TRUE)

# ipredict the habitat suitability into the whole study area
# since the newdata is a raster object, the output is also a raster object
p1 <- predict(m1,newdata=raster_stack,filename='p1.img') 
plot(p1)