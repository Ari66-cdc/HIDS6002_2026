# One function per plot. Each returns a ggplot object.
# Paste chapter code into the body and note its source above it.
# Put any data prep inside the function so each plot is self-contained.

# from dataviz ch. XX (replace with the real chapter)
fig_temp_houston <- function(font_size = 12) {
  temps <- dplyr::filter(dviz.supp::ncdc_normals,
                         station_id == "USW00012918")  # Houston, TX

  ggplot(temps, aes(x = date, y = temperature)) +
    geom_line(linewidth = 1, color = "#0072B2") +
    scale_x_date(
      name = "month",
      limits = c(lubridate::ymd("0000-01-01"), lubridate::ymd("0001-01-03")),
      breaks = c(lubridate::ymd("0000-01-01"), lubridate::ymd("0000-04-01"),
                 lubridate::ymd("0000-07-01"), lubridate::ymd("0000-10-01"),
                 lubridate::ymd("0001-01-01")),
      labels = c("Jan", "Apr", "Jul", "Oct", "Jan"),
      expand = c(2/366, 0)
    ) +
    scale_y_continuous(limits = c(50, 90), name = "temperature (°F)") +
    theme_dviz_grid(font_size) +
    theme(plot.margin = margin(3, 5, 3, 1.5))
}
