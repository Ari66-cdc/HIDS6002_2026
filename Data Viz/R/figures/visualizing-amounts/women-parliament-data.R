# Shared data prep for the Rwandan parliament figures.
get_women_rwanda <- function() {
  women_parliaments %>%
    filter(country_code == "RWA" & year > 1990) %>%
    mutate(women = perc_women, men = 100 - perc_women) %>%
    select(-perc_women) %>%
    gather(gender, percent, women, men) %>%
    mutate(gender = factor(gender, levels = c("women", "men")))
}
