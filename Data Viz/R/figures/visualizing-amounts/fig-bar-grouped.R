# from dataviz ch. 5 (bar chart with rotated axis labels)
fig_bar_grouped <- function(font_size = 12) {
income_by_age %>% filter(race == "all") %>%
  ggplot(aes(x = age, y = median_income)) +
    geom_col(fill = "#56B4E9", alpha = 0.9) +
    scale_y_continuous(expand = c(0, 0),
                       name = "median income (USD)",
                       breaks = c(0, 20000, 40000, 60000),
                       labels = c("$0", "$20,000", "$40,000", "$60,000")) +
    xlab("age (years)") +
    coord_cartesian(clip = "off") +
    theme_dviz_hgrid() +
    theme(
      #axis.ticks.length = grid::unit(0, "pt"),
      axis.ticks.x = element_blank(),
      axis.line = element_blank(),
      plot.margin = margin(3, 7, 3, 1.5)
    )
}