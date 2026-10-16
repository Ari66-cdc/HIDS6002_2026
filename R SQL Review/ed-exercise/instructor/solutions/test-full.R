# ANSWER KEY tests: every test idea from the assignment's Functions table.
# All expected values are hand counts (see instructor/answer-key.md).
# Run with instructor/run_key.R.

# ---- validate_ed_visits ----------------------------------------------------

test_that("validate_ed_visits: a clean fixture comes back unchanged", {
  v <- fx_visits()
  expect_identical(validate_ed_visits(v), v)
})

test_that("validate_ed_visits: each problem raises an error that names it", {
  expected <- c(
    urgentcare          = "non-emergency",
    duplicate_id        = "duplicate",
    negative_cost       = "negative total_claim_cost",
    missing_cost        = "missing total_claim_cost",
    cost_in_cents       = "cents",
    coverage_above_cost = "payer_coverage greater than",
    payer_whitespace    = "Medicaid ",
    date_outside_window = "outside the study window"
  )
  expect_setequal(names(expected), names(fx_problems))
  for (name in names(expected)) {
    expect_error(validate_ed_visits(fx_problem(name)), expected[[name]], fixed = TRUE,
                 info = name)
  }
})

test_that("validate_ed_visits: a missing payer is allowed", {
  v <- fx_visits()
  expect_true(anyNA(v$payer))
  expect_no_error(validate_ed_visits(v))
})

test_that("validate_ed_visits: one problem does not trigger the others", {
  expect_error(validate_ed_visits(fx_problem("negative_cost")), "negative")
  msg <- tryCatch(validate_ed_visits(fx_problem("negative_cost")),
                  error = conditionMessage)
  expect_false(grepl("payer_coverage greater", msg))
  expect_false(grepl("missing total_claim_cost", msg))
})

test_that("validate_ed_visits: reports every problem at once, and missing columns", {
  v <- fx_problem("duplicate_id")
  v$total_claim_cost[5] <- NA
  expect_error(validate_ed_visits(v), "duplicate.*missing total_claim_cost")
  expect_error(validate_ed_visits(fx_visits()[, -5]), "missing columns: payer")
})

test_that("validate_ed_visits: window edges are inside the window", {
  v <- fx_visits()
  v$start[1] <- study_window[1]
  v$start[2] <- study_window[2]
  expect_no_error(validate_ed_visits(v))
})

# ---- monthly_counts --------------------------------------------------------

test_that("monthly_counts: hand count is 2, 0, 4, 11, 5 for Jan-May", {
  out <- monthly_counts(fx_visits(), fx_data_end)
  expect_named(out, c("month", "ed_visits"))
  expect_equal(out$month, as.Date(c("2024-01-01", "2024-02-01", "2024-03-01",
                                    "2024-04-01", "2024-05-01")))
  expect_equal(out$ed_visits, c(2, 0, 4, 11, 5))
  expect_equal(sum(out$ed_visits), 22)
})

test_that("monthly_counts: the same patient-date twice counts once", {
  v <- fx_visits()
  expect_equal(sum(v$start >= "2024-03-01" & v$start < "2024-04-01"), 5)  # raw rows
  expect_equal(monthly_counts(v, fx_data_end)$ed_visits[3], 4)
})

test_that("monthly_counts: a month with no visits appears with 0", {
  out <- monthly_counts(fx_visits(), fx_data_end)
  expect_equal(out$ed_visits[out$month == as.Date("2024-02-01")], 0)
})

test_that("monthly_counts: the partial last month is dropped", {
  out <- monthly_counts(fx_visits(), fx_data_end)
  expect_false(as.Date("2024-06-01") %in% out$month)
  # a complete last month is kept
  out2 <- monthly_counts(fx_visits(), as.Date("2024-06-30"))
  expect_equal(last(out2$ed_visits), 3)
})

test_that("monthly_counts: the partial first month is dropped", {
  out <- monthly_counts(fx_visits(), fx_data_end, data_start = as.Date("2024-01-10"))
  expect_equal(out$month[1], as.Date("2024-02-01"))
  expect_equal(sum(out$ed_visits), 20)
})

test_that("monthly_counts: ed_visits sums to distinct patient-dates in complete months", {
  v <- fx_visits()
  in_months <- v$start < as.Date("2024-06-01")
  expected <- nrow(distinct(v[in_months, ], patient, start))
  expect_equal(sum(monthly_counts(v, fx_data_end)$ed_visits), expected)
})

# ---- payer_summary ---------------------------------------------------------

test_that("payer_summary: hand counts by payer, sorted by visits", {
  out <- payer_summary(fx_visits())
  expect_named(out, c("payer", "ed_visits", "share_of_visits",
                      "total_claim_cost", "payer_coverage"))
  expect_equal(out$payer, c("Medicare", "Private", "Medicaid", "NO_INSURANCE", "Unknown"))
  expect_equal(out$ed_visits, c(11, 5, 4, 4, 1))
  expect_equal(out$share_of_visits, c(.44, .20, .16, .16, .04))
  expect_equal(out$total_claim_cost, c(16300, 7800, 2600, 11700, 1800))
  expect_equal(out$payer_coverage, c(13000, 5600, 2600, 0, 0))
})

