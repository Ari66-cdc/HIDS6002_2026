fig_two_density<-function(font_size=12) {

titanic2 <- titanic
titanic2$sex <- factor(titanic2$sex, levels = c("male", "female"))

ggplot(titanic2, aes(x = age, y = ..count..)) +
  geom_density_line(
    data = select(titanic, -sex), aes(fill = "all passengers"),
    color = "transparent"
  ) + 
  geom_density_line(aes(fill = sex), bw = 2, color = "transparent") +
  scale_x_continuous(limits = c(0, 75), name = "passenger age (years)", expand = c(0, 0)) +
  scale_y_continuous(limits = c(0, 26), name = "scaled density", expand = c(0, 0)) +
  scale_fill_manual(
    values = c("#b3b3b3a0", "#D55E00", "#0072B2"), 
    breaks = c("all passengers", "male", "female"),
    labels = c("all passengers  ", "males  ", "females"),
    name = NULL,
    guide = guide_legend(direction = "horizontal")
  ) +
  coord_cartesian(clip = "off") +
  facet_wrap(~sex, labeller = labeller(sex = function(sex) paste(sex, "passengers"))) +
  theme_dviz_hgrid() +
  theme(
    axis.line.x = element_blank(),
    strip.text = element_text(size = 14, margin = margin(0, 0, 0.2, 0, "cm")),
    legend.position = "bottom",
    legend.justification = "right",
    legend.margin = margin(4.5, 0, 1.5, 0, "pt"),
    legend.spacing.x = grid::unit(4.5, "pt"),
    legend.spacing.y = grid::unit(0, "pt"),
    legend.box.spacing = grid::unit(0, "cm")
  )
}