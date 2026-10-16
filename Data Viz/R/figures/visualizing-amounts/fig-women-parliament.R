fig_women_parliament <- function(font_size = 12) {
women_rwanda <- get_women_rwanda()

plot_base <- ggplot(women_rwanda, aes(x = year, y = percent, fill = gender)) +
  geom_col(position = "stack", width = 1, color = "#FFFFFF", linewidth = .75, alpha = 0.8) +
  geom_hline(yintercept = c(50), color = "#000000FF", linewidth = 0.4, linetype = 2) +
  geom_hline(yintercept = 100, color = "black") +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(
    name = "relative proportion",
    labels = scales::percent_format(accuracy = 1, scale = 1),
    expand = c(0, 0)
  ) +
  scale_fill_manual(values = c("#D55E00E0", "#0072B2E0"), guide = "none") +
  coord_cartesian(clip = "off") +
  theme_dviz_open() +
  theme(
    axis.line.y = element_blank(),
    plot.margin = margin(14, 1.5, 3, 1.5)
  )

# calculate label position
labels <- filter(women_rwanda, year == max(year)) %>%
  mutate(pos = 100 - cumsum(percent) + 0.5*percent)

yax <- axis_canvas(plot_base, axis = "y") +
  geom_text(data = labels, aes(y = pos, label = paste0(" ", gender)),
            family = dviz_font_family,
            x = 0, hjust = 0, size = 14/.pt)

ggdraw(insert_yaxis_grob(plot_base, yax, grid::unit(.15, "null")))
}
