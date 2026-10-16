fig_blue_jays_scatter_bubbles <- function(font_size = 12) {
blue_jays$sex <- ifelse(blue_jays$KnownSex == "F", "female birds", "male birds")
blue_jays$sex <- factor(blue_jays$sex, levels = c("female birds", "male birds"))

ggplot(blue_jays, aes(Mass, Head, size = Skull, fill = KnownSex)) +
  geom_point(pch = 21, color = "white") +
  facet_wrap(~sex, ncol = 2, scales = "fixed") +
  scale_x_continuous(name = "body mass (g)") +
  scale_y_continuous(name = "head length (mm)", breaks = c(52, 54, 56, 58, 60)) +
  scale_fill_manual(values = c(F = "#D55E00", M = "#0072B2"), guide = "none") +
  scale_radius(
    name = "skull size (mm)",
    range = c(2, 7),
    limits = c(28, 34),
    breaks = c(28, 30, 32, 34),
    labels = c("28   ", "30   ", "32   ", "34"),
    guide = guide_legend(
      direction = "horizontal",
      title.position = "top",
      title.hjust = 0.5,
      label.position = "right",
      override.aes = list(fill = "gray40")
    )
  ) +
  theme_dviz_grid(12) +
  theme(
    legend.position = "bottom",
    legend.spacing.x = unit(2, "pt"),
    legend.spacing.y = unit(2, "pt"),
    legend.key.width = unit(10, "pt"),
    strip.text = element_text(size = 12, margin = margin(2, 0, 2, 0)),
    strip.background = element_rect(
      fill = "grey85", colour = "grey85",
      linetype = 1, linewidth = 0.25
    )
  )
}
