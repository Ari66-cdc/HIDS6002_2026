# Fixture data

Small data so prep.R and plots.R can be written and tested before any SQL exists.
Columns follow the Synthea names. Study window: 2024-01-01 to 2024-06-15 (June is partial).

| File | Rows | Columns |
|---|---|---|
| `data/ed_visits.csv` | 26 | id, patient, start, encounterclass, payer, total_claim_cost, payer_coverage |
| `data/patients.csv` | 12 | id (everyone in the population, including two with no ED visits) |

## Helpers in tests/testthat/helper-fixtures.R

- `fx_visits()`: the clean visits table, as the extract should return it.
- `fx_problem("name")`: the clean table with exactly one problem injected.
  Names: `urgentcare`, `duplicate_id`, `negative_cost`, `missing_cost`, `cost_in_cents`,
  `coverage_above_cost`, `payer_whitespace`, `date_outside_window`.
- `fx_costs_hand`: five patient costs for a hand-worked Lorenz example.
- `fx_monthly()`, `fx_payer()`, `fx_curve()`: tables shaped like the output of
  `monthly_counts()`, `payer_summary()` and `lorenz_curve()`, so plots can be tested
  before prep.R works.

To test a new check, add an injector to `fx_problems` and call `fx_problem("its_name")`.

## What the clean table contains

- Months with different numbers of visits, and one month (February) with none.
- A partial last month.
- Two rows for the same patient on the same date.
- A visit with no payer, and an uninsured payer with zero coverage.
- One patient with many more visits and dollars than the rest.
