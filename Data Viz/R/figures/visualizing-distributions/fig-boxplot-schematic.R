fig_boxplot_schematic <- function(font_size = 12) {
set.seed(3423)
y <- c(rnorm(100), 3.4)
s <- boxplot.stats(y)
df <- data.frame(y = c(s$stats, max(y)),
                 x = c(1.03, 1.405, 1.405, 1.405, 1.03, 1.04),
                 label = c("minimum", "first quartile", "median", "third quartile", "maximum within upper fence", "outlier"))
p_boxplot <- ggplot(data.frame(y), aes(x = 1, y = y)) + geom_boxplot(fill = 'grey90') +
  geom_text(data = df, aes(x, y, label = label), hjust = 0,
            size = 14/.pt, family = dviz_font_family) +
  scale_x_continuous(limits = c(0, 3.5), expand = c(0, 0)) +
  scale_y_continuous(limits = c(-2.55, 3.5), expand = c(0, 0)) +
  theme_nothing()

p_points <- ggplot(data.frame(y), aes(x = 0, y = y)) +
  geom_point(position = position_jitter(width = .4, height = 0, seed = 320)) +
  scale_x_continuous(limits = c(-1.8, .4), expand = c(0, 0)) +
  scale_y_continuous(limits = c(-2.55, 3.5), expand = c(0, 0)) +
  theme_nothing()

plot_grid(p_points, p_boxplot, rel_widths = c(.65, 1), nrow = 1)
}
