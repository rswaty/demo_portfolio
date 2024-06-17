

## Map examples ------

# Randy Swaty
# June 17, 2024
# Code to demo inserting a locator map



## Make a simple locator map

# load packages
library(sf)
library(terra)
library(tidyverse)
library(tmap)

#  read shapefile
shp <- st_read("data/") %>% 
  st_transform(crs = 5070) %>%
  st_union() %>%
  st_sf()



# toggle tmap mode to interactive viewing
tmap_mode("view")

# create a quick interactive map
quickmap <- qtm(shp, 
                borders = "darkgreen", 
                fill = NULL, 
                check.and.fix = TRUE, 
                basemaps = 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}',
                title = 'Ouachita National Forest',)

quickmap
