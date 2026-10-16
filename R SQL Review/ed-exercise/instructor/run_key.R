# Check the answer key against the fixtures. From the repo root:
#   Rscript instructor/run_key.R
Sys.setenv(ED_PREP = normalizePath("instructor/solutions/prep.R"),
           ED_PLOTS = normalizePath("instructor/solutions/plots.R"))
library(testthat)

# Student tests, then the full suite staged next to them.
test_dir("tests/testthat", reporter = "summary", stop_on_failure = FALSE)
staged <- "tests/testthat/test-full.R"
file.copy("instructor/solutions/test-full.R", staged, overwrite = TRUE)
test_dir("tests/testthat", filter = "full", reporter = "summary", stop_on_failure = FALSE)
unlink(staged)
