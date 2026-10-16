# make_rpm_data.R
# Generates the SIMULATED remote blood pressure monitoring (RPM) data used in
# the four ggplot2 exercises. All patients, clinics, and values are fictional.
#
# Run from the project root (the folder that contains rpm-setup.R):
#   Rscript instructor/make_rpm_data.R
#
# What it does:
#   1. Simulates 400 patients and their weekly readings (patient_weeks).
#   2. Builds the plot-ready tables students receive.
#   3. Runs the validation checks in check_rpm_data.R.
#   4. Tries seeds 1..max_seeds and keeps the first seed that passes every
#      check (or, failing that, the seed that passes the most).
#   5. Writes data/*.rds, data/csv/*.csv, and instructor/patient_weeks.rds.
#
# Needs: dplyr, tidyr (the tidyverse). R >= 4.1 (native pipe).

suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
})
source("exercises/instructor/check_rpm_data.R")

# ---- Clinics (fictional) ----------------------------------------------------
# n     patients enrolled
# eng   engagement multiplier on weekly reading rate
# base  shift in baseline systolic mean (mmHg)
# eff   clinic effect on 6-month systolic reduction (mmHg)
# first shift in log days-to-first-reading (Northside is slow)
rpm_clinics <- data.frame(
  clinic = c("Eastgate", "Harbor", "Hillcrest", "Lakeview",
             "Maple Grove", "Northside", "Riverside", "Westfield"),
  n      = c(40, 78, 32, 62, 30, 70, 54, 34),
  eng    = c(0.90, 1.10, 0.85, 1.05, 0.55, 0.95, 1.00, 1.00),
  base   = c(0, 0, 2, 0, 4, 0, 4, 0),
  eff    = c(-0.5, 4.0, -2.5, 2.5, -2.5, 0, 0, 1.0),
  first  = c(0, 0, 0, 0, 0, 0.9, 0, 0),
  stringsAsFactors = FALSE
)

# ---- Model parameters -------------------------------------------------------
rpm_params <- list(
  base_mean  = 142,   # baseline systolic mean before the >= 130 enrollment cut
  base_sd    = 14,
  rate_med   = 3.5,   # median readings per week at the start
  rate_sd    = 0.75,  # patient-to-patient spread (log scale)
  bt_mult    = 0.58,  # Bluetooth engagement multiplier
  bt65       = 0.50,  # extra multiplier for Bluetooth patients aged 65+
  decay      = 0.018, # weekly fade in engagement
  proto_add  = 1.0,   # extra readings per week after the nurse protocol starts
  short_mult = 0.40,  # cellular engagement multiplier during the shortage
  p_drop     = 0.18,  # share of patients who stop transmitting
  nb_size    = 1.2,   # negative binomial size (smaller = more zero weeks)
  red_c      = -15.4, # dose-response intercept
  red_b      = 5.0,   # reduction per log-unit of total readings
  red_noise  = 5,     # patient-level noise (mmHg)
  reg        = 0.2,   # regression toward the mean
  cell_direct = 2.5,  # direct benefit of Cellular (mmHg)
  east_bt    = 3.0,   # Eastgate: Bluetooth benefit instead (reversal)
  proto_extra = 2.0,  # extra systolic drop after the nurse protocol (mmHg)
  lag_add    = 2.5,   # systolic rise on Cellular after the shortage (mmHg)
  wk_noise   = 9,     # weekly measurement noise (mmHg)
  g_tau      = 13     # speed of BP improvement (weeks)
)

