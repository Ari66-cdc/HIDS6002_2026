fig_bio_preprints_direct_label <- function(font_size = 12) {
biorxiv_growth <- get_biorxiv_growth()
preprints <- get_preprints()
preprints_final <- filter(preprints, date == lubridate::ymd("2017-01-01"))

ggplot(preprints) +
  aes(date, count, color = archive, fill = archive, shape = archive) +
  geom_line(linewidth = 1) +
  scale_y_continuous(
    limits = c(0, 600), expand = c(0, 0),
    name = "preprints / month",
    sec.axis = dup_axis(
      breaks = preprints_final$count,
      labels = c("arXiv\nq-bio", "PeerJ\nPreprints", "bioRxiv"),
      name = NULL)
  ) +
  scale_x_date(name = "year",
               limits = c(min(biorxiv_growth$date), lubridate::ymd("2017-01-01")),
               expand = expansion(mult = c(0.02, 0))) +
  scale_color_manual(values = c("#0072b2", "#D55E00", "#009e73"),
                     name = NULL) +
  scale_fill_manual(values = c("#0072b2", "#D55E00", "#009e73"),
                     name = NULL) +
  scale_shape_manual(values = c(21, 22, 23),
                     name = NULL) +
  coord_cartesian(clip = "off") +
  theme_dviz_open() +
  theme(legend.position = "none") +
  theme(axis.line.y.right = element_blank(),
        axis.ticks.y.right = element_blank(),
        axis.text.y.right = element_text(margin = margin(0, 0, 0, 0)),
        plot.margin = margin(14, 7, 3, 1.5))
}
