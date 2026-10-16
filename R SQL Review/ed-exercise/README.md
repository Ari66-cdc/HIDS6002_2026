# ED use and cost

Leadership wants three figures: ED visits by month, ED visits by payer (with claim cost and payer coverage),
and a Lorenz curve of ED cost. Standard ggplot2 only.

```
R/            extract.R (MariaDB wrapper), prep.R (validate, wrangle), plots.R, helpers.R
sql/          SQL queries (run locally; CI never touches the database)
data/         fixture CSVs now, committed extracts later
docs/         fixtures.md, testthat cheat sheet
tests/        testthat.R, testthat/helper-fixtures.R, testthat/test-prep.R
report.qmd    final report; runs validation, then the figures
.github/      workflows/check.yaml (testthat, lintr, Quarto render)
instructor/   answer key, solutions, scripts, refresh files (not copied to team repos)
```

Start with `R/prep.R` and `tests/testthat/test-prep.R`. Run the tests from the repo root:

```bash
Rscript tests/testthat.R
```
