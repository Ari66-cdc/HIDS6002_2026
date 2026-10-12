# from dataviz ch. 2 (common aesthetics)
fig_common_aesthetics <- function() {
  fam <- "sans"   # replaces dviz_font_family (avoids Myriad Pro)

  aes_pos <- ggdraw() +
    geom_segment(data = data.frame(x = c(0, 0.5), xend = c(1, 0.5),
                                   y = c(0.5, 0), yend = c(0.5, 1)),
                 aes(x = x, y = y, xend = xend, yend = yend),
                 arrow = arrow(length = grid::unit(12, "pt")),
                 linewidth = .75) +
    draw_text("y", .5, 1, size = 12, vjust = 1, hjust = 2.5, family = fam) +
    draw_text("x", 1, .5, size = 12, vjust = 2, hjust = 1, family = fam) +
    coord_cartesian(xlim = c(-.2, 1.2), ylim = c(-.2, 1.2))

  aes_color <- ggdraw() +
    geom_tile(data = data.frame(x = 0.15 + .2333*(0:3)),
              aes(x, y = .5, fill = factor(x)), width = .2, height = .6) +
    scale_fill_manual(values = c("#E69F00", "#56B4E9", "#009E73", "#F0E442"),
                      guide = "none")

  aes_shape <- ggdraw() +
    geom_point(data = data.frame(x = (.5 + 0:3)/4),
               aes(x, y = .5, shape = factor(x)), size = 8, fill = "grey80") +
    scale_shape_manual(values = 21:24, guide = "none")

  aes_size <- ggdraw() +
    geom_point(data = data.frame(x = (.5 + 0:3)/4),
               aes(x, y = .5, size = factor(x)), shape = 21, fill = "grey80") +
    scale_size_manual(values = c(2, 5, 8, 11), guide = "none")

  aes_lwd <- ggdraw() +
    geom_segment(data = data.frame(x = rep(0.05, 4), xend = rep(0.95, 4),
                                   y = (1.5 + 0:3)/6, yend = (1.5 + 0:3)/6,
                                   lw = 4:1),
                 aes(x = x, y = y, xend = xend, yend = yend, linewidth = lw)) +
    scale_linewidth_identity()

  aes_ltp <- ggdraw() +
    geom_segment(data = data.frame(x = rep(0.05, 4), xend = rep(0.95, 4),
                                   y = (1.5 + 0:3)/6, yend = (1.5 + 0:3)/6,
                                   linetype = 4:1),
                 aes(x = x, y = y, xend = xend, yend = yend, linetype = linetype),
                 linewidth = 1) +
    scale_linetype_identity()

  plot_grid(aes_pos, aes_shape, aes_size,
            aes_color, aes_lwd, aes_ltp,
            ncol = 3,
            labels = c("position", "shape", "size", "color", "line width", "line type"),
            label_x = 0.05, label_y = 0.95, hjust = 0, vjust = 1)
}