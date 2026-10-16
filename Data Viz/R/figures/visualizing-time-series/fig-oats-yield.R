fig_oats_yield <- function(font_size = 12) {
oats_df <- MASS::oats %>%
  # 1 long (UK) cwt == 112 lbs == 50.802345 kg
  mutate(N = 1*as.numeric(sub("cwt", "", N, fixed = TRUE))) %>%
  group_by(N, V) %>%
  summarize(mean = 20 * mean(Y), .groups = "drop") %>% # factor 20 converts units to lbs/acre
  mutate(variety = ifelse(V == "Golden.rain", "Golden Rain", as.character(V)))

oats_df$variety <- factor(oats_df$variety, levels = c("Marvellous", "Golden Rain", "Victory"))

ggplot(oats_df,
       aes(N, mean, color = variety, shape = variety, fill = variety)) +
  geom_line(linewidth = 0.75) + geom_point(color = "white", size = 2.5) +
  scale_y_continuous(name = "mean yield (lbs/acre)") +
  scale_x_continuous(name = "manure treatment (cwt/acre)") +
  scale_shape_manual(values = c(21, 22, 23),
                     name = "oat variety") +
  scale_color_manual(values = c("#0072b2", "#D55E00", "#009e73"),
                     name = "oat variety") +
  scale_fill_manual(values = c("#0072b2", "#D55E00", "#009e73"),
                     name = "oat variety") +
  coord_cartesian(clip = "off") +
  theme_dviz_open() +
  theme(legend.title.align = 0.5)
}
