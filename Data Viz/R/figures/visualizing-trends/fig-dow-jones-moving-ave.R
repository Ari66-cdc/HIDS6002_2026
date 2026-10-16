fig_dow_jones_moving_ave <- function(font_size = 12) {
dow <- dow_jones_industrial %>%
  filter(date >= lubridate::ymd("2008/12/31") & date <= lubridate::ymd("2010/01/10"))
x_limits <- c(lubridate::ymd("2008-12-31"), lubridate::ymd("2010-01-10"))

ma_colors <- c(`20d` = "#009e73", `50d` = "#d55e00", `100d` = "#0072b2")
ma_labels <- c("20-day average", "50-day average", "100-day average")

# lagged (trailing) moving average
p1 <- dow %>%
  mutate(
    close_20d_ave = moving_ave(date, close, 20, center = FALSE),
    close_50d_ave = moving_ave(date, close, 50, center = FALSE),
    close_100d_ave = moving_ave(date, close, 100, center = FALSE)
  ) %>%
  ggplot(aes(date, close)) +
  geom_line(color = "grey20", linewidth = .35) +
  geom_line(aes(date, close_20d_ave, color = "20d"), linewidth = 1, na.rm = TRUE) +
  geom_line(aes(date, close_50d_ave, color = "50d"), linewidth = 1, na.rm = TRUE) +
  geom_line(aes(date, close_100d_ave, color = "100d"), linewidth = 1, na.rm = TRUE) +
  scale_color_manual(
    values = ma_colors,
    breaks = c("20d", "50d", "100d"),
    labels = ma_labels,
    name = NULL
  ) +
  scale_x_date(limits = x_limits, expand = c(0, 0), labels = NULL) +
  xlab(NULL) + ylab("Dow Jones Industrial Average") +
  theme_dviz_grid() +
  theme(
    plot.margin = margin(3, 12, 3, 1.5),
    legend.position = c(1, 0),
    legend.justification = c(1, 0),
    legend.box.background = element_rect(fill = "white", color = NA),
    legend.box.margin = margin(6, 12, 0, 12),
    axis.ticks.x = element_blank()
  )

# centered moving average
p2 <- dow %>%
  mutate(
    close_20d_ave = moving_ave(date, close, 20, center = TRUE),
    close_50d_ave = moving_ave(date, close, 50, center = TRUE),
    close_100d_ave = moving_ave(date, close, 100, center = TRUE)
  ) %>%
  ggplot(aes(date, close)) +
  geom_line(color = "grey20", linewidth = .35) +
  geom_line(aes(date, close_20d_ave, color = "20d"), linewidth = 1, na.rm = TRUE) +
  geom_line(aes(date, close_50d_ave, color = "50d"), linewidth = 1, na.rm = TRUE) +
  geom_line(aes(date, close_100d_ave, color = "100d"), linewidth = 1, na.rm = TRUE) +
  scale_color_manual(
    values = ma_colors,
    breaks = c("20d", "50d", "100d"),
    labels = ma_labels,
    name = NULL,
    guide = "none"
  ) +
  scale_x_date(limits = x_limits, expand = c(0, 0)) +
  xlab(NULL) + ylab("Dow Jones Industrial Average") +
  theme_dviz_grid() +
  theme(
    plot.margin = margin(3, 12, 3, 1.5)
  )

plot_grid(p1, p2, ncol = 1, align = 'h', labels = "auto")
}