# ---- Simulation -------------------------------------------------------------
simulate_rpm <- function(seed, p = rpm_params, clin = rpm_clinics) {
  set.seed(seed)
  N <- sum(clin$n)
  K <- 52
  clinic <- sample(rep(clin$clinic, clin$n))      # shuffle so head() mixes clinics
  idx <- match(clinic, clin$clinic)
  eng <- clin$eng[idx]
  base_off <- clin$base[idx]
  eff <- clin$eff[idx]
  first_shift <- clin$first[idx]

  # Patients
  age <- pmin(85, pmax(25, round(rnorm(N, 58, 12))))
  age_group <- cut(age, breaks = c(-Inf, 44, 64, Inf),
                   labels = c("18–44", "45–64", "65+"),
                   ordered_result = TRUE)
  cellular <- runif(N) < 0.5
  device_type <- factor(ifelse(cellular, "Cellular", "Bluetooth"),
                        levels = c("Bluetooth", "Cellular"))
  off <- sample(0:81, N, replace = TRUE)           # enrollment: Jan 6 - Mar 28
  enrollment_date <- rpm_start + off

  mu <- p$base_mean + base_off
  b <- rnorm(N, mu, p$base_sd)
  bad <- b < 130
  while (any(bad)) {                               # enrollment required SBP >= 130
    b[bad] <- rnorm(sum(bad), mu[bad], p$base_sd)
    bad <- b < 130
  }
  baseline_sbp <- as.integer(round(b))

  lf <- log(4) + first_shift - 0.3 * cellular
  days_to_first_reading <- as.integer(pmin(60, pmax(1, round(exp(rnorm(N, lf, 0.9))))))

  # Engagement: weekly reading rate per patient
  east <- clinic == "Eastgate"
  devm <- ifelse(cellular, 1, ifelse(east, 1, p$bt_mult))
  agem <- ifelse(!cellular & age >= 65 & !east, p$bt65, 1)
  rate <- p$rate_med * exp(rnorm(N, 0, p$rate_sd)) * eng * devm * agem

  # Patient x week grid
  weeks <- rpm_start + 7 * (0:(K - 1))
  col_mat <- function(v) matrix(v, nrow = N, ncol = K)               # per-patient
  row_mat <- function(v) matrix(v, nrow = N, ncol = K, byrow = TRUE) # per-week
  kk <- row_mat(0:(K - 1))
  e_idx <- off %/% 7
  f_idx <- (off + days_to_first_reading) %/% 7
  tt <- kk - col_mat(e_idx)                        # weeks since enrollment week

  drop <- runif(N) < p$p_drop
  drop_t <- sample(6:40, N, replace = TRUE)
  drop_t <- pmax(drop_t, (f_idx - e_idx) + 2)
  drop_t <- ifelse(drop, drop_t, 1e6)
  active <- (tt >= 0) & (kk >= col_mat(f_idx)) & (tt < col_mat(drop_t))

  protoadd <- ifelse(weeks >= rpm_protocol_start, p$proto_add, 0)
  hol <- rep(1, K)
  hol[weeks == as.Date("2025-06-30")] <- 0.90
  hol[weeks == as.Date("2025-11-24")] <- 0.75
  hol[weeks %in% as.Date(c("2025-12-22", "2025-12-29"))] <- 0.70
  in_short <- weeks >= rpm_shortage_start & weeks <= rpm_shortage_end
  shortm <- ifelse(row_mat(in_short) & col_mat(cellular), p$short_mult, 1)

  lam <- (col_mat(rate) * exp(-p$decay * pmax(tt, 0)) + row_mat(protoadd)) *
    row_mat(hol) * shortm
  lam <- ifelse(active, lam, 0)
  cnt <- ifelse(lam > 0,
                rnbinom(length(lam), mu = pmax(lam, 1e-9), size = p$nb_size),
                0)
  cnt <- pmin(cnt, 14)                             # at most twice daily
  first_week <- (kk == col_mat(f_idx)) & active
  cnt <- ifelse(first_week, pmax(cnt, 1), cnt)     # everyone submits at least once

  in6 <- (tt >= 0) & (tt <= 25)
  total_readings <- as.integer(rowSums(cnt * in6)) # first 26 weeks after enrollment

  # Outcome: log-linear dose-response, regression to the mean, clinic and device effects
  cell_d <- ifelse(east, ifelse(cellular, 0, p$east_bt),
                   ifelse(cellular, p$cell_direct, 0))
  red <- p$red_c + p$red_b * log(pmax(total_readings, 5)) + eff +
    p$reg * (baseline_sbp - 150) + cell_d + rnorm(N, 0, p$red_noise)

  # Planted outliers: low engagement with a big drop, high engagement with a rise
  low <- which(total_readings < 25)
  low <- low[order(total_readings[low])]
  low <- low[seq_len(min(12, length(low)))]
  pick <- if (length(low) >= 3) sample(low, 3) else low
  red[pick] <- c(26, 30, 24)[seq_along(pick)]
  hi <- which(total_readings > 200)
  hi <- hi[order(-total_readings[hi])]
  hi <- hi[seq_len(min(12, length(hi)))]
  pick2 <- if (length(hi) >= 3) sample(hi, 3) else hi
  red[pick2] <- c(-10, -12, -9)[seq_along(pick2)]

  sbp_6mo <- as.integer(pmin(210, pmax(100, round(baseline_sbp - red))))
  sbp_reduction <- baseline_sbp - sbp_6mo
  controlled_6mo <- sbp_6mo < 140                  # systolic only, a simplification

  # Weekly mean home systolic
  g <- (1 - exp(-pmax(tt, 0) / p$g_tau)) / (1 - exp(-26 / p$g_tau))
  pextra <- ifelse(weeks >= rpm_protocol_start,
                   p$proto_extra * pmin(1, as.numeric(weeks - rpm_protocol_start) / 7 / 8),
                   0)
  lag_wk <- weeks >= rpm_lag_start & weeks <= rpm_lag_end
  lagm <- ifelse(row_mat(lag_wk) & col_mat(cellular), p$lag_add, 0)
  noise <- matrix(rnorm(N * K), N, K) * p$wk_noise / sqrt(pmax(cnt, 1))
  msbp <- col_mat(baseline_sbp) - col_mat(sbp_reduction) * g - row_mat(pextra) +
    lagm + noise
  msbp[cnt < 1] <- NA

  patient_id <- sprintf("P%03d", seq_len(N))
  patients <- data.frame(
    patient_id, clinic = factor(clinic, levels = clin$clinic),
    age = as.integer(age), age_group, device_type, enrollment_date,
    baseline_sbp, days_to_first_reading, total_readings,
    sbp_6mo, sbp_reduction, controlled_6mo,
    stringsAsFactors = FALSE
  )

  v <- which(tt >= 0, arr.ind = TRUE)              # (row, col) of enrolled patient-weeks
  patient_weeks <- data.frame(
    patient_id  = patient_id[v[, 1]],
    clinic      = patients$clinic[v[, 1]],
    device_type = device_type[v[, 1]],
    age_group   = age_group[v[, 1]],
    week_start  = weeks[v[, 2]],
    tt          = tt[v],
    readings    = as.integer(cnt[v]),
    mean_sbp    = msbp[v]
  )
  list(patients = patients, patient_weeks = patient_weeks)
}

