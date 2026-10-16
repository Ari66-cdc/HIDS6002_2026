# check_rpm_data.R
# Validation checks for the simulated remote BP monitoring (RPM) data.
#
# Two ways to use this file (run from the project root, the folder that
# contains rpm-setup.R):
#   1. Source it, then call check_rpm(patients, patient_weeks, tabs).
#      make_rpm_data.R does this for every candidate seed.
#   2. Run it on its own to audit the shipped files:
#        Rscript instructor/check_rpm_data.R
#      This reads data/*.rds and instructor/patient_weeks.rds.
#
# Each check returns pass/fail, the observed value, and the target.

suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
})

# ---- Shared date constants (must match rpm-setup.R) -------------------------
rpm_start           <- as.Date("2025-01-06")  # first Monday of the program year
rpm_protocol_start  <- as.Date("2025-06-02")  # nurse titration protocol launch
rpm_shortage_start  <- as.Date("2025-08-04")  # cellular cuff supply shortage
rpm_shortage_end    <- as.Date("2025-09-14")
rpm_lag_start       <- as.Date("2025-08-18")  # lagged systolic rise on cellular
rpm_lag_end         <- as.Date("2025-10-12")

check_rpm <- function(patients, patient_weeks, tabs) {
  pat <- patients
  pw  <- patient_weeks
  cs  <- tabs$clinic_summary
  ce  <- tabs$clinic_effect
  wp  <- tabs$weekly_program
  wd  <- tabs$weekly_device

  out <- list()
  add <- function(name, pass, value = NA_real_, target = "") {
    out[[length(out) + 1]] <<- data.frame(
      check  = name,
      pass   = isTRUE(pass),
      value  = as.character(round(as.numeric(value), 2)),
      target = target,
      stringsAsFactors = FALSE
    )
  }
  between <- function(x, lo, hi) x >= lo & x <= hi

  # ---- Structure ------------------------------------------------------------
  rows <- c(patients = nrow(pat), clinic_summary = nrow(cs),
            clinic_device = nrow(tabs$clinic_device),
            clinic_month = nrow(tabs$clinic_month),
            quarter_control = nrow(tabs$quarter_control),
            clinic_effect = nrow(ce), weekly_program = nrow(wp),
            weekly_device = nrow(wd))
  expected <- c(400, 8, 16, 96, 8, 8, 52, 104)
  add("table row counts match spec", all(rows == expected),
      sum(rows != expected), "0 mismatches")
  add("no missing values in patients", !anyNA(pat), sum(is.na(pat)), "0")
  add("factor order: months Jan-Dec, age_group ordered, clinic alphabetical",
      identical(levels(tabs$clinic_month$month), month.abb) &&
        is.ordered(pat$age_group) &&
        identical(levels(pat$clinic), sort(levels(pat$clinic))),
      NA_real_, "TRUE")
  recomputed <- pat |>
    group_by(clinic) |>
    summarize(p = 100 * mean(controlled_6mo), .groups = "drop")
  add("clinic_summary reconciles with patients",
      max(abs(recomputed$p - cs$pct_controlled)) <= 0.06,
      max(abs(recomputed$p - cs$pct_controlled)), "<= 0.06")

  # ---- Distributions (Exercise 2) ------------------------------------------
  add("baseline systolic >= 130 for everyone",
      min(pat$baseline_sbp) >= 130, min(pat$baseline_sbp), ">= 130")
  mb <- median(pat$baseline_sbp)
  add("baseline systolic median", between(mb, 145, 152), mb, "145-152")
  u140 <- 100 * mean(pat$baseline_sbp < 140)
  add("% under 140 at baseline", between(u140, 20, 32), u140, "20-32")
  md <- median(pat$days_to_first_reading)
  add("median days to first reading", between(md, 3, 5.5), md, "3-5.5")
  add("max days to first reading (long tail)",
      max(pat$days_to_first_reading) >= 30,
      max(pat$days_to_first_reading), ">= 30")
  ns <- cs$median_days_first_reading[cs$clinic == "Northside"]
  oth <- max(cs$median_days_first_reading[cs$clinic != "Northside"])
  add("Northside is the slow clinic (median 7-12 d, above all others)",
      between(ns, 7, 12) && ns > oth, ns, "7-12 and highest")

  # ---- Amounts and proportions (Exercise 1) --------------------------------
  oc <- 100 * mean(pat$controlled_6mo)
  add("overall % controlled at 6 months", between(oc, 42, 52), oc, "42-52")
  add("lowest clinic % controlled",
      between(min(cs$pct_controlled), 18, 40), min(cs$pct_controlled), "18-40")
  add("highest clinic % controlled",
      between(max(cs$pct_controlled), 55, 72), max(cs$pct_controlled), "55-72")
  cdw <- tidyr::pivot_wider(tabs$clinic_device, id_cols = clinic,
                            names_from = device_type,
                            values_from = pct_controlled)
  add("Cellular beats Bluetooth in at least 5 clinics",
      sum(cdw$Cellular > cdw$Bluetooth) >= 5,
      sum(cdw$Cellular > cdw$Bluetooth), ">= 5")
  east <- cdw[cdw$clinic == "Eastgate", ]
  add("Eastgate reversed (Bluetooth >= Cellular)",
      east$Bluetooth >= east$Cellular, east$Bluetooth - east$Cellular, ">= 0")
  qc <- tabs$quarter_control
  qv <- qc[qc$status == "Controlled", ]
  qv <- qv$pct[order(qv$quarter)]
  add("Q1 % controlled", between(qv[1], 20, 40), qv[1], "20-40")
  add("Q4 % controlled (crosses the 50% line)",
      between(qv[4], 50, 66), qv[4], "50-66")
  add("% controlled rises every quarter", all(diff(qv) > 0),
      min(diff(qv)), "> 0")
  cmw <- tidyr::pivot_wider(tabs$clinic_month, id_cols = month,
                            names_from = clinic,
                            values_from = mean_readings_wk)
  lowest <- apply(as.matrix(cmw[, -1]), 1, function(r) names(r)[which.min(r)])
  add("Maple Grove has the lowest engagement in >= 8 of 12 months",
      sum(lowest == "Maple Grove") >= 8, sum(lowest == "Maple Grove"), ">= 8")
  pre_pw <- pw[pw$week_start < rpm_protocol_start, ]
  a <- mean(pre_pw$readings[pre_pw$tt >= 3 & pre_pw$tt <= 6])
  z <- mean(pre_pw$readings[pre_pw$tt >= 12 & pre_pw$tt <= 15])
  add("engagement fades before the protocol (late/early ratio)",
      z <= 0.92 * a, z / a, "<= 0.92")

  # ---- Associations (Exercise 3) -------------------------------------------
  lg <- cor(pat$sbp_reduction, log10(pat$total_readings))
  rw <- cor(pat$sbp_reduction, pat$total_readings)
  add("median total readings", between(median(pat$total_readings), 50, 120),
      median(pat$total_readings), "50-120")
  add("total readings: min >= 1 and max >= 200",
      min(pat$total_readings) >= 1 && max(pat$total_readings) >= 200,
      max(pat$total_readings), "max >= 200")
  add("cor(reduction, log10 readings)", between(lg, 0.35, 0.65), lg, "0.35-0.65")
  add("log-scale correlation exceeds raw-scale by >= 0.02",
      lg > rw + 0.02, lg - rw, ">= 0.02")
  mr <- mean(pat$sbp_reduction)
  add("mean systolic reduction (mmHg)", between(mr, 5, 7.5), mr, "5-7.5")
  third <- dplyr::ntile(pat$total_readings, 3)
  top <- mean(pat$sbp_reduction[third == 3])
  bot <- mean(pat$sbp_reduction[third == 1])
  add("top engagement third: mean reduction", between(top, 8, 13), top, "8-13")
  add("bottom engagement third: mean reduction", between(bot, 0, 4), bot, "0-4")
  cross <- ce$ci_low <= 0 & ce$ci_high >= 0
  add("1-3 clinics have a CI crossing zero", between(sum(cross), 1, 3),
      sum(cross), "1-3")
  add("only small clinics (n <= 34) cross zero",
      all(ce$n_patients[cross] <= 34), NA_real_, "TRUE")
  close <- FALSE
  for (i in 1:(nrow(cs) - 1)) {
    for (j in (i + 1):nrow(cs)) {
      if (abs(cs$mean_readings_wk[i] - cs$mean_readings_wk[j]) <= 0.3 &&
          abs(cs$pct_controlled[i] - cs$pct_controlled[j]) <= 5) close <- TRUE
    }
  }
  add("two clinics close together in the clinic-level scatter (labels collide)",
      close, NA_real_, "TRUE")

  # ---- Equity gradient and device effects ----------------------------------
  wdp <- tidyr::pivot_wider(wd, id_cols = week_start, names_from = device_type,
                            values_from = c(pct_submitting, mean_sbp))
  in_short <- wdp$week_start >= rpm_shortage_start & wdp$week_start <= rpm_shortage_end
  out_short <- wdp$week_start >= as.Date("2025-04-07") & wdp$week_start < rpm_shortage_start
  gap <- wdp$pct_submitting_Bluetooth - wdp$pct_submitting_Cellular
  add("Bluetooth below Cellular outside the shortage (pts)",
      between(-mean(gap[out_short]), 7, 18), -mean(gap[out_short]), "7-18")
  add("cellular dip during the shortage (pts, vs. normal gap)",
      mean(gap[in_short]) - mean(gap[out_short]) >= 10,
      mean(gap[in_short]) - mean(gap[out_short]), ">= 10")
  pw2 <- pw[pw$tt >= 4 &
              !(pw$week_start >= rpm_shortage_start & pw$week_start <= rpm_shortage_end), ]
  gaps <- sapply(levels(pw2$age_group), function(ag) {
    d <- pw2[pw2$age_group == ag, ]
    100 * mean(d$readings[d$device_type == "Cellular"] >= 1) -
      100 * mean(d$readings[d$device_type == "Bluetooth"] >= 1)
  })
  add("device gap is larger for 65+ than younger groups (pts)",
      gaps[3] >= max(gaps[1:2]) + 3, gaps[3] - max(gaps[1:2]), ">= 3")

  # ---- Time series (Exercise 4) --------------------------------------------
  pre  <- mean(tail(wp$pct_submitting[wp$week_start < rpm_protocol_start], 4))
  post <- mean(head(wp$pct_submitting[wp$week_start >= rpm_protocol_start], 4))
  add("jump in % submitting after protocol start (pts)",
      post - pre >= 4, post - pre, ">= 4")
  pct_at <- function(d) wp$pct_submitting[wp$week_start == as.Date(d)]
  add("Thanksgiving dip",
      pct_at("2025-11-24") <
        mean(wp$pct_submitting[wp$week_start %in% as.Date(c("2025-11-10", "2025-11-17"))]) - 2,
      NA_real_, "TRUE")
  add("late-December dip",
      pct_at("2025-12-22") <
        mean(wp$pct_submitting[wp$week_start %in% as.Date(c("2025-12-01", "2025-12-08", "2025-12-15"))]) - 3,
      NA_real_, "TRUE")
  n <- nrow(wdp)
  early <- mean(as.matrix(wdp[9:14, c("mean_sbp_Bluetooth", "mean_sbp_Cellular")]))
  late  <- mean(as.matrix(wdp[(n - 7):n, c("mean_sbp_Bluetooth", "mean_sbp_Cellular")]))
  add("mean systolic drifts down over the year (mmHg)",
      early - late >= 5, early - late, ">= 5")
  lag_wk <- wdp$week_start >= rpm_lag_start & wdp$week_start <= rpm_lag_end
  nolag  <- !lag_wk & wdp$week_start >= as.Date("2025-04-01")
  dsb <- wdp$mean_sbp_Bluetooth - wdp$mean_sbp_Cellular
  add("Cellular systolic lower than Bluetooth (median, mmHg)",
      median(dsb[nolag]) >= 1, median(dsb[nolag]), ">= 1")
  base_win <- wdp$week_start >= as.Date("2025-07-07") & wdp$week_start < rpm_shortage_start
  rise_c <- mean(wdp$mean_sbp_Cellular[lag_wk]) - mean(wdp$mean_sbp_Cellular[base_win])
  rise_b <- mean(wdp$mean_sbp_Bluetooth[lag_wk]) - mean(wdp$mean_sbp_Bluetooth[base_win])
  add("lagged systolic rise on Cellular after the shortage (mmHg)",
      rise_c - rise_b >= 1.5, rise_c - rise_b, ">= 1.5")

  do.call(rbind, out)
}

print_rpm_report <- function(res) {
  res$status <- ifelse(res$pass, "PASS", "FAIL")
  print(res[, c("status", "check", "value", "target")], row.names = FALSE, right = FALSE)
  cat(sprintf("\n%d of %d checks passed.\n", sum(res$pass), nrow(res)))
  invisible(res)
}

# Standalone mode: audit the shipped files.
if (sys.nframe() == 0) {
  stopifnot(file.exists("data/patients.rds"),
            file.exists("instructor/patient_weeks.rds"))
  tabs <- list(
    clinic_summary  = readRDS("data/clinic_summary.rds"),
    clinic_device   = readRDS("data/clinic_device.rds"),
    clinic_month    = readRDS("data/clinic_month.rds"),
    quarter_control = readRDS("data/quarter_control.rds"),
    clinic_effect   = readRDS("data/clinic_effect.rds"),
    weekly_program  = readRDS("data/weekly_program.rds"),
    weekly_device   = readRDS("data/weekly_device.rds")
  )
  res <- check_rpm(readRDS("data/patients.rds"),
                   readRDS("instructor/patient_weeks.rds"), tabs)
  print_rpm_report(res)
}
