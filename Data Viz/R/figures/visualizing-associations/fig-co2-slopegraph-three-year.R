fig_co2_slopegraph_three_year <- function(font_size = 12) {
CO2_emissions %>% filter(year %in% c(2000, 2005, 2010)) %>%
  tidyr::spread(year, emissions) %>%
  na.omit() %>%
  mutate(diff = `2010` - `2000`, absdiff = abs(diff)) %>%
  arrange(desc(absdiff)) -> emissions_diff

emissions_diff[1:10,] %>% select(-diff) %>%
  tidyr::gather(year, emissions, `2000`:`2010`) %>%
  mutate(year = as.numeric(year)) -> emissions_top_ten

textcol <- "gray30"

labels_df <- filter(emissions_top_ten, year == 2010) %>%
  left_join(
    tibble::tibble(
      country = c("Trinidad and Tobago", "Qatar", "United Arab Emirates", "Oman", "Bahrain", "Singapore", "Netherlands Antilles", "Kazakhstan", "Equatorial Guinea", "Kuwait"),
      nudge_y = c(.1, .1, .1, .1, -.3, .1, .7, .1, .1, .1)
    ),
    by = "country"
  )

ggplot(emissions_top_ten, aes(x = year, y = emissions)) +
  geom_line(aes(group = country), color = "gray60") +
  geom_point(color = "white", size = 4) +
  geom_point(color = "#0072B2", size = 2) +
  geom_text(
    data = labels_df,
    aes(x = year + 0.45, y = emissions + nudge_y, label = country),
    family = dviz_font_family,
    size = 10/.pt,
    hjust = 0) +
  scale_x_continuous(
    limits = c(2000, 2020), breaks = c(2000, 2005, 2010),
    labels = c("2000", "2005", "2010"),
    expand = expansion(add = c(1, 0)),
    name = NULL,
    position = "top"
  ) +
  scale_y_continuous(
    limits = c(0, 63.2),
    expand = c(0, 0),
    name = parse(text = "`CO`[2]*` emissions (tons / person)`")
  ) +
  coord_cartesian(clip = "off") +
  theme_dviz_open() +
  theme(
    axis.line.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.title.y = element_text(color = textcol),
    axis.text.y = element_text(color = textcol),
    axis.line.y.left = element_line(color = textcol),
    axis.text.y.right = element_text(
      hjust = 0, vjust = .5,
      margin = margin(0, 0, 0, 0),
      color = "black",
      lineheight = 0.8
    ),
    axis.line.y.right = element_blank(),
    axis.ticks.y.right = element_blank(),
    plot.margin = margin(3.5, 1.5, 7, 1.5)
  )
}
