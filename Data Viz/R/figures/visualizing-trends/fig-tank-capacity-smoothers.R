fig_tank_capacity_smoothers <- function(font_size = 12) {
cars93 <- MASS::Cars93

cars_base <- ggplot(cars93, aes(x = Price, y = Fuel.tank.capacity)) + geom_point(color = "grey60") +
  scale_x_continuous(
    name = "price (USD)",
    breaks = c(20, 40, 60),
    labels = c("$20,000", "$40,000", "$60,000")
  ) +
  scale_y_continuous(name = "fuel-tank capacity\n(US gallons)") +
  theme_dviz_grid(12)

p1 <- cars_base + geom_smooth(se = FALSE, method = "loess", formula = y ~ x, color = "#0072B2")
p2 <- cars_base + geom_smooth(se = FALSE, method = "gam", formula = y ~ s(x, k = 5, bs = 'cr'), color = "#0072B2")
p3 <- cars_base + geom_smooth(se = FALSE, method = "gam", formula = y ~ s(x, k = 3), color = "#0072B2")
p4 <- cars_base + geom_smooth(se = FALSE, method = "gam", formula = y ~ s(x, k = 6, bs = 'gp'), color = "#0072B2")

plot_grid(
  p1, NULL, p2,
  NULL, NULL, NULL,
  p3, NULL, p4,
  align = 'hv',
  labels = c("a", "", "b", "", "", "", "c", "", "d"),
  rel_widths = c(1, .02, 1),
  rel_heights = c(1, .02, 1)
)
}
