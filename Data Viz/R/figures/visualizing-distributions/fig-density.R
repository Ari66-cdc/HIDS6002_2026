fig_density <- function(font_size = 12) {
pdens1 <- ggplot(titanic, aes(x = age)) + 
  geom_density_line(fill = "#56B4E9", color = darken("#56B4E9", 0.5), bw = .5, kernel = "gaussian") + 
  scale_y_continuous(limits = c(0, 0.046), expand = c(0, 0), name = "density") +
  scale_x_continuous(name = "age (years), band=0.5", limits = c(0, 75), expand = c(0, 0)) +
  coord_cartesian(clip = "off") +
  theme_dviz_hgrid(12) +
  theme(
    axis.line.x = element_blank(),
    plot.margin = margin(3, 1.5, 3, 1.5)
  )

pdens2 <- ggplot(titanic, aes(x = age)) + 
  geom_density_line(fill = "#56B4E9", color = darken("#56B4E9", 0.5), bw = 2, kernel = "gaussian") + 
  scale_y_continuous(limits = c(0, 0.046), expand = c(0, 0), name = "density") +
  scale_x_continuous(name = "age (years), band=2", limits = c(0, 75), expand = c(0, 0)) +
  coord_cartesian(clip = "off") +
  theme_dviz_hgrid(12) +
  theme(
    axis.line.x = element_blank(),
    plot.margin = margin(3, 1.5, 3, 1.5)
  )

pdens3 <- ggplot(titanic, aes(x = age)) + 
  geom_density_line(fill = "#56B4E9", color = darken("#56B4E9", 0.5), bw = 5, kernel = "gaussian") + 
  scale_y_continuous(limits = c(0, 0.046), expand = c(0, 0), name = "density") +
  scale_x_continuous(name = "age (years), band=5", limits = c(0, 75), expand = c(0, 0)) +
  coord_cartesian(clip = "off") +
  theme_dviz_hgrid(12) +
  theme(
    axis.line.x = element_blank(),
    plot.margin = margin(3, 1.5, 3, 1.5)
  )

pdens4 <- ggplot(titanic, aes(x = age)) + 
  geom_density_line(fill = "#56B4E9", color = darken("#56B4E9", 0.5), bw = 2, kernel = "rectangular") + 
  scale_y_continuous(limits = c(0, 0.046), expand = c(0, 0), name = "density") +
  scale_x_continuous(name = "age (years), Rectangular", limits = c(0, 75), expand = c(0, 0)) +
  coord_cartesian(clip = "off") +
  theme_dviz_hgrid(12) +
  theme(
    axis.line.x = element_blank(),
    plot.margin = margin(3, 1.5, 3, 1.5)
  )

plot_grid(
  pdens1, NULL, pdens2, 
  NULL, NULL, NULL,
  pdens3, NULL, pdens4,
  align = 'hv',
  labels = c("a", "", "b", "", "", "", "c", "", "d"),
  rel_widths = c(1, .04, 1),
  rel_heights = c(1, .04, 1)
)
}