# ---- Plot-ready tables ------------------------------------------------------
build_tables <- function(pat, pw) {
  clinic_summary <- pat |>
    group_by(clinic) |>
    summarize(n_patients = n(),
              pct_controlled = round(100 * mean(controlled_6mo), 1),
              mean_readings_wk = round(mean(total_readings) / 26, 2),
              median_days_first_reading = median(days_to_first_reading),
              .groups = "drop")

  clinic_device <- pat |>
    group_by(clinic, device_type) |>
    summarize(n_patients = n(),
              pct_controlled = round(100 * mean(controlled_6mo), 1),
              .groups = "drop")

  clinic_month <- pw |>
    mutate(month = factor(month.abb[as.integer(format(week_start, "%m"))],
                          levels = month.abb, ordered = TRUE)) |>
    group_by(clinic, month) |>
    summarize(mean_readings_wk = round(mean(readings), 2), .groups = "drop")

  quarter_control <- pw |>
    filter(readings >= 1) |>
    mutate(quarter = ceiling(as.integer(format(week_start, "%m")) / 3)) |>
    group_by(patient_id, quarter) |>
    summarize(m = mean(mean_sbp), .groups = "drop") |>
    group_by(quarter) |>
    summarize(Controlled = round(100 * mean(m < 140), 1), .groups = "drop") |>
    mutate(`Not controlled` = round(100 - Controlled, 1)) |>
    pivot_longer(c(Controlled, `Not controlled`),
                 names_to = "status", values_to = "pct") |>
    mutate(quarter = factor(paste0("Q", quarter), levels = paste0("Q", 1:4),
                            ordered = TRUE),
           status = factor(status, levels = c("Controlled", "Not controlled"))) |>
    arrange(quarter, status)

  clinic_effect <- pat |>
    group_by(clinic) |>
    summarize(n_patients = n(),
              mean_reduction = mean(sbp_reduction),
              se = sd(sbp_reduction) / sqrt(n()),
              .groups = "drop") |>
    mutate(h = qt(0.975, n_patients - 1) * se,
           ci_low = round(mean_reduction - h, 2),
           ci_high = round(mean_reduction + h, 2),
           mean_reduction = round(mean_reduction, 2)) |>
    select(clinic, n_patients, mean_reduction, ci_low, ci_high)

  weekly_program <- pw |>
    group_by(week_start) |>
    summarize(n_enrolled = n(),
              pct_submitting = 100 * mean(readings >= 1),
              .groups = "drop") |>
    mutate(trail_5wk = as.numeric(stats::filter(pct_submitting, rep(1 / 5, 5), sides = 1)),
           center_5wk = as.numeric(stats::filter(pct_submitting, rep(1 / 5, 5), sides = 2)),
           pct_submitting = round(pct_submitting, 1),
           trail_5wk = round(trail_5wk, 1),
           center_5wk = round(center_5wk, 1))

  weekly_device <- pw |>
    group_by(week_start, device_type) |>
    summarize(pct_submitting = round(100 * mean(readings >= 1), 1),
              mean_sbp = round(mean(mean_sbp, na.rm = TRUE), 1),
              .groups = "drop") |>
    group_by(device_type) |>
    mutate(end_label = ifelse(week_start == max(week_start),
                              as.character(device_type), NA_character_)) |>
    ungroup()

  list(clinic_summary = as.data.frame(clinic_summary),
       clinic_device = as.data.frame(clinic_device),
       clinic_month = as.data.frame(clinic_month),
       quarter_control = as.data.frame(quarter_control),
       clinic_effect = as.data.frame(clinic_effect),
       weekly_program = as.data.frame(weekly_program),
       weekly_device = as.data.frame(weekly_device))
}

