# Answer key: ED exercise

Reference code: `instructor/solutions/prep.R` and `plots.R`. Full tests: `instructor/solutions/test-full.R`
(every test idea from the assignment's Functions table). Check everything with `Rscript instructor/run_key.R`.

Students get stubs, one worked EXAMPLE evaluation per function, and one EXAMPLE test per function:

| Function | EXAMPLE evaluation shown | EXAMPLE test given |
|---|---|---|
| `validate_ed_visits` | Only emergency encounters | A duplicate ID raises an error |
| `monthly_counts` | Months with no visits filled with 0 | The same patient-date twice counts once |
| `payer_summary` | Missing payer labeled "Unknown" and kept | Shares sum to 1 |
| `lorenz_curve` | Zero-cost patients kept | Starts at (0, 0), ends at (1, 1) |

All four example tests fail on the stubs. The first fails until students add the duplicate-ID check.
`gini`, the plot functions, and every other evaluation and test are the students' work.
`patient_costs()` is not in the assignment tables; it is provided so the zero-cost patients reach the Lorenz curve.

Window: 2024-01-01 to 2024-06-15. `data_end` = 2024-06-15.

## Validation: what each injected problem should produce

| `fx_problem()` | Row changed | Error should mention |
|---|---|---|
| urgentcare | 3 | non-emergency |
| duplicate_id | 2 (id copied from row 1) | duplicate |
| negative_cost | 5 (-50) | negative total_claim_cost |
| missing_cost | 5 (NA) | missing total_claim_cost |
| cost_in_cents | 7 (200,000; coverage 160,000) | cents / above 100,000 |
| coverage_above_cost | 1 (coverage = cost + 500) | payer_coverage greater than |
| payer_whitespace | 3 ("Medicaid ") | the payer name |
| date_outside_window | 25 (2024-07-01) | outside the study window |

The clean table passes unchanged. Its missing payer (E017) is allowed. Each injection triggers only its own message
(coverage is not compared when cost is negative or missing).

## monthly_counts (each patient-date counted once, partial months dropped)

| Month | Raw rows | Distinct patient-dates |
|---|---|---|
| Jan | 2 | 2 |
| Feb | 0 | 0 |
| Mar | 5 | **4** (E004 and E026: P05 on 03-12) |
| Apr | 11 | 11 |
| May | 5 | 5 |
| Jun (partial, dropped) | 3 | 3 |

Output: Jan to May, 2, 0, 4, 11, 5; sum 22. With `data_start = 2024-01-10` the partial January is dropped too: Feb to May, sum 20.
With `data_end = 2024-06-30`, June is complete and kept (3).

## payer_summary (sorted by visits, ties by payer name)

| Payer | Rows | ed_visits | Share | total_claim_cost | payer_coverage |
|---|---|---|---|---|---|
| Medicare | 11 | 11 | 0.44 | 16,300 | 13,000 |
| Private | 6 | 5 | 0.20 | 7,800 | 5,600 |
| Medicaid | 4 | 4 | 0.16 | 2,600 | 2,600 |
| NO_INSURANCE | 4 | 4 | 0.16 | 11,700 | 0 |
| Unknown (NA payer, E017) | 1 | 1 | 0.04 | 1,800 | 0 |

Totals: 25 visits, 40,200 cost, 21,200 coverage. Trap: counting rows gives 26 visits; averaging gives means, not sums.

## Lorenz and Gini

Population is 12 patients (P11, P12 have no visits). Patient costs: P08 12,000; P06 6,500; P10 5,200; P04 3,800;
P05 3,300 (includes the duplicate record); P09 2,500; P03 2,200; P07 2,100; P02 1,400; P01 1,200; P11 0; P12 0. Total 40,200.
The curve has 13 rows. Dropping zero-cost patients gives 11 rows and a lower Gini.

Hand-worked example, costs `c(0, 1, 1, 3, 5)`:

| cum_patients | 0 | .2 | .4 | .6 | .8 | 1 |
|---|---|---|---|---|---|---|
| cum_cost | 0 | 0 | .1 | .2 | .5 | 1 |

Gini = 1 - sum(dx * (y + y_prev)) = 1 - 0.2 * (0 + 0.1 + 0.3 + 0.7 + 1.5) = 1 - 0.52 = **0.48**.
Fixture Gini (12 patients) is 0.486; dropping the zero-cost patients gives 0.383.
Equal costs give 0. A zero total, or any negative or missing cost, raises an error.
