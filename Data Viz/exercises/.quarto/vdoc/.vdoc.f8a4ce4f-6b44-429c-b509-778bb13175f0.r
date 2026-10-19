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
head(patients)
#
#
#
#
#
#
#
ggplot(patients, aes(x = baseline_sbp, y = sbp_6mo)) +
  geom_point() +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed")
#
#
#
#
#
#
#
#
#
ggplot(patients, aes(x = baseline_sbp, y = sbp_6mo, color = device_type )) +
  geom_point(size = 2, alpha = 0.7) 
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
ggplot(clinic_summary, aes(x = clinic, y = n_patients)) +
  geom_col()
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
ggplot(clinic_device, aes(x = clinic, y = pct_controlled, fill = device_type)) +
  geom_col(position = "dodge") +
  scale_fill_viridis_d()
#
#
#
#
#
#
#
#
#
ggplot(clinic_month, aes(x = month, y = clinic, fill = mean_readings_wk)) +
  geom_tile(color = "white") +
  scale_fill_viridis_c(option = "magma") +
  labs(x = NULL, y = NULL, fill = "Readings\nper week")
#
#
#
#
#
#
#
#
#
ggplot(quarter_control, aes(x = quarter, y = pct, fill = status)) +
  geom_col(position = position_stack(reverse = TRUE)) +
  geom_hline(yintercept = 50, linetype = "dashed") +
  scale_fill_viridis_d(end = 0.85) +
  labs(x = NULL, y = "Share of patients (%)", fill = NULL)
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
ggplot(quarter_control, aes(x = "", y = pct, fill = status)) +
  geom_col(width = 1) +
  coord_polar(theta = "y") +
  facet_wrap(~ quarter) +
  scale_fill_viridis_d(end = 0.85) +
  theme_void() +
  labs(fill = NULL)
#
#
#
#
#
library(dplyr)
library(tidyr)
library(ggplot2)

# 1. Expand pct into 10 discrete units (1 unit = 10%)
quarter_dots <- quarter_control |>
  mutate(n_units = round(pct / 10)) |>
  uncount(n_units) |>
  group_by(quarter) |>
  mutate(unit_id = row_number() * 10) |> 
  ungroup()

# 2. Plot with shape = 21 (circles) or shape = 22 (boxes)
ggplot(quarter_dots, aes(x = quarter, y = unit_id, fill = status)) +
  geom_point(
    shape = 22,             # Use 22 for boxes, 21 for circles
    size = 12,               # Adjust size to fit your spacing
    stroke = 0.8,           # Border thickness
    color = "black"         # Border color
  ) +
  geom_hline(yintercept = 50, linetype = "dashed", color = "gray40") +
  scale_y_continuous(limits = c(5, 105), breaks = seq(0, 100, 20)) +
  scale_fill_viridis_d(end = 0.85) +
  labs(x = NULL, y = "Share of patients (%)", fill = NULL) +
  theme_minimal()
#
#
#