# ---- Seed search ------------------------------------------------------------
find_seed <- function(seeds = 1:400) {
  best <- NULL
  best_n <- -1
  for (s in seeds) {
    sim <- simulate_rpm(s)
    tabs <- build_tables(sim$patients, sim$patient_weeks)
    res <- check_rpm(sim$patients, sim$patient_weeks, tabs)
    n_pass <- sum(res$pass)
    if (n_pass > best_n) {
      best_n <- n_pass
      best <- list(seed = s, sim = sim, tabs = tabs, res = res)
    }
    if (s %% 10 == 0 || all(res$pass)) {
      cat(sprintf("seed %d: %d/%d checks pass (best so far: seed %d, %d)\n",
                  s, n_pass, nrow(res), best$seed, best_n))
    }
    if (all(res$pass)) break
  }
  best
}

# ---- Main -------------------------------------------------------------------
main <- function(max_seeds = 400) {
  best <- find_seed(1:max_seeds)
  cat(sprintf("\nUsing seed %d\n\n", best$seed))
  print_rpm_report(best$res)

  dir.create("exercises/data/csv", recursive = TRUE, showWarnings = FALSE)
  dir.create("exercises/instructor", showWarnings = FALSE)
  all_tabs <- c(list(patients = best$sim$patients), best$tabs)
  for (nm in names(all_tabs)) {
    saveRDS(all_tabs[[nm]], file.path("exercises/data", paste0(nm, ".rds")))
    write.csv(all_tabs[[nm]], file.path("exercises/data/csv", paste0(nm, ".csv")),
              row.names = FALSE, na = "")
  }
  saveRDS(best$sim$patient_weeks, "exercises/instructor/patient_weeks.rds")
  cat("\nWrote data/*.rds, data/csv/*.csv, and exercises/instructor/patient_weeks.rds\n")
  if (!all(best$res$pass)) {
    cat("WARNING: no seed passed every check. Review the FAIL rows above.\n")
  }
  invisible(best)
}

main()
