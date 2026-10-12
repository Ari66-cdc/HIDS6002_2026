fig_log_scale <- function(font_size = 12) {
df <- data.frame(x = c(1, 3.16, 10, 31.6, 100))

xaxis_lin <- ggplot(df, aes(x, y = 1)) + 
  geom_point(size = 3, color = "#0072B2") + 
  scale_y_continuous(limits = c(0.8, 1.2), expand = c(0, 0), breaks = 1) +
  theme_dviz_grid(font_size, rel_large = 1) +
  theme(axis.ticks.length = grid::unit(0, "pt"),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks.y = element_blank(),
        plot.title = element_text(face = "plain"),
        plot.margin = margin(3, 14, 3, 1.5))

xaxis_log <- ggplot(df, aes(log10(x), y = 1)) + 
  geom_point(size = 3, color = "#0072B2") + 
  scale_y_continuous(limits = c(0.8, 1.2), expand = c(0, 0), breaks = 1) +
  theme_dviz_grid(font_size, rel_large = 1) +
  theme(axis.ticks.length = grid::unit(0, "pt"),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks.y = element_blank(),
        plot.title = element_text(face = "plain"),
        plot.margin = margin(3, 14, 3, 1.5))

plotlist <- 
  align_plots(xaxis_lin + scale_x_continuous(limits = c(0, 100)) + 
                ggtitle("original data, linear scale"),
              xaxis_log + scale_x_continuous(limits = c(0, 2)) +
                xlab(expression(paste("log"["10"], "(x)"))) + 
                ggtitle("log-transformed data, linear scale"),
              xaxis_lin + scale_x_log10(limits = c(1, 100), breaks = c(1, 3.16, 10, 31.6, 100),
                                        labels = c("1", "3.16", "10", "31.6", "100")) + 
                ggtitle("original data, logarithmic scale"),
              xaxis_lin + scale_x_log10(limits = c(1, 100), breaks = c(1, 3.16, 10, 31.6, 100),
                                        labels = c("1", "3.16", "10", "31.6", "100")) +
                xlab(expression(paste("log"["10"], "(x)"))) + 
                ggtitle("logarithmic scale with incorrect axis title"),
              align = 'vh')

plot_grid(plotlist[[1]], plotlist[[2]], plotlist[[3]], stamp_wrong(plotlist[[4]]), ncol = 1)
}