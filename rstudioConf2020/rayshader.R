library(rayshader)
library(geoviz)

mapbox_key <- "pk.eyJ1IjoiaXZhbGV0dGUiLCJhIjoiY2s3MHN2eWp5MDBpYzNmbXRhZ2RkcmJkNSJ9.5wB9mCxzag_tGyQRnX1nzg"

lat <- 59.9140100
long <- 10.7246670
square_km <- 10


#Get elevation data from Mapbox
dem <- mapbox_dem(lat, long, square_km, api_key = mapbox_key)

#Note: You can get elevation data from Mapzen instead, which doesn't require an API key.
#You'll still need an API key for any mapbox image overlays.
#Get a DEM from mapzen with:
#dem <- mapzen_dem(lat, long, square_km)

#Get an overlay image (Stamen for this example because it doesn't need an API key)
overlay_image <-
  slippy_overlay(dem, image_source = "stamen", image_type = "watercolor", png_opacity = 0.5)


#Optionally, turn mountainous parts of the overlay transparent
overlay_image <-
  elevation_transparency(overlay_image,
                         dem,
                         pct_alt_high = 0.5,
                         alpha_max = 0.9)


#Draw the 'rayshader' scene
elmat = matrix(
  raster::extract(dem, raster::extent(dem), method = 'bilinear'),
  nrow = ncol(dem),
  ncol = nrow(dem)
)

scene <- elmat %>%
  sphere_shade(sunangle = 270, texture = "desert") %>% 
  add_overlay(overlay_image)

rayshader::plot_3d(
  scene,
  elmat,
  zscale = raster_zscale(dem),
  solid = FALSE,
  shadow = TRUE,
  shadowdepth = -150
)

gg_overlay_image <-
  slippy_overlay(
    dem,
    image_source = "stamen",
    image_type = "watercolor",
    return_png = FALSE
  )

ggplot2::ggplot() +
  ggslippy(gg_overlay_image)

