fig_stacked_histogram <- function(font_size = 12) {
    data.frame(
  age = (1:25)*3 - 1.5, 
  male = hist(filter(titanic, sex == "male")$age, breaks = (0:25)*3 + .01, plot = FALSE)$counts,
  female = hist(filter(titanic, sex == "female")$age, breaks = (0:25)*3 + .01, plot = FALSE)$counts
) %>%
  gather(gender, count, -age) -> gender_counts

gender_counts$gender <- factor(gender_counts$gender, levels = c("female", "male"))

p_hist_overlapped <- ggplot(gender_counts, aes(x = age, y = count, fill = gender)) + 
  geom_col(position = "identity", alpha = 0.7) +
  scale_x_continuous(name = "age (years)", limits = c(0, 75), expand = c(0, 0)) +
  scale_y_continuous(limits = c(0, 56), expand = c(0, 0), name = "count") +
  scale_fill_manual(
    values = c("#D55E00", "#0072B2"),
    guide = guide_legend(reverse = TRUE)
  ) +
  coord_cartesian(clip = "off") +
  theme_dviz_hgrid() +
  theme(
    axis.line.x = element_blank(),
    legend.position = c(.9, .87),
    legend.justification = c("right", "top"),
    legend.box.background = element_rect(fill = "white", color = "white"),
    plot.margin = margin(3, 7, 3, 1.5)
  )

stamp_bad(p_hist_overlapped)
}