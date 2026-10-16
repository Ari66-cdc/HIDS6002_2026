# Loads the code under test and builds fixtures. Run tests from the repo root.
# Instructors can point ED_PREP and ED_PLOTS at instructor/solutions/.
#
# Fixtures stand in for the SQL output, so prep.R and plots.R can be tested
# before any SQL exists:
#   fx_visits()          clean visits table (what the extract should return)
#   fx_problem("name")   the clean table with exactly one problem injected
#   fx_monthly(), fx_payer(), fx_curve()   plot-ready tables, typed by hand
#   fx_costs_hand        patient costs for the hand-worked Lorenz example
library(dplyr, warn.conflicts = FALSE)
library(ggplot2)

repo_root <- normalizePath(file.path(testthat::test_path(), "..", ".."))
source(file.path(repo_root, "R", "helpers.R"))
source(Sys.getenv("ED_PREP", file.path(repo_root, "R", "prep.R")))
source(Sys.getenv("ED_PLOTS", file.path(repo_root, "R", "plots.R")))

read_fixture <- function(name) {
  readr::read_csv(file.path(repo_root, "data", name),
                  show_col_types = FALSE, progress = FALSE)
}

fx_visits <- function() read_fixture("ed_visits.csv")
fx_patients <- function() read_fixture("patients.csv")
fx_data_end <- study_window[2]

# Each injector changes one row of the clean table. To test a new check, add
# an injector here and call fx_problem("its_name").
fx_problems <- list(
  urgentcare          = function(v) { v$encounterclass[3] <- "urgentcare"; v },
  duplicate_id        = function(v) { v$id[2] <- v$id[1]; v },
  negative_cost       = function(v) { v$total_claim_cost[5] <- -50; v },
  missing_cost        = function(v) { v$total_claim_cost[5] <- NA; v },
  cost_in_cents       = function(v) {
    v$total_claim_cost[7] <- 200000
    v$payer_coverage[7] <- 160000
    v
  },
  coverage_above_cost = function(v) {
    v$payer_coverage[1] <- v$total_claim_cost[1] + 500
    v
  },
  payer_whitespace    = function(v) { v$payer[3] <- "Medicaid "; v },
  date_outside_window = function(v) { v$start[25] <- as.Date("2024-07-01"); v }
)
fx_problem <- function(name) fx_problems[[name]](fx_visits())

# Hand-worked Lorenz example: n = 5, Gini = 0.48.
fx_costs_hand <- c(0, 1, 1, 3, 5)

# Plot-ready tables, typed by hand (not produced by prep.R).
fx_monthly <- function() {
  tibble(month = as.Date(c("2024-01-01", "2024-02-01", "2024-03-01",
                           "2024-04-01", "2024-05-01")),
         ed_visits = c(2L, 0L, 4L, 11L, 5L))
}
fx_payer <- function() {
  tibble(payer = c("Medicare", "Private", "Medicaid", "NO_INSURANCE", "Unknown"),
         ed_visits = c(11L, 5L, 4L, 4L, 1L),
         share_of_visits = c(0.44, 0.20, 0.16, 0.16, 0.04),
         total_claim_cost = c(16300, 7800, 2600, 11700, 1800),
         payer_coverage = c(13000, 5600, 2600, 0, 0))
}
fx_curve <- function() {
  tibble(cum_patients = c(0, .2, .4, .6, .8, 1),
         cum_cost = c(0, 0, .1, .2, .5, 1))
}
