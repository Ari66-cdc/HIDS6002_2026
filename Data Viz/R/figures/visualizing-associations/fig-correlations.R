fig_correlations <- function(font_size = 12) {
r <- c(.2, .6, .9, -.2, -.6, -.9)
labels_df <- tibble::tibble(
  r = factor(r, levels = r),
  label = c("r = 0.2", "r = 0.6", "r = 0.9", "r = –0.2", "r = –0.6", "r = –0.9"),
  x = c(-2.3, -2.3, -2.3, 2.3, 2.3, 2.3),
  hjust = c(0, 0, 0, 1, 1, 1),
  y = 2.3
)

ggplot(correlation_examples, aes(x, y)) +
  geom_point(pch = 21, color = "white", size = 2, fill = "#0072B2") +
  geom_text(
    data = labels_df,
    aes(label = label, hjust = hjust),
    vjust = 1,
    family = dviz_font_family,
    size = 14/.pt
  ) +
  facet_wrap(~r) +
  coord_fixed(xlim = c(-2.5, 2.5), ylim = c(-2.5, 2.5), expand = FALSE, clip = "off") +
  theme_dviz_map() +
  theme(
    strip.text = element_blank(),
    panel.spacing = grid::unit(12, "pt"),
    plot.margin = margin(3.5, 1.5, 3.5, 1.5)
  ) +
  panel_border(colour = "grey80", size = 0.5)
}
