# Data preparation. Functions take data and return data; no files, database
# calls or printing inside them. Fixture data in data/ has hand-countable
# answers (see docs/fixtures.md). Each function below shows one worked EXAMPLE
# evaluation; the rest is yours.

#' Check the ED visits table before using it.
#'
#' Input: visits with columns id, patient, start (Date), encounterclass, payer,
#' total_claim_cost, payer_coverage.
#' Output: `visits`, unchanged, or an error that names what is wrong.
#'
#' @param visits data frame of ED visits
#' @param window Date vector of length 2, the study window
validate_ed_visits <- function(visits, window = study_window) {
  problems <- character()

  # EXAMPLE evaluation: only emergency encounters (no urgentcare)
  if (any(visits$encounterclass != "emergency")) {
    problems <- c(problems, "non-emergency encounters (e.g. urgentcare)")
  }

  # TODO: add your own evaluations. Add each problem to `problems`.

  if (length(problems) > 0) {
    stop("invalid ED visits: ", paste(problems, collapse = "; "), call. = FALSE)
  } 
  invisible(visits)
}

#' Count ED visits per complete month.
#'
#' Input: visits table; `data_end`, the last date in the data; `data_start`,
#' the first. Output: one row per complete month (month, ed_visits).
#'
#' @param visits data frame of ED visits
#' @param data_end Date
#' @param data_start Date
monthly_counts <- function(visits, data_end, data_start = study_window[1]) {
  # EXAMPLE evaluation: fill in months with no visits with 0
  #   all_months <- data.frame(month = seq(first_month, last_month, by = "month"))
  #   out <- left_join(all_months, counts, by = "month")
  #   out$ed_visits[is.na(out$ed_visits)] <- 0L
  stop("monthly_counts() is not implemented yet")
}

#' Summarize ED visits by payer.
#'
#' Input: visits table. Output: one row per payer (payer, ed_visits,
#' share_of_visits, total_claim_cost, payer_coverage).
#'
#' @param visits data frame of ED visits
payer_summary <- function(visits) {
  # EXAMPLE evaluation: a missing payer is labeled "Unknown" and kept
  #   visits$payer[is.na(visits$payer)] <- "Unknown"
  stop("payer_summary() is not implemented yet")
}

#' Lorenz curve of cost.
#'
#' Input: vector of patient costs. Output: curve table (cum_patients, cum_cost).
#'
#' @param costs numeric vector, one cost per patient
lorenz_curve <- function(costs) {
  # EXAMPLE evaluation: zero-cost patients are kept, not dropped
  #   n <- length(costs)   # not sum(costs > 0)
  stop("lorenz_curve() is not implemented yet")
}

#' Gini coefficient of cost, built on lorenz_curve().
#'
#' @param costs numeric vector, one cost per patient
#' @return a single number between 0 and 1
gini <- function(costs) {
  stop("gini() is not implemented yet")
}

#' Total ED cost for every patient in the population, zero-cost ones included.
#' Provided for you.
#'
#' @param visits data frame of ED visits
#' @param patients data frame with column `id`: everyone in the population
#' @return data frame: patient, ed_cost (0 for patients with no ED visits)
patient_costs <- function(visits, patients) {
  totals <- tapply(visits$total_claim_cost, visits$patient, sum)
  cost <- unname(totals[patients$id])
  cost[is.na(cost)] <- 0
  data.frame(patient = patients$id, ed_cost = cost)
}
