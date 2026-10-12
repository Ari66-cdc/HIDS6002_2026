
fig_log_ratio <- function() {

  US_census %>% filter(state == "Texas") %>%
  select(name, pop2010) %>%
  tidyr::extract(name, "county", regex = "(.+) County") %>%
  mutate(popratio = pop2010/median(pop2010)) %>%
  arrange(desc(popratio)) %>%
  mutate(index = 1:n(),
         label = ifelse(index <= 3 | index > n()-3 | runif(n()) < .04, county, ""),
         label_large = ifelse(index <= 6, county, "")) -> tx_counties
  
  p <- ggplot(tx_counties, aes(x = index, y = popratio)) +
    geom_point(size = 0.5, color = "#0072B2") +
    ggrepel::geom_text_repel(aes(label = label_large), point.padding = .4, color = "black",
                  min.segment.length = 0, family = dviz_font_family) +
    scale_y_continuous(name = "population number / median") +
    scale_x_continuous(limits = c(.5, nrow(tx_counties) + .5), expand = c(0, 0),
                     breaks = NULL, #c(1, 50*(1:5)),
                     name = "Texas counties, from most to least populous") +
    theme_dviz_hgrid() +
    theme(axis.line = element_blank(),
        plot.margin = margin(3, 7, 3, 1.5))

  stamp_bad(p)
}
