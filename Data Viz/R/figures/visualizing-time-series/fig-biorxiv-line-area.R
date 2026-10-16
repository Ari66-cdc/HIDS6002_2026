fig_biorxiv_line_area <- function(font_size = 12) {
biorxiv_growth <- get_biorxiv_growth()

ggplot(biorxiv_growth, aes(date, height = count, y = 0)) +
  geom_ridgeline(color = "#0072B2", fill = "#0072B240", linewidth = 0.75) +
  scale_y_continuous(limits = c(0, 1600), expand = c(0, 0),
                name = "preprints / month") +
  scale_x_date(name = "year") +
  theme_dviz_open() +
  theme(plot.margin = margin(7, 7, 3, 1.5))
}
