# Shared fit for the male blue jay curve-fit figures. Stands in for the
# sample_outcomes() / confidence_band() helpers from the ungeviz package.
get_blue_jays_male_fit <- function(n_draws = 15, seed = 1234) {
  blue_jays_male <- filter(blue_jays, KnownSex == "M")
  fit <- mgcv::gam(Head ~ Mass, data = blue_jays_male, method = "REML")
  newdata <- data.frame(Mass = seq(59, 82, length.out = 100))

  pred <- predict(fit, newdata, se.fit = TRUE, unconditional = TRUE)
  ci_df <- data.frame(newdata, Head = as.numeric(pred$fit)) %>%
    mutate(lo = Head - 1.96 * as.numeric(pred$se.fit),
           hi = Head + 1.96 * as.numeric(pred$se.fit))

  # draws from the (unconditional) posterior of the model coefficients
  set.seed(seed)
  Xp <- predict(fit, newdata, type = "lpmatrix")
  betas <- MASS::mvrnorm(n_draws, coef(fit), vcov(fit, unconditional = TRUE))
  sample_df <- do.call(rbind, lapply(seq_len(n_draws), function(i) {
    data.frame(newdata, Head = as.numeric(Xp %*% betas[i, ]), .draw = i)
  }))

  list(data = blue_jays_male, ci = ci_df, draws = sample_df)
}
