# from dataviz ch. 5 (bar chart with rotated axis labels)
fig_bar_long <- function(font_size = 12) {
df_Americas <- gapminder %>% filter(year == 2007, continent == "Americas")

p <- ggplot(df_Americas, aes(y = lifeExp, x = forcats::fct_reorder(country, lifeExp))) +
  geom_col(fill = "#56B4E9", alpha = 0.9) +
  scale_y_continuous(
    name = "life expectancy (years)",
    limits = c(0, 85),
    expand = c(0, 0)
  ) +
  scale_x_discrete(name = NULL, expand = c(0, 0.5)) +
  coord_flip(clip = "off") +
  theme_dviz_vgrid(font_size, rel_small = 1) +
  theme(
    #axis.ticks.length = grid::unit(0, "pt"),
    axis.line.y = element_blank(),
    axis.ticks.y = element_blank(),
    #axis.title = element_text(size = 12),
    plot.margin = margin(18, 6, 3, 1.5)
  )

stamp_bad(p)
}