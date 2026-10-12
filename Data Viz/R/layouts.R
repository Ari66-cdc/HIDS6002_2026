# Helper for Layout B: overlay a figure at exact slide coordinates.
# Slide is 16 cm wide x 9 cm tall; x and y are measured from the top-left.
#   w, h  = size the plot is drawn at (controls apparent text size)
#   width = size of the figure on the slide, in cm
# Use in a chunk with:  #| output: asis

place_fig <- function(name, plot, w = 4, h = 3.2,
                      x = 8.5, y = 1.8, width = 7) {
  dir.create("figs", showWarnings = FALSE)
  path <- file.path("figs", paste0(name, ".pdf"))
  ggplot2::ggsave(path, plot, width = w, height = h,
                  device = cairo_pdf, bg = "transparent")
  cat(sprintf(
    "\n```{=latex}\n\\begin{textblock*}{%gcm}(%gcm,%gcm)\n\\includegraphics[width=\\linewidth]{%s}\n\\end{textblock*}\n```\n",
    width, x, y, path))
}
