# from dataviz ch. 5 (bar chart with rotated axis labels)
fig_bar_good <- function(font_size = 12) {
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

ggplot(boxoffice, aes(x = forcats::fct_reorder(title_short, desc(rank)), y = amount)) +
  geom_col(fill = "#56B4E9", alpha = 0.9) +
  scale_y_continuous(limits = c(0, 7.5e7),
                     expand = c(0, 0),
                     breaks = c(0, 2e7, 4e7, 6e7),
                     labels = c("0", "20", "40", "60"),
                     name = "weekend gross (million USD)") +
  scale_x_discrete(name = NULL,
                   expand = c(0, 0.5)) +
  coord_flip(clip = "off") +
  theme_dviz_vgrid(font_size, rel_small = 1) +
  theme(
    #axis.ticks.length = grid::unit(0, "pt"),
    axis.line.y = element_blank(),
    axis.ticks.y = element_blank()
  )
}