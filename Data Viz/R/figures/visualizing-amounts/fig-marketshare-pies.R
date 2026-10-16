fig_marketshare_pies <- function(font_size = 12) {
small_size <- (12/14) * (14 / .pt)

# calculate the start and end angles for each pie
market_pies_df <- marketshare %>%
  group_by(year) %>%
  mutate(total = sum(percent),
         end_angle = 2*pi*cumsum(percent)/total,      # ending angle for each pie slice
         start_angle = lag(end_angle, default = 0),   # starting angle for each pie slice
         mid_angle = 0.5*(start_angle + end_angle),   # middle of each pie slice, for the text label
         hjust = ifelse(mid_angle>pi, 1, 0),
         vjust = ifelse(mid_angle<pi/2 | mid_angle>3*pi/2, 0, 1))

rpie <- 1
rlabel <- 1.05 * rpie

market_pies <- ggplot(market_pies_df) +
  geom_arc_bar(
    aes(
      x0 = 0, y0 = 0, r0 = 0, r = rpie,
      start = start_angle, end = end_angle, fill = company
    ),
    color = NA
  ) +
  geom_text(
    aes(x = rlabel*sin(mid_angle), y = rlabel*cos(mid_angle), label = company, hjust = hjust, vjust = vjust),
    family = dviz_font_family,
    size = small_size
  ) +
  coord_fixed() +
  facet_wrap(~year) +
  scale_x_continuous(limits = c(-1.2, 1.2), expand = c(0, 0), name = NULL, breaks = NULL, labels = NULL) +
  scale_y_continuous(limits = c(-1.2, 1.2), expand = c(0, 0), name = NULL, breaks = NULL, labels = NULL) +
  scale_fill_OkabeIto(order = c(1:3, 5, 4)) +
  guides(fill = "none") +
  theme_dviz_open() +
  theme(
    axis.line = element_blank(),
    axis.title = element_blank(),
    axis.ticks = element_blank(),
    axis.ticks.length = grid::unit(0, "pt"),
    plot.margin = margin(7, 7, 0, 7),
    legend.position = "none",
    strip.background = element_blank(),
    strip.text.x = element_text(size = 14, margin = margin(0, 0, 0.1, 0))
  )

stamp_bad(market_pies)
}
