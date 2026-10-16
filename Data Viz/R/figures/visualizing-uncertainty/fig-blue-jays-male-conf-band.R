fig_blue_jays_male_conf_band <- function(font_size = 12) {
f <- get_blue_jays_male_fit()

ggplot(f$data, aes(Mass, Head)) +
  geom_ribbon(data = f$ci, aes(ymin = lo, ymax = hi), fill = "grey70", color = NA, alpha = 1/2) +
  geom_point(color = "grey60", size = 1.5) +
  geom_line(data = f$ci, color = "#0072B2", linewidth = 1) +
  scale_x_continuous(
    limits = c(59, 82),
    expand = c(0, 0),
    name = "body mass (g)") +
  scale_y_continuous(
    limits = c(52, 61),
    expand = c(0, 0),
    name = "head length (mm)"
  ) +
  theme_dviz_open()
}
