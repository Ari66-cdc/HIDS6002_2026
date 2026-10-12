# One function per plot. Each returns a ggplot object.
# Paste chapter code into the body and note its source above it.
# Put any data prep inside the function so each plot is self-contained.

# from dataviz ch. XX (replace with the real chapter)
fig_cartesian_coordinates <- function() {
  
df_points <- data.frame(x = c(-1, 0, 2),
                        y = c(-1, 0, 1),
                        label = c("(–1, –1)", "(0, 0)", "(2, 1)"),
                        vjust = c(1.4, -.8, -.8),
                        hjust = c(1.1, 1.1, -.1))

df_segments <- data.frame(x0 = c(0, 2, 0, -1),
                          x1 = c(2, 2, -1, -1),
                          y0 = c(1, 0, -1, 0),
                          y1 = c(1, 1, -1, -1))

df_labels <- data.frame(x = c(-1, -.5, 1, 2),
                        y = c(-.5, -1, 1, 0.5),
                        vjust = c(.5, 1.3, -.3, .5),
                        hjust = c(1.1, .5, .5, -.1),
                        label = c("y = –1", "x = –1", "x = 2", "y = 1"))

ggplot(df_points, aes(x, y)) +
  geom_hline(yintercept = 0, color = "gray50") +
  geom_vline(xintercept = 0, color = "gray50") +
  geom_segment(data = df_segments, aes(x = x0, xend = x1, y = y0, yend = y1),
               linetype = 2) +
  geom_point(size = 3, color = "#0072B2") +
  geom_text(aes(label = label, vjust = vjust, hjust = hjust),
            size = 12/.pt, family = dviz_font_family) +
  geom_text(data = df_labels, aes(label = label, hjust = hjust, vjust = vjust),
            size = 12/.pt, family = dviz_font_family) +
  coord_fixed(xlim = c(-2.2, 3.2), ylim = c(-2.2, 2.2), expand = FALSE) +
  xlab("x axis") +
  ylab("y axis") +
  theme_dviz_grid() +
  theme(axis.ticks.length = grid::unit(0, "pt"))
}

