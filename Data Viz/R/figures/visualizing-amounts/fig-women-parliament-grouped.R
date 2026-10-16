fig_women_parliament_grouped <- function(font_size = 12) {
women_rwanda <- get_women_rwanda()

p <- ggplot(women_rwanda, aes(x = factor(year), y = percent, fill = gender)) +
  geom_col(position = "dodge", width = .8) +
  geom_hline(yintercept = 50, color = "#000000FF", linewidth = 0.4, linetype = 2) +
  scale_x_discrete(name = "year", guide = guide_axis(check.overlap = TRUE)) +
  scale_y_continuous(
    name = "relative proportion",
    labels = scales::percent_format(accuracy = 1, scale = 1),
    expand = c(0, 0)
  ) +
  scale_fill_manual(values = c("#D55E00E0", "#0072B2E0"), name = NULL) +
  theme_dviz_open() +
  theme(
    plot.margin = margin(14, 7, 3, 1.5),
    legend.position = "bottom"
  )

stamp_bad(p)
}
