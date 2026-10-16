# Homework answer key: Part 1 bad chart

Students must find at least five of the eight. Starter file: `homework/homework-critique-and-design.qmd`. All R is untested (no R in the build environment); run it once before distributing.

| # | Problem | Why it matters | Acceptable fix |
|---|---|---|---|
| 1 | Bar axis does not start at zero (`coord_cartesian(ylim = ...)`) | Bar length encodes the value, so a truncated axis exaggerates differences | Zero baseline, or (better) switch to a dot-and-interval plot and choose the range deliberately. Do not mark "use a dot plot with a truncated axis" wrong |
| 2 | Clinics in alphabetical order | No visual ranking; hard to compare | Sort by the plotted value (`reorder()`) |
| 3 | Rainbow fill plus redundant legend | Color encodes nothing; legend repeats the x axis | One color; remove the legend |
| 4 | No uncertainty or n | Small and large clinics look equally certain | Add 95% CI (`clinic_effect` has them) or label n |
| 5 | Rotated labels; generic title | Hard to read; title says nothing | Horizontal bars or flipped axes; an informative title |
| 6 | **Sum** of reduction per clinic instead of the mean | Larger clinics look better regardless of effect. This is the one substantive error | Plot the mean (or use `clinic_effect`) |
| 7 | Axis says "SBP (mmHg)": no statement that it is a reduction, that positive means improvement, or a "no change" line | Reader cannot tell direction or meaning | Label as "Mean systolic BP reduction (mmHg)", add a zero line |
| 8 | Heavy panel border, dark major and minor gridlines, default grey theme | Clutter competes with the data | Light grid or none, no border, `theme_minimal()` |

**Decoy:** the y axis does include a unit (mmHg). A student who "fixes" the unit is changing something that was fine.

Grading note: a student who lists five but misses #6 can still earn full credit for finding five, but a repaired chart that still sums is not a fix of #6, and any chart that still shows a sum under a title about "results" should lose the repair points for that item.
