fig_blue_jays_scatter <- function(font_size = 12) {
ggplot(blue_jays, aes(Mass, Head)) +
  geom_point(pch = 21, fill = "gray25", color = "white", size = 2.5) +
  scale_x_continuous(name = "body mass (g)") +
  scale_y_continuous(name = "head length (mm)") +
  theme_dviz_grid()
}
