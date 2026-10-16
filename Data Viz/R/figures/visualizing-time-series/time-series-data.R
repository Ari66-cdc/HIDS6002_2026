# Shared data prep for the preprint time-series figures.
get_biorxiv_growth <- function() {
  preprint_growth %>%
    filter(archive == "bioRxiv") %>%
    filter(count > 0)
}

get_preprints <- function() {
  preprint_growth %>%
    filter(archive %in% c("bioRxiv", "arXiv q-bio", "PeerJ Preprints")) %>%
    filter(count > 0) %>%
    mutate(archive = factor(archive, levels = c("bioRxiv", "arXiv q-bio", "PeerJ Preprints")))
}
