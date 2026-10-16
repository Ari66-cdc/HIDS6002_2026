fig_biorxiv_dots_line <- function(font_size = 12) {
biorxiv_growth <- get_biorxiv_growth()

ggplot(biorxiv_growth, aes(date, count)) +
  geom_line(linewidth = 0.5, color = "#0072B2") +
  geom_point(color = "white", fill = "#0072B2", shape = 21, size = 2) +
  scale_y_continuous(limits = c(0, 1600), expand = c(0, 0),
                name = "preprints / month") +
  scale_x_date(name = "year") +
  theme_dviz_open() +
  theme(plot.margin = margin(7, 7, 3, 1.5))
}
