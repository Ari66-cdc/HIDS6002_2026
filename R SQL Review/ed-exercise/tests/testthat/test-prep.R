# One example test per function is written for you. Use them as models.
# Write the rest. Hand-count expected values from data/ed_visits.csv.

test_that("EXAMPLE validate_ed_visits: a duplicate ID raises an error", {
  expect_error(validate_ed_visits(fx_problem("duplicate_id")), "duplicate")
})

test_that("EXAMPLE monthly_counts: the same patient-date twice counts once", {
  visits <- tibble(
    id = c("A1", "A2"), patient = "P01",
    start = as.Date("2024-01-10"), encounterclass = "emergency"
  )
  out <- monthly_counts(visits, data_end = as.Date("2024-01-31"))
  expect_equal(out$ed_visits, 1)
})

test_that("EXAMPLE payer_summary: shares sum to 1", {
  out <- payer_summary(fx_visits())
  expect_equal(sum(out$share_of_visits), 1)
})

test_that("EXAMPLE lorenz_curve: starts at (0, 0) and ends at (1, 1)", {
  out <- lorenz_curve(fx_costs_hand)
  expect_equal(c(out$cum_patients[1], out$cum_cost[1]), c(0, 0))
  expect_equal(c(last(out$cum_patients), last(out$cum_cost)), c(1, 1))
})
