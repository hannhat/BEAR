# Recover source meta-analysis DOIs and psychology subfields from author metadata.
# Run this optional acquisition stage before process/Sladekova/Sladekova.R.

library(tidyverse)
library(httr2)
library(readxl)
source("R/doi_lookup.R")

dir.create("data_raw/Sladekova/publication_metadata", recursive = TRUE,
           showWarnings = FALSE)
dir.create("doi/Sladekova/derived", recursive = TRUE, showWarnings = FALSE)
dir.create("doi/Sladekova/final", recursive = TRUE, showWarnings = FALSE)

source_urls <- c(
  "pool_2008.xlsx" = "https://osf.io/download/s9bdp/",
  "pool_2018.xlsx" = "https://osf.io/download/gx26f/",
  "coded_meta.csv" = "https://osf.io/download/ds5rb/"
)
for (file in names(source_urls)) {
  path <- paste0("data_raw/Sladekova/publication_metadata/", file)
  if (file.exists(path)) next
  request(source_urls[[file]]) %>%
    req_url_query(refresh = as.integer(Sys.time())) %>%
    req_perform(path = path)
}

keys <- read_csv("process/Sladekova/metadata.csv", show_col_types = FALSE) %>%
  distinct(key = str_extract(metaid, "^[AB][0-9]+"))
papers <- map_dfr(c(2008, 2018), ~ read_excel(paste0(
  "data_raw/Sladekova/publication_metadata/pool_", .x, ".xlsx")) %>%
  transmute(key = Key, title = Title, author = Authors,
            journal = `Source title`, year = Year, pool_doi = extract_doi(DOI))) %>%
  semi_join(keys, by = "key")
stopifnot(!anyDuplicated(papers$key), setequal(papers$key, keys$key))

coded <- read_csv("data_raw/Sladekova/publication_metadata/coded_meta.csv",
                  col_select = c(key, doi, psych_subfield),
                  show_col_types = FALSE) %>%
  transmute(key = str_to_upper(str_squish(key)), coded_doi = extract_doi(doi),
            topic = na_if(str_squish(psych_subfield), "")) %>%
  semi_join(keys, by = "key")
coded_dois <- coded %>% filter(!is.na(coded_doi)) %>%
  distinct(key, coded_doi)
stopifnot(!anyDuplicated(coded_dois$key))

# Conflicting coder assignments remain unclassified.
topics <- coded %>% filter(!is.na(topic)) %>% distinct(key, topic) %>%
  group_by(key) %>%
  summarise(topic_candidates = str_c(sort(topic), collapse = "; "),
            topic_conflict = n() > 1,
            topic = if(n() == 1) first(topic) else NA_character_,
            .groups = "drop")

papers <- papers %>%
  left_join(coded_dois, by = "key", relationship = "one-to-one") %>%
  left_join(topics, by = "key", relationship = "one-to-one") %>%
  mutate(conflict = !is.na(pool_doi) & !is.na(coded_doi) &
           pool_doi != coded_doi,
         doi_meta = if_else(conflict, NA_character_,
                            coalesce(pool_doi, coded_doi)),
         doi_source = case_when(
           conflict ~ "conflict", !is.na(pool_doi) ~ "sampling_inventory",
           !is.na(coded_doi) ~ "coded_metadata",
           TRUE ~ "missing"))
write_csv(papers, "doi/Sladekova/derived/meta_doi_audit.csv")
saveRDS(select(papers, key, doi_meta, topic),
        "doi/Sladekova/final/meta_doi_mapping.rds")
print(count(papers, doi_source))
print(count(papers, topic))
