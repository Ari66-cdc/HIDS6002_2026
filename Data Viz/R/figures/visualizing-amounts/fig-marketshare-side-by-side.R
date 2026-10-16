fig_marketshare_side_by_side <- function(font_size = 12) {
ggplot(marketshare, aes(x = company, y = percent, fill = company)) +
  geom_col() +
  facet_wrap(~year) +
  scale_y_continuous(
    name = "market share",
    labels = scales::percent_format(accuracy = 1, scale = 1),
    expand = c(0, 0)
  ) +
  scale_fill_OkabeIto(order = c(1:3, 5, 4), guide = "none") +
  theme_dviz_open() +
  theme(strip.background = element_blank())
}
