fig_bundestag_pie <- function(font_size = 12) {
main_size <- 14 / .pt

# calculate the start and end angles for each pie
bund_pie <- bundestag %>%
  arrange(seats) %>%
  mutate(
    seat_total = sum(seats),
    end_angle = 2*pi*cumsum(seats)/seat_total,   # ending angle for each pie slice
    start_angle = lag(end_angle, default = 0),   # starting angle for each pie slice
    mid_angle = 0.5*(start_angle + end_angle),   # middle of each pie slice, for the text label
    hjust = ifelse(mid_angle>pi, 1, 0),
    vjust = ifelse(mid_angle<pi/2 | mid_angle>3*pi/2, 0, 1)
  )

rpie <- 1
rlabel <- 1.05 * rpie

ggplot(bund_pie) +
  geom_arc_bar(
    aes(
      x0 = 0, y0 = 0, r0 = 0, r = rpie,
      start = start_angle, end = end_angle, fill = party
    ),
    color = "white", linewidth = 0.5
  ) +
  geom_text(
    aes(
      x = rlabel*sin(mid_angle),
      y = rlabel*cos(mid_angle),
      label = party,
      hjust = hjust, vjust = vjust
    ),
    family = dviz_font_family, size = main_size
  ) +
  geom_text(
    aes(
      x = 0.6*sin(mid_angle),
      y = 0.6*cos(mid_angle),
      label = seats
    ),
    family = dviz_font_family, size = main_size,
    color = c("black", "white", "white")
  ) +
  coord_fixed(clip = "off") +
  scale_x_continuous(limits = c(-1.9, 1.5), expand = c(0, 0), name = "", breaks = NULL, labels = NULL) +
  scale_y_continuous(limits = c(-1.01, 1.15), expand = c(0, 0), name = "", breaks = NULL, labels = NULL) +
  scale_fill_manual(values = bund_pie$colors[order(bund_pie$party)]) +
  theme_dviz_map() +
  theme(
    legend.position = "none",
    plot.margin = margin(3.5, 1.5, 3.5, 1.5)
  )
}
