fig_lincoln_temp_violins <- function(font_size = 12) {
lincoln_df <- get_lincoln_df()

p <- ggplot(lincoln_df, aes(x = month_short, y = `Mean Temperature [F]`)) +
  geom_violin(fill = 'grey90') +
  xlab("month") +
  ylab("mean temperature (°F)") +
  theme_dviz_open() +
  theme(plot.margin = margin(3, 7, 3, 1.5))

p
}
