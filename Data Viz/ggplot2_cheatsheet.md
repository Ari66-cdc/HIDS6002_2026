# ggplot2 Syntax Reference (R)

## 1. How a plot is built

```r
ggplot(df, aes(x = x_col, y = y_col)) +      # data + what maps to what
  geom_point() +                              # one layer per geom
  labs(x = "X label", y = "Y label")          # layers are added with +
```

A plot is a stack of layers joined with `+`. Layers are drawn in the
order you add them, so later layers sit on top of earlier ones.

**Mapping vs. setting.** A value inside `aes()` is *mapped* to a column
(one color per category, for example). A value outside `aes()` is *set*
for every mark.

```r
geom_point(aes(color = category))   # color depends on the data
geom_point(color = "steelblue")     # every point is steelblue
```

**`+` goes at the end of the line, not the start.** A line that begins
with `+` is a new statement, and R will either error or silently drop
the rest of the plot.

---

## 2. Choosing a geom

```r
geom_col(aes(x = category, y = value))     # bar height = a value you already have
geom_bar(aes(x = category))                # bar height = a count of rows, computed for you
geom_histogram(aes(x = x_col))             # distribution of one number
geom_density(aes(x = x_col))               # smoothed distribution
geom_boxplot(aes(x = category, y = x_col)) # distribution by group
geom_violin(aes(x = category, y = x_col)) # distribution by group, shape visible
geom_point(aes(x = x_col, y = y_col))      # two numbers per row
geom_line(aes(x = date_col, y = y_col))    # ordered in time (x can be non-date but needs an order)
geom_pointrange(aes(xmin = lo, xmax = hi)) # a point with an interval
geom_ribbon(aes(ymin = lo, ymax = hi))     # a shaded band around a line
```
---

## 3. Frequency and Proportions
```r
ggplot(df, aes(x=category)) +
geom_bar(aes(fill = group), width = 0.6, position = position_dodge(width = 0.7))
```
**`geom_col()` plots values; `geom_bar()` counts rows.** If your data
already has one row per bar with its height in a column, use
`geom_col()`. Using `geom_bar()` on that data just counts the rows (and
every bar comes out the same height).

**Position** controls how bars for different groups are placed within a
category:

```r
position = "stack"                    # groups stacked on top of each other (the default with fill)
position = "dodge"                    # groups side by side
position = "fill"                     # stacked and scaled to 100%, to compare proportions
position = position_dodge(width = 0.7)   # side by side, with control over spacing
```

**Width** controls how wide each bar is, from 0 to 1 (the default is
0.9; at 1 bars touch). For grouped bars, `width` is each bar's width and
`position_dodge(width = )` is the space one category takes up in total.
Keep the dodge width a little larger than `width` for a small gap
between groups. If it is smaller, the bars overlap.

---

## 4. Distributions

```r
ggplot(df, aes(x = x_col)) +
  geom_histogram(binwidth = 5, boundary = 130,
                 fill = "#56B4E9", color = "white")

ggplot(df, aes(x = x_col)) +
  geom_histogram(aes(y = after_stat(density)), binwidth = 5,
                 fill = "grey85", color = "white") +   # histogram on the density scale
  geom_density(adjust = 0.5, bounds = c(130, Inf))      # smaller adjust = follows data more closely
```

- **`binwidth`** is your choice and it changes the story. Try several
  before committing: narrow bins show noise, wide bins hide structure.
- **`boundary`** pins where a bin starts (set it to the lowest possible
  value so the first bar is not straddling it).
- **`bounds`** in `geom_density()` tells the curve that no data can fall
  outside a range (such as below a minimum enrollment value), so the
  smoothing does not spill past it. It needs a recent ggplot2 (3.4.0 or
  later).

**A Q-Q plot checks whether data look normal.**

```r
ggplot(df, aes(sample = x_col)) +
  stat_qq() +
  stat_qq_line()          # points on the line = roughly normal
```

---

## 5. Comparing groups

