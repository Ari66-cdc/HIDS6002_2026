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
#
#
#
#
#
#
source("rpm-setup.R")
head(weekly_program)
#
#
#
#
#
#
#
ggplot(weekly_program, aes(x = week_start, y = pct_submitting)) +
  geom_line() +
  scale_y_continuous(limits=c(0,80)) +
  labs(x = NULL, y = "Patients submitting a reading (%)")
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
ggplot(weekly_program, aes(x = week_start)) +
  geom_line(aes(y = pct_submitting), color = "grey70") +
  geom_line(aes(y = center_5wk), color = "#0072B2", linewidth = 1.2) +
  labs(x = NULL, y = "Patients submitting a reading (%)")
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
ggplot(weekly_program, aes(x = week_start, y = center_5wk)) +
  geom_line(color = "#0072B2", linewidth = 1.2) +
  scale_x_date(date_breaks = "2 months", date_labels = "%b") +
  labs(x = NULL, y = "Patients submitting a reading (%)")
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
ggplot(weekly_program, aes(x = week_start, y = center_5wk)) +
  geom_line(color = "#0072B2", linewidth = 1.2) +
  geom_vline(xintercept = protocol_start, linetype = "dashed") +
  annotate("text", x = protocol_start, y = Inf, label = "Nurse titration\nprotocol starts",
           hjust = 1.05, vjust = 1.5, size = 3.5) +
  scale_x_date(date_breaks = "2 months", date_labels = "%b") +
  labs(x = NULL, y = "Patients submitting a reading (%)")
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
ggplot(weekly_device, aes(x = week_start, y = pct_submitting, color = device_type)) +
  geom_line(linewidth = 1) +
  annotate("rect", xmin = shortage_start, xmax = shortage_end,
           ymin = -Inf, ymax = Inf, alpha = 0.2) +
  scale_x_date(date_breaks = "2 months", date_labels = "%b") +
  scale_color_viridis_d(end = 0.7) +
  labs(x = NULL, y = "Patients submitting a reading (%)", color = NULL)
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
ggplot(weekly_device, aes(x = week_start, y = pct_submitting, color = device_type)) +
  annotate("rect", xmin = shortage_start, xmax = shortage_end,
           ymin = -Inf, ymax = Inf, alpha = 0.2) +
  geom_line(linewidth = 1) +
  geom_text(aes(label = end_label), hjust = -0.1, na.rm = TRUE) +
  scale_x_date(date_breaks = "2 months", date_labels = "%b") +
  scale_color_viridis_d(end = 0.7) +
  labs(x = NULL, y = "Patients submitting a reading (%)") +
  theme(legend.position = "none")
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
