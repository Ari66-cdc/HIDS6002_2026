# testthat cheat sheet

Examples use this repo's fixtures and `prep.R` functions.

## Run tests

From the repo root:

``` bash
Rscript tests/testthat.R                       # all tests
```

``` r
testthat::test_file("tests/testthat/test-prep.R")   # one file
testthat::test_dir("tests/testthat", filter = "prep") # files matching "prep"
```

Output: `.` pass, `F` fail, `E` error, `S` skipped.

## Anatomy of a test

``` r
test_that("monthly_rate keeps the zero-visit month", {
  out <- monthly_rate(fx_visits(), fx_patient_months())   # arrange
  expect_equal(nrow(out), 6)                              # assert
})
```

- One behavior per `test_that()`. The description should finish the sentence "It ...".
- Each test runs in its own environment, so variables don't leak between tests.
- Files are named `test-<topic>.R`. `helper-*.R` files load automatically before tests.

## Choosing an expectation

| You want to check | Use |
|------------------------------------|------------------------------------|
| Values equal (numbers within tolerance 1.5e-8) | `expect_equal(x, y)` |
| Exactly identical, including type | `expect_identical(x, y)` |
| Looser numeric tolerance | `expect_equal(x, y, tolerance = 1e-3)` |
| TRUE / FALSE | `expect_true(x)`, `expect_false(x)` |
| Missing values | `expect_true(is.na(x))` |
| Length / rows | `expect_length(x, 3)`, `expect_equal(nrow(df), 6)` |
| Column names | `expect_named(df, c("month", "rate"))` |
| Class | `expect_s3_class(df, "data.frame")`, `expect_type(x, "double")` |
| Every element | `expect_true(all(x >= 0))` |
| An error | `expect_error(f(x), "regex")` |
| No error | `expect_no_error(f(x))` |
| A warning / message | `expect_warning(f(x), "regex")`, `expect_message(f(x), "regex")` |
| Set membership | `expect_in(x, c("a", "b"))` |
| Sets equal, order ignored | `expect_setequal(x, y)` |
| Plot object type | `expect_s3_class(p, "ggplot")` |

Argument order: `expect_equal(actual, expected)`. Put the function's result first.

## Testing errors well

``` r
expect_error(validate_ed_visits(v, data_end), "duplicate")  # message matches regex
expect_error(f(x), class = "my_error")                       # by condition class
expect_error(f(x), "a.b", fixed = TRUE)                      # literal, not regex
```

Match a distinctive piece of the message, so the test fails if the wrong error fires.

## Floating point

``` r
expect_equal(0.1 * 3, 0.3)       # passes (tolerance)
expect_identical(0.1 * 3, 0.3)   # fails
```

`ceiling(0.1 * 30)` is 4, not 3. Test boundaries like this on purpose.

## Good test habits for this project

- Compute the expected value **by hand** from the fixture, then write it into the test. Do not compute it with the code under test.
- Cover the edge cases the fixtures were built for: zero-visit month, partial month, day-30 versus day-31, boundary age 17 versus 18, zero or NA denominator.
- Test invariants: group sums equal totals, shares end at 1, no negative costs.
- Write the failing test first, then make it pass.
- Keep fixtures small. Build a one-off data frame inside the test when the fixture is not enough:

``` r
test_that("top_share is not fooled by floating point", {
  pc <- tibble::tibble(patient_id = 1:30, total_cost = rep(1, 30))
  expect_equal(top_share(pc), 3 / 30)
})
```

## Setup, helpers, skipping

``` r
# tests/testthat/helper-fixtures.R : runs before every test file
read_fixture <- function(name) readr::read_csv(file.path(repo_root, "data", name))

skip("waiting on SQL extract")                        # skip unconditionally
skip_if_not(nzchar(Sys.getenv("ED_DB_HOST")), "no database")   # skip locally-only tests
skip_on_ci()                                          # CI never touches the database
```

Use `withr::local_envvar()` or `withr::local_tempfile()` to change state only for the length of a test.

## Reading failures

```         
── Failure ('test-prep.R:24:3'): monthly_rate gives 20, 0, 20, 55, 10, 6 ──
out$rate (`actual`) not equal to c(20, 0, 20, 55, 10, 6) (`expected`).
`actual[4]`: 50
`expected[4]`: 55
```

The location is `file:line:col`. `actual` is your function's output. Look at the first differing element.

## Debugging a failing test

``` r
devtools::load_all()          # only if this were a package; here, source the files:
source("R/helpers.R"); source("R/prep.R")
out <- monthly_rate(readr::read_csv("data/ed_visits.csv"), readr::read_csv("data/patient_months.csv"))
print(out)
```

Reproduce the call in the console, inspect with `print()` or `str()`, then fix the function or the test.

## Snapshot tests (use sparingly)

``` r
expect_snapshot(print(cost_per_visit(fx_visits())))   # stores output in tests/testthat/_snaps/
```

Good for printed output. For values, prefer `expect_equal()` with explicit numbers. Review changes with `testthat::snapshot_review()`.