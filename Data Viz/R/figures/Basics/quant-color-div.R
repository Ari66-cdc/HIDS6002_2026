quant_color_div <- function() {
texas_race %>% st_sf() %>%
  st_transform(crs = texas_crs) %>%
  filter(variable == "White") %>%
  ggplot(aes(fill = pct)) +
  geom_sf(color = "white") +
  coord_sf(xlim = texas_xlim, datum = NA) + 
  theme_dviz_map() +
  scale_fill_continuous_divergingx(
    palette = "Earth",
    mid = 50,
    limits = c(0, 100),
    breaks = 25*(0:4),
    labels = c("0% ", "25%", "50%", "75%", " 100%"),
    name = "percent identifying as white",
    guide = guide_colorbar(
      direction = "horizontal",
      label.position = "bottom",
      title.position = "top",
      ticks = FALSE,
      barwidth = grid::unit(3.0, "in"),
      barheight = grid::unit(0.2, "in"))) +
  theme(
    legend.title.align = 0.5,
    legend.text.align = 0.5,
    legend.justification = c(0, 0),
    legend.position = c(0.02, 0.1)
  )
}

