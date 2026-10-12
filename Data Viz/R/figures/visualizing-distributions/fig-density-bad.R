fig_density_bad <- function(font_size = 12) {
pdens_neg <- ggplot(titanic, aes(x = age)) + 
  geom_density_line(fill = "#56B4E9", color = darken("#56B4E9", 0.5)) + 
  scale_y_continuous(limits = c(0, 0.046), expand = c(0, 0), name = "density") +
  scale_x_continuous(name = "age (years)", limits = c(-10, 79), expand = c(0, 0)) +
  coord_cartesian(clip = "off") +
  theme_dviz_hgrid() +
  theme(
    axis.line.x = element_blank(),
    plot.margin = margin(3, 7, 3, 1.5)
  )

stamp_wrong(pdens_neg)
}