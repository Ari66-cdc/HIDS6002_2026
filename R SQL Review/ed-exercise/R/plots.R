# Figure functions. Each takes a table from prep.R and returns a ggplot object.
# Use standard ggplot2 only. No data wrangling here.

#' Monthly ED visits.
#' @param monthly output of monthly_counts(): month, ed_visits
#' @return a ggplot
plot_trend <- function(monthly) {
  stop("plot_trend() is not implemented yet")
}

#' ED visits by payer, next to total claim cost and payer coverage.
#' @param payers output of payer_summary()
#' @return a ggplot
plot_payer <- function(payers) {
  stop("plot_payer() is not implemented yet")
}

#' Lorenz curve of ED cost.
#' @param curve output of lorenz_curve(): cum_patients, cum_cost
#' @return a ggplot
plot_lorenz <- function(curve) {
  stop("plot_lorenz() is not implemented yet")
}
