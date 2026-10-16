# rpm-setup.R
# Run this once at the top of each exercise:  source("rpm-setup.R")
#
# It loads ggplot2, sets a clean theme, reads the (simulated) remote blood
# pressure monitoring data, and defines a few constants used in the exercises.
# All patients, clinics, and values are fictional.

library(ggplot2)
theme_set(theme_minimal(base_size = 13))
if (!file.exists("data/patients.rds")) {
  stop("Can't find the data folder. Open the project folder in RStudio or VS Code ",
       "so that 'data/patients.rds' is in your working directory.")
}

# ---- Data -------------------------------------------------------------------
patients        <- readRDS("data/patients.rds")         # one row per patient
clinic_summary  <- readRDS("data/clinic_summary.rds")   # one row per clinic
clinic_device   <- readRDS("data/clinic_device.rds")    # clinic x device type
clinic_month    <- readRDS("data/clinic_month.rds")     # clinic x month
quarter_control <- readRDS("data/quarter_control.rds")  # quarter x BP status
clinic_effect   <- readRDS("data/clinic_effect.rds")    # mean reduction with 95% CI
weekly_program  <- readRDS("data/weekly_program.rds")   # program-wide, by week
weekly_device   <- readRDS("data/weekly_device.rds")    # by week and device type

# ---- Constants --------------------------------------------------------------
sbp_thresholds            <- c(130, 140)            # systolic cutoffs (mmHg)
target_days_first_reading <- 7                      # goal: first reading within a week
protocol_start            <- as.Date("2025-06-02")  # nurse titration protocol begins
shortage_start            <- as.Date("2025-08-04")  # cellular cuff supply shortage
shortage_end              <- as.Date("2025-09-14")