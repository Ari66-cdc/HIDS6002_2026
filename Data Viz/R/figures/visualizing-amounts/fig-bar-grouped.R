# from dataviz ch. 5 (bar chart with rotated axis labels)
fig_bar_grouped <- function(font_size = 12) {
income_by_age %>% filter(race %in% c("white", "asian", "black", "hispanic")) %>%
   mutate(race = fct_relevel(race, c("asian", "white", "hispanic", "black")),
          race = fct_recode(race, Asian = "asian", Hispanic = "hispanic"),
          age = fct_recode(age, "≥ 75" = "> 74")) -> income_df
# Take the darkest seven colors from 8-class ColorBrewer palette "PuBu"
colors_seven = RColorBrewer::brewer.pal(8, "PuBu")[2:8]

ggplot(income_df, aes(x = race, y = median_income, fill = age)) +
  geom_col(position = "dodge", alpha = 0.9) +
  scale_y_continuous(
    expand = c(0, 0),
    name = "median income (USD)",
    breaks = c(0, 20000, 40000, 60000, 80000, 100000),
    labels = c("$0", "$20,000", "$40,000", "$60,000", "$80,000", "$100,000")
  ) +
  scale_fill_manual(values = colors_seven, name = "age (yrs)") +
  coord_cartesian(clip = "off") +
  xlab(label = NULL) +
  theme_dviz_hgrid() +
  theme(
    axis.line.x = element_blank(),
    axis.ticks.x = element_blank(),
    legend.title.align = 0.5
  ) -> p_income_age_dodged

p_income_age_dodged
}