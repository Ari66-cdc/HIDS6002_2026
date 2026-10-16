# Shared constants and helpers used by prep.R and plots.R.

# First and last day the extract should cover.
study_window <- as.Date(c("2024-01-01", "2024-06-15"))

# Payer names allowed in the extract. A missing payer (NA) is also allowed.
allowed_payers <- c("Medicaid", "Medicare", "Private", "NO_INSURANCE")

# Largest plausible cost for one ED encounter, in dollars. Larger means cents.
max_plausible_cost <- 100000

#' First day of the month for each date.
month_start <- function(x) {
  as.Date(format(as.Date(x), "%Y-%m-01"))
}

#' Last day of the month for a single date.
month_end <- function(x) {
  seq(month_start(x), by = "month", length.out = 2)[2] - 1
}
