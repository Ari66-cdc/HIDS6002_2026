# from dataviz ch. 5 (bar chart with rotated axis labels)
fig_bar_bad <- function(font_size = 12) {
  boxoffice <- data.frame(
    rank = 1:5,
    title = c("Star Wars: The Last Jedi", "Jumanji: Welcome to the Jungle",
              "Pitch Perfect 3", "The Greatest Showman", "Ferdinand"),
    title_short = c("Star Wars", "Jumanji", "Pitch Perfect 3",
                    "Greatest Showman", "Ferdinand"),
    amount = c(71565498, 36169328, 19928525, 8805843, 7316746),
    amount_text = c("$71,565,498", "$36,169,328", "$19,928,525",
                    "$8,805,843", "$7,316,746")
  )

  p_box_axrot <- ggplot(
    boxoffice,
    aes(x = factor(title_short, levels = title_short[c(2, 1, 5, 3, 4)]),
        y = amount)
  ) +
    geom_col(fill = "#56B4E9", alpha = 0.9) +
    scale_y_continuous(expand = c(0, 0),
                       breaks = c(0, 2e7, 4e7, 6e7),
                       labels = c("0", "20", "40", "60"),
                       name = "weekend gross (million USD)") +
    scale_x_discrete(name = NULL) +
    coord_cartesian(clip = "off") +
    theme_dviz_hgrid(font_size, font_family = "sans", rel_small = 1) +
    theme(
      axis.line.x = element_blank(),
      axis.ticks.x = element_blank(),
      axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1),
      plot.margin = margin(3, 7, 3, 1.5)
    )

  stamp_bad(p_box_axrot)
}