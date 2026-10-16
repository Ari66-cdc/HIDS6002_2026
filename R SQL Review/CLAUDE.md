# Project handoff: ggplot2 exercises + ED use and cost team exercise

Two related teaching projects live in this folder. Read this file first.

## Conventions the instructor has asked for
- Student exercises are Quarto (`.qmd`, HTML), about 15 minutes, one `source("rpm-setup.R")` setup chunk.
- Students do **minimal data wrangling**. All aggregation is instructor-side; "Your turn" tasks change ggplot arguments, not data.
- **Hints go inline in the task text**, in parentheses and not fully directive, e.g. "Can you fix it? (Hint: look at the `bounds` argument.)". Do not use collapsed hint callouts.
- Each exercise adds 2-3 formatting skills (expand, facet, data labels, scales, vertical line + label, ticks).

## Project 1: `rpm-project/` (simulated remote blood pressure monitoring)
Four ggplot2 exercises (amounts, distributions, associations, time series) on one simulated dataset: 400 patients, 8 clinics, 52 weeks (starts 2025-01-06).

Files:
- `rpm-setup.R`: loads ggplot2, reads `data/*.rds`, defines constants (`sbp_thresholds`, `target_days_first_reading`, `protocol_start`, `shortage_start/end`).
- `instructor/make_rpm_data.R`: simulator (negative-binomial weekly counts, log-linear dose-response, protocol effect, cellular cuff shortage 2025-08-04 to 09-14, dropout, holiday dips). `find_seed(1:400)` searches for a seed that passes the checks. Writes `data/*.rds`, `data/csv/*.csv`, `instructor/patient_weeks.rds`.
- `instructor/check_rpm_data.R`: about 38 validation checks, `check_rpm()` and `print_rpm_report()`.
- `01-amounts-exercise.qmd`, `02-distributions-exercise.qmd`, `03-associations-exercise.qmd`, `04-time-series-exercise.qmd`.

Tables students use: `patients` (400), `clinic_summary` (8), `clinic_device` (16), `clinic_month` (96), `quarter_control` (8), `clinic_effect` (8), `weekly_program` (52), `weekly_device` (104).

### STATUS: NOTHING HAS BEEN RUN
R was not available when this was written. The simulator was prototyped and validated in Python (35 checks pass for some seeds), but the R RNG differs. First job:
1. `Rscript instructor/make_rpm_data.R` from `rpm-project/`. Fix any errors.
2. If the seed search fails the checks, widen `find_seed()` or adjust parameters, and confirm the planted patterns exist (below).
3. Render each exercise (`quarto render 0X-*.qmd`) and fix any code or text mismatches.

### Planted patterns the exercises rely on
- Baseline systolic is cut at 130 (all patients >= 130), median about 146.
- Days to first reading is right-skewed, capped at 60; Northside is the slow clinic (median about 9).
- Cellular beats Bluetooth in most clinics; one clinic is the exception.
- Maple Grove has consistently low engagement; a month where the whole heatmap changes (shortage window).
- More readings goes with larger BP reduction, flattening at high counts (log scale helps).
- Pct submitting declines over the year, with dips the weeks of 2025-06-30, 11-24, 12-22, 12-29; cellular drops during the shortage window.

### Known to-do on the exercises
- Exercise 1 and 2 still use collapsed hint callouts. Convert to inline hints (3 and 4 already do).
- Exercise 2: `reorder(clinic, baseline_sbp)` orders by the **mean** (default). Use `FUN = median` so the order matches the boxplot's median line, and say so in the text.
- Optional: data dictionary and README for students.

## Project 2: ED use and cost team exercise (`ed-exercise/`)

> **REVISED 2026-10-13 to follow `R_SQL_Review_Exercise_v2.docx`, which supersedes the design below where they differ.** Deliverables are now trend by month, ED visits by payer (with claim cost and coverage), and a Lorenz curve with Gini. `prep.R` has `validate_ed_visits`, `monthly_counts`, `payer_summary`, `lorenz_curve`, `gini` (plus provided `patient_costs`); `plots.R` has `plot_trend`, `plot_payer`, `plot_lorenz`. Fixtures use Synthea column names, with `fx_problem()` injectors in `tests/testthat/helper-fixtures.R`. Students get only the items marked EXAMPLE in the document; the answer key is `instructor/` (`Rscript instructor/run_key.R`). The ED-rate, control-limit, module A/B/C and refresh-variant material below is not yet reconciled with v2 and the modules folder was removed.
Two-hour in-class exercise. Synthea data in MariaDB, R for visualization, unit tests (testthat), GitHub PRs and CI checks. Teams of 3 or 4. The run sheet is `ed-exercise/ED-exercise-run-sheet.docx` (current plan; keep it in sync).

