# ANSWER KEY. Reference implementation of R/plots.R. Standard ggplot2 only.

plot_trend <- function(monthly) {
  ggplot(monthly, aes(month, ed_visits)) +
    geom_line(colour = "#0072B2", linewidth = 1) +
    geom_point(colour = "#0072B2", size = 2) +
    scale_y_continuous(limits = c(0, NA), expand = expansion(mult = c(0, 0.08))) +
    scale_x_date(date_labels = "%b %Y") +
    labs(title = "ED visits by month", x = NULL, y = "ED visits") +
    theme_minimal()
}

plot_payer <- function(payers) {
  panel_visits <- "Visits by payer"
  panel_cost <- "Total claim cost and payer coverage"
  lvl <- function(d) factor(d$payer, levels = rev(d$payer))
  pnl <- function(d, name) factor(rep(name, nrow(d)), levels = c(panel_visits, panel_cost))
  ggplot(payers) +
    geom_col(
      data = function(d) data.frame(payer = lvl(d), x = d$ed_visits, panel = pnl(d, panel_visits)),
      aes(x, payer), fill = "#0072B2", width = 0.6
    ) +
    geom_text(
      data = function(d) data.frame(
        payer = lvl(d), x = d$ed_visits, panel = pnl(d, panel_visits),
        label = sprintf("%d (%.0f%%)", d$ed_visits, 100 * d$share_of_visits)),
      aes(x, payer, label = label), hjust = -0.1, size = 3
    ) +
    geom_segment(
      data = function(d) data.frame(
        payer = lvl(d), x = d$payer_coverage, xend = d$total_claim_cost, panel = pnl(d, panel_cost)),
      aes(x = x, xend = xend, y = payer, yend = payer), colour = "#E69F00", linewidth = 1.2
    ) +
    geom_point(
      data = function(d) data.frame(payer = lvl(d), x = d$payer_coverage, panel = pnl(d, panel_cost)),
      aes(x, payer), colour = "#0072B2", size = 3
    ) +
    geom_point(
      data = function(d) data.frame(payer = lvl(d), x = d$total_claim_cost, panel = pnl(d, panel_cost)),
      aes(x, payer), colour = "grey20", size = 3
    ) +
    facet_wrap(~panel, scales = "free_x") +
    scale_x_continuous(labels = function(x) format(x, big.mark = ","),
                       limits = c(0, NA), expand = expansion(mult = c(0.03, 0.25))) +
    labs(x = NULL, y = NULL) +
    theme_minimal() +
    theme(strip.text = element_text(face = "bold", hjust = 0))
}

plot_lorenz <- function(curve) {
  ggplot(curve, aes(cum_patients, cum_cost)) +
    geom_abline(slope = 1, intercept = 0, linetype = "dashed", colour = "grey50") +
    geom_line(colour = "#0072B2", linewidth = 1) +
    coord_equal(xlim = c(0, 1), ylim = c(0, 1)) +
    scale_x_continuous(labels = function(x) paste0(100 * x, "%")) +
    scale_y_continuous(labels = function(x) paste0(100 * x, "%")) +
    labs(title = "Concentration of ED cost",
         x = "Cumulative share of patients", y = "Cumulative share of cost") +
    theme_minimal()
}
