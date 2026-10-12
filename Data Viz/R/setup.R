# Libraries, chunk defaults, and theme. Sourced once from deck.qmd.

library(ggplot2)
library(dplyr)
library(cowplot) # ggdraw, draw_text, plot_grid
library(dviz.supp)
library(sf)
library(gapminder)
library(ggridges) # for geom_density_line()
library(tidyr) 

# Add more as you borrow chapters, e.g.:
# library(cowplot); library(ggrepel); library(patchwork)

knitr::opts_chunk$set(
  echo = FALSE, message = FALSE, warning = FALSE,
  dev = "cairo_pdf"
)

# "sans" always works; avoid "Myriad Pro"
theme_set(theme_minimal(base_size = 14, base_family = "sans"))
dviz_font_family <- "sans"