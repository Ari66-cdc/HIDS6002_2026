fig_bio_preprints_dots <- function(font_size = 12) {
biorxiv_growth <- get_biorxiv_growth()
preprints <- get_preprints()

p <- ggplot(preprints, aes(date, count, color = archive, fill = archive, shape = archive)) +
  geom_point(color = "white", size = 2) +
  scale_shape_manual(values = c(21, 22, 23),
                     name = NULL) +
  scale_y_continuous(limits = c(0, 600), expand = c(0, 0),
                name = "preprints / month") +
  scale_x_date(name = "year",
               limits = c(min(biorxiv_growth$date), lubridate::ymd("2017-01-01"))) +
  scale_color_manual(values = c("#0072b2", "#D55E00", "#009e73"),
                     name = NULL) +
  scale_fill_manual(values = c("#0072b2", "#D55E00", "#009e73"),
                     name = NULL) +
  theme_dviz_open() +
  theme(legend.title.align = 0.5,
        legend.position = c(0.1, .9),
        legend.just = c(0, 1),
        plot.margin = margin(14, 7, 3, 1.5))

stamp_bad(p)
}
