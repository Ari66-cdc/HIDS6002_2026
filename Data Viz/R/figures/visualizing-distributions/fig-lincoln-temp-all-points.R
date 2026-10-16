fig_lincoln_temp_all_points <- function(font_size = 12) {
lincoln_df <- get_lincoln_df()

p <- ggplot(lincoln_df, aes(x = month_short, y = `Mean Temperature [F]`)) +
  geom_point(size = 0.75) +
  xlab("month") +
  ylab("mean temperature (°F)") +
  theme_dviz_open() +
  theme(plot.margin = margin(3, 7, 3, 1.5))

stamp_bad(p)
}
