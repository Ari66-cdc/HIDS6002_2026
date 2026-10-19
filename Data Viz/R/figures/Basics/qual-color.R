# One function per plot. Each returns a ggplot object.
# Paste chapter code into the body and note its source above it.
# Put any data prep inside the function so each plot is self-contained.

# from dataviz ch. XX (replace with the real chapter)
qual_color <- function() {
popgrowth_df <- left_join(US_census, US_regions) %>%
    group_by(region, division, state) %>%
    summarize(pop2000 = sum(pop2000, na.rm = TRUE),
              pop2010 = sum(pop2010, na.rm = TRUE),
              popgrowth = (pop2010-pop2000)/pop2000,
              area = sum(area)) %>%
    arrange(popgrowth) %>%
    ungroup() %>%
    mutate(state = factor(state, levels = state),
           region = factor(region, levels = c("West", "South", "Midwest", "Northeast")))

# make color vector in order of the state
region_colors <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442")
region_colors_dark <- darken(region_colors, 0.4)
state_colors <- region_colors_dark[as.numeric(popgrowth_df$region[order(popgrowth_df$state)])]

ggplot(popgrowth_df, aes(x = state, y = 100*popgrowth, fill = region)) + 
  geom_col(width = 0.7) + 
  scale_y_continuous(
    limits = c(-.6, 37.5), expand = c(0, 0),
    labels = scales::percent_format(accuracy = 1, scale = 1),
    name = "population growth, 2000 to 2010"
  ) +
  scale_fill_manual(values = region_colors) +
  coord_flip() + 
  theme_dviz_vgrid(12, rel_small = 1) +
  theme(axis.title.y = element_blank(),
        axis.line.y = element_blank(),
        axis.ticks.length = unit(0, "pt"),
        axis.text.y = element_text(size = 6, color = state_colors),
        legend.position = c(.56, .68),
        #legend.text = element_text(color = region_colors),
        legend.background = element_rect(fill = "#ffffffb0"))
}

