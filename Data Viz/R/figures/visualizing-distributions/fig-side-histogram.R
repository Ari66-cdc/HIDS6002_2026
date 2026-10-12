fig_side_histogram<-function(font_size = 12) {
data.frame(
  age = (1:25)*3 - 1.5, 
  male = hist(filter(titanic, sex == "male")$age, breaks = (0:25)*3 + .01, plot = FALSE)$counts,
  female = hist(filter(titanic, sex == "female")$age, breaks = (0:25)*3 + .01, plot = FALSE)$counts
) %>%
  gather(gender, count, -age) -> gender_counts

gender_counts$gender <- factor(gender_counts$gender, levels = c("female", "male"))

    ggplot(gender_counts, aes(x = age, y = ifelse(gender == "male",-1, 1)*count, fill = gender)) + 
        geom_col() +
        scale_x_continuous(name = "age (years)", limits = c(0, 75), expand = c(0, 0)) +
        scale_y_continuous(name = "count", breaks = 20*(-2:1), labels = c("40", "20", "0", "20")) +
        scale_fill_manual(values = c("#D55E00", "#0072B2"), guide = "none") +
        draw_text(x = 70, y = -39, "male", hjust = 0) +
        draw_text(x = 70, y = 21, "female", hjust = 0) +
        coord_flip() +
        theme_dviz_grid() +
        theme(axis.title.x = element_text(hjust = 0.61))
}