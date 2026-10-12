fig_hist <- function(font_size = 12) {
    titanic <- titanic_all
    age_counts <- hist(titanic$age, breaks = (0:15) * 5 + .01, plot = FALSE)$counts
    age_hist <- data.frame(
        `age range` = c("0--5", "6--10", "11--15", "16--20", "21--25", "26--30", "31--35", "36--40", "41--45", "46--50", "51--55", "56--60", "61--65", "66--70", "71--75"),
        count = age_counts,
        check.names = FALSE
    )

    age_hist <- cbind(age_hist, age = (1:15) * 5 - 2.5)

    age_hist_1 <- data.frame(
    age = (1:75) - 0.5, 
    count = hist(titanic$age, breaks = (0:75) + .01, plot = FALSE)$counts
    )

    age_hist_3 <- data.frame(
    age = (1:25) * 3 - 1.5, 
    count = hist(titanic$age, breaks = (0:25) * 3 + .01, plot = FALSE)$counts
    )

    age_hist_15 <- data.frame(
    age = (1:5) * 15 - 7.5, 
    count = hist(titanic$age, breaks = (0:5) * 15 + .01, plot = FALSE)$counts
    )

h1 <- ggplot(age_hist, aes(x = age, y = count)) + geom_col(width = 4.7, fill = "#56B4E9")  + 
  scale_y_continuous(expand = c(0, 0), breaks = 25 * (0:5)) +
  scale_x_continuous(name = "age (years), bin 5", limits = c(0, 75), expand = c(0, 0)) +
  coord_cartesian(clip = "off") +
  theme_dviz_hgrid() +
  theme(
    axis.line.x = element_blank(),
    plot.margin = margin(3, 7, 3, 1.5)
  )
    h2 <- ggplot(age_hist_1, aes(x = age, y = count)) + 
    geom_col(width = .85, fill = "#56B4E9")  + 
    scale_y_continuous(expand = c(0, 0), breaks = 10 * (0:5)) +
    scale_x_continuous(name = "age (years), bin 1", limits = c(0, 75), expand = c(0, 0)) +
    coord_cartesian(clip = "off") +
    theme_dviz_hgrid(12) +
    theme(
        axis.line.x = element_blank(),
        plot.margin = margin(3, 1.5, 3, 1.5)
    )

    h3 <- ggplot(age_hist_3, aes(x = age, y = count)) + geom_col(width = 2.75, fill = "#56B4E9")  + 
    scale_y_continuous(expand = c(0, 0), breaks = 25 * (0:5)) +
    scale_x_continuous(name = "age (years), bin 3", limits = c(0, 75), expand = c(0, 0)) +
    coord_cartesian(clip = "off") +
    theme_dviz_hgrid(12) +
    theme(
        axis.line.x = element_blank(),
        plot.margin = margin(3, 1.5, 3, 1.5)
    )

    h4 <- ggplot(age_hist_15, aes(x = age, y = count)) + geom_col(width = 14.5, fill = "#56B4E9")  + 
    scale_y_continuous(expand = c(0, 0), breaks = 100 * (0:4)) +
    scale_x_continuous(name = "age (years), bin 15", limits = c(0, 75), expand = c(0, 0)) +
    coord_cartesian(clip = "off") +
    theme_dviz_hgrid(12) +
    theme(
        axis.line.x = element_blank(),
        plot.margin = margin(3, 1.5, 3, 1.5)
    )


    plot_grid(
    h2, NULL, h3,
    NULL, NULL, NULL,
    h1 + theme_dviz_hgrid(12) + theme(axis.line.x = element_blank(), plot.margin = margin(3, 1.5, 3, 1.5)),
    NULL, h4,
    align = 'hv',
    labels = c("a", "", "b", "", "", "", "c", "", "d"),
    rel_widths = c(1, .04, 1),
    rel_heights = c(1, .04, 1)
    )
}   