**Case:** finance/quality committee asks whether ED use is rising, what a typical ED visit costs by payer, and how concentrated cost is. Deliverable: Quarto brief with three figures plus a one-sentence takeaway each.

Core figures:
1. Monthly ED visits per 1,000 active patients with u-chart limits.
2. Cost per visit by payer, sorted, log axis, n labels.
3. Cumulative cost share vs patient share (Lorenz-style), top 10% marked.

Design decisions already made:
- SQL runs locally; students commit CSV extracts. **CI never touches the database.** Credentials via `.Renviron` (gitignored).
- Fixture CSVs with hand-computable answers let teams start at minute 0. Fixtures need varied denominators, a zero-visit month, a day-30 and a day-31 return, a boundary-age patient, and active-condition edge cases.
- Repo layout: `R/{extract,prep,plots,helpers,model}.R`, `sql/`, `data/` (fixtures), `tests/testthat/`, `report.qmd`, `.github/workflows/check.yaml` (testthat, lintr, Quarto render, cached deps).
- `prep.R` functions: `validate_ed_visits`, `drop_partial_month`, `monthly_rate`, `control_limits`, `cost_per_visit`, `patient_costs`, `lorenz_curve`, `top_share`. Students get stubs and docs plus the first two tests; they write the rest.
- Roles: Data (SQL, validation), Trend, Cost, Concentration and report (merge 3 and 4 for teams of three).

Timeline (120 min): 0:00 kickoff and first green push; 0:10 data and prep; 0:30 plots; 1:05 integrate (core complete 1:25); 1:25-1:40 one module; 1:40 instructor pushes the "Monday data refresh" PRs; 1:42-1:55 teams respond; 1:55 debrief.

Modules (team picks one at 1:25):
- **A, 30-day returns:** `flag_returns()`, `return_rate()`; eligible = at least 30 days before data end; return = another ED visit 1-30 days later.
- **B, age-group rates:** `assign_age_group()` used by numerator and denominator; extract `patient_months_age.csv`; invariant tests (group sums equal totals, boundaries 17/18).
- **C, prediction and calibration (advanced):** supplied `patient_model.csv` (age, gender, payer, prior_ed_12m, n_conditions active at the index date top-coded at 5+, condition flags, ed_next_12m). `split_patients`, `fit_ed_model` (glm, provided), `predict_risk`, `calibration_table`, `plot_calibration`. Compare base model vs model with conditions. Leakage traps: conditions or visits after the index date; inner join dropping patients with no conditions.

**Break it is instructor-run, not team vs team.** At 1:40 a script pushes a PR to every team repo with a data refresh variant (duplicate encounters, costs in cents, payer label whitespace/case, partial month appended, zero or NA `n_active`, future dates, leaky `prior_ed_12m` for Module C) or a change to a shared helper in `R/helpers.R` (`per_1000`, `month_start`, `assign_age_group`). Different teams get different variants. Code patches are avoided because student implementations differ.

### To build (suggested order)
1. DONE (2026-10-13): fixtures, `prep.R` stubs, first two tests (`validate_ed_visits`, `drop_partial_month`), answer key. Verified with `Rscript instructor/run_key.R` (R 4.5.1 at `C:/Program Files/R/R-4.5.1/bin`; testthat installed). Fixture window ends 2024-06-15; June partial; see `instructor/answer-key.md`. Folder skeleton for later steps exists (`.github/workflows`, `instructor/{scripts,refresh}`, `modules/`).
2. CI workflow and scripts: `create_team_repos.sh`, `push_refresh.sh` (GitHub CLI loop: branch, commit, push, `gh pr create`).
3. Refresh variant files and `make_refresh_files.R`.
4. Student handout (one page) and README.
5. Module A, B, C stubs, tests and fixtures.

### Open items
- **Synthea schema in MariaDB is not confirmed.** Column names (`ENCOUNTERCLASS`, `payer`, `start`, `stop`, `description`, etc.) are assumed from the standard Synthea CSVs. Get `DESCRIBE encounters, patients, payers, conditions` output and make the SQL match. Verify condition descriptions (the `(disorder)` suffix) in the actual data.
- Check the data supports the case: ED visits vary by month and payer, enough repeat visits for Module A, enough patients per age group for Module B.
- Debrief is only 5 minutes; plan to finish it next session.

## Not carried over
The older `dataviz-deck/` Beamer project and the earlier airquality/mtcars/economics exercises were superseded or are separate work and were not copied here.
