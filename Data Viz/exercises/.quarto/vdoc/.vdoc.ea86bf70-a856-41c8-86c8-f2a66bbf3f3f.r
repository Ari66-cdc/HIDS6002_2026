#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
source("rpm-setup.R")
#
#
#
#
#
#
#
#
#
#
#
#
#
#| label: bad-chart
#| fig-width: 8
#| fig-height: 5

# One row per clinic: total systolic BP reduction among its patients
bad <- aggregate(sbp_reduction ~ clinic, data = patients, FUN = sum)
names(bad)[2] <- "total_reduction"
bad$clinic <- factor(bad$clinic, levels = sort(as.character(bad$clinic)))

ggplot(bad, aes(x = clinic, y = total_reduction, fill = clinic)) +
  geom_col() +
  coord_cartesian(ylim = c(0.8 * min(bad$total_reduction),
                           1.02 * max(bad$total_reduction))) +
  scale_fill_manual(values = rainbow(nlevels(bad$clinic))) +
  labs(title = "Results by Clinic", x = "Clinic", y = "SBP (mmHg)") +
  theme_gray(base_size = 13) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        panel.border = element_rect(colour = "black", fill = NA, linewidth = 1.2),
        panel.grid.major = element_line(colour = "grey40"),
        panel.grid.minor = element_line(colour = "grey70"))
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| label: fixed-chart

# Your code here
#
#
#
#
#
#
#
#| label: part2-figure

# Start here: what comparison does the committee need? Look at patients
# (total_readings, sbp_reduction, age_group, device_type, clinic) and
# clinic_summary before you choose a chart type.
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
