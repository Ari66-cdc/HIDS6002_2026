fig_student_grades_qq <- function(font_size = 12) {

# hypothetical class of 50 students
set.seed(4211)
points <- round(c(rnorm(47, mean = 82, sd = 10), 45, 51, 67))
points[points > 100] <- 100
student_data <- data.frame(points, rank = rank(points, ties.method = "random"))

# estimate distribution parameters (mean and sd)
params <- as.list(MASS::fitdistr(student_data$points, "normal")$estimate)

# axis line segments
df_segment <- data.frame(
  x = c(50, -Inf),
  xend = c(100, -Inf),
  y = c(-Inf, 50),
  yend = c(-Inf, 100)
)

ggplot(student_data, aes(sample = points)) +
  geom_abline(slope = 1, intercept = 0, color = "grey70") +
  stat_qq(dparams = params, color = "#0072B2") +
  geom_segment(
    data = df_segment,
    aes(x = x, xend = xend, y = y, yend = yend),
    linewidth = 0.5, inherit.aes = FALSE) +
  scale_x_continuous(limits = c(43, 107), expand = c(0, 0), breaks = 10 * (5:10), name = "theoretical") +
  scale_y_continuous(limits = c(43, 102), expand = c(0, 0), breaks = 10 * (5:10), name = "observed") +
  coord_fixed(clip = "off") +
  theme_dviz_open(font_size) +
  theme(axis.line = element_blank())
}
