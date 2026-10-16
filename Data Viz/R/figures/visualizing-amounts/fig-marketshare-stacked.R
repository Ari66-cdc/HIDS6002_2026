fig_marketshare_stacked <- function(font_size = 12) {
stacked_bars <- ggplot(marketshare, aes(x = year, y = percent, fill = company)) +
  geom_col(position = "stack") +
  scale_y_continuous(
    name = "market share",
    labels = scales::percent_format(accuracy = 1, scale = 1),
    expand = c(0, 0)
  ) +
  scale_fill_OkabeIto(order = c(1:3, 5, 4)) +
  theme_dviz_open() +
  theme(plot.margin = margin(14, 7, 3, 1.5))

stamp_bad(stacked_bars)
}