test_that("payer_summary: shares sum to 1", {
  expect_equal(sum(payer_summary(fx_visits())$share_of_visits), 1)
})

test_that("payer_summary: visits by payer sum to total unique visits", {
  v <- fx_visits()
  expect_equal(sum(payer_summary(v)$ed_visits), nrow(distinct(v, patient, start)))
  expect_equal(sum(payer_summary(v)$ed_visits), 25)
})

test_that("payer_summary: a missing payer ends up in the Unknown category", {
  out <- payer_summary(fx_visits())
  expect_equal(out$ed_visits[out$payer == "Unknown"], 1)
  expect_false(anyNA(out$payer))
})

test_that("payer_summary: an uninsured payer with zero coverage keeps its row", {
  out <- payer_summary(fx_visits())
  row <- out[out$payer == "NO_INSURANCE", ]
  expect_equal(nrow(row), 1)
  expect_equal(row$payer_coverage, 0)
})

test_that("payer_summary: dollar totals match the hand count and are sums", {
  out <- payer_summary(fx_visits())
  expect_equal(sum(out$total_claim_cost), 40200)
  expect_equal(sum(out$payer_coverage), 21200)
  expect_equal(out$total_claim_cost[out$payer == "Medicare"], 16300)  # not a mean
})

# ---- lorenz_curve, gini ----------------------------------------------------

test_that("lorenz_curve: hand-worked example table", {
  out <- lorenz_curve(fx_costs_hand)
  expect_named(out, c("cum_patients", "cum_cost"))
  expect_equal(out$cum_patients, c(0, .2, .4, .6, .8, 1))
  expect_equal(out$cum_cost, c(0, 0, .1, .2, .5, 1))
})

test_that("lorenz_curve: starts at (0, 0), ends at (1, 1), unsorted input is fine", {
  out <- lorenz_curve(c(5, 0, 3, 1, 1))
  expect_equal(c(out$cum_patients[1], out$cum_cost[1]), c(0, 0))
  expect_equal(c(last(out$cum_patients), last(out$cum_cost)), c(1, 1))
  expect_equal(out$cum_cost, lorenz_curve(fx_costs_hand)$cum_cost)
})

test_that("lorenz_curve: never rises above the diagonal", {
  out <- lorenz_curve(fx_costs_hand)
  expect_true(all(out$cum_cost <= out$cum_patients + 1e-12))
  expect_true(all(diff(out$cum_cost) >= 0))
})

test_that("lorenz_curve: a zero-cost patient adds a row (n patients give n + 1 rows)", {
  expect_equal(nrow(lorenz_curve(c(1, 2, 3))), 4)
  expect_equal(nrow(lorenz_curve(c(0, 1, 2, 3))), 5)
})

test_that("lorenz_curve: a negative or missing cost raises an error", {
  expect_error(lorenz_curve(c(1, -2, 3)), "non-negative")
  expect_error(lorenz_curve(c(1, NA, 3)), "non-negative")
  expect_error(lorenz_curve(c(0, 0, 0)), "zero")
})

test_that("patient_costs keeps zero-cost patients, so the Lorenz curve has 13 rows", {
  pc <- patient_costs(fx_visits(), fx_patients())
  expect_equal(nrow(pc), 12)
  expect_equal(sum(pc$ed_cost == 0), 2)
  expect_equal(sum(pc$ed_cost), 40200)
  expect_equal(pc$ed_cost[pc$patient == "P08"], 12000)
  expect_equal(pc$ed_cost[pc$patient == "P05"], 3300)
  expect_equal(nrow(lorenz_curve(pc$ed_cost)), 13)
})

test_that("gini: the hand-worked example gives 0.48", {
  expect_equal(gini(fx_costs_hand), 0.48)
})

test_that("gini: equal costs give 0; stays between 0 and 1", {
  expect_equal(gini(rep(10, 7)), 0)
  g <- gini(patient_costs(fx_visits(), fx_patients())$ed_cost)
  expect_gt(g, 0)
  expect_lt(g, 1)
})

test_that("gini: same checks as lorenz_curve apply", {
  expect_error(gini(c(1, -1)), "non-negative")
})

# ---- plots -----------------------------------------------------------------

test_that("each plot function returns a ggplot built from the expected columns", {
  cases <- list(
    trend  = list(plot_trend(fx_monthly()), c("month", "ed_visits")),
    payer  = list(plot_payer(fx_payer()),
                  c("payer", "ed_visits", "share_of_visits", "total_claim_cost", "payer_coverage")),
    lorenz = list(plot_lorenz(fx_curve()), c("cum_patients", "cum_cost"))
  )
  for (nm in names(cases)) {
    p <- cases[[nm]][[1]]
    expect_s3_class(p, "ggplot")
    expect_true(all(cases[[nm]][[2]] %in% names(p$data)), info = nm)
    expect_no_error(ggplot_build(p))
  }
})
