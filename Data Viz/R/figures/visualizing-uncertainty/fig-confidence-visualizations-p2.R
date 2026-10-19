fig_confidence_visualizations_p2 <- function(font_size = 12) {
cacao_smaller <- filter(cacao_small, location != "Switzerland")

fit <- lm(rating ~ location, data = cacao_smaller)
fit_rg <- emmeans::ref_grid(fit)

contrasts_dunnettx <- data.frame(level = c(0.99, 0.95, 0.8)) %>%
  mutate(
    df = purrr::map(
      level,
      ~data.frame(confint(emmeans::contrast(fit_rg, method = "trt.vs.ctrl1"), level = .x))
    )
  ) %>%
  tidyr::unnest(df) %>%
  select(level, contrast, estimate, std.error = SE, conf.low = lower.CL, conf.high = upper.CL) %>%
  mutate(
    level = paste0(signif(100*level, 2), "%"),
    contrast = stringr::str_extract(as.character(contrast), "[a-zA-Z]+")
  )

ggplot(filter(contrasts_dunnettx, level == "95%"),
       aes(x = estimate, y = reorder(contrast, estimate))) +
  geom_vline(xintercept = 0, linetype = 2, color = "gray50") +
  geom_errorbarh(
    aes(xmin = conf.low, xmax = conf.high),
    height = 0.2
  ) +
  geom_point(size = 2.5, color = "#D55E00") +
  scale_x_continuous(
    name = "difference in mean rating of chocolate\nby country of origin(95% CI)",
    limits = c(-.65, .47),
    expand = c(0, 0)
  ) +
  scale_y_discrete(name = NULL) +
  coord_cartesian(clip = "off") +
  theme_dviz_hgrid(12, rel_small = 1) +
  theme(
    axis.line.x = element_line(color = "black"),
    axis.line.x.top = element_blank(),
    axis.ticks.x = element_line(color = "black"),
    axis.ticks.x.top = element_line(color = "gray50")
  )
}
