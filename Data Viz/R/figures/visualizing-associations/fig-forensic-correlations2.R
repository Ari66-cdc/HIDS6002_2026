fig_forensic_correlations2 <- function(font_size = 12) {
# correlation matrix, clustered, in long format
cm <- cor(select(forensic_glass, -type, -RI, -Si))
df_wide <- as.data.frame(cm)
df_long <- stack(df_wide)
names(df_long) <- c("cor", "var1")
df_long <- cbind(df_long, var2 = rep(rownames(cm), length(rownames(cm))))
clust <- hclust(as.dist(1 - cm), method = "average")
levels <- clust$labels[clust$order]
df_long$var1 <- factor(df_long$var1, levels = levels)
df_long$var2 <- factor(df_long$var2, levels = levels)

ggplot(filter(df_long, as.integer(var1) < as.integer(var2)),
       aes(var1, var2, fill = cor, size = abs(cor))) +
  geom_point(shape = 21, stroke = 0) +
  scale_x_discrete(position = "top", name = NULL, expand = c(0, 0.5)) +
  scale_y_discrete(name = NULL, expand = c(0, 0.5)) +
  scale_size_area(max_size = 19, limits = c(0, 0.5), guide = "none") +
  colorspace::scale_fill_continuous_divergingx(
    palette = "Earth", rev = FALSE,
    limits = c(-.5, .5),
    breaks = c(-.5, 0, .5),
    labels = c("–0.5", "0.0", "0.5"),
    name = "correlation",
    guide = guide_colorbar(
      direction = "horizontal",
      label.position = "bottom",
      title.position = "top",
      barwidth = grid::unit(140, "pt"),
      barheight = grid::unit(17.5, "pt"),
      ticks.linewidth = 1
    )
  ) +
  coord_fixed() +
  theme_dviz_open(rel_small = 1) +
  theme(
    axis.line = element_blank(),
    axis.ticks = element_blank(),
    axis.ticks.length = grid::unit(3, "pt"),
    legend.position = c(.97, .0),
    legend.justification = c(1, 0),
    legend.title.align = 0.5
  )
}
