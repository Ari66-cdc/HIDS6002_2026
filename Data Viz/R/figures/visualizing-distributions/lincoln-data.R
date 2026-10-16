# Shared data prep for the Lincoln, Nebraska temperature figures.
get_lincoln_df <- function() {
  lincoln_weather %>%
    mutate(
      month_short = forcats::fct_recode(
        Month,
        Jan = "January", Feb = "February", Mar = "March", Apr = "April",
        May = "May", Jun = "June", Jul = "July", Aug = "August",
        Sep = "September", Oct = "October", Nov = "November", Dec = "December"
      )
    ) %>%
    mutate(month_short = forcats::fct_rev(month_short))
}