```r
ggplot(df, aes(x = x_col, y = category)) +
  geom_boxplot(fill = "grey90", outlier.shape = NA) +   # no outlier dots if points follow
  geom_jitter(width = 0, height = 0.15, alpha = 0.4)    # every observation as a dot

ggplot(df, aes(x = x_col, y = category)) +
  geom_violin(fill = "grey90")                          # same layout, shape instead of box
```

**Put long category labels on the y axis** (as above) so they stay
horizontal and readable.

**When you add jittered points to a boxplot, turn off the boxplot's own
outlier dots** (`outlier.shape = NA`), or each outlier is drawn twice.
On a horizontal plot, jitter vertically (`height`), not horizontally.

**A violin shows shape; it can also invent shape.** The smooth outline
extends past the data and looks equally confident for a group of 10 and
a group of 500. Overlay the points or label the group sizes.

**Sort categories by a value with `reorder()`.**

```r
aes(y = reorder(category, x_col))                    # sorts by the MEAN by default
aes(y = reorder(category, x_col, FUN = median))      # sorts by the median instead
```

`reorder()` sorts by the **mean** unless you tell it otherwise. If the
plot shows medians (a boxplot's center line), sort by `FUN = median` or
the order will not match what the reader sees.

---

## 6. Facets (small multiples)

```r
facet_wrap(~ category)                    # one panel per category
facet_wrap(~ category, ncol = 2)          # control the layout
facet_grid(rows_col ~ cols_col)           # one variable on each side of ~
facet_wrap(~ category, scales = "free_y") # each panel gets its own y axis
```

**Fixed axes let you compare panels; free axes hide differences.** Use
free scales only when you can justify it, since panels with different
axes look more alike than they are.

**Every split costs sample size.** A grid of six panels from 400
patients leaves roughly 65 per panel, and the noise gets louder as the
panels get smaller.

**Per-panel reference lines need their own data frame.**

```r
geom_vline(data = group_summary, aes(xintercept = median_value),
           color = "firebrick")           # one line per panel
```

---

## 7. Relationships

```r
ggplot(df, aes(x = x_col, y = y_col)) +
  geom_point(alpha = 0.5) +                       # transparency shows overplotting
  geom_smooth(method = "lm", se = FALSE) +        # straight-line fit
  geom_hline(yintercept = 0, linetype = "dashed") # "no change" reference

geom_smooth()                                      # default: a flexible curve (loess)
```

- **Compare `geom_smooth()` with `method = "lm"`.** If the curve and the
  straight line disagree, the relationship is not a straight line.
- **`alpha` lower than 1** makes dense areas darker so overplotted
  points stay visible.
- **A reference line is part of the chart.** A dashed zero line
  answers "did it improve?" without the reader having to find zero.

**A log axis spreads out small values.**

```r
scale_x_log10()                                  # each doubling = same distance
scale_x_log10(breaks = c(10, 30, 100, 300))      # choose readable ticks
```

You cannot take the log of zero. Rows with zero values drop off a log
axis, so say how many were removed or handle them on purpose.

---

## 8. Intervals and labels on marks

```r
ggplot(df, aes(x = estimate, y = reorder(category, estimate))) +
  geom_pointrange(aes(xmin = ci_low, xmax = ci_high)) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  geom_text(aes(label = round(estimate, 1)), nudge_y = 0.3)

geom_text(aes(label = paste0(round(estimate, 1), " (n=", n, ")")),
          nudge_y = 0.3)                         # build a label from several columns

geom_text(aes(label = name), check_overlap = TRUE)   # skip labels that would collide
```

- **`nudge_y`** lifts the label off the mark so it does not cover it.
- **`paste0()`** stitches text and numbers together with no separator.
- **An interval that crosses the reference line** means the data cannot
  separate that group from "no change."
- **Show n next to an interval.** The reader can then see why some
  intervals are wide.

---

## 9. Scales, limits, and zoom

```r
scale_y_continuous(limits = c(0, NA))                       # NA = keep the default for that end
scale_y_continuous(expand = expansion(mult = c(0, 0.05)))   # 0% below, 5% above
scale_y_continuous(expand = expansion(add = c(0, 10)))      # padding in data units
coord_cartesian(ylim = c(100, 160))                         # zoom, keep all data
```

- **`mult` is a fraction of the data range; `add` is in data units.**
- **Remove the gap under bars** with `expansion(mult = c(0, 0.05))`:
  bars and histograms should sit on the axis. Extra room at the top is
  useful when you want space for a label.

**`limits` removes data; `coord_cartesian()` zooms.** Setting `limits`
in a scale drops every row outside it before anything is computed, so
fits, bins, and summaries can change. `coord_cartesian(ylim = ...)`
only changes the visible window.

**Whether to start at zero depends on the mark.**

| Mark | Encodes value by | Truncated axis |
|---|---|---|
| Bar | length | Misleading (half the height reads as half the value) |
| Dot, line, point | position | Often fine, and sometimes necessary to see a real difference |

If bars would need a truncated axis to be readable, switch to a dot or
point-and-interval plot. Either way, label the axis and choose the
range on purpose.

---

## 10. Time series

```r
ggplot(df, aes(x = date_col, y = y_col)) +
  geom_line() +
  geom_point() +
  scale_x_date(date_breaks = "2 months", date_labels = "%b %Y",
               minor_breaks = NULL)
```

- **`%b`** month abbreviation, **`%B`** full month name, **`%d`** day,
  **`%Y`** four-digit year, **`%y`** two-digit year.
- **`minor_breaks = NULL`** removes the extra gridlines between ticks.
- **The `x` column must be a real date**, not text, or the axis will
  not behave as a date axis.

**Mark an event with a vertical line and a label.**

```r
geom_vline(xintercept = as.Date("2025-06-02"), linetype = "dashed") +
annotate("text", x = as.Date("2025-06-02"), y = Inf,
         label = "Protocol starts", hjust = 1.05, vjust = 1.5)
```

`y = Inf` pins the label to the top of the panel. **`hjust = 1.05` puts
text to the left of the line; a negative value puts it to the right.**
`xintercept` accepts a vector of dates.

**Shade a window of time, behind the data.**

```r
annotate("rect", xmin = start, xmax = end,
         ymin = -Inf, ymax = Inf, alpha = 0.2) +   # add this BEFORE geom_line()
geom_line()
```

Layers are drawn in order, so a rectangle added after the line covers
the line. Add it first.

**Smoothing costs resolution.** A trailing average uses this week and
the weeks before it (usable live, lags behind). A centered average
looks both ways (better for reports, but has gaps at both ends). A wide
window can erase real, short events such as holiday dips.

---

## 11. Color and legends

```r
scale_color_viridis_d(end = 0.7)               # perceptually even, color-blind safe
scale_fill_manual(values = c("#0072B2", "#D55E00"))
theme(legend.position = "none")                # drop the legend
```

**Label lines directly instead of using a legend.** The reader does not
have to look back and forth.

```r
# end_label holds the group name on the last row of each line, NA elsewhere
geom_text(aes(label = end_label), hjust = -0.1, na.rm = TRUE) +
scale_x_date(expand = expansion(mult = c(0.02, 0.15))) +   # room for the labels
theme(legend.position = "none")
```

**Color should carry meaning.**
- A different color for every bar (a rainbow), plus a legend that
  repeats the axis, encodes nothing. Use one color, and save color for
  a highlight or a real grouping.
- A diverging scale (two hues around a neutral midpoint) fits values
  that can be above or below zero. A sequential scale fits values that
  only go up.
- Avoid red against green. Check your figure in grayscale.

**A legend is worth keeping** when there are too many groups to label
directly or when the labels would collide with the data.

---

## 12. Titles, themes, and saving

```r
labs(title = "Systolic BP fell most at Clinic C",    # say what the chart shows
     subtitle = "Mean 6-month reduction, 95% CI",
     x = NULL,                                         # drop an obvious axis title
     y = "Mean systolic BP reduction (mmHg)",         # name the measure and the unit
     caption = "Simulated data")

theme_set(theme_minimal(base_size = 13))               # one theme for every plot
theme(panel.grid.minor = element_blank())              # remove clutter

ggsave("figure.png", width = 7, height = 4.5, dpi = 300)   # saves the last plot
```

- **A title says what the chart found, not what it contains.** "Results
  by Clinic" tells the reader nothing.
- **Name the measure, the unit, and the direction.** "SBP (mmHg)" does
  not say whether higher is better. Say "reduction," and say that a
  positive value means improvement.
- **Set the size once** (`ggsave()` or the `fig-width` / `fig-height`
  chunk options in Quarto), so the figure is the same every time.

In a Quarto chunk:

```r
#| fig-width: 8
#| fig-height: 5
```

---

## 13. Checks before you share a chart

- **Is it the right statistic?** Summing a value per group makes bigger
  groups look better. A comparison across groups of different sizes
  usually needs a mean or a rate.
- **Is the order useful?** Alphabetical rarely is. Sort by the value
  you are comparing.
- **Is uncertainty shown?** An interval, an n, or a ribbon tells the
  reader how much to trust a difference.
- **Is there an unintended message?** A dual y axis can imply a
  relationship that comes from the scaling alone. Prefer two panels
  with a shared x axis.
- **Does the encoding fit the question?** Magnitude: bars or dots.
  Trend: a line. Distribution: histogram, box, or violin. Relationship:
  points. Comparison across many groups: sorted dots, or facets.
- **Could the figure be read in two minutes by someone outside your
  field?** If not, simplify the labels, drop the clutter, and say what
  the chart shows in the title.
- **Is a pattern causal?** A relationship in a chart does not show cause.
  Patients who send more readings may differ from those who send fewer.

---

## Quick lookup

| I want to... | Syntax |
|---|---|
| Bars from values I already have | `geom_col()` |
| Bars from a count of rows | `geom_bar()` |
| Histogram with set bins | `geom_histogram(binwidth = , boundary = )` |
| Smooth curve over a histogram | `after_stat(density)` + `geom_density()` |
| Keep a density from spilling past a minimum | `geom_density(bounds = c(min, Inf))` |
| Compare distributions across groups | `geom_boxplot()` / `geom_violin()` |
| Show every point on a boxplot | `outlier.shape = NA` + `geom_jitter()` |
| Sort categories by a value | `reorder(x, value, FUN = median)` |
| One panel per group | `facet_wrap(~ x)` / `facet_grid(r ~ c)` |
| Trend line | `geom_smooth(method = "lm")` |
| Log axis with chosen ticks | `scale_x_log10(breaks = c(...))` |
| Point with an interval | `geom_pointrange(aes(xmin, xmax))` |
| Label marks with values | `geom_text(aes(label = ...), nudge_y = )` |
| Remove the gap under bars | `expansion(mult = c(0, 0.05))` |
| Zoom without dropping data | `coord_cartesian(ylim = c(a, b))` |
| Start an axis at 0 | `scale_y_continuous(limits = c(0, NA))` |
| Choose date ticks and format | `scale_x_date(date_breaks = , date_labels = )` |
| Vertical event line plus label | `geom_vline()` + `annotate("text")` |
| Shade a time window | `annotate("rect", ymin = -Inf, ymax = Inf)` |
| Shaded uncertainty band | `geom_ribbon(aes(ymin, ymax), alpha = 0.2)` |
| Label lines instead of a legend | `geom_text()` + `theme(legend.position = "none")` |
| Color-blind safe palette | `scale_color_viridis_d()` |
| Same theme everywhere | `theme_set(theme_minimal())` |
| Save a figure | `ggsave("file.png", width, height, dpi)` |
