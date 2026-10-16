# Like chocolate-HOP-static (one panel per outcome, shared styling), but each
# panel shows a different model fit to the same data instead of a random draw.
fig_fit_comparison <- function(font_size = 12) {
fits <- c("linear", "quadratic", "cubic", "spline")
dat <- mtcars
grid <- data.frame(disp = seq(min(dat$disp), max(dat$disp), length.out = 200))

pred_df <- bind_rows(
  data.frame(grid, mpg = predict(lm(mpg ~ disp, dat), grid), fit = "linear"),
  data.frame(grid, mpg = predict(lm(mpg ~ poly(disp, 2), dat), grid), fit = "quadratic"),
  data.frame(grid, mpg = predict(lm(mpg ~ poly(disp, 3), dat), grid), fit = "cubic"),
  data.frame(grid, mpg = predict(mgcv::gam(mpg ~ s(disp, bs = "ts", k = 6), data = dat, method = "REML"), grid),
             fit = "spline")
) %>%
  mutate(fit = factor(fit, levels = fits))

points_df <- tidyr::crossing(dat, fit = factor(fits, levels = fits))

ggplot(points_df, aes(disp, mpg)) +
  geom_point(color = "grey60", size = 1.5) +
  geom_line(data = pred_df, color = "#0072B2", linewidth = 1) +
  facet_wrap(~fit, nrow = 2,
             labeller = labeller(fit = function(x) paste(x, "fit"))) +
  scale_x_continuous(name = "displacement (cu. in.)") +
  scale_y_continuous(name = "fuel efficiency (mpg)") +
  theme_dviz_hgrid(12, rel_small = 1) +
  theme(
    axis.line.x = element_line(color = "black"),
    axis.ticks.x = element_line(color = "black"),
    axis.line.y = element_blank(),
    strip.background = element_blank(),
    strip.text = element_text(size = 12, margin = margin(0, 0, 0.2, 0, "cm"))
  ) +
  panel_border()
}
