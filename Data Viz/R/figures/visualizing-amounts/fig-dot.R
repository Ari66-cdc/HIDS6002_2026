# from dataviz ch. 5 (bar chart with rotated axis labels)
fig_dot <- function(font_size = 12) {
df_Americas <- gapminder %>% filter(year == 2007, continent == "Americas")
ggplot(df_Americas, aes(x = lifeExp, y = forcats::fct_reorder(country, lifeExp))) +
  geom_point(color = "#0072B2", size = 3) +
  scale_x_continuous(
    name = "life expectancy (years)",
    limits = c(59.7, 81.5),
    expand = c(0, 0)
  ) +
  scale_y_discrete(name = NULL, expand = c(0, 0.5)) +
  theme_dviz_grid(font_size, rel_small = 1) +
  theme(
    #axis.ticks.length = grid::unit(0, "pt"),
    #axis.title = element_text(size = 12),
    plot.margin = margin(18, 6, 3, 1.5)
  )
}