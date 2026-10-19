# One function per plot. Each returns a ggplot object.
# Paste chapter code into the body and note its source above it.
# Put any data prep inside the function so each plot is self-contained.

# from dataviz ch. XX (replace with the real chapter)
# B19013_001: Median household income in the past 12 months (in 2015 Inflation-adjusted dollars)

quant_color_seq <- function() {
texas_income %>% st_transform(crs = texas_crs) %>%
  ggplot(aes(fill = estimate)) + 
  geom_sf(color = "white") + 
  coord_sf(xlim = texas_xlim, datum = NA) +
  theme_dviz_map() + 
  scale_fill_distiller(
    palette = "Blues", type = 'seq', na.value = "grey60", direction = 1,
    name = "annual median income\n(USD in Thousands)",
    limits = c(18000, 90000),
    breaks = 20000*c(1:4),
    labels = c("$20", "$40", "$60", "$80"),
    guide = guide_colorbar(
      direction = "horizontal",
      label.position = "bottom",
      title.position = "top",
      ticks = FALSE,
      barwidth = grid::unit(2.0, "in"),
      barheight = grid::unit(0.2, "in")
    )
  ) +
  theme(
    legend.title.align = 0.5,
    legend.text.align = 0.5,
    legend.justification = c(0, 0),
    legend.position = c(0.02, 0.1)
  )
}
