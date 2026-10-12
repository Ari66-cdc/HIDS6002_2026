# EPSG:3083, NAD83 / Texas Centric Albers Equal Area
texas_crs <- "+proj=aea +lat_1=27.5 +lat_2=35 +lat_0=18 +lon_0=-100 +x_0=1500000 +y_0=6000000 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"

# -110, -93.5 transformed using texas_crs
texas_xlim <- c(558298.7, 2112587)
